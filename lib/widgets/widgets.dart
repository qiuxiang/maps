import '../main.dart';

export 'align.dart';
export 'page.dart';

abstract class GetxWidget<T> extends StatelessWidget {
  const GetxWidget({Key? key}) : super(key: key);

  final String? tag = null;

  T get state => GetInstance().find<T>(tag: tag)!;
}

class VerticalSpace extends StatelessWidget {
  const VerticalSpace();

  @override
  Widget build(BuildContext context) {
    return Container(height: 10, color: Get.theme.scaffoldBackgroundColor);
  }
}
