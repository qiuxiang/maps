import 'package:permission_handler/permission_handler.dart';

import '../../main.dart';
import 'bottom.dart';
import 'maps.dart';

class HomePage extends GetxWidget<AppState> {
  const HomePage();

  @override
  Widget build(BuildContext context) {
    Permission.location.request();
    Get.lazyPut(() => AppState());
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Stack(children: [
          const Maps(),
          Positioned(bottom: 0, width: Get.width, child: const Bottom()),
        ]),
      ),
    );
  }
}
