import 'package:flutter/physics.dart';

import '../../main.dart';
import 'state.dart';

class Maps extends StatefulWidget {
  const Maps();

  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> with TickerProviderStateMixin<Maps> {
  double dx = 0;
  double dy = 0;
  double scale = 0;
  double rotation = 0;
  CameraPosition? cameraPosition;
  late MapViewController mapView;
  late AnimationController scrollAC;
  late AnimationController zoomAC;
  late Animation<FractionalOffset?> offsetA;
  late Animation<double> zoomA;
  DateTime time = DateTime.now();
  late double zoom;

  @override
  void initState() {
    super.initState();
    scrollAC = AnimationController(vsync: this);
    zoomAC = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (event) async {
        scrollAC.stop();

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
          zoom = log(event.scale) / log(2) + cameraPosition!.zoom!;
          mapView.zoom(zoom);
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
        if (scale.abs() > 0.1) {
          time = DateTime.now();
          final tween = Tween(begin: zoom, end: zoom + scale.sign / 2);
          zoomA = zoomAC.drive(tween);
          zoomA.removeListener(zoomListener);
          zoomA.addListener(zoomListener);
          const spring = SpringDescription(mass: 50, stiffness: 1, damping: 1);
          return zoomAC.animateWith(SpringSimulation(spring, 0, 1, 1));
        }

        final now = DateTime.now().millisecondsSinceEpoch;
        if (now - time.millisecondsSinceEpoch < 100) {
          return;
        }

        final velocity = event.velocity.pixelsPerSecond;
        final tween = FractionalOffsetTween(
          begin: const FractionalOffset(0, 0),
          end: FractionalOffset(velocity.dx, velocity.dy),
        );
        dx = 0;
        dy = 0;
        final duration =
            event.velocity.pixelsPerSecond.distance ~/ Get.pixelRatio;
        offsetA = tween.animate(CurvedAnimation(
            parent: scrollAC,
            curve: Cubic(0, min(duration / 1000, 0.9), 0.5, 1)));
        offsetA.removeListener(scrollListener);
        offsetA.addListener(scrollListener);
        scrollAC.reset();
        scrollAC.duration = Duration(milliseconds: duration);
        await scrollAC.forward();
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

  void zoomListener() {
    mapView.zoom(zoomA.value);
  }

  void scrollListener() {
    if (dx == 0 || dy == 0) {
      dx = offsetA.value!.dx;
      dy = offsetA.value!.dy;
      return;
    }
    final x = offsetA.value!.dx - dx;
    final y = offsetA.value!.dy - dy;
    mapView.scroll(x, y);
    dx = offsetA.value!.dx;
    dy = offsetA.value!.dy;
  }

  HomeState get state => Get.find<HomeState>();
}
