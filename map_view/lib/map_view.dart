import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'controller.dart';
import 'types.dart';

export 'controller.dart';
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

class MapViewState extends State<MapView> {
  late MapViewController controller;

  @override
  Widget build(BuildContext context) {
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
    controller = MapViewController(id, widget);
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
}
