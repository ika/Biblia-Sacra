import 'dart:async';

import 'package:bibliasacra/colors/palette.dart';
import 'package:bibliasacra/cubit/chaptersCubit.dart';
import 'package:bibliasacra/cubit/paletteCubit.dart';
import 'package:bibliasacra/cubit/searchCubit.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/globals/write.dart';
import 'package:bibliasacra/main/dbModel.dart';
import 'package:bibliasacra/main/dbQueries.dart';
import 'package:bibliasacra/langs/bookLists.dart';
import 'package:bibliasacra/main/mainPage.dart';
import 'package:bibliasacra/main/searchAreas.dart';
import 'package:bibliasacra/utils/sharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

DbQueries _dbQueries = DbQueries();
SharedPrefs sharedPrefs = SharedPrefs();
BookLists bookLists = BookLists();

Future<List<Bible>> blankSearch;
Future<List<Bible>> filteredSearch;
Future<List<Bible>> results;

String _contents = '';

MaterialColor primarySwatch;

class MainSearch extends StatefulWidget {
  const MainSearch({Key key}) : super(key: key);

  @override
  State<MainSearch> createState() => _MainSearchState();
}

class _MainSearchState extends State<MainSearch> {
  @override
  initState() {
    Globals.scrollToVerse = false;
    blankSearch = Future.value([]);
    filteredSearch = blankSearch;
    primarySwatch = BlocProvider.of<PaletteCubit>(context).state;
    super.initState();
  }

  void runFilter(String enterdKeyWord) {
    //int k = await sharedPrefs.readSearchAreaKey();
    int k = BlocProvider.of<SearchCubit>(context).state;

    String sec = ereasSections[k];
    var arr = sec.split('|');

    enterdKeyWord.isEmpty
        ? results = blankSearch
        : results = _dbQueries.getSearchedValues(enterdKeyWord, arr[0], arr[1]);

    // Refresh the UI
    setState(
      () {
        filteredSearch = results;
      },
    );
  }

// MaterialColor getMaterialColor(Color color) => Colors.primaries
//   .firstWhere((element) => element.value == color.value);

  backButton(BuildContext context) {
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
        );
      },
    );
  }

  onSearchTap(WriteVarsModel model) {
    Globals.scrollToVerse = true;
    Globals.initialScroll = true;
    writeVars(model).then((value) {
      backButton(context);
    });
  }

  // backPopButton(BuildContext context) {
  //   Future.delayed(
  //     const Duration(milliseconds: 300),
  //     () {
  //       Navigator.pop(context);
  //     },
  //   );
  // }

  Future emptyInputDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Empty Input!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const [
                Text('Please enter some text.'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget searchWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextFormField(
            initialValue: '',
            maxLength: 40,
            maxLines: 1,
            autofocus: false,
            onTap: () {
              filteredSearch = Future.value([]);
            },
            onChanged: (value) {
              _contents = value;
            },
            decoration: InputDecoration(
              labelText: 'Search',
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Future.delayed(
                    const Duration(milliseconds: 300),
                    () {
                      _contents.isEmpty
                          ? emptyInputDialog(context)
                          : runFilter(_contents);
                    },
                  );
                },
              ),
            ),
          ),
          // const SizedBox(
          //   height: 20,
          // ),
          Expanded(
            child: FutureBuilder<List<Bible>>(
              future: filteredSearch,
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.separated(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return listTileMethod(snapshot, index);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  RichText highLiteSearchWord(String t, String m) {
    int idx = t.toLowerCase().indexOf(m.toLowerCase());

    if (idx != -1) {
      // String firstPart = t.substring(0, idx);
      // String middlPart = t.substring(idx, idx + m.length);
      // String lastPart = t.substring(idx + m.length); // to the end

      return RichText(
        //softWrap: true,
        text: TextSpan(
          text: t.substring(0, idx),
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: t.substring(idx, idx + m.length),
              style: TextStyle(
                fontSize: 16.0,
                //fontWeight: FontWeight.bold,
                backgroundColor: primarySwatch[50],
              ),
            ),
            TextSpan(
              text: t.substring(idx + m.length),
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
    } else {
      return RichText(
        //softWrap: true,
        text: TextSpan(
          text: t,
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
        ),
      );
    }
  }

  ListTile listTileMethod(AsyncSnapshot<List<Bible>> snapshot, int index) {
    String bookName = bookLists.getBookByNumber(
        snapshot.data[index].b, Globals.bibleLang); // 0 - 66
    return ListTile(
      title: Text(
        "$bookName ${snapshot.data[index].c}:${snapshot.data[index].v}",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: highLiteSearchWord(snapshot.data[index].t, _contents),
      onTap: () {
        //Globals.scrollToVerse = Globals.initialScroll = true;

        BlocProvider.of<ChapterCubit>(context)
            .setChapter(snapshot.data[index].c);

        final model = WriteVarsModel(
          lang: Globals.bibleLang,
          version: Globals.bibleVersion,
          abbr: Globals.versionAbbr,
          book: snapshot.data[index].b,
          chapter: snapshot.data[index].c,
          verse: snapshot.data[index].v,
          name: bookName,
        );
        onSearchTap(model);
      },
    );
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: primarySwatch[700],
            // centerTitle: true,
            // elevation: 16,
            actions: [
              Row(
                children: [
                  BlocBuilder<SearchCubit, int>(
                    builder: (context, area) {
                      return Text(
                        ereasList[area],
                        style: const TextStyle(fontSize: 16),
                      );
                    },
                  ),
                  const SizedBox(
                    width: 56,
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      searchAreasDialog(context);
                    },
                  )
                ],
              )
            ],
          ),
          body: searchWidget(),
        ),
      );
}
