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

// Magneta
  static const MaterialColor p5 = MaterialColor(
    0xffc678dd, // 0% comes in here, this will be color picked if no shade is selected.
    <int, Color>{
      50: Color(0xffe3bcee), //10%
      100: Color(0xffddaeeb), //20%
      200: Color(0xffd7a1e7), //30%
      300: Color(0xffd193e4), //40%
      400: Color(0xffcc86e0), //50%
      500: Color(0xffc678dd), //60%
      600: Color(0xffb26cc7), //70%
      700: Color(0xff9e60b1), //80%
      800: Color(0xff8b549b), //90%
      900: Color(0xff774885), //100%
    },
  );

// Orange
  static const MaterialColor p6 = MaterialColor(
    0xffd19a66, // 0% comes in here, this will be color picked if no shade is selected.
    <int, Color>{
      50: Color(0xffe8cdb3), //10%
      100: Color(0xffe3c2a3), //20%
      200: Color(0xffdfb894), //30%
      300: Color(0xffdaae85), //40%
      400: Color(0xffd6a475), //50%
      500: Color(0xffd19a66), //60%
      600: Color(0xffbc8b5c), //70%
      700: Color(0xffa77b52), //80%
      800: Color(0xff926c47), //90%
      900: Color(0xff7d5c3d), //100%
    },
  );

// Purple
  // static const MaterialColor p7 = MaterialColor(
  //   0xffc678dd, // 0% comes in here, this will be color picked if no shade is selected.
  //   <int, Color>{
  //     50: Color(0xffe3bcee), //10%
  //     100: Color(0xffddaeeb), //20%
  //     200: Color(0xffd7a1e7), //30%
  //     300: Color(0xffd193e4), //40%
  //     400: Color(0xffcc86e0), //50%
  //     500: Color(0xffc678dd), //60%
  //     600: Color(0xffb26cc7), //70%
  //     700: Color(0xff9e60b1), //80%
  //     800: Color(0xff8b549b), //90%
  //     900: Color(0xff774885), //100%
  //   },
  // );

// Red
  static const MaterialColor p8 = MaterialColor(
    0xffe06c75, // 0% comes in here, this will be color picked if no shade is selected.
    <int, Color>{
      50: Color(0xfff0b6ba), //10%
      100: Color(0xffeca7ac), //20%
      200: Color(0xffe9989e), //30%
      300: Color(0xffe68991), //40%
      400: Color(0xffe37b83), //50%
      500: Color(0xffe06c75), //60%
      600: Color(0xffca6169), //70%
      700: Color(0xffb3565e), //80%
      800: Color(0xff9d4c52), //90%
      900: Color(0xff864146), //100%
    },
  );

// Yellow
  static const MaterialColor p9 = MaterialColor(
    0xffe5c07b, // 0% comes in here, this will be color picked if no shade is selected.
    <int, Color>{
      50: Color(0xfff2e0bd), //10%
      100: Color(0xffefd9b0), //20%
      200: Color(0xffedd3a3), //30%
      300: Color(0xffeacd95), //40%
      400: Color(0xffe8c688), //50%
      500: Color(0xffe5c07b), //60%
      600: Color(0xffcead6f), //70%
      700: Color(0xffb79a62), //80%
      800: Color(0xffa08656), //90%
      900: Color(0xff89734a), //100%
    },
  );
}
