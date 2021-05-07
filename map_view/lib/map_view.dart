import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';

import 'controller.dart';
import 'types.dart';

export 'controller.dart';
export 'marker.dart';
export 'types.dart';

class MapView extends StatefulWidget {
  /// 地图类型 [MapType]
  final int mapType;

  /// 地图创建完成时调用
  ///
  /// 可以使用参数 [MapViewController] 控制地图
  final void Function(MapViewController)? onCreated;

  /// 点击地图时调用
  final void Function(LatLng)? onTap;

  /// 点击地图兴趣点时调用
  final void Function(MapPoi)? onTapPoi;

  /// 长按地图时调用
  final void Function(LatLng)? onLongPress;

  const MapView({
    this.mapType = MapType.none,
    this.onCreated,
    this.onTap,
    this.onTapPoi,
    this.onLongPress,
  });

  @override
  State<MapView> createState() => MapViewState();
}

class MapViewState extends State<MapView> with TickerProviderStateMixin {
  late MapViewController controller;
  CameraPosition? cameraPosition;
  late double pixelRatio;

  // double _rotation = 0;
  Offset _offset = Offset.zero;
  double _scale = 0;
  late double _zoom;
  late AnimationController _acScroll;
  late AnimationController _acZoom;
  Animation<Alignment?>? _aScroll;
  Animation<double>? _aZoom;
  DateTime _lastZoomTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      pixelRatio = MediaQuery.of(context).devicePixelRatio;
    });
    _acScroll = AnimationController(vsync: this);
    _acZoom = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (event) async {
        _acScroll.stop();
        _aScroll?.removeListener(_scrollListener);
        _aScroll?.removeListener(_scaleEndScrollListener);
        _offset = event.focalPoint;
        _scale = 0;
        // _rotation = 0;
        cameraPosition = await controller.getCameraPosition();
      },
      onScaleUpdate: (event) {
        final point = event.focalPoint - _offset;
        _offset = event.focalPoint;
        controller.scroll(point.dx * pixelRatio, point.dy * pixelRatio);

        if (_scale != 0 && cameraPosition != null) {
          _zoom = log(event.scale) / log(2) + cameraPosition!.zoom!;
          controller.zoom(_zoom);
        }
        _scale = event.scale;
        // if (rotation == 0 || cameraPosition == null) {
        //   rotation = event.rotation;
        // } else {
        //   mapView.rotate(event.rotation * 180 / pi);
        // }
      },
      onScaleEnd: (event) async {
        _scale -= 1;
        if (_scale.abs() > 0.1) {
          _lastZoomTime = DateTime.now();
          final tween = Tween(begin: _zoom, end: _zoom + _scale.sign / 5);
          _aZoom = _acZoom.drive(tween);
          _aZoom?.removeListener(_zoomListener);
          _aZoom?.addListener(_zoomListener);
          const spring = SpringDescription(mass: 60, stiffness: 1, damping: 1);
          return _acZoom.animateWith(SpringSimulation(spring, 0, 1, 1));
        }

        final now = DateTime.now().millisecondsSinceEpoch;
        if (now - _lastZoomTime.millisecondsSinceEpoch < 100) {
          return;
        }

        _offset = Offset.zero;
        final pixels = event.velocity.pixelsPerSecond;
        _animateScroll(const LatLng(0, 0), LatLng(pixels.dx, pixels.dy),
            _scaleEndScrollListener);
      },
      child: _buildMapView(),
    );
  }

  Widget _buildMapView() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'map_view',
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }
    return Text('$defaultTargetPlatform is not yet supported');
  }

  void _onPlatformViewCreated(int id) {
    controller = MapViewController(id, this);
    widget.onCreated?.call(controller);
    controller.setMapType(widget.mapType);
  }

  @override
  void didUpdateWidget(MapView old) {
    super.didUpdateWidget(old);
    if (old.mapType != widget.mapType) {
      controller.setMapType(widget.mapType);
    }
  }

  void animateScroll(LatLng target,
      [int duration = 1000, Curve curve = Curves.easeOutCubic]) async {
    final position = await controller.getCameraPosition();
    _animateScroll(position.target!, target, _scrollListener, duration, curve);
  }

  void _animateScroll(LatLng begin, LatLng end, void Function() listener,
      [int duration = 1000, Curve curve = Curves.easeOutCubic]) {
    final tween = AlignmentTween(
      begin: Alignment(begin.latitude, begin.longitude),
      end: Alignment(end.latitude, end.longitude),
    );
    _aScroll = tween.animate(CurvedAnimation(parent: _acScroll, curve: curve));
    _aScroll?.removeListener(_scaleEndScrollListener);
    _aScroll?.removeListener(_scrollListener);
    _aScroll?.addListener(listener);
    _acScroll.reset();
    _acScroll.duration = Duration(milliseconds: duration);
    _acScroll.forward();
  }

  void _zoomListener() {
    controller.zoom(_aZoom!.value);
  }

  void _scrollListener() {
    controller.moveCamera(
        CameraPosition(target: LatLng(_aScroll!.value!.x, _aScroll!.value!.y)));
  }

  void _scaleEndScrollListener() {
    if (_offset.distanceSquared == 0) {
      _offset = Offset(_aScroll!.value!.x, _aScroll!.value!.y);
      return;
    }
    final x = _aScroll!.value!.x - _offset.dx;
    final y = _aScroll!.value!.y - _offset.dy;
    controller.scroll(x, y);
    _offset = Offset(_aScroll!.value!.x, _aScroll!.value!.y);
  }
}
