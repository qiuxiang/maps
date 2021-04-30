import '../../main.dart';

enum HomeStateId { focus }

const mainPanelMinHeight = 80.0;

class HomeState extends GetxController {
  late MapViewController mapView;
  final focusNode = FocusNode();
  final secondaryPanel = PanelController();
  final panel = PanelController();
  final fabPosition = mainPanelMinHeight.obs;
  final poi = Rx<MapPoi?>(null);

  @override
  void onInit() {
    super.onInit();
    focusNode.addListener(() {
      update([HomeStateId.focus]);
      if (focusNode.hasFocus) {
        panel.open();
      }
    });
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      secondaryPanel.hide();
    });
  }

  void hideSecondaryPanel() async {
    await panel.show();
    await secondaryPanel.hide();
    poi.value = null;
  }
}
