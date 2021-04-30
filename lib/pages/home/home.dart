import 'package:permission_handler/permission_handler.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../main.dart';
import 'maps.dart';
import 'panel.dart';
import 'state.dart';

class HomePage extends GetxWidget<HomeState> {
  const HomePage();

  @override
  Widget build(BuildContext context) {
    Permission.location.request();
    Get.lazyPut(() => HomeState());
    const minHeight = 80.0;
    final maxHeight = Get.mediaQuery.size.height -
        Get.mediaQuery.padding.top -
        MediaQuery.of(context).viewInsets.bottom;
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: SlidingUpPanel(
          controller: state.panel,
          minHeight: minHeight,
          maxHeight: maxHeight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          backdropEnabled: true,
          panel: const Panel(),
          body: Stack(children: [
            const Maps(),
            Obx(() {
              return Positioned(
                bottom: state.panelHeight.value + 16,
                right: 16,
                child: Opacity(
                  opacity: max(1 - state.panel.panelPosition * 5, 0),
                  child: FloatingActionButton(
                    child: const Icon(Icons.my_location),
                    onPressed: toLocation,
                  ),
                ),
              );
            }),
          ]),
          onPanelSlide: (position) {
            state.panelHeight.value = maxHeight * position + minHeight;
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
    await state.mapView.moveCamera(CameraPosition(
        target: LatLng(location.latitude, location.longitude), zoom: 16));
  }
}
