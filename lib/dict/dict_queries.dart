import 'dart:async';
import 'dict_provider.dart';

// dict_queries.dart
// The dict.db file is not correctly formatted - missing second field in some cases

class DicModel {
  int? id;
  String? word;
  String? trans;

  DicModel({this.id, this.word, this.trans});

  DicModel.fromMap(dynamic map) {
    id = map['id'];
    word = map['word'];
    trans = map['trans'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['id'] = id;
    map['word'] = word;
    map['trans'] = trans;

    return map;
  }
}

DicProvider dicProvider = DicProvider();

class DictQueries {
  final String _tableName = 't_wordlist';

  Future<List<DicModel>> getSearchedValues(String s) async {
    List<DicModel> emptyList = [];
    final mod = DicModel(id: 0, word: 'No results.', trans: '');
    emptyList.add(mod);

    final db = await dicProvider.database;

    var res = await db.rawQuery(
        '''SELECT * FROM $_tableName WHERE word LIKE ? ORDER BY word''',
        ['$s%']);

    List<DicModel> list = res.isNotEmpty
        ? res.map((tableName) => DicModel.fromMap(tableName)).toList()
        : emptyList;

    list.sort((a, b) => a.toString().compareTo(b.toString()));

    return list;
  }
}
