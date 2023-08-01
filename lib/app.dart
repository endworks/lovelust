import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lovelust/home.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/navigation_service.dart';
import 'package:lovelust/services/shared_service.dart';
import 'package:lovelust/themes.dart';
import 'package:relative_time/relative_time.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final SharedService _shared = getIt<SharedService>();
  final NavigationService _navigator = getIt<NavigationService>();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _shared.initialLoad(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) =>
          DynamicColorBuilder(
              builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        bool initialLoadDone = snapshot.connectionState == ConnectionState.done;
        ThemeData theme = generateTheme(
          _shared.colorScheme,
          darkMode: false,
          modernUI: _shared.modernUI,
        );
        ThemeData darkTheme = generateTheme(
          _shared.colorScheme,
          darkMode: true,
          modernUI: _shared.modernUI,
        );
        ThemeMode themeMode = ThemeMode.system;

        if (initialLoadDone) {
          if (_shared.colorScheme == 'dynamic') {
            if (lightDynamic != null && darkDynamic != null) {
              theme = generateTheme(
                null,
                darkMode: false,
                modernUI: _shared.modernUI,
                colorScheme: lightDynamic.harmonized(),
              );
              darkTheme = generateTheme(
                null,
                darkMode: true,
                modernUI: _shared.modernUI,
                colorScheme: darkDynamic.harmonized(),
              );
            } else if (!kIsWeb && Platform.isIOS) {
              theme = generateTheme(
                "blue",
                darkMode: false,
                modernUI: _shared.modernUI,
              );
              darkTheme = generateTheme(
                "blue",
                darkMode: true,
                modernUI: _shared.modernUI,
              );
            }
          }
          /* else if (_shared.colorScheme == 'experimental') {
            theme = experimentalTheme;
            darkTheme = experimentalDarkTheme;
          } else if (_shared.colorScheme == 'lovelust') {
            theme = lovelustTheme;
            darkTheme = lovelustDarkTheme;
          } else if (_shared.colorScheme == 'lustfullove') {
            theme = lustfulLoveTheme;
            darkTheme = lustfulLoveDarkTheme;
          } else if (_shared.colorScheme == 'lovefullust') {
            theme = lovefulLustTheme;
            darkTheme = lovefulLustDarkTheme;
          } else if (_shared.colorScheme == 'love') {
            theme = loveTheme;
            darkTheme = loveDarkTheme;
          } else if (_shared.colorScheme == 'lust') {
            theme = lustTheme;
            darkTheme = lustDarkTheme;
          } else if (_shared.colorScheme == 'lipstick') {
            theme = lipstickTheme;
            darkTheme = lipstickDarkTheme;
          } else if (_shared.colorScheme == 'monochrome') {
            theme = monochromeTheme;
            darkTheme = monochromeDarkTheme;
          }*/

          if (_shared.theme == 'light') {
            themeMode = ThemeMode.light;
          } else if (_shared.theme == 'dark') {
            themeMode = ThemeMode.dark;
          }
        }

        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
        ));

        return MaterialApp(
          title: 'LoveLust',
          theme: theme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          home: Home(initialLoadDone: initialLoadDone),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            RelativeTimeLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          restorationScopeId: 'root',
          navigatorKey: _navigator.navigatorKey,
          debugShowCheckedModeBanner: false,
          debugShowMaterialGrid: false,
        );
      }),
    );
  }
}
