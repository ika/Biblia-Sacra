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
}
