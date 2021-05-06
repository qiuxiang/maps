import '../../main.dart';
import 'state.dart';

class MainPanel extends GetxWidget<HomeState> {
  const MainPanel();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        TextField(
          focusNode: state.focusNode,
          style: const TextStyle(fontSize: 20),
          decoration: InputDecoration(
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
                    onPressed: () {
                      state.mainPanel.close();
                      state.focusNode.unfocus();
                    },
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
      ]),
    );
  }
}
