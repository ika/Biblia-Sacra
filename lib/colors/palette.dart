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
}
