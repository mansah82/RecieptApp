//palette.dart
import 'package:flutter/material.dart';

class MyColors {
  static const MaterialColor primaryWhite = MaterialColor(
    0xFFFFEBEE, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xFFFFEBEE), //10%
      100: Color(0xFFFFEBEE), //20%
      200: Color(0xFFFFEBEE), //30%
      300: Color(0xFFFFEBEE), //40%
      400: Color(0xFFFFEBEE), //50%
      500: Color(0xFFFFEBEE), //60%
      600: Color(0xFFFFEBEE), //70%
      700: Color(0xFFFFEBEE), //80%
      800: Color(0xFFFFEBEE), //90%
      900: Color(0xFFFFEBEE), //100%
    },
  );
}
