import 'main.dart';

class Home extends GetxWidget<AppState> {
  const Home();

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => AppState());
    return SizedBox();
  }
}
