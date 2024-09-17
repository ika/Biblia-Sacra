import 'dart:ui';

import 'package:bibliasacra/bloc/bloc_book.dart';
import 'package:bibliasacra/bloc/bloc_chapters.dart';
import 'package:bibliasacra/bloc/bloc_verse.dart';
import 'package:bibliasacra/bloc/bloc_version.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/langs/lang_booklists.dart';
import 'package:bibliasacra/main/main_queries.dart';
import 'package:bibliasacra/main/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';

late DbQueries dbQueries;
BookLists bookLists = BookLists();
late int bibleBook;
late String bookName;

var allBooks = {};
var filteredBooks = {};
var results = {};
List<String> tabNames = ['Books', 'Chapters', 'Verses'];

late int _currentChapterValue;
late int _currentVerseValue;

class MainSelector extends StatefulWidget {
  const MainSelector({super.key, required this.bibleLang});
  final String bibleLang;

  @override
  State<MainSelector> createState() => _MainSelectorState();
}

class _MainSelectorState extends State<MainSelector>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  initState() {
    super.initState();

    //_currentChapterValue = Globals.bibleBookChapter;
    //_currentVerseValue = Globals.chapterVerse;

    //primaryTextSize = Globals.initialTextSize;
    allBooks = bookLists.getBookListByLang(widget.bibleLang);
    filteredBooks = allBooks;

    tabController = TabController(length: 3, vsync: this);
    tabController!.addListener(() {
      setState(() {});
    });

    // WidgetsBinding.instance.addPostFrameCallback(
    //   (_) {
    //     //bibleBook = context.read<BookBloc>().state.book;
    //     //bibleVersion = context.read<VersionBloc>().state.bibleVersion;
    //     //dbQueries = DbQueries(bibleVersion);
    //   },
    // );
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  void runFilter(String keyWord) {
    (keyWord.isEmpty)
        ? results = allBooks
        : results = bookLists.searchList(keyWord, widget.bibleLang);

    setState(() {
      filteredBooks = results;
    });
  }

  Widget versesWidget() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: FutureBuilder<int>(
        future: dbQueries.getVerseCount(bibleBook, _currentChapterValue),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            int lastVerse = snapshot.data!.toInt();
            return Column(
              children: <Widget>[
                const SizedBox(height: 32),
                Text("Verses 1 - $lastVerse",
                    style: Theme.of(context).textTheme.bodyMedium),
                ScrollConfiguration(
                  behavior:
                      ScrollConfiguration.of(context).copyWith(dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  }),
                  child: NumberPicker(
                    value: _currentVerseValue,
                    minValue: 1,
                    maxValue: lastVerse,
                    step: 1,
                    itemHeight: 100,
                    axis: Axis.horizontal,
                    onChanged: (value) {
                      context.read<VerseBloc>().add(UpdateVerse(verse: value));
                      setState(() {
                        _currentVerseValue = value;
                      });
                    },
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2.0),
                    ),
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
        future: dbQueries.getChapterCount(bibleBook),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            int lastChapter = snapshot.data!.toInt();
            return Column(
              children: [
                const SizedBox(height: 32),
                Text("Chapters 1 - $lastChapter",
                    style: Theme.of(context).textTheme.bodyMedium),
                ScrollConfiguration(
                  behavior:
                      ScrollConfiguration.of(context).copyWith(dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  }),
                  child: NumberPicker(
                    value: _currentChapterValue,
                    minValue: 1,
                    maxValue: lastChapter,
                    step: 1,
                    itemHeight: 100,
                    axis: Axis.horizontal,
                    haptics: true,
                    onChanged: (value) {
                      setState(() {
                        _currentChapterValue = value;
                        _currentVerseValue = 1;
                      });
                      context
                          .read<ChapterBloc>()
                          .add(UpdateChapter(chapter: value));
                    },
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2.0),
                    ),
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
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TextField(
            onChanged: (value) => runFilter(value),
            decoration: const InputDecoration(
              labelText: 'Search',
              //labelStyle: TextStyle(fontSize: primaryTextSize),
              suffixIcon: Icon(Icons.search),
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
                    //debugPrint("filteredBooks ${filteredBooks.keys.elementAt(index) +1}");
                    context.read<BookBloc>().add(UpdateBook(book: key + 1));

                    context.read<ChapterBloc>().add(UpdateChapter(chapter: 1));

                    context.read<VerseBloc>().add(UpdateVerse(verse: 1));

                    setState(() {
                      _currentChapterValue = _currentVerseValue = 1;
                    });

                    FocusScope.of(context).requestFocus(FocusNode());
                    filteredBooks = allBooks; // restore full list

                    Future.delayed(
                      Duration(milliseconds: Globals.navigatorDelay),
                      () {
                        //debugPrint("BOOKBLOC STATE ${context.read<BookBloc>().state}");
                        tabController!.animateTo(1);
                      },
                    );
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
    bibleBook = context.read<BookBloc>().state;
    bibleVersion = context.read<VersionBloc>().state;
    bookName = BookLists().readBookName(bibleBook, bibleVersion);

    dbQueries = DbQueries(bibleVersion);

    _currentChapterValue = context.read<ChapterBloc>().state;
    _currentVerseValue = context.read<VerseBloc>().state;

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
          ),
          title: Text(
              "$bookName: $_currentChapterValue : $_currentVerseValue", style: const TextStyle(fontWeight: FontWeight.w700),),
          bottom: TabBar(
            controller: tabController,
            //labelStyle: Theme.of(context).tabBarTheme.labelStyle?.copyWith(color: Colors.white),
            tabs: [
              Tab(
                child: Text(
                  tabNames[0],
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Tab(
                child: Text(
                  tabNames[1],
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Tab(
                child: Text(
                  tabNames[2],
                  style: const TextStyle(fontWeight: FontWeight.w700),
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
      ),
    );
  }
}
