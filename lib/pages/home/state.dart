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
  final suggestions = [].obs;
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

  void onSearchTyping(String value) async {
    final result = await getSuggestions(value, '');
    suggestions.assignAll(result['data']);
  }

  void closeMainPanel() {
    mainPanel.close();
    focusNode.unfocus();
    suggestions.clear();
  }

  void onCreated(MapViewController controller) {
    mapView = controller;
    mapView.addClusterItems(const [
      ClusterItem(LatLng(39.984059, 116.307621)),
      ClusterItem(LatLng(39.981954, 116.304703)),
      ClusterItem(LatLng(39.984355, 116.312256)),
      ClusterItem(LatLng(39.980442, 116.315346)),
      ClusterItem(LatLng(39.981527, 116.308994)),
      ClusterItem(LatLng(39.979751, 116.310539)),
      ClusterItem(LatLng(39.977252, 116.305776)),
      ClusterItem(LatLng(39.984026, 116.316419)),
      ClusterItem(LatLng(39.976956, 116.314874)),
      ClusterItem(LatLng(39.978501, 116.311827)),
      ClusterItem(LatLng(39.980277, 116.312814)),
      ClusterItem(LatLng(39.980236, 116.369022)),
      ClusterItem(LatLng(39.978838, 116.368486)),
      ClusterItem(LatLng(39.977161, 116.367488)),
      ClusterItem(LatLng(39.915398, 116.396713)),
      ClusterItem(LatLng(39.937645, 116.455421)),
      ClusterItem(LatLng(39.896304, 116.321182)),
      ClusterItem(LatLng(31.254487, 121.452827)),
      ClusterItem(LatLng(31.225133, 121.485443)),
      ClusterItem(LatLng(31.216912, 121.442528)),
      ClusterItem(LatLng(31.251552, 121.500893)),
      ClusterItem(LatLng(31.249204, 121.455917)),
      ClusterItem(LatLng(22.546885, 114.042892)),
      ClusterItem(LatLng(22.538086, 113.999805)),
      ClusterItem(LatLng(22.534756, 114.082031)),
    ]);
  }
}
