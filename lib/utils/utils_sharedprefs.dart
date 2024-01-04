import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  final Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();

  // ==================SET=====================

  Future<void> setStringPref(String key, String value) async {
    final prefs = await sharedPrefs;
    prefs.setString(key, value);
  }

  Future<void> setIntPref(String key, int value) async {
    final prefs = await sharedPrefs;
    prefs.setInt(key, value);
  }

  Future<void> setDoublePref(String key, double value) async {
    final prefs = await sharedPrefs;
    prefs.setDouble(key, value);
  }

  Future<void> setBoolPref(String key, bool value) async {
    final prefs = await sharedPrefs;
    prefs.setBool(key, value);
  }

  Future<void> setStringListPref(String key, List<String> list) async {
    final prefs = await sharedPrefs;
    prefs.setStringList(key, list);
  }

  // ==================GET=====================

  Future<String?> getStringPref(String key) async {
    final prefs = await sharedPrefs;
    return prefs.getString(key);
  }

  Future<int?> getIntPref(String key) async {
    final prefs = await sharedPrefs;
    return prefs.getInt(key);
  }

  Future<double?> getDoublePref(String key) async {
    final prefs = await sharedPrefs;
    return prefs.getDouble(key);
  }

  Future<bool?> getBoolPref(key) async {
    final prefs = await sharedPrefs;
    return prefs.getBool(key);
  }

  Future<List<String>?> getStringListPref(key) async {
    final prefs = await sharedPrefs;
    return prefs.getStringList(key);
  }

  // =====================================

  // Chapter
  Future<void> setChapterPref(int value) async {
    final prefs = await sharedPrefs;
    prefs.setInt("chapterNumber", value);
  }

  Future<int> getChapterPref() async {
    final prefs = await sharedPrefs;
    return prefs.getInt("chapterNumber") ?? 1;
  }

  // Bible Version
  Future<void> setVersionPref(int value) async {
    final prefs = await sharedPrefs;
    prefs.setInt("versionNumber", value);
  }

  Future<int> getVersionPref() async {
    final prefs = await sharedPrefs;
    return prefs.getInt("versionNumber") ?? 1;
  }

  // Verse
  Future<void> setVersePref(int value) async {
    final prefs = await sharedPrefs;
    prefs.setInt("verseNumber", value);
  }

  Future<int> getVersePref() async {
    final prefs = await sharedPrefs;
    return prefs.getInt("verseNumber") ?? 1;
  }

  // Book
  Future<void> setBookPref(int value) async {
    final prefs = await sharedPrefs;
    prefs.setInt("bookNumber", value);
  }

  Future<int> getBookPref() async {
    final prefs = await sharedPrefs;
    return prefs.getInt("bookNumber") ?? 43;
  }

  // Search Area
  Future<void> setSearchAreaPref(int value) async {
    final prefs = await sharedPrefs;
    prefs.setInt("searchArea", value);
  }

  Future<int> getSearchAreaPref() async {
    final prefs = await sharedPrefs;
    return prefs.getInt("searchArea") ?? 5;
  }
}
