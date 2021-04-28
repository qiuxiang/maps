import 'main.dart';
import 'maps.dart';

class Home extends GetxWidget<AppState> {
  const Home();

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => AppState());
    return const AnnotatedRegion(
      value: SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(body: Maps()),
    );
  }
}
