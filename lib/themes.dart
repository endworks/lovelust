import 'package:flutter/material.dart';
import 'package:lovelust/colors.dart';

ThemeData defaultTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: defaultColor,
  ),
  useMaterial3: true,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

ThemeData defaultDarkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: defaultColor,
    brightness: Brightness.dark,
  ),
  useMaterial3: true,
  brightness: Brightness.dark,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

ThemeData loveLustTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: lustColor,
  ),
  useMaterial3: true,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

ThemeData loveLustDarkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: loveColor,
    brightness: Brightness.dark,
  ),
  brightness: Brightness.dark,
  useMaterial3: true,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

ThemeData loveLustAlterTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: loveColor,
  ),
  useMaterial3: true,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

ThemeData loveLustAlterDarkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: lustColor,
    brightness: Brightness.dark,
  ),
  brightness: Brightness.dark,
  useMaterial3: true,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

ThemeData loveTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: loveColor,
  ),
  useMaterial3: true,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

ThemeData loveDarkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: loveColor,
    brightness: Brightness.dark,
  ),
  brightness: Brightness.dark,
  useMaterial3: true,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

ThemeData lustTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: lustColor,
  ),
  useMaterial3: true,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

ThemeData lustDarkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: lustColor,
    brightness: Brightness.dark,
  ),
  brightness: Brightness.dark,
  useMaterial3: true,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

ThemeData monochromeTheme = ThemeData(
  useMaterial3: true,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: MaterialColor(0xFF000000, color),
    onPrimary: MaterialColor(0xFFFFFFFF, colorWhite),
    secondary: MaterialColor(0xFF000000, color),
    onSecondary: MaterialColor(0xFFFFFFFF, colorWhite),
    outlineVariant: Colors.grey[200],
  ),
  appBarTheme: AppBarTheme(
    surfaceTintColor: MaterialColor(0xFFFFFFFF, colorWhite),
    elevation: 1,
  ),
  navigationBarTheme: NavigationBarThemeData(
    surfaceTintColor: MaterialColor(0xFFFFFFFF, colorWhite),
    elevation: 1,
  ),
);

ThemeData monochromeDarkTheme = ThemeData(
  useMaterial3: true,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: MaterialColor(0xFFFFFFFF, colorWhite),
    onPrimary: MaterialColor(0xFF000000, color),
    secondary: MaterialColor(0xFFFFFFFF, colorWhite),
    onSecondary: MaterialColor(0xFF000000, color),
    outlineVariant: Colors.grey[800],
    brightness: Brightness.dark,
  ),
  appBarTheme: AppBarTheme(
    surfaceTintColor: MaterialColor(0xFF000000, color),
    elevation: 1,
  ),
  navigationBarTheme: NavigationBarThemeData(
    surfaceTintColor: MaterialColor(0xFF000000, color),
    elevation: 1,
  ),
);
