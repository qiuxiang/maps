import 'package:flutter/cupertino.dart';

/// 经纬度坐标
@immutable
class LatLng {
  /// 纬度
  final double latitude;

  /// 经度
  final double longitude;

  const LatLng(this.latitude, this.longitude);

  LatLng.fromJson(json)
      : latitude = json['latitude'],
        longitude = json['longitude'];

  Map<String, double> toJson() =>
      {'latitude': latitude, 'longitude': longitude};

  @override
  bool operator ==(Object it) =>
      it is LatLng && it.latitude == latitude && it.longitude == longitude;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;

  @override
  String toString() => '$latitude,$longitude';
}

/// 地图状态
@immutable
class CameraPosition {
  /// 坐标
  final LatLng? target;

  /// 倾斜角度（视角）
  final double? tilt;

  /// 旋转角度（方向）
  final double? bearing;

  /// 缩放级别
  final double? zoom;

  const CameraPosition({this.target, this.tilt, this.bearing, this.zoom});

  CameraPosition.fromJson(json)
      : target = LatLng.fromJson(json['target']),
        tilt = json['tilt'],
        bearing = json['bearing'],
        zoom = json['zoom'];

  Map<String, Object?> toJson() => {
        'target': target?.toJson(),
        'tilt': tilt,
        'bearing': bearing,
        'zoom': zoom,
      };

  @override
  bool operator ==(Object it) =>
      it is CameraPosition &&
      it.target == target &&
      it.tilt == tilt &&
      it.bearing == bearing &&
      it.zoom == zoom;

  @override
  int get hashCode =>
      target.hashCode ^ tilt.hashCode ^ bearing.hashCode ^ zoom.hashCode;
}

// ignore: avoid_classes_with_only_static_members
class MapType {
  static const int none = -1;
  static const int normal = 1000;
  static const int dark = 1008;
  static const int trafficNavi = 1009;
  static const int trafficNight = 1010;
  static const int satellite = 1011;
  static const int navi = 1012;
  static const int night = 1013;
}

class Location {
  final double latitude;
  final double longitude;
  final double accuracy;

  Location.fromJson(json)
      : latitude = json['latitude'],
        longitude = json['longitude'],
        accuracy = json['accuracy'];
}

class MapPoi {
  final LatLng position;
  final String name;

  MapPoi(this.position, this.name);

  MapPoi.fromJson(json)
      : position = LatLng.fromJson(json['position']),
        name = json['name'];
}

class ClusterItem {
  final LatLng position;
  final String? asset;

  const ClusterItem(this.position, [this.asset]);

  ClusterItem.fromJson(json)
      : position = LatLng.fromJson(json['position']),
        asset = json['asset'];

  Map<String, Object?> toJson() => {
        'position': position.toJson(),
        'asset': asset,
      };
}
