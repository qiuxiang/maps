import '../../main.dart';

class Bottom extends GetxWidget<AppState> {
  const Bottom();

  @override
  Widget build(BuildContext context) {
    const minHeight = kToolbarHeight + 56 + 16;
    final screenHeight =
        Get.mediaQuery.size.height - Get.mediaQuery.padding.top;
    final minSize = minHeight / screenHeight;
    return SizedBox(
      height: screenHeight,
      child: DraggableScrollableSheet(
        initialChildSize: minSize,
        minChildSize: minSize,
        builder: (_, controller) {
          return CustomScrollView(controller: controller, slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  padding: const EdgeInsets.only(right: 16, bottom: 16),
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    child: const Icon(Icons.my_location),
                    onPressed: toMyLocation,
                  ),
                ),
              ]),
            ),
            SliverFillRemaining(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [],
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }

  void toMyLocation() async {
    final location = await state.mapView.getLocation();
    await state.mapView.moveCamera(CameraPosition(
        target: LatLng(location.latitude, location.longitude), zoom: 16));
  }
}
