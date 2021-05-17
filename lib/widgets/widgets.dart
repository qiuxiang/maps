import '../main.dart';

export 'align.dart';
export 'loading.dart';
export 'page.dart';
export 'rounded_button.dart';

abstract class GetxWidget<T> extends StatelessWidget {
  const GetxWidget({Key? key}) : super(key: key);

  final String? tag = null;

  T get state => Get.find<T>(tag: tag)!;
}

mixin GetState<T> {
  T get state => Get.find<T>()!;
}

class VerticalSpace extends StatelessWidget {
  const VerticalSpace();

  @override
  Widget build(BuildContext context) {
    return Container(height: 10, color: Get.theme.scaffoldBackgroundColor);
  }
}
