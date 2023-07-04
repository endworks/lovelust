import 'dart:ui';

const loveColor = Color.fromARGB(255, 251, 35, 186);
const lustColor = Color.fromARGB(255, 106, 47, 208);
get defaultColor {
  int red = ((loveColor.red + lustColor.red) / 2).floor();
  int green = ((loveColor.green + lustColor.green) / 2).floor();
  int blue = ((loveColor.blue + lustColor.blue) / 2).floor();
  return Color.fromARGB(255, red, green, blue);
}
