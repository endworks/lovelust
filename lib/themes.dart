import 'package:flutter/material.dart';
import 'package:lovelust/colors.dart';

const fallbackTextStyle = TextStyle(
  fontFamily: 'Roboto',
  fontFamilyFallback: ['NotoEmoji'],
);

const defaultTextStyle = TextStyle(
  fontFamily: 'Inter',
  fontFamilyFallback: ['NotoEmoji'],
);

TextTheme fallbackTextTheme = const TextTheme(
  bodyLarge: fallbackTextStyle,
  bodyMedium: fallbackTextStyle,
  labelLarge: fallbackTextStyle,
  bodySmall: fallbackTextStyle,
  labelSmall: fallbackTextStyle,
  displayLarge: fallbackTextStyle,
  displayMedium: fallbackTextStyle,
  displaySmall: fallbackTextStyle,
  headlineMedium: fallbackTextStyle,
  headlineSmall: fallbackTextStyle,
  titleLarge: fallbackTextStyle,
  titleMedium: fallbackTextStyle,
  titleSmall: fallbackTextStyle,
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

ThemeData defaultTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: lustColor,
  ),
  useMaterial3: true,
  brightness: Brightness.light,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  navigationBarTheme: const NavigationBarThemeData(
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
  ),
  textTheme: Typography.material2021().black.merge(defaultTextTheme),
);

ThemeData defaultDarkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: lustColor,
  ),
  useMaterial3: defaultTheme.useMaterial3,
  brightness: Brightness.dark,
  visualDensity: defaultTheme.visualDensity,
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
  ),
  textTheme: Typography.material2021().white.merge(defaultTextTheme),
);

ColorScheme experimentalColorScheme = ColorScheme.fromSeed(
  seedColor: loveColor,
  background: whiteColor[900],
  brightness: Brightness.light,
);

ColorScheme experimentalDarkColorScheme = ColorScheme.fromSeed(
  seedColor: lustColor,
  background: blackColor[900],
  brightness: Brightness.dark,
);

ThemeData experimentalTheme = ThemeData(
  colorScheme: experimentalColorScheme,
  appBarTheme: AppBarTheme(
    backgroundColor: experimentalColorScheme.background,
    surfaceTintColor: experimentalColorScheme.surfaceVariant,
    elevation: 1,
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
    surfaceTintColor: experimentalColorScheme.surfaceVariant,
    elevation: 1,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    elevation: 0,
  ),
  textTheme: defaultTheme.textTheme,
  useMaterial3: true,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

ThemeData experimentalDarkTheme = ThemeData(
  colorScheme: experimentalDarkColorScheme,
  appBarTheme: AppBarTheme(
    backgroundColor: experimentalDarkColorScheme.background,
    surfaceTintColor: experimentalDarkColorScheme.surfaceVariant,
    elevation: experimentalTheme.appBarTheme.elevation,
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: experimentalTheme.navigationBarTheme.labelBehavior,
    surfaceTintColor: experimentalDarkColorScheme.surfaceVariant,
    elevation: experimentalTheme.navigationBarTheme.elevation,
  ),
  floatingActionButtonTheme: experimentalTheme.floatingActionButtonTheme,
  textTheme: defaultDarkTheme.textTheme,
  useMaterial3: experimentalTheme.useMaterial3,
  visualDensity: experimentalTheme.visualDensity,
  brightness: Brightness.dark,
);

ThemeData lovelustTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: lovelustColor,
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
  ),
  textTheme: defaultTheme.textTheme,
  useMaterial3: defaultTheme.useMaterial3,
  visualDensity: defaultTheme.visualDensity,
);

ThemeData lovelustDarkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: lovelustColor,
    brightness: Brightness.dark,
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
  ),
  textTheme: defaultDarkTheme.textTheme,
  useMaterial3: defaultTheme.useMaterial3,
  visualDensity: defaultTheme.visualDensity,
  brightness: Brightness.dark,
);

ThemeData lustfulLoveTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: lustColor,
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
  ),
  textTheme: defaultTheme.textTheme,
  useMaterial3: defaultTheme.useMaterial3,
  visualDensity: defaultTheme.visualDensity,
);

ThemeData lustfulLoveDarkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: loveColor,
    brightness: Brightness.dark,
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
  ),
  textTheme: defaultDarkTheme.textTheme,
  useMaterial3: defaultTheme.useMaterial3,
  visualDensity: defaultTheme.visualDensity,
  brightness: Brightness.dark,
);

ThemeData lovefulLustTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: loveColor,
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
  ),
  textTheme: defaultTheme.textTheme,
  useMaterial3: defaultTheme.useMaterial3,
  visualDensity: defaultTheme.visualDensity,
);

ThemeData lovefulLustDarkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: lustColor,
    brightness: Brightness.dark,
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
  ),
  textTheme: defaultDarkTheme.textTheme,
  useMaterial3: defaultTheme.useMaterial3,
  visualDensity: defaultTheme.visualDensity,
  brightness: Brightness.dark,
);

ThemeData loveTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: loveColor,
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
  ),
  textTheme: defaultTheme.textTheme,
  useMaterial3: defaultTheme.useMaterial3,
  visualDensity: defaultTheme.visualDensity,
);

ThemeData loveDarkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: loveColor,
    brightness: Brightness.dark,
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
  ),
  textTheme: defaultDarkTheme.textTheme,
  useMaterial3: defaultTheme.useMaterial3,
  visualDensity: defaultTheme.visualDensity,
  brightness: Brightness.dark,
);

ThemeData lustTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: lustColor,
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
  ),
  textTheme: defaultTheme.textTheme,
  useMaterial3: defaultTheme.useMaterial3,
  visualDensity: defaultTheme.visualDensity,
);

ThemeData lustDarkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: lustColor,
    brightness: Brightness.dark,
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
  ),
  textTheme: defaultDarkTheme.textTheme,
  useMaterial3: defaultTheme.useMaterial3,
  visualDensity: defaultTheme.visualDensity,
  brightness: Brightness.dark,
);

ThemeData redlightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: redlightColor,
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
  ),
  textTheme: defaultTheme.textTheme,
  useMaterial3: defaultTheme.useMaterial3,
  visualDensity: defaultTheme.visualDensity,
);

ThemeData redlightDarkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: redlightColor,
    brightness: Brightness.dark,
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
  ),
  textTheme: defaultDarkTheme.textTheme,
  useMaterial3: defaultTheme.useMaterial3,
  visualDensity: defaultTheme.visualDensity,
  brightness: Brightness.dark,
);

ThemeData appleTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: appleBlueColor,
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
  ),
  textTheme: defaultTheme.textTheme,
  useMaterial3: defaultTheme.useMaterial3,
  visualDensity: defaultTheme.visualDensity,
);

ThemeData appleDarkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: appleBlueDarkColor,
    brightness: Brightness.dark,
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
  ),
  textTheme: defaultDarkTheme.textTheme,
  useMaterial3: defaultTheme.useMaterial3,
  visualDensity: defaultTheme.visualDensity,
  brightness: Brightness.dark,
);

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
  textTheme: defaultDarkTheme.textTheme,
);
