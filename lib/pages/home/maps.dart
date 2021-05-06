import '../../main.dart';
import 'state.dart';

class Maps extends GetxWidget<HomeState> {
  const Maps();

  @override
  Widget build(BuildContext context) {
    return MapView(
      mapType: context.isDarkMode ? MapType.dark : MapType.normal,
      onCreated: (controller) {
        state.mapView = controller;
      },
      onTapPoi: (poi) {
        state.poi.value = poi;
        state.mapView.animateScroll(poi.position);
        state.mainPanel.hide();
        state.secondaryPanel.show();
        if (state.marker == null) {
          state.mapView
              .addMarker(MarkerOptions(
                position: poi.position,
                asset: 'asset/marker.png',
              ))
              .then((marker) => state.marker = marker);
        } else {
          state.marker?.update(MarkerOptions(position: poi.position));
        }
      },
      onTap: (_) => state.hideSecondaryPanel(),
    );
  }
}
