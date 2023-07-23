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
  cardTheme: const CardTheme(
    elevation: 1,
    shadowColor: Colors.transparent,
    clipBehavior: Clip.antiAlias,
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
  navigationBarTheme: defaultTheme.navigationBarTheme,
  cardTheme: defaultTheme.cardTheme,
  textTheme: Typography.material2021().white.merge(defaultTextTheme),
);

ColorScheme experimentalColorScheme = ColorScheme.fromSeed(
  seedColor: lustColor,
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
  appBarTheme: defaultTheme.appBarTheme.copyWith(
    backgroundColor: experimentalColorScheme.background,
    surfaceTintColor: experimentalColorScheme.surfaceVariant,
    elevation: 0,
  ),
  navigationBarTheme: defaultTheme.navigationBarTheme.copyWith(
    labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
    // surfaceTintColor: experimentalColorScheme.surfaceVariant,
    elevation: 0,
    indicatorColor: experimentalColorScheme.primaryContainer,
    backgroundColor: experimentalColorScheme.surface,
    height: 56,
  ),
  floatingActionButtonTheme: defaultTheme.floatingActionButtonTheme.copyWith(
    elevation: 0,
    backgroundColor: experimentalColorScheme.primaryContainer,
    foregroundColor: experimentalColorScheme.onPrimaryContainer,
  ),
  cardTheme: defaultTheme.cardTheme.copyWith(
    color: experimentalColorScheme.surface,
    // surfaceTintColor: experimentalColorScheme.surfaceVariant,
  ),
  chipTheme: ChipThemeData(
    labelStyle: defaultTheme.textTheme.labelSmall!.copyWith(
      color: defaultTheme.colorScheme.onSurface,
    ),
    backgroundColor: defaultTheme.colorScheme.surface,
    side: BorderSide.none,
    shape: const StadiumBorder(),
    labelPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
  ),
  textTheme: defaultTheme.textTheme,
  useMaterial3: true,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

ThemeData experimentalDarkTheme = ThemeData(
  colorScheme: experimentalDarkColorScheme,
  appBarTheme: experimentalTheme.appBarTheme.copyWith(
    backgroundColor: experimentalDarkColorScheme.background,
    surfaceTintColor: experimentalDarkColorScheme.surfaceVariant,
  ),
  navigationBarTheme: experimentalTheme.navigationBarTheme.copyWith(
    surfaceTintColor: experimentalDarkColorScheme.surfaceVariant,
    indicatorColor: experimentalDarkColorScheme.primaryContainer,
    backgroundColor: experimentalDarkColorScheme.surface,
  ),
  floatingActionButtonTheme:
      experimentalTheme.floatingActionButtonTheme.copyWith(
    backgroundColor: experimentalDarkColorScheme.primaryContainer,
    foregroundColor: experimentalDarkColorScheme.onPrimaryContainer,
  ),
  cardTheme: experimentalTheme.cardTheme.copyWith(
    color: experimentalDarkColorScheme.surface,
    // surfaceTintColor: experimentalDarkColorScheme.surfaceVariant,
  ),
  chipTheme: experimentalTheme.chipTheme.copyWith(
    labelStyle: defaultDarkTheme.textTheme.labelSmall!.copyWith(
      color: defaultDarkTheme.colorScheme.onSurface,
    ),
    backgroundColor: defaultDarkTheme.colorScheme.surface,
  ),
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
  cardTheme: defaultTheme.cardTheme,
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
    labelBehavior: defaultDarkTheme.navigationBarTheme.labelBehavior,
  ),
  cardTheme: defaultDarkTheme.cardTheme,
  textTheme: defaultDarkTheme.textTheme,
  useMaterial3: defaultDarkTheme.useMaterial3,
  visualDensity: defaultDarkTheme.visualDensity,
  brightness: Brightness.dark,
);

ThemeData lustfulLoveTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: lustColor,
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
  ),
  cardTheme: defaultTheme.cardTheme,
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
    labelBehavior: defaultDarkTheme.navigationBarTheme.labelBehavior,
  ),
  cardTheme: defaultDarkTheme.cardTheme,
  textTheme: defaultDarkTheme.textTheme,
  useMaterial3: defaultDarkTheme.useMaterial3,
  visualDensity: defaultDarkTheme.visualDensity,
  brightness: Brightness.dark,
);

ThemeData lovefulLustTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: loveColor,
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
  ),
  cardTheme: defaultTheme.cardTheme,
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
    labelBehavior: defaultDarkTheme.navigationBarTheme.labelBehavior,
  ),
  cardTheme: defaultDarkTheme.cardTheme,
  textTheme: defaultDarkTheme.textTheme,
  useMaterial3: defaultDarkTheme.useMaterial3,
  visualDensity: defaultDarkTheme.visualDensity,
  brightness: Brightness.dark,
);

ThemeData loveTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: loveColor,
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
  ),
  cardTheme: defaultTheme.cardTheme,
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
    labelBehavior: defaultDarkTheme.navigationBarTheme.labelBehavior,
  ),
  cardTheme: defaultDarkTheme.cardTheme,
  textTheme: defaultDarkTheme.textTheme,
  useMaterial3: defaultDarkTheme.useMaterial3,
  visualDensity: defaultDarkTheme.visualDensity,
  brightness: Brightness.dark,
);

ThemeData lustTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: lustColor,
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
  ),
  cardTheme: defaultTheme.cardTheme,
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
    labelBehavior: defaultDarkTheme.navigationBarTheme.labelBehavior,
  ),
  cardTheme: defaultDarkTheme.cardTheme,
  textTheme: defaultDarkTheme.textTheme,
  useMaterial3: defaultDarkTheme.useMaterial3,
  visualDensity: defaultDarkTheme.visualDensity,
  brightness: Brightness.dark,
);

ThemeData redlightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: redlightColor,
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
  ),
  cardTheme: defaultTheme.cardTheme,
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
    labelBehavior: defaultDarkTheme.navigationBarTheme.labelBehavior,
  ),
  cardTheme: defaultDarkTheme.cardTheme,
  textTheme: defaultDarkTheme.textTheme,
  useMaterial3: defaultDarkTheme.useMaterial3,
  visualDensity: defaultDarkTheme.visualDensity,
  brightness: Brightness.dark,
);

ThemeData appleTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: appleBlueColor,
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
  ),
  cardTheme: defaultTheme.cardTheme,
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
    labelBehavior: defaultDarkTheme.navigationBarTheme.labelBehavior,
  ),
  cardTheme: defaultDarkTheme.cardTheme,
  textTheme: defaultDarkTheme.textTheme,
  useMaterial3: defaultDarkTheme.useMaterial3,
  visualDensity: defaultDarkTheme.visualDensity,
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
  cardTheme: defaultDarkTheme.cardTheme,
  textTheme: defaultDarkTheme.textTheme,
);
