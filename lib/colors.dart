import 'package:flutter/material.dart';

const loveColor = Color.fromARGB(255, 246, 30, 109);
// Color.fromARGB(255, 251, 35, 150);
const lustColor = Color.fromARGB(255, 185, 82, 197);
// Color.fromARGB(255, 106, 47, 208);
const lipstickColor = Color.fromARGB(255, 223, 0, 32);
const redColor = Color.fromARGB(255, 235, 0, 77);
const blueColor = Color.fromARGB(255, 0, 122, 255);
const shimapanColor = Color.fromARGB(255, 0, 216, 184);

double mixVariation = 0.7;

get lovelustColor {
  int red = (loveColor.red * mixVariation + lustColor.red * (1 - mixVariation))
      .floor();
  int green =
      (loveColor.green * mixVariation + lustColor.green * (1 - mixVariation))
          .floor();
  int blue =
      (loveColor.blue * mixVariation + lustColor.blue * (1 - mixVariation))
          .floor();
  return Color.fromARGB(255, red, green, blue);
}

get lovelustMonoColor {
  return HSLColor.fromColor(lovelustColor).withSaturation(0).toColor();
}

final Map<int, Color> blackColor = {
  50: const Color.fromRGBO(0, 0, 0, .1),
  100: const Color.fromRGBO(0, 0, 0, .2),
  200: const Color.fromRGBO(0, 0, 0, .3),
  300: const Color.fromRGBO(0, 0, 0, .4),
  400: const Color.fromRGBO(0, 0, 0, .5),
  500: const Color.fromRGBO(0, 0, 0, .6),
  600: const Color.fromRGBO(0, 0, 0, .7),
  700: const Color.fromRGBO(0, 0, 0, .8),
  800: const Color.fromRGBO(0, 0, 0, .9),
  900: const Color.fromRGBO(0, 0, 0, 1),
};

final Map<int, Color> whiteColor = {
  50: const Color.fromRGBO(255, 255, 255, .1),
  100: const Color.fromRGBO(255, 255, 255, .2),
  200: const Color.fromRGBO(255, 255, 255, .3),
  300: const Color.fromRGBO(255, 255, 255, .4),
  400: const Color.fromRGBO(255, 255, 255, .5),
  500: const Color.fromRGBO(255, 255, 255, .6),
  600: const Color.fromRGBO(255, 255, 255, .7),
  700: const Color.fromRGBO(255, 255, 255, .8),
  800: const Color.fromRGBO(255, 255, 255, .9),
  900: const Color.fromRGBO(255, 255, 255, 1),
};
