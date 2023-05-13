import 'package:flutter/material.dart';
import 'package:notiboy/utils/color.dart';

class ThemeClass {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Clr.light,
    colorScheme: ColorScheme.light(),
  );

  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Clr.dark,
    colorScheme: ColorScheme.dark(),
  );
}
