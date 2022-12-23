import 'package:flutter/material.dart';

// https://maketintsandshades.com/

class Palette {
// Blue
  static const MaterialColor p1 = MaterialColor(
    0xff61afef, // 0% comes in here, this will be color picked if no shade is selected.
    <int, Color>{
      50: Color(0xffb0d7f7), //10%
      100: Color(0xffa0cff5), //20%
      200: Color(0xff90c7f4), //30%
      300: Color(0xff81bff2), //40%
      400: Color(0xff71b7f1), //50%
      500: Color(0xff61afef), //60%
      600: Color(0xff579ed7), //70%
      700: Color(0xff4e8cbf), //80%
      800: Color(0xff447aa7), //90%
      900: Color(0xff3a698f), //100%
    },
  );

  // Cyan
  static const MaterialColor p2 = MaterialColor(
    0xff56b6c2, // 0% comes in here, this will be color picked if no shade is selected.
    <int, Color>{
      50: Color(0xffabdbe1), //10%
      100: Color(0xff9ad3da), //20%
      200: Color(0xff89ccd4), //30%
      300: Color(0xff78c5ce), //40%
      400: Color(0xff67bdc8), //50%
      500: Color(0xff56b6c2), //60%
      600: Color(0xff4da4af), //70%
      700: Color(0xff45929b), //80%
      800: Color(0xff3c7f88), //90%
      900: Color(0xff346d74), //100%
    },
  );

  // Green
  static const MaterialColor p3 = MaterialColor(
    0xff98C379, // 0% comes in here, this will be color picked if no shade is selected.
    <int, Color>{
      50: Color(0xffcce1bc), //10%
      100: Color(0xffc1dbaf), //20%
      200: Color(0xffb7d5a1), //30%
      300: Color(0xffadcf94), //40%
      400: Color(0xffa2c986), //50%
      500: Color(0xff98C379), //60%
      600: Color(0xff89b06d), //70%
      700: Color(0xff7a9c61), //80%
      800: Color(0xff6a8955), //90%
      900: Color(0xff5b7549), //100%
    },
  );

  // Grey
  static const MaterialColor p4 = MaterialColor(
    0xff3e4451, // 0% comes in here, this will be color picked if no shade is selected.
    <int, Color>{
      50: Color(0xff9fa2a8), //10%
      100: Color(0xff8b8f97), //20%
      200: Color(0xff787c85), //30%
      300: Color(0xff656974), //40%
      400: Color(0xff515762), //50%
      500: Color(0xff3e4451), //60%
      600: Color(0xff383d49), //70%
      700: Color(0xff323641), //80%
      800: Color(0xff2b3039), //90%
      900: Color(0xff252931), //100%
    },
  );
}
