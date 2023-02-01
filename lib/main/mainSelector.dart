import 'package:bibliasacra/cubit/chaptersCubit.dart';
import 'package:bibliasacra/cubit/textSizeCubit.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/langs/bookLists.dart';
import 'package:bibliasacra/main/dbQueries.dart';
import 'package:bibliasacra/main/mainPage.dart';
import 'package:bibliasacra/utils/sharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

DbQueries dbQueries = DbQueries();
SharedPrefs sharedPrefs = SharedPrefs();
BookLists bookLists = BookLists();
double primaryTextSize;

var allBooks = {};
var filteredBooks = {};
var results = {};
List<String> tabNames = ['Books', 'Chapters', 'Verses'];

class MainSelector extends StatefulWidget {
  const MainSelector({Key key}) : super(key: key);

  @override
  State<MainSelector> createState() => _MainSelectorState();
}

class _MainSelectorState extends State<MainSelector>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  initState() {
    super.initState();
    Globals.chapterVerse = 0;
    Globals.selectorText = "${Globals.bookName}: ${Globals.bookChapter}:1";
    primaryTextSize = BlocProvider.of<TextSizeCubit>(context).state;
    allBooks = bookLists.getBookListByLang(Globals.bibleLang);
    filteredBooks = allBooks;

    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    tabController.dispose();
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MainPage(),
      ),
    );
  }

  Widget versesWidget() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: FutureBuilder<int>(
        future: dbQueries.getVerseCount(Globals.bibleBook, Globals.bookChapter),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.count(
              crossAxisCount: 5,
              children: List.generate(
                snapshot.data,
                (index) {
                  int verse = index + 1;
                  return Center(
                    child: GestureDetector(
                      onTap: () {
                        Globals.chapterVerse = index;
                        backButton(context);
                      },
                      child: SizedBox(
                        width: 40.0,
                        height: 40.0,
                        child: FittedBox(
                          fit: BoxFit.none,
                          child: Text(
                            '$verse',
                            style: TextStyle(fontSize: primaryTextSize),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
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
            return GridView.count(
              crossAxisCount: 5,
              children: List.generate(
                snapshot.data,
                (index) {
                  int chap = index + 1;
                  return Center(
                    child: GestureDetector(
                      onTap: () {
                        // save chapter
                        sharedPrefs.saveChapter(chap).then(
                          (value) {
                            Globals.bookChapter = chap;
                            BlocProvider.of<ChapterCubit>(context)
                                .setChapter(chap);
                            Globals.selectorText =
                                "${Globals.bookName}: $chap:1";
                            tabController.animateTo(2);
                          },
                        );
                      },
                      child: SizedBox(
                        width: 40.0,
                        height: 40.0,
                        child: FittedBox(
                          fit: BoxFit.none,
                          child: Text(
                            '$chap',
                            style: TextStyle(fontSize: primaryTextSize),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
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
                suffixIcon: const Icon(Icons.search)),
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
                  style: TextStyle(fontSize: primaryTextSize),
                ),
                onTap: () {
                  int book = key + 1;
                  // save book
                  sharedPrefs.saveBook(book).then(
                    (value) {
                      Globals.bibleBook = book;
                      sharedPrefs.writeBookName(book).then(
                        // book number =1 and list number = 0
                        (value) {
                          // see also Globals.selectorText
                          sharedPrefs.saveChapter(1).then(
                            (value) {
                              Globals.bookChapter = 1;
                              BlocProvider.of<ChapterCubit>(context)
                                  .setChapter(1);
                              tabController.animateTo(1);
                            },
                          );
                        },
                      );
                    },
                  );
                  FocusScope.of(context).requestFocus(FocusNode());
                  filteredBooks = allBooks; // restore full list
                },
                trailing: const Icon(Icons.arrow_right),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(height: 2.0),
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => backButton(context),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.1,
          title: Text(
            Globals.selectorText,
            style: const TextStyle(fontSize: 20.0),
          ),
          centerTitle: true,
          bottom: TabBar(
            controller: tabController,
            tabs: [
              Tab(
                  child: Text(tabNames[0],
                      style: const TextStyle(fontSize: 18.0))),
              Tab(
                  child: Text(tabNames[1],
                      style: const TextStyle(fontSize: 18.0))),
              Tab(
                  child: Text(tabNames[2],
                      style: const TextStyle(fontSize: 18.0))),
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
