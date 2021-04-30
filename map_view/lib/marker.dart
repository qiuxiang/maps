import 'package:flutter/services.dart';

import 'controller.dart';
import 'types.dart';

/// 地图标记覆盖物
class MarkerOptions {
  /// 标记坐标
  final LatLng position;

  final String? asset;

  const MarkerOptions({required this.position, this.asset});

  Map<String, Object?> toJson() => {
        'position': position.toJson(),
        'asset': asset,
      };
}

/// 地图标记覆盖物
class Marker {
  final MethodChannel _channel;
  final MapViewController mapView;
  final String id;

  Marker(this.mapView, this.id)
      : _channel = MethodChannel('map_view_marker_$id');

  Future<void> remove() {
    mapView.markers.remove(id);
    return _channel.invokeMethod('remove');
  }

  Future<void> update(MarkerOptions options) {
    return _channel.invokeMethod('update', options.toJson());
  }
}
