import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/langs/bookLists.dart';
import 'package:shared_preferences/shared_preferences.dart';

BookLists bookLists = BookLists();

class SharedPrefs {
  SharedPreferences _sharedPreferences;

  Future<SharedPreferences> initInstance() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    return _sharedPreferences;
  }

  // Future<String> getLanguageBookName(number, lang) async {
  //   List<LKeyModel> value = List<LKeyModel>.empty();
  //   value = await _lkQueries.getBookName(number, lang);
  //   return value.first.name;
  // }

  // ==================SAVE=====================

  // Save version
  Future<void> saveVersion(int v) async {
    final prefs = await initInstance();
    const key = 'version';
    final value = v;
    prefs.setInt(key, value);
  }

  // Save book
  Future<void> saveBook(int b) async {
    final prefs = await initInstance();
    const key = 'book';
    final value = b;
    prefs.setInt(key, value);
  }

  // Save chapter
  Future<void> saveChapter(int c) async {
    final prefs = await initInstance();
    const key = 'chapter';
    final value = c;
    prefs.setInt(key, value);
  }

  // Save verse
  Future<void> saveVerse(int c) async {
    final prefs = await initInstance();
    const key = 'verse';
    final value = c;
    prefs.setInt(key, value);
  }

  Future<void> saveLang(String l) async {
    final prefs = await initInstance();
    const key = 'language';
    final value = l;
    prefs.setString(key, value);
  }

  Future<void> saveVerAbbr(String r) async {
    final prefs = await initInstance();
    const key = 'verabbr';
    final value = r;
    prefs.setString(key, value);
  }

  Future<void> saveBookName(String n) async {
    final prefs = await initInstance();
    const key = 'bookname';
    final value = n;
    prefs.setString(key, value);
  }

  Future<void> saveSearchAreaKey(int a) async {
    final prefs = await initInstance();
    const key = 'searcharea';
    final value = a;
    prefs.setInt(key, value);
  }

  // ==================READ=====================

  Future<int> readSearchAreaKey() async {
    final prefs = await initInstance();
    const key = 'searcharea';
    return prefs.getInt(key) ?? 0;
  }

  Future<int> readVersion() async {
    final prefs = await initInstance();
    const key = 'version';
    return prefs.getInt(key) ?? 1;
  }

  // Read book
  Future<int> readBook() async {
    final prefs = await initInstance();
    const key = 'book';
    return prefs.getInt(key) ?? 43; // Gospel of John
  }

  // Read chapter
  Future<int> readChapter() async {
    final prefs = await initInstance();
    const key = 'chapter';
    return prefs.getInt(key) ?? 1; // Chapter one
  }

  // Read verse
  Future<int> readVerse() async {
    final prefs = await initInstance();
    const key = 'verse';
    return prefs.getInt(key) ?? 1; // Chapter one
  }

  Future<String> readLang() async {
    final prefs = await initInstance();
    const key = 'language';
    return prefs.getString(key) ?? 'eng'; // English
  }

  Future<String> readVerAbbr() async {
    final prefs = await initInstance();
    const key = 'verabbr';
    return prefs.getString(key) ?? 'KJV'; // King James version
  }

  Future<String> readBookName(int book) async {
    return bookLists.getBookByNumber(book, Globals.bibleLang);
  }

  Future<void> writeBookName(int book) async {
    readBookName(book).then(
      (name) {
        saveBookName(name).then(
          (v) {
            Globals.bookName = name;
            Globals.selectorText = "$name: 1:1";
          },
        );
      },
    );
  }
}
