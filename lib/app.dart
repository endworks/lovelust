import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:lovelust/colors.dart';
import 'package:lovelust/home.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/common_service.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final CommonService _common = getIt<CommonService>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _common.initialLoad(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) =>
          DynamicColorBuilder(
              builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme = ColorScheme.fromSeed(
          seedColor: loveColor,
        );
        ColorScheme darkColorScheme = ColorScheme.fromSeed(
          seedColor: lustColor,
          brightness: Brightness.dark,
        );
        ThemeMode themeMode = ThemeMode.system;
        if (snapshot.connectionState.name == 'done') {
          debugPrint('theme: ${_common.theme}');
          debugPrint('colorScheme: ${_common.colorScheme}');

          if (_common.colorScheme == 'dynamic') {
            if (lightDynamic != null && darkDynamic != null) {
              lightColorScheme = lightDynamic.harmonized();
              darkColorScheme = darkDynamic.harmonized();
            }
          } else if (_common.colorScheme == 'love') {
            darkColorScheme = ColorScheme.fromSeed(
              seedColor: loveColor,
              brightness: Brightness.dark,
            );
          } else if (_common.colorScheme == 'lust') {
            lightColorScheme = ColorScheme.fromSeed(
              seedColor: lustColor,
            );
          }

          if (_common.theme == 'light') {
            themeMode = ThemeMode.light;
          } else if (_common.theme == 'dark') {
            themeMode = ThemeMode.dark;
          }
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
          themeMode: themeMode,
          home: snapshot.connectionState.name == 'done'
              ? const Home()
              : const SizedBox.shrink(),
          debugShowCheckedModeBanner: false,
        );
      }),
    );
  }
}
