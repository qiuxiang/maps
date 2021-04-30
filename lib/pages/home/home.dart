import 'package:permission_handler/permission_handler.dart';

import '../../main.dart';
import 'main_sliding_up_panel.dart';
import 'poi.dart';
import 'state.dart';

class HomePage extends GetxWidget<HomeState> {
  const HomePage();

  @override
  Widget build(BuildContext context) {
    Permission.location.request();
    Get.lazyPut(() => HomeState());
    final maxHeight = Get.mediaQuery.size.height - Get.mediaQuery.padding.top;
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
          controller: state.secondaryPanel,
          minHeight: mainPanelMinHeight,
          maxHeight: maxHeight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          panel: Material(
            color: Get.theme.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: const Poi(),
          ),
          body: const MainSlidingUpPanel(),
          onPanelSlide: (position) {
            state.fabPosition.value = maxHeight * position + mainPanelMinHeight;
          },
        ),
      ),
    );
  }
}
