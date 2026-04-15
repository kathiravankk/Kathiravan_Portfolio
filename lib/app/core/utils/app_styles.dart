import 'package:flutter/material.dart';

class AppStyles {
  static TextStyle customTextStyle({
    required double size,
    FontWeight weight = FontWeight.normal,
    Color? color,
    double lineSpace = 1.0,
    bool isUnderlined = false,
    Color? underlineColor,
    double underlineThickness = 1.0,
    String fontFamily = "Inter",
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      height: lineSpace,
      color: color ?? Colors.white,
      fontWeight: weight,
      fontSize: size,
      decoration: isUnderlined ? TextDecoration.underline : TextDecoration.none,
      decorationColor: underlineColor,
      decorationThickness: underlineThickness,
    );
  }
}
