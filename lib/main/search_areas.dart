import 'package:bibliasacra/cubit/cub_search.dart';
import 'package:bibliasacra/globals/globs_main.dart';
import 'package:bibliasacra/utils/utils_sharedprefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

var searchAreasList = {};
SharedPrefs sharedPrefs = SharedPrefs();

Future<dynamic> searchAreasDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return SimpleDialog(
        children: [
          SizedBox(
            height: 300.0,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SearchAreasList(),
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

List<String> areasSections = [
  '1|5',
  '6|17',
  '18|22',
  '23|27',
  '28|39',
  '40|43',
  '44|44',
  '45|57',
  '58|65',
  '66|66'
];

List<String> areasList = [
  'Books of Moses', // 1 -5
  'Historical Books', // 6 - 17
  'Poetic Books', // 18 - 22
  'Major Prophets', // 23 - 27
  'Minor Prophets', // 28 - 39
  'The Gospels', // 40 - 43
  'Acts', // 44
  'Pauline Letters', // 45 - 57
  'General Letters', //58 - 65
  'The Revelation' // 66
];

Map getAreasList() {
  var listMap = {};

  for (var i = 0; i < areasList.length; i++) {
    listMap[i] = areasList[i];
  }

  return listMap;
}

class SearchAreasList extends StatelessWidget {
  SearchAreasList({super.key});

  final searchAreasList = getAreasList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: searchAreasList.length,
      itemBuilder: (BuildContext context, int index) {
        int elementKey =
            searchAreasList.keys.elementAt(index); // use index alone
        return ListTile(
          title: Text(
            searchAreasList[elementKey],
          ),
          onTap: () {
            sharedPrefs.setIntPref('searchArea', elementKey).then((v) {
              BlocProvider.of<SearchCubit>(context)
                  .setSearchAreaKey(elementKey);

              Future.delayed(
                Duration(milliseconds: Globals.navigatorDelay),
                () {
                  Navigator.of(context).pop();
                },
              );
            });
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
