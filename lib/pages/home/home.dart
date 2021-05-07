import 'package:permission_handler/permission_handler.dart';

import '../../main.dart';
import 'maps.dart';
import 'panel.dart';
import 'poi.dart';
import 'state.dart';

class HomePage extends GetxWidget<HomeState> {
  const HomePage();

  @override
  Widget build(BuildContext context) {
    Permission.location.request();
    Get.lazyPut(() => HomeState());
    final maxHeight = Get.mediaQuery.size.height -
        Get.mediaQuery.padding.top -
        context.mediaQuery.viewInsets.bottom;
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        systemNavigationBarIconBrightness:
            context.isDarkMode ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: Get.theme.scaffoldBackgroundColor,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            context.isDarkMode ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        body: SlidingUpPanel(
          controller: state.mainPanel,
          minHeight: mainPanelMinHeight,
          maxHeight: maxHeight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          panel: Material(
            color: Get.theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: const MainPanel(),
          ),
          body: SlidingUpPanel(
            controller: state.secondaryPanel,
            minHeight: mainPanelMinHeight,
            maxHeight: maxHeight,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            panel: Material(
              color: Get.theme.scaffoldBackgroundColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: const Poi(),
            ),
            body: Stack(children: [
              const Maps(),
              Obx(() {
                final position = state.poi.value == null
                    ? state.mainPanel.panelPosition
                    : state.secondaryPanel.panelPosition;
                return Positioned(
                  bottom: state.fabPosition.value + 16,
                  right: 16,
                  child: Opacity(
                    opacity: min(max(-3 - 6 * (position - 1), 0), 1),
                    child: FloatingActionButton(
                      foregroundColor:
                          context.isDarkMode ? Colors.white70 : null,
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
              state.fabPosition.value =
                  maxHeight * position + mainPanelMinHeight;
            },
          ),
          onPanelSlide: (position) {
            state.fabPosition.value = maxHeight * position + mainPanelMinHeight;
          },
          onPanelClosed: () {
            state.focusNode.unfocus();
          },
        ),
      ),
    );
  }

  void toLocation() async {
    final location = await state.mapView.getLocation();
    state.mapView.animateScroll(LatLng(location.latitude, location.longitude),
        600, Curves.easeInOutSine);
  }
}
