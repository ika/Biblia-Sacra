import 'package:bibliasacra/cubit/cub_chapters.dart';
import 'package:bibliasacra/cubit/cub_textsize.dart';
import 'package:bibliasacra/globals/globs_main.dart';
import 'package:bibliasacra/langs/lang_booklists.dart';
import 'package:bibliasacra/main/db_queries.dart';
import 'package:bibliasacra/main/main_page.dart';
import 'package:bibliasacra/utils/utils_sharedprefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

DbQueries dbQueries = DbQueries();
SharedPrefs sharedPrefs = SharedPrefs();
BookLists bookLists = BookLists();
double? primaryTextSize;

var allBooks = {};
var filteredBooks = {};
var results = {};
List<String> tabNames = ['Books', 'Chapters', 'Verses'];

class MainSelector extends StatefulWidget {
  const MainSelector({Key? key}) : super(key: key);

  @override
  State<MainSelector> createState() => _MainSelectorState();
}

class _MainSelectorState extends State<MainSelector>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  initState() {
    super.initState();
    Globals.chapterVerse = 0;
    Globals.selectorText = "${Globals.bookName}: ${Globals.bookChapter}:1";
    primaryTextSize = BlocProvider.of<TextSizeCubit>(context).state;
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
    Future.delayed(
      Duration(milliseconds: Globals.navigatorDelay),
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
                snapshot.data!,
                (index) {
                  int verse = index + 1;
                  return Center(
                    child: GestureDetector(
                      onTap: () {
                        Globals.scrollToVerse = true;
                        Globals.chapterVerse = index;
                        backButton(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(5),
                          shape: BoxShape.rectangle,
                          boxShadow: [
                            BoxShadow(
                                // Bottom right
                                color: Colors.grey.shade600,
                                offset: const Offset(3, 3),
                                blurRadius: 5,
                                spreadRadius: 1),
                            const BoxShadow(
                                // Top left
                                color: Colors.white,
                                offset: Offset(-3, -3),
                                blurRadius: 5,
                                spreadRadius: 1)
                          ],
                        ),
                        child: Text(
                          verse.toString(),
                          style: TextStyle(fontSize: primaryTextSize),
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
                snapshot.data!,
                (index) {
                  int chap = index + 1;
                  return Center(
                    child: GestureDetector(
                      onTap: () {
                        Globals.bookChapter = chap;
                        Globals.selectorText = "${Globals.bookName}: $chap:1";
                        sharedPrefs.setIntPref('chapter', chap).then((value) {
                          BlocProvider.of<ChapterCubit>(context)
                              .setChapter(chap);
                          tabController!.animateTo(2);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(5),
                          shape: BoxShape.rectangle,
                          boxShadow: [
                            BoxShadow(
                                // Bottom right
                                color: Colors.grey.shade600,
                                offset: const Offset(3, 3),
                                blurRadius: 5,
                                spreadRadius: 1),
                            const BoxShadow(
                                // Top left
                                color: Colors.white,
                                offset: Offset(-3, -3),
                                blurRadius: 5,
                                spreadRadius: 1)
                          ],
                        ),
                        child: Text(
                          chap.toString(),
                          style: TextStyle(fontSize: primaryTextSize),
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
                  Globals.bibleBook = book;
                  Globals.bookChapter = 1;
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
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        leading: GestureDetector(
          child: const Icon(Globals.backArrow),
          onTap: () {
            backButton(context);
          },
        ),
        elevation: 0.1,
        title: Text(
          Globals.selectorText,
          style: TextStyle(fontSize: Globals.appBarFontSize),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: tabController,
          tabs: [
            Tab(
                child: Text(tabNames[0],
                    style: TextStyle(fontSize: primaryTextSize))),
            Tab(
                child: Text(tabNames[1],
                    style: TextStyle(fontSize: primaryTextSize))),
            Tab(
                child: Text(tabNames[2],
                    style: TextStyle(fontSize: primaryTextSize))),
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
