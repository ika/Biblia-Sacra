import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/utils/sharedPrefs.dart';

SharedPrefs _sharedPrefs = SharedPrefs();

class WriteVarsModel {
  int id;
  String lang;
  int version; // version book number
  String abbr; // version abbreviation
  int book; // book number
  int chapter; // chapter number
  int verse;
  String name; // book name

  WriteVarsModel({
    this.id,
    this.lang,
    this.version,
    this.abbr,
    this.book,
    this.chapter,
    this.verse,
    this.name,
  });
}

Future<void> writeVars(WriteVarsModel model) async {
  // version
  _sharedPrefs.setIntPref('version', model.version).then((v) {
    Globals.bibleVersion = model.version;
    // language
    _sharedPrefs.setStringPref('language', model.lang).then((v) {
      Globals.bibleLang = model.lang;
      // version abbreviation
      _sharedPrefs.setStringPref('verabbr', model.abbr).then((v) {
        Globals.versionAbbr = model.abbr;
        // Book
        _sharedPrefs.setIntPref('book',model.book).then((v) {
          Globals.bibleBook = model.book;
          // Chapter
          _sharedPrefs.setIntPref('chapter', model.chapter).then((v) {
            Globals.bookChapter = model.chapter;
            // Verse
            _sharedPrefs.setIntPref('verse', model.verse).then((v) {
              Globals.chapterVerse = model.verse - 1;
              // Book name
              _sharedPrefs.setStringPref('bookname', model.name).then((v) {
                Globals.bookName = model.name;
              });
            });
          });
        });
      });
    });
  });
}
