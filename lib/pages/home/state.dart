import '../../main.dart';

enum HomeStateId { focus }

const mainPanelMinHeight = 80.0;
const secondaryPanelMinHeight = 120.0;

class HomeState extends GetxController {
  late MapViewController mapView;
  final focusNode = FocusNode();
  final mainPanel = PanelController();
  final secondaryPanel = PanelController();
  final fabPosition = mainPanelMinHeight.obs;
  final poi = Rx<MapPoi?>(null);
  final poiInfo = Rx<Map?>(null);
  final poiLoading = true.obs;
  Marker? marker;

  double get panelMinHeight =>
      poi.value == null ? mainPanelMinHeight : secondaryPanelMinHeight;

  @override
  void onInit() {
    super.onInit();
    focusNode.addListener(() {
      update([HomeStateId.focus]);
      if (focusNode.hasFocus) {
        mainPanel.open();
      }
    });
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      secondaryPanel.hide();
    });
  }

  Future<void> hideSecondaryPanel() async {
    await mainPanel.show();
    await secondaryPanel.hide();
    poi.value = null;
    await marker?.remove();
    marker = null;
  }

  void onTapPoi(MapPoi poi, [Map? info]) {
    this.poi.value = poi;
    mapView.animateScroll(poi.position, 600);
    mainPanel.hide();
    secondaryPanel.show();
    if (marker == null) {
      final options =
          MarkerOptions(position: poi.position, asset: 'asset/marker.png');
      mapView.addMarker(options).then((marker) => this.marker = marker);
    } else {
      marker?.update(MarkerOptions(position: poi.position));
    }
    if (info == null) {
      poiLoading.value = true;
      reGeocode(poi.position).then((result) {
        poiInfo.value = result;
        poiLoading.value = false;
      });
    }
  }

  void hidePoi() async {
    await hideSecondaryPanel();
    fabPosition.value = panelMinHeight;
  }

  void onLogPress(LatLng latLng) async {
    poiInfo.value = await reGeocode(latLng);
    onTapPoi(MapPoi(
        latLng, poiInfo.value!['result']['formatted_addresses']['recommend']));
    poiLoading.value = false;
  }
}
