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
        ThemeData theme = ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: defaultColor,
          ),
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        );
        ThemeData darkTheme = ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: defaultColor,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          brightness: Brightness.dark,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        );
        ThemeMode themeMode = ThemeMode.system;

        if (snapshot.connectionState.name == 'done') {
          debugPrint('theme: ${_common.theme}');
          debugPrint('colorScheme: ${_common.colorScheme}');

          if (_common.colorScheme == 'dynamic') {
            if (lightDynamic != null && darkDynamic != null) {
              theme = ThemeData(
                colorScheme: lightDynamic.harmonized(),
                useMaterial3: true,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              );
              darkTheme = ThemeData(
                colorScheme: darkDynamic.harmonized(),
                brightness: Brightness.dark,
                useMaterial3: true,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              );
            }
          } else if (_common.colorScheme == 'lovelust') {
            theme = ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: lustColor,
              ),
              useMaterial3: true,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            );
            darkTheme = ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: loveColor,
                brightness: Brightness.dark,
              ),
              brightness: Brightness.dark,
              useMaterial3: true,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            );
          } else if (_common.colorScheme == 'lovelust2') {
            theme = ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: loveColor,
              ),
              useMaterial3: true,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            );
            darkTheme = ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: lustColor,
                brightness: Brightness.dark,
              ),
              brightness: Brightness.dark,
              useMaterial3: true,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            );
          } else if (_common.colorScheme == 'love') {
            theme = ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: loveColor,
              ),
              useMaterial3: true,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            );
            darkTheme = ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: loveColor,
                brightness: Brightness.dark,
              ),
              brightness: Brightness.dark,
              useMaterial3: true,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            );
          } else if (_common.colorScheme == 'lust') {
            theme = ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: lustColor,
              ),
              useMaterial3: true,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            );
            darkTheme = ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: lustColor,
                brightness: Brightness.dark,
              ),
              brightness: Brightness.dark,
              useMaterial3: true,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            );
          } else if (_common.colorScheme == 'monochrome') {
            final Map<int, Color> color = {
              50: const Color.fromRGBO(0, 0, 0, .1),
              100: const Color.fromRGBO(0, 0, 0, .2),
              200: const Color.fromRGBO(0, 0, 0, .3),
              300: const Color.fromRGBO(0, 0, 0, .4),
              400: const Color.fromRGBO(0, 0, 0, .5),
              500: const Color.fromRGBO(0, 0, 0, .6),
              600: const Color.fromRGBO(0, 0, 0, .7),
              700: const Color.fromRGBO(0, 0, 0, .8),
              800: const Color.fromRGBO(0, 0, 0, .9),
              900: const Color.fromRGBO(0, 0, 0, 1),
            };

            final Map<int, Color> colorWhite = {
              50: const Color.fromRGBO(255, 255, 255, .1),
              100: const Color.fromRGBO(255, 255, 255, .2),
              200: const Color.fromRGBO(255, 255, 255, .3),
              300: const Color.fromRGBO(255, 255, 255, .4),
              400: const Color.fromRGBO(255, 255, 255, .5),
              500: const Color.fromRGBO(255, 255, 255, .6),
              600: const Color.fromRGBO(255, 255, 255, .7),
              700: const Color.fromRGBO(255, 255, 255, .8),
              800: const Color.fromRGBO(255, 255, 255, .9),
              900: const Color.fromRGBO(255, 255, 255, 1),
            };
            theme = ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              colorScheme: ColorScheme.light(
                primary: MaterialColor(0xFF000000, color),
                onPrimary: MaterialColor(0xFFFFFFFF, colorWhite),
                secondary: MaterialColor(0xFF000000, color),
                onSecondary: MaterialColor(0xFFFFFFFF, colorWhite),
                outlineVariant: Colors.grey[200],
              ),
            );
            darkTheme = ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorScheme: ColorScheme.dark(
                primary: MaterialColor(0xFFFFFFFF, colorWhite),
                onPrimary: MaterialColor(0xFF000000, color),
                secondary: MaterialColor(0xFFFFFFFF, colorWhite),
                onSecondary: MaterialColor(0xFF000000, color),
                outlineVariant: Colors.grey[800],
                brightness: Brightness.dark,
              ),
              visualDensity: VisualDensity.adaptivePlatformDensity,
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
          theme: theme,
          darkTheme: darkTheme,
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
