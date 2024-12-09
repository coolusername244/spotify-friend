import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'theme/custom_color_scheme.dart';
import './screens/splash_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'CircularStd',
        scaffoldBackgroundColor: customColorScheme.surface,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: customColorScheme.onSurface),
          bodyMedium: TextStyle(color: customColorScheme.onSurface),
          bodySmall: TextStyle(color: customColorScheme.onSurface),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: customColorScheme.primary,
            foregroundColor: customColorScheme.onPrimary,
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
