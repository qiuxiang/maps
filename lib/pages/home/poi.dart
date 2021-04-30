import '../../main.dart';
import 'state.dart';

class Poi extends GetxWidget<HomeState> {
  const Poi();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.only(left: 16, top: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(
                child: Text(
                  '${state.poi.value?.name}',
                  style: Get.textTheme.headline6,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: state.hideSecondaryPanel,
                splashRadius: 24,
              ),
            ]),
          ],
        ),
      );
    });
  }
}
