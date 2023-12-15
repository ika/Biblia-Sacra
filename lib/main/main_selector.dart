import 'package:bibliasacra/cubit/cub_chapters.dart';
import 'package:bibliasacra/globals/globs_main.dart';
import 'package:bibliasacra/langs/lang_booklists.dart';
import 'package:bibliasacra/main/db_queries.dart';
import 'package:bibliasacra/main/main_page.dart';
import 'package:bibliasacra/utils/utils_sharedprefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';

DbQueries dbQueries = DbQueries();
SharedPrefs sharedPrefs = SharedPrefs();
BookLists bookLists = BookLists();
double? primaryTextSize;

var allBooks = {};
var filteredBooks = {};
var results = {};
List<String> tabNames = ['Books', 'Chapters', 'Verses'];

int _currentChapterValue = Globals.bookChapter;
int _currentVerseValue = Globals.chapterVerse;

// // Chapter
// sharedPrefs.getIntPref('chapter').then((c) {
//   _currentChapterValue = c ?? 0;
// });

// // Verse
// sharedPrefs.getIntPref('verse').then((v) {
//   _currentVerseValue = v ?? 0;
// });

class MainSelector extends StatefulWidget {
  const MainSelector({super.key});

  @override
  State<MainSelector> createState() => _MainSelectorState();
}

class _MainSelectorState extends State<MainSelector>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  initState() {
    super.initState();

    // _currentChapterValue = Globals.bookChapter;
    // _currentVerseValue = Globals.chapterVerse;

    primaryTextSize = Globals.initialTextSize;
    allBooks = bookLists.getBookListByLang(Globals.bibleLang);
    filteredBooks = allBooks;

    tabController = TabController(length: 3, vsync: this);
    tabController!.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  void runFilter(String keyWord) {
    (keyWord.isEmpty)
        ? results = allBooks
        : results = bookLists.searchList(keyWord, Globals.bibleLang);

    setState(() {
      filteredBooks = results;
    });
  }

