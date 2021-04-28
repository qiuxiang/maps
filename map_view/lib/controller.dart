import 'package:flutter/services.dart';

import 'map_view.dart';

class MapViewController {
  final MethodChannel _channel;

  MapViewController(int id) : _channel = MethodChannel('map_view_$id') {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onTap':
          break;
        case 'onTapPoi':
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
}
