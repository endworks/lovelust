import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lovelust/colors.dart';

ColorScheme defaultColorScheme = ColorScheme.fromSeed(
    seedColor: loveColor,
    background: whiteColor[900],
    brightness: Brightness.light);

ColorScheme defaultDarkColorScheme = ColorScheme.fromSeed(
  seedColor: loveColor,
  background: blackColor[900],
  brightness: Brightness.dark,
);

ThemeData defaultTheme = ThemeData(
  colorScheme: defaultColorScheme,
  appBarTheme: AppBarTheme(
    backgroundColor: defaultColorScheme.background,
    surfaceTintColor: defaultColorScheme.surfaceVariant,
    elevation: 1,
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
    surfaceTintColor: defaultColorScheme.surfaceVariant,
    elevation: 1,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    elevation: 0,
  ),
  textTheme: GoogleFonts.dmSansTextTheme(),
  useMaterial3: true,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

ThemeData defaultDarkTheme = ThemeData(
  colorScheme: defaultDarkColorScheme,
  appBarTheme: AppBarTheme(
    backgroundColor: defaultDarkColorScheme.background,
    surfaceTintColor: defaultDarkColorScheme.surfaceVariant,
    elevation: defaultTheme.appBarTheme.elevation,
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
    surfaceTintColor: defaultDarkColorScheme.surfaceVariant,
    elevation: defaultTheme.navigationBarTheme.elevation,
  ),
  floatingActionButtonTheme: defaultTheme.floatingActionButtonTheme,
  textTheme: GoogleFonts.dmSansTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme),
  useMaterial3: defaultTheme.useMaterial3,
  visualDensity: defaultTheme.visualDensity,
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
