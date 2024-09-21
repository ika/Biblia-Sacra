import 'dart:async';

import 'package:bibliasacra/bloc/bloc_book.dart';
import 'package:bibliasacra/bloc/bloc_chapters.dart';
import 'package:bibliasacra/bloc/bloc_search.dart';
import 'package:bibliasacra/bloc/bloc_verse.dart';
import 'package:bibliasacra/bloc/bloc_version.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/main/main_model.dart';
import 'package:bibliasacra/main/main_queries.dart';
import 'package:bibliasacra/langs/lang_booklists.dart';
import 'package:bibliasacra/main/main_page.dart';
import 'package:bibliasacra/main/main_versmenu.dart';
import 'package:bibliasacra/main/search_areas.dart';
import 'package:bibliasacra/utils/utils_utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bibliasacra/utils/utils_snackbars.dart';

// main_search.dart

Future<List<Bible>>? blankSearch;
Future<List<Bible>>? filteredSearch;
Future<List<Bible>>? results;

String _contents = '';

late String bibleLang;
late String versionAbbr;

class MainSearch extends StatefulWidget {
  const MainSearch({super.key});

  @override
  State<MainSearch> createState() => _MainSearchState();
}

class _MainSearchState extends State<MainSearch> {
  @override
  initState() {
    super.initState();
    blankSearch = Future.value([]);
    filteredSearch = blankSearch;

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        bibleVersion = context.read<VersionBloc>().state;
        bibleLang = Utilities(bibleVersion).getLanguage();
      },
    );
  }

  Future<void> runFilter(String enterdKeyWord) async {
    int? k = context.read<SearchBloc>().state;

    enterdKeyWord = " $enterdKeyWord"; // add leading space

    String sec = areasSections[k];
    var arr = sec.split('|');

    enterdKeyWord.isEmpty
        ? results = blankSearch
        : results = DbQueries(bibleVersion)
            .getSearchedValues(enterdKeyWord, arr[0], arr[1]);

    // Refresh the UI
    setState(
      () {
        filteredSearch = results;
      },
    );
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
                Text('Please enter a search text!'),
              ],
            ),
          ),
        );
      },
    );
  }

  RichText highLiteSearchWord(String t, String m) {
    int idx = t.toLowerCase().indexOf(m.toLowerCase());

    if (idx != -1) {
      return RichText(
        //softWrap: true,
        text: TextSpan(
          text: t.substring(0, idx),
          style: Theme.of(context).textTheme.bodyMedium,
          // style: TextStyle(
          //   color: Theme.of(context).colorScheme.primary,
          // ),
          children: [
            TextSpan(
              text: t.substring(idx, idx + m.length),
              //style: Theme.of(context).textTheme.bodyMedium,
              style: TextStyle(
                //fontWeight: FontWeight.w700
                //color: Theme.of(context).colorScheme.primary
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
              ),
            ),
            TextSpan(
              text: t.substring(idx + m.length),
              style: Theme.of(context).textTheme.bodyMedium,
              //style: TextStyle(color: Theme.of(context).colorScheme.primary),
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
            //fontSize: primaryTextSize,
            color: Colors.black,
          ),
        ),
      );
    }
  }

  ListTile listTileMethod(AsyncSnapshot<List<Bible>> snapshot, int index) {
    bool emptySearchResult = (snapshot.data![index].b == 0) ? true : false;
    String bookName = (!emptySearchResult)
        ? BookLists().getBookByNumber(snapshot.data![index].b!, bibleLang)
        : '';
    return ListTile(
      title: Text(
        (!emptySearchResult)
            ? "$bookName ${snapshot.data![index].c!}:${snapshot.data![index].v!}"
            : snapshot.data![index].t!,
        // style:
        //     TextStyle(fontWeight: FontWeight.bold, fontSize: primaryTextSize),
      ),
      subtitle: (!emptySearchResult)
          ? highLiteSearchWord(snapshot.data![index].t!, _contents)
          : Container(),
      onTap: () {
        // Book
        context
            .read<BookBloc>()
            .add(UpdateBook(book: snapshot.data![index].b!));

        // Chapter
        context
            .read<ChapterBloc>()
            .add(UpdateChapter(chapter: snapshot.data![index].c!));

        // Verse
        context
            .read<VerseBloc>()
            .add(UpdateVerse(verse: snapshot.data![index].v!));

        Route route = MaterialPageRoute(
          builder: (context) => const MainPage(),
        );
        Future.delayed(
          Duration(milliseconds: Globals.navigatorDelay),
          () {
            Navigator.push(context, route);
          },
        );
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
  Widget build(BuildContext context) {
    versionAbbr = Utilities(bibleVersion).getVersionAbbr();
    return PopScope(
      canPop: false,
      child: Scaffold(
        //backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          centerTitle: true,
          elevation: 5,
          leading: GestureDetector(
            child: const Icon(Globals.backArrow),
            onTap: () {
              Future.delayed(
                Duration(milliseconds: Globals.navigatorDelay),
                () {
                  Navigator.of(context).pop();
                },
              );
            },
          ),
          // title: Text("${Globals.areaSearchTitle} - ${Globals.versionAbbr}"
          //     //style: TextStyle(fontSize: Globals.appBarFontSize),
          //     ),
          title: BlocBuilder<SearchBloc, int>(
            builder: (context, state) {
              return Text(
                "${areasList[state]} - $versionAbbr",
                style: const TextStyle(fontWeight: FontWeight.w700),
              );
            },
          ),
          actions: [
            Row(
              children: [
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
        body: Container(
          padding: const EdgeInsets.all(50.0),
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
                  //labelStyle: TextStyle(fontSize: primaryTextSize),
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
        ),
      ),
    );
  }
}
