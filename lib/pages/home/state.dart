import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../main.dart';

enum HomeStateId { focus }

class HomeState extends GetxController {
  late MapViewController mapView;
  final focusNode = FocusNode();
  final panel = PanelController();
  final panelHeight = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    focusNode.addListener(() {
      update([HomeStateId.focus]);
      if (focusNode.hasFocus) {
        panel.open();
      }
    });
  }
}
