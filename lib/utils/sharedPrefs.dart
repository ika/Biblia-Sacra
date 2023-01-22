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

  // ==================SAVE=====================

  Future<void> saveVersion(int v) async {
    final prefs = await initInstance();
    prefs.setInt('version', v);
  }

  Future<void> saveBook(int b) async {
    final prefs = await initInstance();
    prefs.setInt('book', b);
  }

  Future<void> saveChapter(int c) async {
    final prefs = await initInstance();
    prefs.setInt('chapter', c);
  }

  Future<void> saveVerse(int c) async {
    final prefs = await initInstance();
    prefs.setInt('verse', c);
  }

  Future<void> saveLang(String l) async {
    final prefs = await initInstance();
    prefs.setString('language', l);
  }

  Future<void> saveVerAbbr(String r) async {
    final prefs = await initInstance();
    prefs.setString('verabbr', r);
  }

  Future<void> saveBookName(String n) async {
    final prefs = await initInstance();
    prefs.setString('bookname', n);
  }

  Future<void> saveSearchAreaKey(int a) async {
    final prefs = await initInstance();
    prefs.setInt('searcharea', a);
  }

  Future<void> saveColorListNumber(int p) async {
    final prefs = await initInstance();
    prefs.setInt('colorsList', p);
  }

  // ==================READ=====================

  Future<int> readColorsListNumber() async {
    final prefs = await initInstance();
    return prefs.getInt('colorsList') ?? 12;
  }

  Future<int> readSearchAreaKey() async {
    final prefs = await initInstance();
    return prefs.getInt('searcharea') ?? 0;
  }

  Future<int> readVersion() async {
    final prefs = await initInstance();
    return prefs.getInt('version') ?? 1;
  }

  Future<int> readBook() async {
    final prefs = await initInstance();
    return prefs.getInt('book') ?? 43; // Gospel of John
  }

  Future<int> readChapter() async {
    final prefs = await initInstance();
    return prefs.getInt('chapter') ?? 1; // Chapter one
  }

  Future<int> readVerse() async {
    final prefs = await initInstance();
    return prefs.getInt('verse') ?? 1; // Chapter one
  }

  Future<String> readLang() async {
    final prefs = await initInstance();
    return prefs.getString('language') ?? 'eng'; // English
  }

  Future<String> readVerAbbr() async {
    final prefs = await initInstance();
    return prefs.getString('verabbr') ?? 'KJV'; // King James version
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
