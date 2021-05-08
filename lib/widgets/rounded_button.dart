import '../main.dart';

class RoundedButton extends StatefulWidget {
  final IconData? icon;
  final String text;
  final double fontSize;
  final FutureOr? Function()? onPressed;
  final double? width;
  final double height;
  final Color? color;
  final Color? textColor;
  final BorderSide? border;
  final bool loading;
  final double? radius;
  final BorderRadius? borderRadius;
  final EdgeInsets padding;

  const RoundedButton({
    required this.text,
    this.icon,
    this.onPressed,
    this.fontSize = 14,
    this.width,
    this.height = 28,
    this.color,
    this.textColor = Colors.white,
    this.border,
    this.radius,
    this.loading = false,
    this.borderRadius,
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
  });

  @override
  _RoundedButtonState createState() => _RoundedButtonState();

  factory RoundedButton.large({
    required String text,
    required FutureOr? Function() onPressed,
    bool loading = false,
  }) {
    return RoundedButton(
      text: text,
      onPressed: onPressed,
      loading: loading,
      width: double.infinity,
      height: 44,
      fontSize: 18,
    );
  }
}

class _RoundedButtonState extends State<RoundedButton> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: widget.padding,
          primary: widget.color,
          onPrimary:
              widget.color == Colors.white ? Get.theme.primaryColor : null,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            side: widget.border ?? BorderSide.none,
            borderRadius: widget.borderRadius ??
                BorderRadius.all(
                  Radius.circular(widget.radius ?? widget.height),
                ),
          ),
        ),
        onPressed: (loading && widget.loading) ? null : onPressed,
        child: buildChild(),
      ),
    );
  }

  void onPressed() async {
    setState(() => loading = true);
    await widget.onPressed?.call();
    if (mounted) setState(() => loading = false);
  }

  Widget buildChild() {
    if (loading && widget.loading) {
      return const Loading(color: Colors.white, width: 1);
    }

    final text = Text(
      widget.text,
      style: TextStyle(color: widget.textColor, fontSize: widget.fontSize),
    );

    if (widget.icon == null) return text;

    return Row(children: [
      Icon(widget.icon, size: widget.fontSize + 2),
      const SizedBox(width: 8),
      text,
    ]);
  }
}
