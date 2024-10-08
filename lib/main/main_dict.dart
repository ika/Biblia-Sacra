import 'package:bibliasacra/dict/dict_queries.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:flutter/material.dart';

// main_dict.dart

DictQueries _dictQueries = DictQueries();

Future<dynamic> dictDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return SimpleDialog(
        children: [
          SizedBox(
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: DictListing(),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}

Future<List<DicModel>> repeatSearch() async {
  List<DicModel> searchList = [];
  String word = ''; //Globals.dictionaryLookup;

  word = Globals.dictionaryLookup.replaceAll(RegExp(r'[^\w\s]+'), '');

  do {
    searchList = await _dictQueries.getSearchedValues(word);
    word = word.characters.skipLast(1).toString();
  } while (searchList.first.trans!.isEmpty);

  return searchList;
}

Widget listTileMethod(AsyncSnapshot<List<DicModel>> snapshot, int index) {
  return ListTile(
    title: Text(
      snapshot.data![index].word!,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    subtitle: Text(
      snapshot.data![index].trans!,
      style: const TextStyle(fontWeight: FontWeight.normal),
    ),
    //onTap: () {},
  );
}

class DictListing extends StatelessWidget {
  const DictListing({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DicModel>>(
      future: repeatSearch(),
      builder: (BuildContext context, AsyncSnapshot<List<DicModel>> snapshot) {
        int l = (snapshot.data != null) ? snapshot.data!.length : 0;
        return ListView.separated(
          itemCount: l,
          itemBuilder: (BuildContext context, int index) {
            return listTileMethod(snapshot, index);
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        );
      },
    );
  }
}
