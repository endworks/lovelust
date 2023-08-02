import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lovelust/home.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/local_auth_service.dart';
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
  final LocalAuthService _localAuth = getIt<LocalAuthService>();
  final NavigationService _navigator = getIt<NavigationService>();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _localAuth.init();
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
          material: _shared.material,
        );
        ThemeData darkTheme = generateTheme(
          _shared.colorScheme,
          darkMode: true,
          material: _shared.material,
        );
        ThemeMode themeMode = ThemeMode.system;

        if (initialLoadDone) {
          if (_shared.colorScheme == 'dynamic') {
            if (lightDynamic != null && darkDynamic != null) {
              theme = generateTheme(
                null,
                darkMode: false,
                material: _shared.material,
                colorScheme: lightDynamic.harmonized(),
              );
              darkTheme = generateTheme(
                null,
                darkMode: true,
                material: _shared.material,
                colorScheme: darkDynamic.harmonized(),
              );
            }
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
