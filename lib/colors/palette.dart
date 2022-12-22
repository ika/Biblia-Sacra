import 'package:flutter/material.dart';

// https://maketintsandshades.com/

class Palette {
// blueGray
  static const MaterialColor p1 = MaterialColor(
    0xff6699CC, // 0% comes in here, this will be color picked if no shade is selected.
    <int, Color>{
      50: Color(0xffb3cce6), //10%
      100: Color(0xffa3c2e0), //20%
      200: Color(0xff94b8db), //30%
      300: Color(0xff85add6), //40%
      400: Color(0xff75a3d1), //50%
      500: Color(0xff6699CC), //60%
      600: Color(0xff5c8ab8), //70%
      700: Color(0xff527aa3), //80%
      800: Color(0xff476b8f), //90%
      900: Color(0xff3d5c7a), //100%
    },
  );

  // Lime
  static const MaterialColor p2 = MaterialColor(
    0xffcddc39, // 0% comes in here, this will be color picked if no shade is selected.
    <int, Color>{
      50: Color(0xffe6ee9c), //10%
      100: Color(0xffe1ea88), //20%
      200: Color(0xffdce774), //30%
      300: Color(0xffd7e361), //40%
      400: Color(0xffd2e04d), //50%
      500: Color(0xffcddc39), //60%
      600: Color(0xffb9c633), //70%
      700: Color(0xffa4b02e), //80%
      800: Color(0xff909a28), //90%
      900: Color(0xff7b8422), //100%
    },
  );

  static const MaterialColor p3 = MaterialColor(
    0xffe9967a, // 0% comes in here, this will be color picked if no shade is selected.
    <int, Color>{
      50: Color(0xfff4cbbd), //10%
      100: Color(0xfff2c0af), //20%
      200: Color(0xfff0b6a2), //30%
      300: Color(0xffedab95), //40%
      400: Color(0xffeba187), //50%
      500: Color(0xffe9967a), //60%
      600: Color(0xffd2876e), //70%
      700: Color(0xffba7862), //80%
      800: Color(0xffa36955), //90%
      900: Color(0xff8c5a49), //100%
    },
  );

  static const MaterialColor p4 = MaterialColor(
    0xff95e595, // 0% comes in here, this will be color picked if no shade is selected.
    <int, Color>{
      50: Color(0xffcaf2ca), //10%
      100: Color(0xffbfefbf), //20%
      200: Color(0xffb5edb5), //30%
      300: Color(0xffaaeaaa), //40%
      400: Color(0xffa0e8a0), //50%
      500: Color(0xff95e595), //60%
      600: Color(0xff86ce86), //70%
      700: Color(0xff77b777), //80%
      800: Color(0xff68a068), //90%
      900: Color(0xff598959), //100%
    },
  );
}
