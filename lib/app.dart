import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      ColorScheme lightColorScheme;
      ColorScheme darkColorScheme;

      if (lightDynamic != null && darkDynamic != null) {
        lightColorScheme = lightDynamic.harmonized();
        darkColorScheme = darkDynamic.harmonized();
      } else {
        lightColorScheme = ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 252, 85, 147),
        );
        darkColorScheme = ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 93, 89, 217),
          brightness: Brightness.dark,
        );
      }

      return MaterialApp(
        title: 'LoveLust',
        theme: ThemeData(
          colorScheme: lightColorScheme,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: darkColorScheme,
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        home: const Home(),
        supportedLocales: const [Locale('en', 'US'), Locale('es', 'ES')],
        debugShowCheckedModeBanner: false,
      );
    });
  }
}
