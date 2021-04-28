import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'controller.dart';

export 'controller.dart';
export 'types.dart';

class MapView extends StatefulWidget {
  /// 地图创建完成时调用
  ///
  /// 可以使用参数 [MapViewController] 控制地图
  final void Function(MapViewController)? onCreated;

  const MapView({this.onCreated});

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
    controller = MapViewController(id);
    widget.onCreated?.call(controller);
  }
}
