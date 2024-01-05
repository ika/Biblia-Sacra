
import 'package:flutter/material.dart';

class Globals {
  //----initial read-----------------------
  //static int bibleVersion = 1; // KJV bible version
  //static String bibleLang = 'eng'; // Bible language
  //static String versionAbbr = 'KJV'; // version abbreviation KJV
  //static String versionName = 'King James Version';  // version full name
  //static int bibleBook = 43; // Gospel of John
  //static int bookNameIndex = 42; // index is one less that book number
  //static int bibleBookChapter = 1; // used for Block cubit
  //static int chapterVerse = 1; // Verse
  //static String bookName = 'John'; // Book name
  //--------------------------------------

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
