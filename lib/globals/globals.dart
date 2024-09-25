import 'package:flutter/material.dart';

// globals.dart

class Globals {
  // Navigarot delay
  static int navigatorDelay = 200;
  static int navigatorLongDelay = 500;
  static int navigatorLongestDelay = 800;

  // back Icon
  static const IconData backArrow =
      IconData(0xe791, fontFamily: "MaterialIcons");

  // Dictionary mode
  static bool dictionaryMode = false;
  static String dictionaryLookup = '';

  // Active Version count
  static int? activeVersionCount = 0;
}
