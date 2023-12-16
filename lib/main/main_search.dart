import 'dart:async';

import 'package:bibliasacra/cubit/cub_chapters.dart';
import 'package:bibliasacra/cubit/cub_search.dart';
import 'package:bibliasacra/globals/globs_main.dart';
import 'package:bibliasacra/globals/globs_write.dart';
import 'package:bibliasacra/main/db_model.dart';
import 'package:bibliasacra/main/db_queries.dart';
import 'package:bibliasacra/langs/lang_booklists.dart';
import 'package:bibliasacra/main/main_versmenu.dart';
import 'package:bibliasacra/main/search_areas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bibliasacra/utils/utils_snackbars.dart';

DbQueries _dbQueries = DbQueries();
BookLists bookLists = BookLists();

Future<List<Bible>>? blankSearch;
Future<List<Bible>>? filteredSearch;
Future<List<Bible>>? results;

String _contents = '';

double? primaryTextSize;

class MainSearch extends StatefulWidget {
  const MainSearch({super.key});

  @override
  State<MainSearch> createState() => _MainSearchState();
}

class _MainSearchState extends State<MainSearch> {
  @override
  initState() {
    blankSearch = Future.value([]);
    filteredSearch = blankSearch;
    // primarySwatch =
    //     BlocProvider.of<SettingsCubit>(context).state.themeData.primaryColor as MaterialColor?;
    primaryTextSize = Globals.initialTextSize;
    super.initState();
  }

  void runFilter(String enterdKeyWord) {
    int k = BlocProvider.of<SearchCubit>(context).state;

    String sec = areasSections[k];
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

  backButton(BuildContext context) {
    Future.delayed(
      Duration(milliseconds: Globals.navigatorDelay),
      () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const MainPage(),
        //   ),
        // );
        Navigator.of(context).pushNamed('/MainPage');
      },
    );
  }

  onSearchTap(WriteVarsModel model) {
    writeVars(model).then((value) {
      backButton(context);
    });
  }

  Future emptyInputDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Empty Input!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
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
      padding: const EdgeInsets.all(20.0),
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
              labelStyle: TextStyle(fontSize: primaryTextSize),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Future.delayed(
                    Duration(milliseconds: Globals.navigatorDelay),
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
                    itemCount: snapshot.data!.length,
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
      return RichText(
        //softWrap: true,
        text: TextSpan(
          text: t.substring(0, idx),
          style: TextStyle(
            fontSize: primaryTextSize,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: t.substring(idx, idx + m.length),
              style: TextStyle(
                fontSize: primaryTextSize,
                //backgroundColor: primarySwatch![100],
              ),
            ),
            TextSpan(
              text: t.substring(idx + m.length),
              style: TextStyle(
                fontSize: primaryTextSize,
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
          style: TextStyle(
            fontSize: primaryTextSize,
            color: Colors.black,
          ),
        ),
      );
    }
  }

  ListTile listTileMethod(AsyncSnapshot<List<Bible>> snapshot, int index) {
    bool emptySearchResult = (snapshot.data![index].b == 0) ? true : false;
    String bookName = (!emptySearchResult)
        ? bookLists.getBookByNumber(snapshot.data![index].b!, Globals.bibleLang)
        : '';
    return ListTile(
      title: Text(
        (!emptySearchResult)
            ? "$bookName ${snapshot.data![index].c!}:${snapshot.data![index].v!}"
            : snapshot.data![index].t!,
        style:
            TextStyle(fontWeight: FontWeight.bold, fontSize: primaryTextSize),
      ),
      subtitle: (!emptySearchResult)
          ? highLiteSearchWord(snapshot.data![index].t!, _contents)
          : Container(),
      onTap: () {
        BlocProvider.of<ChapterCubit>(context)
            .setChapter(snapshot.data![index].c!);

        final model = WriteVarsModel(
          lang: Globals.bibleLang,
          version: Globals.bibleVersion,
          abbr: Globals.versionAbbr,
          book: snapshot.data![index].b,
          chapter: snapshot.data![index].c,
          verse: snapshot.data![index].v,
          name: bookName,
        );
        onSearchTap(model);
      },
    );
  }

  void showVersionsDialog(BuildContext context) {
    (Globals.activeVersionCount! > 1)
        ? versionsDialog(context, 'search').then((value) {
            setState(() {});
          })
        : ScaffoldMessenger.of(context).showSnackBar(moreVersionsSnackBar);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            leading: GestureDetector(
              child: const Icon(Globals.backArrow),
              onTap: () {
                backButton(context);
              },
            ),
            actions: [
              Row(
                children: [
                  BlocBuilder<SearchCubit, int>(
                    builder: (context, area) {
                      return Text(
                        areasList[area],
                        // style: TextStyle(fontSize: Globals.appBarFontSize),
                      );
                    },
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    Globals.versionAbbr,
                    // style: TextStyle(fontSize: Globals.appBarFontSize),
                  ),
                  const SizedBox(
                    width: 16,
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
