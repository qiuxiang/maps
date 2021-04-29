import 'main.dart';
import 'pages/home/home.dart';

void app() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Maps',
      theme: lightTheme,
      home: const HomePage(),
    );
  }

  ThemeData get lightTheme {
    final theme = ThemeData(
      primaryColor: const Color(0xff2670f3),
      scaffoldBackgroundColor: const Color(0xfff5f5f5),
    );
    return theme.copyWith(
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.black87,
        backgroundColor: Colors.white,
        backwardsCompatibility: false,
        elevation: 0.2,
      ),
    );
  }
}
