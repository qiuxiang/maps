import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TencentMapView extends StatefulWidget {
  const TencentMapView();

  @override
  State<TencentMapView> createState() => TencentMapViewState();
}

class TencentMapViewState extends State<TencentMapView> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return const AndroidView(viewType: 'MapView');
    }
    return Text('$defaultTargetPlatform is not yet supported');
  }
}
