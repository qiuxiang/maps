import 'package:flutter/animation.dart';
import 'package:flutter/services.dart';

import 'map_view.dart';
import 'marker.dart';
import 'types.dart';

class MapViewController {
  final MethodChannel _channel;
  final MapViewState state;
  final markers = <String, Marker>{};
  CameraPosition? cameraPosition;

  MapViewController(int id, this.state)
      : _channel = MethodChannel('map_view_$id') {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onTap':
          state.widget.onTap?.call(LatLng.fromJson(call.arguments));
          break;
        case 'onTapPoi':
          state.widget.onTapPoi?.call(MapPoi.fromJson(call.arguments));
          break;
        case 'onLongPress':
          state.widget.onLongPress?.call(LatLng.fromJson(call.arguments));
          break;
        case 'onLocation':
          state.widget.onLocation?.call(Location.fromJson(call.arguments));
          break;
        case 'onTapMarker':
          state.widget.onTapMarker?.call(markers[call.arguments]!);
          break;
        case 'onTapClusterItem':
          state.widget.onTapClusterItem?.call(call.arguments);
          break;
      }
    });
  }

  Future<void> setMapType(int mapType) {
    return _channel.invokeMethod('setMapType', mapType);
  }

  Future<void> scroll(double x, double y) {
    return _channel.invokeMethod('scroll', [x, y]);
  }

  Future<void> zoom(double level) {
    return _channel.invokeMethod('zoom', [level]);
  }

  Future<void> rotate(double bearing) {
    return _channel.invokeMethod('rotate', bearing);
  }

  Future<CameraPosition> getCameraPosition() async {
    return CameraPosition.fromJson(
        await _channel.invokeMethod('getCameraPosition'));
  }

  Future<Location> getLocation() async {
    return Location.fromJson(await _channel.invokeMethod('getLocation'));
  }

  Future<void> moveCamera(CameraPosition position, [int duration = 0]) {
    return _channel.invokeMethod(
        'moveCamera', position.toJson()..addAll({'duration': duration}));
  }

  Future<Marker> addMarker(MarkerOptions options) async {
    final id = await _channel.invokeMethod('addMarker', options.toJson());
    final marker = Marker(this, id);
    markers[id] = marker;
    return marker;
  }

  Future<void> addClusterItems(List<ClusterItem> list) {
    return _channel.invokeMethod(
        'addClusterItems', list.map((i) => i.toJson()).toList());
  }

  Future<void> clearClusterItems(List<ClusterItem> list) {
    return _channel.invokeMethod('clearClusterItems');
  }

  void animateScroll(LatLng target,
      [int duration = 1000, Curve curve = Curves.easeOutCubic]) {
    state.animateScroll(target, duration, curve);
  }
}
