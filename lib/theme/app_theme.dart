import 'package:flutter/material.dart';

class DesignColors {
  static const Color backgroundColor = Color(0xff181a20);
  static const Color secondaryColor = Color(0xff333358);
  static const Color secondaryColorDark = Color(0xff1f222a);
  static const Color mainColor = Color(0xffff1686);
  static const Color detailsColor = Color(0xff9e9e9e);
  static const Color negativeColor = Color(0xfff75555);
  static const Color positiveColor = Color(0xff12d18e);
  static const Color detailsColorDark = Color(0xff616161);
}

final appTheme = ThemeData(
    scaffoldBackgroundColor: DesignColors.backgroundColor,
    colorScheme: const ColorScheme.dark(
      background: DesignColors.backgroundColor,
    ),
    checkboxTheme: CheckboxThemeData(
        overlayColor: const MaterialStatePropertyAll(DesignColors.mainColor),
        fillColor: const MaterialStatePropertyAll(DesignColors.mainColor),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4), side: const BorderSide(width: 4))),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: DesignColors.mainColor,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            textStyle: const TextStyle(fontSize: 18, color: Colors.white),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)))),
    appBarTheme: const AppBarTheme(
      backgroundColor: DesignColors.backgroundColor,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 22),
      centerTitle: true,
      elevation: 0,
    ));

ButtonStyle selectorButtonsTheme(bool isSelected) {
  return ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: isSelected ? DesignColors.secondaryColor : DesignColors.secondaryColorDark,
      elevation: 0,
      side: BorderSide(width: 1, color: Colors.white.withAlpha(50)),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      textStyle: const TextStyle(fontSize: 18, color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)));
}
