import '../../main.dart';
import 'state.dart';

class MainPanel extends GetxWidget<HomeState> {
  const MainPanel();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          focusNode: state.focusNode,
          style: const TextStyle(fontSize: 18),
          textInputAction: TextInputAction.search,
          onChanged: state.onSearchTyping,
          decoration: InputDecoration(
            hintText: '搜索地点',
            hintStyle: const TextStyle(fontSize: 18),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            fillColor: context.isDarkMode
                ? Get.theme.cardColor
                : Get.theme.dividerColor,
            filled: true,
            prefixIcon: GetBuilder<HomeState>(
              id: HomeStateId.focus,
              builder: (_) {
                if (state.focusNode.hasFocus) {
                  return CupertinoButton(
                    onPressed: state.closeMainPanel,
                    padding: EdgeInsets.zero,
                    child: Icon(Icons.arrow_back,
                        color: Get.textTheme.caption?.color),
                  );
                }
                return Icon(Icons.search, color: Get.textTheme.caption?.color);
              },
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide.none,
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      const SizedBox(height: 16),
      const Expanded(child: Suggestions()),
    ]);
  }
}

class Suggestions extends StatelessWidget with GetState<HomeState> {
  const Suggestions();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        padding: EdgeInsets.zero,
        itemBuilder: (_, i) => Item(state.suggestions[i]),
        itemCount: state.suggestions.length,
      );
    });
  }
}

class Item extends StatelessWidget {
  final dynamic item;

  Item(this.item);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      title: Text(item['title']),
      subtitle: Text(item['address'], maxLines: 1),
    );
  }
}
