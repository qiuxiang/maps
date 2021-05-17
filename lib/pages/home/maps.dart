import '../../main.dart';
import 'state.dart';

class Maps extends GetxWidget<HomeState> {
  const Maps();

  @override
  Widget build(BuildContext context) {
    return MapView(
      mapType: context.isDarkMode ? MapType.dark : MapType.normal,
      onCreated: state.onCreated,
      onTapPoi: state.onTapPoi,
      onTap: (_) => state.hidePoi(),
      onLongPress: state.onLogPress,
      onTapMarker: print,
      onTapClusterItem: print,
    );
  }
}
