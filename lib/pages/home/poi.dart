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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: state.hidePoi,
                splashRadius: 24,
              ),
            ]),
            SizedBox(height: 32, child: buildPoiInfo()),
            const Buttons(),
          ],
        ),
      );
    });
  }

  Widget buildPoiInfo() {
    if (state.poiLoading.isTrue) {
      return const Loading(size: 16, align: Alignment.topLeft);
    }

    final poiInfo = state.poiInfo.value!['result'];
    return Text('${poiInfo['address']}');
  }
}

class Buttons extends StatelessWidget {
  const Buttons();

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      RoundedButton(
        icon: Icons.directions,
        text: '路线',
        onPressed: () {},
      ),
      const SizedBox(width: 8),
      RoundedButton(
        icon: Icons.navigation,
        text: '导航',
        textColor: Get.textTheme.bodyText1?.color,
        border: BorderSide(color: Get.theme.dividerColor),
        color: Colors.white,
        onPressed: () {},
      ),
    ]);
  }
}
