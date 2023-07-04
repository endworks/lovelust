import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:lovelust/colors.dart';
import 'package:lovelust/home.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/common_service.dart';
import 'package:lovelust/services/storage_service.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final StorageService storage = getIt<StorageService>();
  final CommonService common = getIt<CommonService>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: common.initialLoad(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) =>
          DynamicColorBuilder(
              builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme = ColorScheme.fromSeed(
          seedColor: loveColor,
        );
        ;
        ColorScheme darkColorScheme = ColorScheme.fromSeed(
          seedColor: lustColor,
          brightness: Brightness.dark,
        );
        ThemeMode themeMode = ThemeMode.system;

        debugPrint('theme: ${storage.theme}');
        debugPrint('colorScheme: ${storage.colorScheme}');

        if (storage.colorScheme == 'dynamic') {
          if (lightDynamic != null && darkDynamic != null) {
            lightColorScheme = lightDynamic.harmonized();
            darkColorScheme = darkDynamic.harmonized();
          }
        } else if (storage.colorScheme == 'love') {
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: loveColor,
            brightness: Brightness.dark,
          );
        } else if (storage.colorScheme == 'lust') {
          lightColorScheme = ColorScheme.fromSeed(
            seedColor: lustColor,
          );
        }

        if (storage.theme == 'light') {
          themeMode = ThemeMode.light;
        } else if (storage.theme == 'dark') {
          themeMode = ThemeMode.dark;
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
          home: const Home(),
          debugShowCheckedModeBanner: false,
        );
      }),
    );
  }
}
