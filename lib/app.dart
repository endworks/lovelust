import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lovelust/home.dart';
import 'package:lovelust/service_locator.dart';
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
        ThemeData theme = defaultTheme;
        ThemeData darkTheme = defaultDarkTheme;
        ThemeMode themeMode = ThemeMode.system;

        if (initialLoadDone) {
          if (_shared.colorScheme == 'dynamic') {
            if (lightDynamic != null && darkDynamic != null) {
              theme = ThemeData(
                colorScheme: lightDynamic.harmonized(),
                navigationBarTheme: NavigationBarThemeData(
                  labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
                ),
                cardTheme: defaultTheme.cardTheme,
                textTheme: defaultTheme.textTheme,
                useMaterial3: defaultTheme.useMaterial3,
                visualDensity: defaultTheme.visualDensity,
              );
              darkTheme = ThemeData(
                colorScheme: darkDynamic.harmonized(),
                navigationBarTheme: NavigationBarThemeData(
                  labelBehavior:
                      defaultDarkTheme.navigationBarTheme.labelBehavior,
                ),
                cardTheme: defaultDarkTheme.cardTheme,
                textTheme: defaultDarkTheme.textTheme,
                useMaterial3: defaultDarkTheme.useMaterial3,
                visualDensity: defaultDarkTheme.visualDensity,
                brightness: Brightness.dark,
              );
            } else if (!kIsWeb && Platform.isIOS) {
              theme = appleTheme;
              darkTheme = appleDarkTheme;
            }
          } else if (_shared.colorScheme == 'experimental') {
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
          } else if (_shared.colorScheme == 'redlight') {
            theme = redlightTheme;
            darkTheme = redlightDarkTheme;
          } else if (_shared.colorScheme == 'monochrome') {
            theme = monochromeTheme;
            darkTheme = monochromeDarkTheme;
          }

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

        FlutterNativeSplash.remove();

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
          debugShowCheckedModeBanner: false,
          debugShowMaterialGrid: false,
        );
      }),
    );
  }
}
