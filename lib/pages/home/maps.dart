import 'dart:math';

import 'package:flutter/physics.dart';

import '../../main.dart';
import 'state.dart';

class Maps extends StatefulWidget {
  const Maps();

  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> with SingleTickerProviderStateMixin<Maps> {
  double dx = 0;
  double dy = 0;
  double scale = 0;
  double rotation = 0;
  CameraPosition? cameraPosition;
  late MapViewController mapView;
  late AnimationController animate;
  late Animation<FractionalOffset?> offset;

  @override
  void initState() {
    super.initState();
    animate = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        animate.stop();
      },
      onScaleStart: (event) async {
        animate.stop();
        dx = event.focalPoint.dx;
        dy = event.focalPoint.dy;
        scale = 0;
        rotation = 0;
        cameraPosition = await mapView.getCameraPosition();
      },
      onScaleUpdate: (event) {
        final x = event.focalPoint.dx - dx;
        final y = event.focalPoint.dy - dy;
        mapView.scroll(x * Get.pixelRatio, y * Get.pixelRatio);
        dx = event.focalPoint.dx;
        dy = event.focalPoint.dy;

        if (scale == 0 || cameraPosition == null) {
          scale = event.scale;
        } else {
          final zoom = log(event.scale) / log(2);
          mapView.zoom(zoom + cameraPosition!.zoom!);
        }
        // if (rotation == 0 || cameraPosition == null) {
        //   rotation = event.rotation;
        // } else {
        //   mapView.rotate(event.rotation * 180 / pi);
        // }
      },
      onScaleEnd: (event) {
        final velocity = event.velocity.pixelsPerSecond;
        final tween = FractionalOffsetTween(
          begin: const FractionalOffset(0, 0),
          end: FractionalOffset(velocity.dx, velocity.dy),
        );
        dx = 0;
        dy = 0;
        final simulation = FrictionSimulation(1e-6, 0, velocity.distance / 500);
        offset = animate.drive(tween);
        offset.addListener(listener);
        animate.animateWith(simulation);
      },
      child: MapView(
        onCreated: (controller) {
          Get.find<HomeState>().mapView = controller;
          mapView = controller;
        },
      ),
    );
  }

  void listener() {
    if (dx == 0 || dy == 0) {
      dx = offset.value!.dx;
      dy = offset.value!.dy;
      return;
    }
    final x = offset.value!.dx - dx;
    final y = offset.value!.dy - dy;
    mapView.scroll(x, y);
    dx = offset.value!.dx;
    dy = offset.value!.dy;
  }
}
