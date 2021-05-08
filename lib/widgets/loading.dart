import '../main.dart';

class Loading extends StatelessWidget {
  final double size;
  final Color? color;
  final double width;
  final Alignment align;

  const Loading({
    this.size = 20,
    this.align = Alignment.center,
    this.color,
    this.width = 2,
  });

  @override
  Widget build(_) {
    return Align(
      alignment: align,
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: width,
          backgroundColor: color,
        ),
      ),
    );
  }
}
