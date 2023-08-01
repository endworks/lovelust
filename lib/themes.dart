import 'package:flutter/material.dart';
import 'package:lovelust/colors.dart';

ThemeData generateTheme(String? colorSchemeName,
    {bool darkMode = false, bool material = false, ColorScheme? colorScheme}) {
  Color seedColor = lovelustColor;
  if (colorSchemeName == "love") {
    seedColor = loveColor;
  } else if (colorSchemeName == "lust") {
    seedColor = lustColor;
  } else if (colorSchemeName == "lipstick") {
    seedColor = lipstickColor;
  } else if (colorSchemeName == "shimapan") {
    seedColor = shimapanColor;
  } else if (colorSchemeName == "blue") {
    seedColor = blueColor;
  } else if (colorSchemeName == "monochrome") {
    if (darkMode) {
      colorScheme ??= ColorScheme.dark(
        primary: MaterialColor(0xFFFFFFFF, whiteColor),
        onPrimary: MaterialColor(0xFF000000, blackColor),
        secondary: MaterialColor(0xFFFFFFFF, whiteColor),
        onSecondary: MaterialColor(0xFF000000, blackColor),
        outlineVariant: Colors.grey[800],
        brightness: Brightness.dark,
      );
    } else {
      colorScheme ??= ColorScheme.light(
        primary: MaterialColor(0xFF000000, blackColor),
        onPrimary: MaterialColor(0xFFFFFFFF, whiteColor),
        secondary: MaterialColor(0xFF000000, blackColor),
        onSecondary: MaterialColor(0xFFFFFFFF, whiteColor),
        outlineVariant: Colors.grey[200],
      );
    }
  }

  colorScheme ??= ColorScheme.fromSeed(
    brightness: darkMode ? Brightness.dark : Brightness.light,
    seedColor: seedColor,
  );

  const defaultTextStyle = TextStyle(
    fontFamily: 'Inter',
    fontFamilyFallback: ['NotoEmoji'],
  );

  TextTheme defaultTextTheme = const TextTheme(
    bodyLarge: defaultTextStyle,
    bodyMedium: defaultTextStyle,
    labelLarge: defaultTextStyle,
    bodySmall: defaultTextStyle,
    labelSmall: defaultTextStyle,
    displayLarge: defaultTextStyle,
    displayMedium: defaultTextStyle,
    displaySmall: defaultTextStyle,
    headlineLarge: defaultTextStyle,
    headlineMedium: defaultTextStyle,
    headlineSmall: defaultTextStyle,
    titleLarge: defaultTextStyle,
    titleMedium: defaultTextStyle,
    titleSmall: defaultTextStyle,
  );

  ThemeData materialTheme = ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    brightness: darkMode ? Brightness.dark : Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    navigationBarTheme: const NavigationBarThemeData(
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
    cardTheme: const CardTheme(
      elevation: 1,
      shadowColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
    ),
    textTheme: (darkMode
            ? Typography.material2021().white
            : Typography.material2021().black)
        .merge(defaultTextTheme),
  );

  ThemeData defaultTheme = ThemeData(
    colorScheme: colorScheme,
    appBarTheme: materialTheme.appBarTheme.copyWith(
      backgroundColor: colorScheme.background,
      surfaceTintColor: colorScheme.surfaceVariant,
      elevation: 0,
    ),
    navigationBarTheme: materialTheme.navigationBarTheme.copyWith(
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      // surfaceTintColor: experimentalColorScheme.surfaceVariant,
      elevation: 0,
      indicatorColor: colorScheme.primaryContainer,
      backgroundColor: colorScheme.surface,
      height: 56,
    ),
    floatingActionButtonTheme: materialTheme.floatingActionButtonTheme.copyWith(
      elevation: 0,
      backgroundColor: colorScheme.primaryContainer,
      foregroundColor: colorScheme.onPrimaryContainer,
      shape: const StadiumBorder(),
    ),
    cardTheme: materialTheme.cardTheme.copyWith(
      color: colorScheme.surface,
      // surfaceTintColor: experimentalColorScheme.surfaceVariant,
    ),
    chipTheme: ChipThemeData(
      labelStyle: materialTheme.textTheme.labelSmall!.copyWith(
        color: materialTheme.colorScheme.onSurface,
      ),
      backgroundColor: materialTheme.colorScheme.surface,
      side: BorderSide.none,
      shape: const StadiumBorder(),
    ),
    textTheme: materialTheme.textTheme,
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
  return material ? materialTheme : defaultTheme;
}
/*
ThemeData monochromeTheme = ThemeData(
  useMaterial3: defaultTheme.useMaterial3,
  visualDensity: defaultTheme.visualDensity,
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: MaterialColor(0xFF000000, blackColor),
    onPrimary: MaterialColor(0xFFFFFFFF, whiteColor),
    secondary: MaterialColor(0xFF000000, blackColor),
    onSecondary: MaterialColor(0xFFFFFFFF, whiteColor),
    outlineVariant: Colors.grey[200],
  ),
  appBarTheme: AppBarTheme(
    elevation: 1,
    surfaceTintColor: MaterialColor(0xFFFFFFFF, whiteColor),
    foregroundColor: MaterialColor(0xFF000000, blackColor),
  ),
  navigationBarTheme: NavigationBarThemeData(
    elevation: 1,
    surfaceTintColor: MaterialColor(0xFFFFFFFF, whiteColor),
    labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
  ),
  chipTheme: ChipThemeData(
    labelStyle: TextStyle(
      color: MaterialColor(0xFFFFFFFF, whiteColor),
    ),
    secondaryLabelStyle: TextStyle(
      color: MaterialColor(0xFF000000, blackColor),
    ),
  ),
  cardTheme: defaultTheme.cardTheme,
  textTheme: defaultTheme.textTheme,
);

ThemeData monochromeDarkTheme = ThemeData(
  useMaterial3: defaultTheme.useMaterial3,
  visualDensity: defaultTheme.visualDensity,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: MaterialColor(0xFFFFFFFF, whiteColor),
    onPrimary: MaterialColor(0xFF000000, blackColor),
    secondary: MaterialColor(0xFFFFFFFF, whiteColor),
    onSecondary: MaterialColor(0xFF000000, blackColor),
    outlineVariant: Colors.grey[800],
    brightness: Brightness.dark,
  ),
  appBarTheme: AppBarTheme(
    elevation: 1,
    surfaceTintColor: MaterialColor(0xFF000000, blackColor),
    foregroundColor: MaterialColor(0xFFFFFFFF, whiteColor),
  ),
  navigationBarTheme: NavigationBarThemeData(
    elevation: 1,
    surfaceTintColor: MaterialColor(0xFF000000, blackColor),
    labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
  ),
  chipTheme: ChipThemeData(
    brightness: Brightness.dark,
    labelStyle: TextStyle(
      color: MaterialColor(0xFFFFFFFF, whiteColor),
    ),
    secondaryLabelStyle: TextStyle(
      color: MaterialColor(0xFFFFFFFF, whiteColor),
    ),
  ),
  cardTheme: defaultDarkTheme.cardTheme,
  textTheme: defaultDarkTheme.textTheme,
);
*/