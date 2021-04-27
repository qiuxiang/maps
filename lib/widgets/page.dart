import '../main.dart';

class ScaffoldPage extends StatelessWidget {
  final Widget? bottom;
  final String title;
  final List<Widget> children;
  final List<Widget> slivers;
  final Color? backgroundColor;
  final Color statusBarColor;
  final ImageProvider? backgroundImage;
  final AppBarTheme? appBarTheme;
  final bool appBarPinned;
  final EdgeInsets padding;

  const ScaffoldPage({
    this.children = const [],
    this.slivers = const [],
    this.bottom,
    this.title = '',
    this.backgroundColor,
    this.backgroundImage,
    this.appBarTheme,
    this.appBarPinned = true,
    this.padding = EdgeInsets.zero,
    this.statusBarColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    final appBarColor =
        appBarTheme?.foregroundColor ?? Get.theme.appBarTheme.foregroundColor;
    Widget? titleText;
    if (title.isNotEmpty) {
      titleText = Text(title, style: TextStyle(color: appBarColor));
    }
    final body = CustomScrollView(slivers: [
      SliverAppBar(
        toolbarHeight: title.isEmpty ? 0 : kToolbarHeight,
        title: titleText,
        pinned: appBarPinned,
        backgroundColor: appBarTheme?.backgroundColor,
        brightness: appBarTheme?.brightness,
        iconTheme: IconThemeData(color: appBarColor),
        elevation: 0.2,
      ),
      SliverPadding(
        padding: padding,
        sliver: SliverList(delegate: SliverChildListDelegate(children)),
      ),
      ...slivers,
    ]);
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.zero,
          child: AppBar(
            shadowColor: Colors.transparent,
            backgroundColor: statusBarColor,
            backwardsCompatibility: true,
            brightness: appBarTheme?.brightness,
          ),
        ),
        body: backgroundImage == null
            ? body
            : Ink.image(
                image: backgroundImage!,
                alignment: Alignment.topCenter,
                child: body,
              ),
        bottomNavigationBar: bottom,
      ),
    );
  }
}
