import 'package:flutter/material.dart';
import 'package:lovelust/colors.dart';

ThemeData defaultTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: lustColor,
  ),
  navigationBarTheme: const NavigationBarThemeData(
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
  ),
  useMaterial3: true,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

ThemeData defaultDarkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: lustColor,
    brightness: Brightness.dark,
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
  ),
  useMaterial3: defaultTheme.useMaterial3,
  visualDensity: defaultTheme.visualDensity,
  brightness: Brightness.dark,
);

ThemeData uniqueTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: lovelustColor,
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
  ),
  useMaterial3: defaultTheme.useMaterial3,
  visualDensity: defaultTheme.visualDensity,
);

ThemeData uniqueDarkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: lovelustColor,
    brightness: Brightness.dark,
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
  ),
  useMaterial3: defaultTheme.useMaterial3,
  visualDensity: defaultTheme.visualDensity,
  brightness: Brightness.dark,
);

ThemeData lustLoveTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: lustColor,
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
  ),
  useMaterial3: defaultTheme.useMaterial3,
  visualDensity: defaultTheme.visualDensity,
);

ThemeData lustLoveDarkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: loveColor,
    brightness: Brightness.dark,
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
  ),
  useMaterial3: defaultTheme.useMaterial3,
  visualDensity: defaultTheme.visualDensity,
  brightness: Brightness.dark,
);

ThemeData loveLustTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: loveColor,
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
  ),
  useMaterial3: defaultTheme.useMaterial3,
  visualDensity: defaultTheme.visualDensity,
);

ThemeData loveLustDarkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: lustColor,
    brightness: Brightness.dark,
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: defaultTheme.navigationBarTheme.labelBehavior,
  ),
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
  ),
  navigationBarTheme: NavigationBarThemeData(
    elevation: 1,
    surfaceTintColor: MaterialColor(0xFFFFFFFF, whiteColor),
    labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
  ),
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
  ),
  navigationBarTheme: NavigationBarThemeData(
    elevation: 1,
    surfaceTintColor: MaterialColor(0xFF000000, blackColor),
    labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
  ),
);
