import '../main.dart';

void snackBar(String content,
    {String? label, void Function()? onPressed}) async {
  if (Get.context == null) return print('showSnackBar: $content');

  ScaffoldMessenger.of(Get.context!)
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(content),
      duration: const Duration(seconds: 4),
      action: label == null
          ? null
          : SnackBarAction(label: label, onPressed: onPressed ?? () {}),
    ));
}

Widget buildIf(
  dynamic value,
  Widget Function() builder, {
  bool sliver = false,
}) {
  final placeholder =
      sliver ? const SliverPadding(padding: EdgeInsets.zero) : const SizedBox();

  if (value == null) return placeholder;
  if (value is bool && !value) return placeholder;

  return builder();
}

Future<void> alert(String title) async {
  if (Get.context == null) return;

  return showDialog(
    context: Get.context!,
    builder: (_) => AlertDialog(
      title: Text(title),
      actions: [TextButton(onPressed: Get.back, child: const Text('确定'))],
    ),
  );
}