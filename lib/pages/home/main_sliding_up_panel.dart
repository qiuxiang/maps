import '../../main.dart';
import 'maps.dart';
import 'panel.dart';
import 'state.dart';

class MainSlidingUpPanel extends GetxWidget<HomeState> {
  const MainSlidingUpPanel();

  @override
  Widget build(BuildContext context) {
    final maxHeight = Get.mediaQuery.size.height - Get.mediaQuery.padding.top;
    return SlidingUpPanel(
      controller: state.panel,
      minHeight: mainPanelMinHeight,
      maxHeight: maxHeight,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      panel: Material(
        color: Get.theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: const Panel(),
      ),
      body: Stack(children: [
        const Maps(),
        Obx(() {
          final position = state.poi.value == null
              ? state.panel.panelPosition
              : state.secondaryPanel.panelPosition;
          return Positioned(
            bottom: state.fabPosition.value + 16,
            right: 16,
            child: Opacity(
              opacity: min(max(-3 - 6 * (position - 1), 0), 1),
              child: FloatingActionButton(
                foregroundColor: context.isDarkMode ? Colors.white70 : null,
                backgroundColor: context.isDarkMode
                    ? Get.theme.scaffoldBackgroundColor
                    : null,
                child: const Icon(Icons.my_location),
                onPressed: toLocation,
              ),
            ),
          );
        }),
      ]),
      onPanelSlide: (position) {
        state.fabPosition.value = maxHeight * position + mainPanelMinHeight;
      },
      onPanelClosed: () {
        state.focusNode.unfocus();
      },
    );
  }

  void toLocation() async {
    final location = await state.mapView.getLocation();
    await state.mapView.moveCamera(CameraPosition(
        target: LatLng(location.latitude, location.longitude), zoom: 16));
  }
}
