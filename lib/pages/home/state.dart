import '../../main.dart';

enum HomeStateId { focus }

const mainPanelMinHeight = 80.0;

class HomeState extends GetxController {
  late MapViewController mapView;
  final focusNode = FocusNode();
  final mainPanel = PanelController();
  final secondaryPanel = PanelController();
  final fabPosition = mainPanelMinHeight.obs;
  final poi = Rx<MapPoi?>(null);
  Marker? marker;

  @override
  void onInit() {
    super.onInit();
    focusNode.addListener(() {
      update([HomeStateId.focus]);
      if (focusNode.hasFocus) {
        mainPanel.open();
      }
    });
  }

  void hideSecondaryPanel() async {
    await mainPanel.show();
    await secondaryPanel.hide();
    poi.value = null;
    await marker?.remove();
    marker = null;
  }
}
