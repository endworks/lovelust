import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lovelust/colors.dart';
import 'package:lovelust/services/shared_service.dart';

ThemeData generateTheme(
  String? colorSchemeName, {
  bool darkMode = false,
  bool material = false,
  ColorScheme? colorScheme,
  bool trueBlack = false,
}) {
  Color seedColor = redColor;
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
  } else if (colorSchemeName == "black") {
    if (darkMode) {
      colorScheme ??= ColorScheme.dark(
        primary: MaterialColor(0xFFFFFFFF, whiteColor),
        onPrimary: MaterialColor(0xFF000000, blackColor),
        secondary: MaterialColor(0xFFFFFFFF, whiteColor),
        onSecondary: MaterialColor(0xFF000000, blackColor),
        surface: MaterialColor(0xFF000000, blackColor),
        onSurface: MaterialColor(0xFFFFFFFF, whiteColor),
        outlineVariant: Colors.grey[800],
        brightness: Brightness.dark,
      );
    } else {
      colorScheme ??= ColorScheme.light(
        primary: MaterialColor(0xFF000000, blackColor),
        onPrimary: MaterialColor(0xFFFFFFFF, whiteColor),
        secondary: MaterialColor(0xFF000000, blackColor),
        onSecondary: MaterialColor(0xFFFFFFFF, whiteColor),
        surface: MaterialColor(0xFFFFFFFF, whiteColor),
        onSurface: MaterialColor(0xFF000000, blackColor),
        outlineVariant: Colors.grey[200],
      );
    }
  }

  Color? background;
  Color? onPrimary;

  if (trueBlack && darkMode) {
    background = blackColor[900];
    onPrimary = blackColor[900];
  }

  if (material) {
    colorScheme ??= ColorScheme.fromSeed(
      brightness: darkMode ? Brightness.dark : Brightness.light,
      seedColor: seedColor,
      surface: background,
      onPrimary: onPrimary,
    );
  } else {
    colorScheme ??= ColorScheme.fromSeed(
      brightness: darkMode ? Brightness.dark : Brightness.light,
      seedColor: seedColor,
      primary: seedColor,
      secondary: SharedService.generateSecondaryColor(seedColor),
      surface: background,
      onPrimary: onPrimary,
    );
  }

  TextTheme defaultTextTheme = GoogleFonts.poppinsTextTheme(ThemeData(
    brightness: darkMode ? Brightness.dark : Brightness.light,
  ).textTheme);

  ThemeData materialTheme = ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    brightness: darkMode ? Brightness.dark : Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    navigationBarTheme: NavigationBarThemeData(
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
    cardTheme: const CardTheme(
      elevation: 1,
      shadowColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );

  ThemeData defaultTheme = ThemeData(
    colorScheme: colorScheme,
    appBarTheme: materialTheme.appBarTheme.copyWith(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceDim,
      elevation: 0,
    ),
    navigationBarTheme: materialTheme.navigationBarTheme.copyWith(
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      surfaceTintColor: colorScheme.surfaceDim,
      elevation: 0,
      indicatorColor: Colors.transparent,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(
            color: colorScheme!.primary,
          );
        }
        return null;
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        return Colors.transparent;
      }),
      backgroundColor: colorScheme.surface,
      height: 56,
    ),
    navigationRailTheme: materialTheme.navigationRailTheme.copyWith(
      labelType: NavigationRailLabelType.selected,
      elevation: 0,
      indicatorColor: Colors.transparent,
      selectedIconTheme: IconThemeData(
        color: colorScheme.primary,
      ),
      backgroundColor: colorScheme.surface,
    ),
    floatingActionButtonTheme: materialTheme.floatingActionButtonTheme.copyWith(
      elevation: 0,
      highlightElevation: 0,
      backgroundColor: colorScheme.primary,
      foregroundColor:
          darkMode ? colorScheme.onPrimaryContainer : colorScheme.onPrimary,
      extendedPadding: const EdgeInsets.symmetric(horizontal: 21, vertical: 0),
      shape: const StadiumBorder(
        side: BorderSide.none,
      ),
    ),
    cardTheme: materialTheme.cardTheme.copyWith(
      color: colorScheme.surface,
      elevation: 1,
      shape: const OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      surfaceTintColor: HSLColor.fromColor(colorScheme.surfaceTint)
          .withSaturation(0)
          .toColor(),
    ),
    chipTheme: ChipThemeData(
      labelStyle: materialTheme.textTheme.labelSmall!.copyWith(
        color: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return darkMode
                ? colorScheme!.onPrimaryContainer
                : colorScheme!.onPrimary;
          }
          return colorScheme!.secondary;
        }),
      ),
      color: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme!.primary;
        }
        return Colors.transparent;
      }),
      showCheckmark: false,
      side: WidgetStateBorderSide.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return BorderSide(
            color: Colors.transparent,
          );
        }
        return BorderSide(
          color: colorScheme!.secondary,
        );
      }),
      shape: StadiumBorder(),
    ),
    filledButtonTheme: FilledButtonThemeData(style: ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        return darkMode
            ? colorScheme!.onPrimaryContainer
            : colorScheme!.onPrimary;
      }),
    )),
    segmentedButtonTheme: materialTheme.segmentedButtonTheme.copyWith(
      style: ButtonStyle(
        side: WidgetStateProperty.resolveWith((states) {
          return BorderSide.none;
        }),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme!.primary;
          }
          return colorScheme!.surfaceContainerHigh;
        }),
        iconColor: WidgetStateProperty.resolveWith((states) {
          return colorScheme!.onSurface;
        }),
      ),
    ),
    inputDecorationTheme: materialTheme.inputDecorationTheme.copyWith(
      border: const UnderlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      fillColor: colorScheme.onInverseSurface,
      filled: true,
      isDense: true,
    ),
    switchTheme: materialTheme.switchTheme.copyWith(
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    radioTheme: materialTheme.radioTheme.copyWith(
      fillColor: WidgetStatePropertyAll(colorScheme.primary),
    ),
    popupMenuTheme: materialTheme.popupMenuTheme.copyWith(
      color: colorScheme.surface,
      // elevation: 1,
      shape: const OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      surfaceTintColor: colorScheme.surface,
    ),
    dialogTheme: materialTheme.dialogTheme.copyWith(
      elevation: 0,
      backgroundColor: colorScheme.surface,
    ),
    textTheme: (darkMode
            ? Typography.material2021().white
            : Typography.material2021().black)
        .merge(defaultTextTheme),
    useMaterial3: materialTheme.useMaterial3,
    visualDensity: materialTheme.visualDensity,
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
