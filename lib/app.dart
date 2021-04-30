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
      darkTheme: darkTheme,
      home: const HomePage(),
    );
  }

  ThemeData get lightTheme {
    final theme = ThemeData();
    return theme.copyWith(
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.black87,
        backgroundColor: Colors.white,
        backwardsCompatibility: false,
        elevation: 0.2,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(fontSize: 14),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: theme.dividerColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: theme.primaryColor),
        ),
      ),
    );
  }

  ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      appBarTheme: const AppBarTheme(backgroundColor: Color(0xff1d1d1d)),
    );
  }
}
