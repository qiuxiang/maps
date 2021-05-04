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
  DateTime time = DateTime.now();

  @override
  void initState() {
    super.initState();
    animate = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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

        if (scale != 0 && cameraPosition != null) {
          final zoom = log(event.scale) / log(2);
          mapView.zoom(zoom + cameraPosition!.zoom!);
        }
        scale = event.scale;
        // if (rotation == 0 || cameraPosition == null) {
        //   rotation = event.rotation;
        // } else {
        //   mapView.rotate(event.rotation * 180 / pi);
        // }
      },
      onScaleEnd: (event) async {
        scale -= 1;
        if (scale.abs() > 0.2) {
          time = DateTime.now();
          return;
          // cameraPosition = await mapView.getCameraPosition();
          // final tween = Tween(
          //   begin: cameraPosition!.zoom,
          //   end: cameraPosition!.zoom! + scale.sign,
          // );
          // final zoom = animate.drive(tween);
          // zoom.addListener(() {
          //   // mapView.zoom(zoom.value!);
          // });
          // const spring = SpringDescription(mass: 20, stiffness: 1, damping: 1);
          // animate.reset();
          // return animate.animateWith(SpringSimulation(spring, 0, 1, 1));
        }

        final now = DateTime.now().millisecondsSinceEpoch;
        if (now - time.millisecondsSinceEpoch < 1000) {
          return;
        }

        final velocity = event.velocity.pixelsPerSecond;
        final tween = FractionalOffsetTween(
          begin: const FractionalOffset(0, 0),
          end: FractionalOffset(velocity.dx, velocity.dy),
        );
        dx = 0;
        dy = 0;
        offset = tween.animate(
            CurvedAnimation(parent: animate, curve: Curves.easeOutCubic));
        offset.removeListener(offsetListener);
        offset.addListener(offsetListener);
        animate.reset();
        final duration =
            event.velocity.pixelsPerSecond.distance ~/ Get.pixelRatio;
        animate.duration = Duration(milliseconds: duration);
        await animate.forward();
      },
      child: MapView(
        mapType: context.isDarkMode ? MapType.dark : MapType.normal,
        onCreated: (controller) {
          state.mapView = controller;
          mapView = controller;
        },
        onTapPoi: (poi) {
          state.poi.value = poi;
          mapView.moveCamera(CameraPosition(target: poi.position), 200);
          state.panel.hide();
          state.secondaryPanel.show();
          if (state.marker == null) {
            mapView
                .addMarker(MarkerOptions(position: poi.position))
                .then((marker) => state.marker = marker);
          } else {
            state.marker?.update(MarkerOptions(position: poi.position));
          }
        },
        onTap: (_) => state.hideSecondaryPanel(),
      ),
    );
  }

  void offsetListener() {
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

  HomeState get state => Get.find<HomeState>();
}
