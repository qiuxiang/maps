import 'package:flutter/cupertino.dart';

/// 经纬度坐标
@immutable
class LatLng {
  /// 纬度
  final double latitude;

  /// 经度
  final double longitude;

  const LatLng(this.latitude, this.longitude);

  LatLng.fromJson(map)
      : latitude = map['latitude'],
        longitude = map['longitude'];

  Map<String, double> toJson() =>
      {'latitude': latitude, 'longitude': longitude};

  @override
  bool operator ==(Object it) =>
      it is LatLng && it.latitude == latitude && it.longitude == longitude;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
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

  CameraPosition.fromJson(map)
      : target = LatLng.fromJson(map['target']),
        tilt = map['tilt'],
        bearing = map['bearing'],
        zoom = map['zoom'];

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
