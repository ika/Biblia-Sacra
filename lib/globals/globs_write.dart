import 'package:bibliasacra/globals/globs_main.dart';
import 'package:bibliasacra/utils/utils_sharedprefs.dart';

SharedPrefs sharedPrefs = SharedPrefs();

class WriteVarsModel {
  int? id;
  String? lang;
  int? version; // version book number
  String? abbr; // version abbreviation
  int? book; // book number
  int? chapter; // chapter number
  int? verse;
  String? name; // book name

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
  Globals.bibleVersion = model.version!;
  Globals.bibleLang = model.lang!;
  Globals.versionAbbr = model.abbr!;
  Globals.bibleBook = model.book!;
  Globals.bookChapter = model.chapter!;
  Globals.chapterVerse = model.verse!;
  Globals.bookName = model.name!;
  // version
  sharedPrefs.setIntPref('version', model.version!);
  // language
  sharedPrefs.setStringPref('language', model.lang!);
  // version abbreviation
  sharedPrefs.setStringPref('verabbr', model.abbr!);
  // Book
  sharedPrefs.setIntPref('book', model.book!);
  // Chapter
  //sharedPrefs.setIntPref('chapter', model.chapter!);
  // Verse
  sharedPrefs.setIntPref('verse', model.verse!);
  // Book name
  sharedPrefs.setStringPref('bookname', model.name!);
}
