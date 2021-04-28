import 'package:map_view/map_view.dart';

import 'main.dart';

class AppState extends GetxController {
  late MapViewController controller;
  double scale = 0;
  double rotation = 0;
  double dx = 0;
  double dy = 0;
  CameraPosition? cameraPosition;
}
