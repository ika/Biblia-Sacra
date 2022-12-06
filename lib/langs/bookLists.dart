// BookLists

import 'package:bibliasacra/langs/afrList.dart';
import 'package:bibliasacra/langs/engList.dart';
import 'package:bibliasacra/langs/latList.dart';

List<String> langListSelector(String lang) {
  List<String> langList = [];
  switch (lang) {
    case 'eng':
      langList = engList;
      break;
    case 'lat':
      langList = latList;
      break;
    case 'afr':
      langList = afrList;
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
}