  backButton(BuildContext context) {
    // update Chapter
    Globals.bookChapter = _currentChapterValue;
    sharedPrefs.setIntPref('chapter', _currentChapterValue).then((v) {
      BlocProvider.of<ChapterCubit>(context).setChapter(_currentChapterValue);

      // upate Verse
      //_currentVerseValue -= 1; // scroller starts with 0

      Globals.chapterVerse = _currentVerseValue;
      sharedPrefs.setIntPref('verse', _currentVerseValue).then((v) {
        Future.delayed(
          Duration(milliseconds: Globals.navigatorDelay),
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MainPage(),
              ),
            );
            // Navigator.of(context).pushNamed('/MainPage':
            //arguments: MainPageArgs(_currentChapterValue, _currentVerseValue));
          },
        );
      });
    });
  }

  // Widget versesWidget() {
  //   return Container(
  //     padding: const EdgeInsets.all(20.0),
  //     child: FutureBuilder<int>(
  //       future: dbQueries.getVerseCount(Globals.bibleBook, Globals.bookChapter),
  //       builder: (context, snapshot) {
  //         if (snapshot.hasData) {
  //           return GridView.count(
  //             crossAxisCount: 5,
  //             children: List.generate(
  //               snapshot.data!,
  //               (index) {
  //                 int verse = index + 1;
  //                 return Center(
  //                   child: GestureDetector(
  //                     onTap: () {
  //                       Globals.chapterVerse = index;
  //                       backButton(context);
  //                     },
  //                     child: Container(
  //                       padding: const EdgeInsets.all(15),
  //                       decoration: BoxDecoration(
  //                         color: Colors.grey[300],
  //                         borderRadius: BorderRadius.circular(5),
  //                         shape: BoxShape.rectangle,
  //                         boxShadow: [
  //                           BoxShadow(
  //                               // Bottom right
  //                               color: Colors.grey.shade600,
  //                               offset: const Offset(3, 3),
  //                               blurRadius: 5,
  //                               spreadRadius: 1),
  //                           const BoxShadow(
  //                               // Top left
  //                               color: Colors.white,
  //                               offset: Offset(-3, -3),
  //                               blurRadius: 5,
  //                               spreadRadius: 1)
  //                         ],
  //                       ),
  //                       child: Text(
  //                         verse.toString(),
  //                         style: TextStyle(fontSize: primaryTextSize),
  //                       ),
  //                     ),
  //                   ),
  //                 );
  //               },
  //             ),
  //           );
  //         }
  //         return const Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       },
  //     ),
  //   );
  // }

  // Widget chaptersWidget() {
  //   return Container(
  //     padding: const EdgeInsets.all(20.0),
  //     child: FutureBuilder<int>(
  //       future: dbQueries.getChapterCount(Globals.bibleBook),
  //       builder: (context, snapshot) {
  //         if (snapshot.hasData) {
  //           return GridView.count(
  //             crossAxisCount: 5,
  //             children: List.generate(
  //               snapshot.data!,
  //               (index) {
  //                 int chap = index + 1;
  //                 return Center(
  //                   child: GestureDetector(
  //                     onTap: () {
  //                       Globals.bookChapter = chap;
  //                       Globals.selectorText = "${Globals.bookName}: $chap:1";
  //                       sharedPrefs.setIntPref('chapter', chap).then((value) {
  //                         BlocProvider.of<ChapterCubit>(context)
  //                             .setChapter(chap);
  //                         tabController!.animateTo(2);
  //                       });
  //                     },
  //                     child: Container(
  //                       padding: const EdgeInsets.all(15),
  //                       decoration: BoxDecoration(
  //                         color: Colors.grey[300],
  //                         borderRadius: BorderRadius.circular(5),
  //                         shape: BoxShape.rectangle,
  //                         boxShadow: [
  //                           BoxShadow(
  //                               // Bottom right
  //                               color: Colors.grey.shade600,
  //                               offset: const Offset(3, 3),
  //                               blurRadius: 5,
  //                               spreadRadius: 1),
  //                           const BoxShadow(
  //                               // Top left
  //                               color: Colors.white,
  //                               offset: Offset(-3, -3),
  //                               blurRadius: 5,
  //                               spreadRadius: 1)
  //                         ],
  //                       ),
  //                       child: Text(
  //                         chap.toString(),
  //                         style: TextStyle(fontSize: primaryTextSize),
  //                       ),
  //                     ),
  //                   ),
  //                 );
  //               },
  //             ),
  //           );
  //         }
  //         return const Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget versesWidget() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: FutureBuilder<int>(
        future:
            dbQueries.getVerseCount(Globals.bibleBook, _currentChapterValue),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            int lastVerse = snapshot.data!.toInt();
            return Column(
              children: <Widget>[
                const SizedBox(height: 32),
                Text("Verses 1 - $lastVerse",
                    style: Theme.of(context).textTheme.bodyMedium),
                NumberPicker(
                  value: _currentVerseValue,
                  minValue: 1,
                  maxValue: lastVerse,
                  step: 1,
                  itemHeight: 100,
                  axis: Axis.horizontal,
                  onChanged: (value) {
                    setState(() {
                      _currentVerseValue = value;
                    });
                  },
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget chaptersWidget() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: FutureBuilder<int>(
        future: dbQueries.getChapterCount(Globals.bibleBook),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            int lastChapter = snapshot.data!.toInt();
            return Column(
              children: [
                const SizedBox(height: 32),
                Text("Chapters 1 - $lastChapter",
                    style: Theme.of(context).textTheme.bodyMedium),
                NumberPicker(
                  value: _currentChapterValue,
                  minValue: 1,
                  maxValue: lastChapter,
                  step: 1,
                  itemHeight: 100,
                  axis: Axis.horizontal,
                  onChanged: (value) {
                    setState(() {
                      _currentChapterValue = value;
                      _currentVerseValue = 1;
                    });
                  },
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget booksWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            onChanged: (value) => runFilter(value),
            decoration: InputDecoration(
              labelText: 'Search',
              labelStyle: TextStyle(fontSize: primaryTextSize),
              suffixIcon: const Icon(Icons.search),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filteredBooks.length,
              itemBuilder: (context, int index) {
                int key = filteredBooks.keys.elementAt(index);
                return ListTile(
                  title: Text(
                    filteredBooks[key],
                    //style: TextStyle(fontSize: primaryTextSize),
                  ),
                  onTap: () {
                    int book = key + 1;
                    Globals.bibleBook = book;
                    //Globals.bookChapter = 1;
                    sharedPrefs.setIntPref('book', book).then(
                      (value) {
                        bookLists.writeBookName(book).then(
                          (value) {
                            sharedPrefs.setIntPref('chapter', 1).then(
                              (value) {
                                BlocProvider.of<ChapterCubit>(context)
                                    .setChapter(1);
                                tabController!.animateTo(1);
                              },
                            );
                          },
                        );
                      },
                    );
                    FocusScope.of(context).requestFocus(FocusNode());
                    filteredBooks = allBooks; // restore full list
                  },
                  trailing: Icon(
                    Icons.arrow_right,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.primary,
        leading: GestureDetector(
          child: const Icon(Globals.backArrow),
          onTap: () {
            backButton(context);
          },
        ),
        title: Text(
            //Globals.selectorText,
            //style: TextStyle(fontSize: Globals.appBarFontSize),
            "${Globals.bookName} $_currentChapterValue : $_currentVerseValue"),
        bottom: TabBar(
          controller: tabController,
          tabs: [
            Tab(
              child: Text(
                tabNames[0],
                // style: TextStyle(fontSize: primaryTextSize),
              ),
            ),
            Tab(
              child: Text(
                tabNames[1],
                //style: TextStyle(fontSize: primaryTextSize),
              ),
            ),
            Tab(
              child: Text(
                tabNames[2],
                //style: TextStyle(fontSize: primaryTextSize),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          Center(
            child: booksWidget(),
          ),
          Center(
            child: chaptersWidget(),
          ),
          Center(
            child: versesWidget(),
          ),
        ],
      ),
    );
  }
}
