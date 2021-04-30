import '../../main.dart';
import 'state.dart';

class Panel extends GetxWidget<HomeState> {
  const Panel();

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
            fillColor: Get.theme.dividerColor,
            filled: true,
            prefixIcon: GetBuilder<HomeState>(
              id: HomeStateId.focus,
              builder: (_) {
                if (state.focusNode.hasFocus) {
                  return CupertinoButton(
                    onPressed: () {
                      state.panel.close();
                      state.focusNode.unfocus();
                    },
                    padding: EdgeInsets.zero,
                    child: const Icon(Icons.arrow_back, color: Colors.black87),
                  );
                }
                return const Icon(Icons.search, color: Colors.black87);
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
