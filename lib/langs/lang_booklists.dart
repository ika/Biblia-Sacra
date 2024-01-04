// BookLists

import 'package:bibliasacra/globals/globs_main.dart';
import 'package:bibliasacra/langs/lang_eng.dart';
import 'package:bibliasacra/langs/lang_latin.dart';
import 'package:bibliasacra/utils/utils_sharedprefs.dart';
import 'package:bibliasacra/utils/utils_utilities.dart';

final sharedPrefs = SharedPrefs();

List<String> langListSelector(String lang) {
  List<String> langList = [];
  switch (lang) {
    case 'eng':
      langList = engList;
      break;
    case 'lat':
      langList = latList;
      break;
  }
  return langList;
}

class BookLists {

  String getBookByNumber(int number, String lang) {
    List<String> langList = [];

    langList = langListSelector(lang);

    return langList[number - 1]; // list=0 book number=1
  }

  Map searchList(String keyWord, String lang) {
    var listMap = {};
    List<String> langList = [];

    langList = langListSelector(lang);

    for (var i = 0; i < langList.length; i++) {
      String word = langList[i];
      if (langList[i].toLowerCase().contains(keyWord.toLowerCase())) {
        listMap[i] = word;
      }
    }

    return listMap;
  }

  Map getBookListByLang(String lang) {
    var listMap = {};
    List<String> langList = [];

    langList = langListSelector(lang);

    for (var i = 0; i < langList.length; i++) {
      listMap[i] = langList[i];
    }

    return listMap;
  }

  Future<String> readBookName(int book) async {
    return getBookByNumber(book, Utilities(book).getLanguage());
  }

  Future<void> writeBookName(int book) async {
    readBookName(book).then(
      (name) {
        sharedPrefs.setStringPref('bookname', name).then(
          (v) {
            Globals.bookName = name;
            //Globals.selectorText = "$name: 1:1";
          },
        );
      },
    );
  }
}
