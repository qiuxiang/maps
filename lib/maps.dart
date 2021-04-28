import 'dart:math';

import 'main.dart';

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

  late AnimationController controller;
  late Animation<double> animation;
  late CurvedAnimation curved;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this);
    curved = CurvedAnimation(parent: controller, curve: Curves.easeOutQuart);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (e) async {
        dx = e.focalPoint.dx;
        dy = e.focalPoint.dy;
        scale = 0;
        rotation = 0;
        cameraPosition = await mapView.getCameraPosition();
      },
      onScaleUpdate: (e) {
        final x = e.focalPoint.dx - dx;
        final y = e.focalPoint.dy - dy;
        mapView.scroll(x * Get.pixelRatio, y * Get.pixelRatio);
        dx = e.focalPoint.dx;
        dy = e.focalPoint.dy;

        if (scale == 0 || cameraPosition == null) {
          scale = e.scale;
        } else {
          final zoom = log(e.scale) / log(2);
          mapView.zoom(zoom + cameraPosition!.zoom!);
        }
        // if (rotation == 0 || cameraPosition == null) {
        //   rotation = e.rotation;
        //   print(e.rotation);
        // } else {
        //   controller.rotate(e.rotation * 180 / pi);
        // }
      },
      onScaleEnd: (event) {
        final ratio = MediaQuery.of(context).devicePixelRatio;
        final v = event.velocity.pixelsPerSecond.dx / (ratio == 1 ? 4 : ratio);
        const a = 1;
        final t = (v ~/ a).abs();
        final s = (v * t - a * t * t / 2) / 1000;
        // controller.reset();
        // controller.duration = Duration(milliseconds: t);
        // controller.forward();
      },
      child: MapView(
        onCreated: (controller) => mapView = controller,
      ),
    );
  }
}
