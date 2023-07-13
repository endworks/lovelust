import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lovelust/home.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';
import 'package:lovelust/themes.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final SharedService _common = getIt<SharedService>();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _common.initialLoad(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) =>
          DynamicColorBuilder(
              builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ThemeData theme = defaultTheme;
        ThemeData darkTheme = defaultDarkTheme;
        ThemeMode themeMode = ThemeMode.system;

        if (snapshot.connectionState.name == 'done') {
          debugPrint('theme: ${_common.theme}');
          debugPrint('colorScheme: ${_common.colorScheme}');

          if (_common.colorScheme == 'dynamic') {
            if (lightDynamic != null && darkDynamic != null) {
              theme = ThemeData(
                colorScheme: lightDynamic.harmonized(),
                useMaterial3: defaultTheme.useMaterial3,
                visualDensity: defaultTheme.visualDensity,
                navigationBarTheme: NavigationBarThemeData(
                  labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
                ),
                textTheme: defaultTheme.textTheme,
              );
              darkTheme = ThemeData(
                colorScheme: darkDynamic.harmonized(),
                useMaterial3: defaultTheme.useMaterial3,
                visualDensity: defaultTheme.visualDensity,
                navigationBarTheme: NavigationBarThemeData(
                  labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
                ),
                textTheme: defaultDarkTheme.textTheme,
                brightness: Brightness.dark,
              );
            } else if (!kIsWeb && Platform.isIOS) {
              theme = appleTheme;
              darkTheme = appleDarkTheme;
            }
          } else if (_common.colorScheme == 'experimental') {
            theme = experimentalTheme;
            darkTheme = experimentalDarkTheme;
          } else if (_common.colorScheme == 'lovelust') {
            theme = lovelustTheme;
            darkTheme = lovelustDarkTheme;
          } else if (_common.colorScheme == 'lustfullove') {
            theme = lustfulLoveTheme;
            darkTheme = lustfulLoveDarkTheme;
          } else if (_common.colorScheme == 'lovefullust') {
            theme = lovefulLustTheme;
            darkTheme = lovefulLustDarkTheme;
          } else if (_common.colorScheme == 'love') {
            theme = loveTheme;
            darkTheme = loveDarkTheme;
          } else if (_common.colorScheme == 'lust') {
            theme = lustTheme;
            darkTheme = lustDarkTheme;
          } else if (_common.colorScheme == 'monochrome') {
            theme = monochromeTheme;
            darkTheme = monochromeDarkTheme;
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
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          debugShowCheckedModeBanner: false,
        );
      }),
    );
  }
}
