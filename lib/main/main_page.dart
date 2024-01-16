import 'dart:async';
import 'dart:ui';
import 'package:bibliasacra/bloc/bloc_book.dart';
import 'package:bibliasacra/bloc/bloc_font.dart';
import 'package:bibliasacra/bloc/bloc_verse.dart';
import 'package:bibliasacra/bloc/bloc_version.dart';
import 'package:bibliasacra/bmarks/bm_model.dart';
import 'package:bibliasacra/bmarks/bm_page.dart';
import 'package:bibliasacra/bmarks/bm_queries.dart';
import 'package:bibliasacra/bloc/bloc_chapters.dart';
import 'package:bibliasacra/dict/dict_page.dart';
import 'package:bibliasacra/fonts/fonts.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/high/hi_page.dart';
import 'package:bibliasacra/high/hl_model.dart';
import 'package:bibliasacra/high/hl_queries.dart';
import 'package:bibliasacra/langs/lang_booklists.dart';
import 'package:bibliasacra/main/db_model.dart';
import 'package:bibliasacra/main/db_queries.dart';
import 'package:bibliasacra/main/main_compage.dart';
import 'package:bibliasacra/main/main_dict.dart';
import 'package:bibliasacra/main/main_search.dart';
import 'package:bibliasacra/main/main_selector.dart';
import 'package:bibliasacra/main/main_versmenu.dart';
import 'package:bibliasacra/notes/no_model.dart';
import 'package:bibliasacra/notes/no_page.dart';
import 'package:bibliasacra/notes/no_queries.dart';
import 'package:bibliasacra/theme/theme.dart';
import 'package:bibliasacra/utils/utils_getlists.dart';
import 'package:bibliasacra/utils/utils_snackbars.dart';
import 'package:bibliasacra/utils/utils_utilities.dart';
import 'package:bibliasacra/vers/vers_page.dart';
import 'package:bibliasacra/vers/vers_queries.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:word_selectable_text/word_selectable_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bibliasacra/fonts/list.dart';

late PageController? pageController;
ItemScrollController? initialScrollController;

late DbQueries _dbQueries;
BmQueries _bmQueries = BmQueries();
HlQueries _hlQueries = HlQueries();
NtQueries _ntQueries = NtQueries();

String verseText = '';
int verseNumber = 0;
int chapterNumber = 0;

bool? initialPageScroll;

late int bibleVersion;
late int bibleBook;
late int bibleBookChapter;

late String bibleLang;
late String versionAbbr;
late String bookName;
late int fontListNum;

int _selectedIndex = 0;
late int verseBid;

late AnimationController animationController;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  @override
  initState() {
    super.initState();

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        VkQueries().getActiveVersionCount().then((c) {
          Globals.activeVersionCount = c;
        });

        initialScrollController = ItemScrollController();

        Future.delayed(Duration(milliseconds: Globals.navigatorLongDelay), () {
          if (initialScrollController!.isAttached) {
            initialScrollController!.scrollTo(
              index: context.read<VerseBloc>().state - 1,
              duration: Duration(milliseconds: Globals.navigatorLongDelay),
              curve: Curves.easeInOutCubic,
            );
          }
        });
      },
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  ItemScrollController? itemScrollControllerSelector() {
    if (initialPageScroll!) {
      initialPageScroll = false;
      return initialScrollController; // initial scroll
    } else {
      return ItemScrollController(); // PageView scroll
    }
  }

  Future confirmDialog(arr) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(arr[0].toString()),
        content: Text(arr[1].toString()),
        actions: [
          TextButton(
            child:
                const Text('NO', style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('YES',
                style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }

  void copyVerseWrapper(BuildContext context) {
    final list = <String>[
      verseText,
      ' ',
      versionAbbr,
      ' ',
      bookName,
      ' ',
      chapterNumber.toString(),
      ':',
      verseNumber.toString()
    ];

    final sb = StringBuffer();
    sb.writeAll(list);

    Clipboard.setData(
      ClipboardData(text: sb.toString()),
    ).then((_) {
      Future.delayed(Duration(milliseconds: Globals.navigatorLongDelay), () {
        ScaffoldMessenger.of(context).showSnackBar(textCopiedSnackBar);
      });
    });
  }

  Future<void> insertBookMark(int bid) async {
    List<String> stringTitle = [
      versionAbbr,
      ' ',
      bookName,
      ' ',
      '$bibleBookChapter',
      ':',
      '$verseNumber'
    ];

    final model = BmModel(
        title: stringTitle.join(),
        subtitle: verseText,
        lang: bibleLang,
        version: bibleVersion,
        abbr: versionAbbr,
        book: bibleBook,
        chapter: bibleBookChapter,
        verse: verseNumber,
        name: bookName,
        bid: bid);
    _bmQueries.saveBookMark(model).then((value) {
      Globals.listReadCompleted = false;
    });
  }

  Future<void> insertHighLight(int bid) async {
    List<String> stringTitle = [
      versionAbbr,
      ' ',
      bookName,
      ' ',
      '$bibleBookChapter',
      ':',
      '$verseNumber'
    ];

    final model = HlModel(
        title: stringTitle.join(),
        subtitle: verseText,
        lang: bibleLang,
        version: bibleVersion,
        abbr: versionAbbr,
        book: bibleBook,
        chapter: bibleBookChapter,
        verse: verseNumber,
        name: bookName,
        bid: bid);

    _hlQueries.saveHighLight(model).then((value) {
      Globals.listReadCompleted = false;
    });
  }

  Future<void> saveNote(int bid) async {
    List<String> stringTitle = [
      versionAbbr,
      ' ',
      bookName,
      ' ',
      '$bibleBookChapter',
      ':',
      '$verseNumber'
    ];

    final model = NtModel(
        title: stringTitle.join(),
        contents: verseText,
        lang: bibleLang,
        version: bibleVersion,
        abbr: versionAbbr,
        book: bibleBook,
        chapter: bibleBookChapter,
        verse: verseNumber,
        name: bookName,
        bid: bid);
    _ntQueries.insertNote(model).then((value) {
      Globals.listReadCompleted = false;
    });
  }

  bool getBookMarksMatch(int bid) {
    bool match = false;
    if (GetLists.booksList!.isNotEmpty) {
      for (int b = 0; b < GetLists.booksList!.length; b++) {
        if (GetLists.booksList![b].bid == bid) {
          match = true;
        }
      }
    }
    return match;
  }

  bool getNotesMatch(int bid) {
    bool match = false;
    if (GetLists.notesList!.isNotEmpty) {
      for (int n = 0; n < GetLists.notesList!.length; n++) {
        if (GetLists.notesList![n].bid == bid) {
          match = true;
        }
      }
    }
    return match;
  }

  bool getHighLightMatch(int bid) {
    bool match = false;
    if (GetLists.highsList!.isNotEmpty) {
      for (int h = 0; h < GetLists.highsList!.length; h++) {
        if (GetLists.highsList![h].bid == bid) {
          match = true;
        }
      }
    }
    return match;
  }

  Widget dicVerseText(BuildContext context, snapshot, index) {
    if (snapshot.data[index].v != 0) {
      return WordSelectableText(
        selectable: true,
        highlight: true,
        text: "${snapshot.data[index].v}:  ${snapshot.data[index].t}",
        // style:
        //     TextStyle(fontStyle: FontStyle.normal, fontSize: primaryTextSize),
        onWordTapped: (word, index) {
          Globals.dictionaryLookup = word;
          dictDialog(context);
        },
      );
    } else {
      return const Text('');
    }
  }

  Widget dictionaryMode(BuildContext context, snapshot, index) {
    return Container(
      margin: const EdgeInsets.only(left: 5, bottom: 6.0),
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: (dicVerseText(context, snapshot, index)),
          ),
        ],
      ),
    );
  }

  Widget normalVerseText(snapshot, index) {
    if (snapshot.data[index].v != 0) {
      return Text(
        "${snapshot.data[index].v}:  ${snapshot.data[index].t}",
        style: TextStyle(
            //fontSize: primaryTextSize,
            backgroundColor: (getHighLightMatch(snapshot.data[index].id))
                ? Theme.of(context).colorScheme.primaryContainer
                : null),
      );
    } else {
      return const Text('');
    }
  }

  SizedBox showNoteIcon(snapshot, index) {
    if (getNotesMatch(snapshot.data[index].id)) {
      return SizedBox(
        height: 30,
        width: 30,
        child: IconButton(
          icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
          onPressed: () {
            Future.delayed(
              Duration(milliseconds: Globals.navigatorDelay),
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotesPage(),
                  ),
                ).then((value) {
                  setState(() {});
                });
              },
            );
          },
        ),
      );
    } else {
      return const SizedBox(height: 0, width: 0);
    }
  }

  SizedBox showBookMarkIcon(snapshot, index) {
    if (getBookMarksMatch(snapshot.data[index].id)) {
      return SizedBox(
        height: 30,
        width: 30,
        child: IconButton(
          icon: Icon(Icons.bookmark_border_outlined,
              color: Theme.of(context).colorScheme.primary),
          onPressed: () {
            Future.delayed(
              Duration(milliseconds: Globals.navigatorDelay),
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BookMarksPage(),
                  ),
                ).then((value) {
                  setState(() {});
                });
              },
            );
          },
        ),
      );
    } else {
      return const SizedBox(height: 0, width: 0);
    }
  }

  Widget normalMode(BuildContext context, snapshot, index) {
    return GestureDetector(
      onTap: () {
        chapterNumber = snapshot.data[index].c;
        verseNumber = snapshot.data[index].v;
        verseText = snapshot.data[index].t;
        verseBid = snapshot.data[index].id;

        animationController.forward();

        Future.delayed(const Duration(milliseconds: 5000), () {
          animationController.reverse();
        });
      },
      child: Container(
        margin: const EdgeInsets.only(left: 5, bottom: 6.0),
        child: Row(
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: (snapshot.data[index].v != 0)
                  ? Text(
                      "${snapshot.data[index].v}:  ${snapshot.data[index].t}",
                      //style: GoogleFonts.getFont(fontsList[6]),
                      style: TextStyle(
                          //fontSize: primaryTextSize,
                          fontFamily:
                              GoogleFonts.getFont(fontsList[fontListNum])
                                  .fontFamily,
                          backgroundColor:
                              getHighLightMatch(snapshot.data[index].id)
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : null),
                    )
                  : const Text(''),
            ),
            showNoteIcon(snapshot, index),
            showBookMarkIcon(snapshot, index)
          ],
        ),
      ),
    );
  }

  void showVersionsDialog(BuildContext context) {
    (Globals.activeVersionCount! > 1)
        ? versionsDialog(context, 'main')
        : Future.delayed(Duration(milliseconds: Globals.navigatorLongDelay),
            () {
            ScaffoldMessenger.of(context).showSnackBar(moreVersionsSnackBar);
          });
  }

  Widget showModes() {
    if (bibleLang == 'lat') {
      String modeText =
          Globals.dictionaryMode ? 'Dictionary Mode' : 'Normal Mode';
      return FloatingActionButton.extended(
        label: Text(modeText),
        icon: const Icon(Icons.change_circle),
        onPressed: () {
          Globals.dictionaryMode = (Globals.dictionaryMode) ? false : true;
          setState(() {});
        },
      );
    } else {
      Globals.dictionaryMode = false;
      return Container();
    }
  }

  getPageController() {
    bibleBookChapter = context.read<ChapterBloc>().state;
    pageController = PageController(initialPage: bibleBookChapter - 1);
  }

  Widget showDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          DrawerHeader(
            //decoration: const BoxDecoration(
            //color: Theme.of(context).colorScheme.secondaryContainer,
            // image: DecorationImage(
            //   fit: BoxFit.fill,
            //   image: AssetImage('path/to/header_background.png'),
            // ),
            // ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 20.0,
                  //left: 16.0,
                  child: Text(
                    "Biblia Sacra",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 32.0),
                    //fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            trailing: const Icon(Icons.arrow_right),
            //color: Theme.of(context).colorScheme.primary),
            title: const Text(
              'Bookmarks',
              // style: TextStyle(
              //     //color: Colors.white,
              //     fontSize: 16.0,
              //     fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Route route = MaterialPageRoute(
                builder: (context) => const BookMarksPage(),
              );
              Future.delayed(
                Duration(milliseconds: Globals.navigatorDelay),
                () {
                  Navigator.push(context, route);
                },
              );
            },
          ),
          ListTile(
            trailing: const Icon(Icons.arrow_right),
            //color: Theme.of(context).colorScheme.primary),
            title: const Text(
              'Hilights',
              // style: TextStyle(
              //     //color: Colors.white,
              //     fontSize: 16.0,
              //     fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Route route = MaterialPageRoute(
                builder: (context) => const HighLightsPage(),
              );
              Future.delayed(
                Duration(milliseconds: Globals.navigatorDelay),
                () {
                  Navigator.push(context, route);
                },
              );
            },
          ),
          ListTile(
            trailing: const Icon(Icons.arrow_right),
            //color: Theme.of(context).colorScheme.primary),
            title: const Text(
              'Notes',
              // style: TextStyle(
              //     //color: Colors.white,
              //     fontSize: 16.0,
              //     fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Route route = MaterialPageRoute(
                builder: (context) => const NotesPage(),
              );
              Future.delayed(
                Duration(milliseconds: Globals.navigatorDelay),
                () {
                  Navigator.push(context, route);
                },
              );
            },
          ),
          ListTile(
            trailing: const Icon(Icons.arrow_right),
            //color: Theme.of(context).colorScheme.primary),
            title: const Text(
              'Latin word list',
              // style: TextStyle(
              //     //color: Colors.white,
              //     fontSize: 16.0,
              //     fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Route route = MaterialPageRoute(
                builder: (context) => const DictSearch(),
              );
              Future.delayed(
                Duration(milliseconds: Globals.navigatorDelay),
                () {
                  Navigator.push(context, route);
                },
              );
            },
          ),
          ListTile(
            trailing: const Icon(Icons.arrow_right),
            //color: Theme.of(context).colorScheme.primary),
            title: const Text(
              'Search',
              // style: TextStyle(
              //     //color: Colors.white,
              //     fontSize: 16.0,
              //     fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Route route = MaterialPageRoute(
                builder: (context) => const MainSearch(),
              );
              Future.delayed(
                Duration(milliseconds: Globals.navigatorDelay),
                () {
                  Navigator.push(context, route);
                },
              );
            },
          ),
          ListTile(
            trailing: const Icon(Icons.arrow_right),
            //color: Theme.of(context).colorScheme.primary),
            title: const Text(
              'Bibles',
              // style: TextStyle(
              //     //color: Colors.white,
              //     fontSize: 16.0,
              //     fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Route route = MaterialPageRoute(
                builder: (context) => const VersionsPage(),
              );
              Future.delayed(
                Duration(milliseconds: Globals.navigatorDelay),
                () {
                  Navigator.push(context, route);
                },
              );
            },
          ),
          ListTile(
            trailing: const Icon(Icons.arrow_right),
            //color: Theme.of(context).colorScheme.primary),
            title: const Text(
              'Fonts',
              // style: TextStyle(
              //     //color: Colors.white,
              //     fontSize: 16.0,
              //     fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Route route = MaterialPageRoute(
                builder: (context) => const FontsPage(),
              );
              Future.delayed(
                Duration(milliseconds: Globals.navigatorDelay),
                () {
                  Navigator.push(context, route).then((value) {
                    setState(() {});
                  });
                },
              );
            },
          ),
          ListTile(
            trailing: const Icon(Icons.arrow_right),
            //color: Theme.of(context).colorScheme.primary),
            title: const Text(
              'Theme',
              // style: TextStyle(
              //     //color: Colors.white,
              //     fontSize: 16.0,
              //     fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Route route = MaterialPageRoute(
                builder: (context) => const ThemePage(),
              );
              Future.delayed(
                Duration(milliseconds: Globals.navigatorDelay),
                () {
                  Navigator.push(context, route);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    initialPageScroll = true;

    fontListNum = context.read<FontBloc>().state;

    bibleBook = context.read<BookBloc>().state;

    bibleVersion = context.read<VersionBloc>().state;

    versionAbbr = Utilities(bibleVersion).getVersionAbbr();
    bibleLang = Utilities(bibleVersion).getLanguage();
    bookName = BookLists().readBookName(bibleBook, bibleVersion);

    getPageController();

    // initialize font from list
    // FontList().init();
    // String f = FontList().getFont();
    // debugPrint("FONT $f");

    _dbQueries = DbQueries(bibleVersion);

    if (!Globals.listReadCompleted) {
      GetLists().updateActiveLists(bibleVersion);
      Globals.listReadCompleted = true;
    }

    return Scaffold(
      //backgroundColor: theme.colorScheme.background,
      drawer: showDrawer(context),
      appBar: AppBar(
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // (Globals.bibleLang == 'lat')
          //     ? showIconButton(context)
          //     : Container(),
          Row(
            children: [
              FilledButton(
                // style: ElevatedButton.styleFrom(
                //     backgroundColor: theme.colorScheme.secondary
                //     ),
                onPressed: () {
                  Route route = MaterialPageRoute(
                    builder: (context) => MainSelector(bibleLang: bibleLang),
                  );
                  Future.delayed(
                    Duration(milliseconds: Globals.navigatorDelay),
                    () {
                      Navigator.push(context, route);
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '$bookName: ',
                      //style: const TextStyle(fontWeight: FontWeight.bold)
                    ),
                    BlocBuilder<ChapterBloc, int>(
                      builder: (context, state) {
                        return Text(
                          state.toString(),
                          //style: const TextStyle(fontWeight: FontWeight.bold)
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              FilledButton(
                // style: ElevatedButton.styleFrom(
                //     backgroundColor: theme.colorScheme.secondary),
                child: Text(
                  versionAbbr,
                  //style: const TextStyle(fontWeight: FontWeight.bold)
                ),
                onPressed: () {
                  showVersionsDialog(context);
                },
              ),
              const SizedBox(
                // right side border width
                width: 16,
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<int>(
        future: _dbQueries.getChapterCount(bibleBook),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData) {
            int chapterCount = snapshot.data!.toInt();
            return ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              }),
              child: PageView.builder(
                controller: pageController,
                itemCount: chapterCount,
                physics: const BouncingScrollPhysics(),
                pageSnapping: true,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.all(20.0),
                    child: FutureBuilder<List<Bible>>(
                      future: _dbQueries.getBookChapter(bibleBook, index + 1),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Bible>> snapshot) {
                        if (snapshot.hasData) {
                          return ScrollablePositionedList.builder(
                            itemCount: snapshot.data!.length,
                            itemScrollController:
                                itemScrollControllerSelector(),
                            itemBuilder: (context, index) {
                              return (Globals.dictionaryMode)
                                  ? dictionaryMode(context, snapshot, index)
                                  : normalMode(context, snapshot, index);
                            },
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  );
                },
                onPageChanged: (index) {
                  // move to top of next chapter
                  context
                      .read<ChapterBloc>()
                      .add(UpdateChapter(chapter: index + 1));
                  context.read<VerseBloc>().add(UpdateVerse(verse: 1));
                },
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: showModes(),
      bottomNavigationBar: SizeTransition(
        sizeFactor: animationController,
        axisAlignment: -1.0,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          //backgroundColor: Colors.blueAccent,
          //elevation: 0,
          //iconSize: 40,
          //selectedFontSize: 20,
          //selectedIconTheme: const IconThemeData(color: Colors.redAccent, size: 40),
          selectedItemColor: Theme.of(context).colorScheme.primary,
          //selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          //  unselectedIconTheme: IconThemeData(
          //   color: Colors.deepOrangeAccent,
          // ),
          // unselectedItemColor: Colors.deepOrangeAccent,
          // showSelectedLabels: false,
          // showUnselectedLabels: false,
          items: const <BottomNavigationBarItem>[
            //New
            BottomNavigationBarItem(
              icon: Icon(Icons.compare),
              label: 'Compare',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: 'Bookmark',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.highlight),
              label: 'Highlight',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.note),
              label: 'Notes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.copy),
              label: 'Copy',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });

            switch (index) {
              case 0:
                // Compare

                final model = Bible(
                    id: 0,
                    b: bibleBook,
                    c: context.read<ChapterBloc>().state,
                    v: verseNumber,
                    t: '');

                (Globals.activeVersionCount! > 1)
                    ? mainCompareDialog(context, model)
                    : Future.delayed(
                        Duration(milliseconds: Globals.navigatorLongDelay), () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(moreVersionsSnackBar);
                      });

                break;
              case 1:
                // Bookmark

                (!getBookMarksMatch(verseBid))
                    ? insertBookMark(verseBid).then((value) {
                        setState(() {});
                      })
                    : Future.delayed(
                        Duration(milliseconds: Globals.navigatorDelay),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BookMarksPage(),
                            ),
                          ).then((value) {
                            setState(() {});
                          });
                        },
                      );

                break;
              case 2:
                // Highlight

                (!getHighLightMatch(verseBid))
                    ? insertHighLight(verseBid).then((value) {
                        setState(() {});
                      })
                    : Future.delayed(
                        Duration(milliseconds: Globals.navigatorDelay),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HighLightsPage()),
                          ).then((value) {
                            setState(() {});
                          });
                        },
                      );

                break;
              case 3:
                // Note

                (getNotesMatch(verseBid))
                    ? Future.delayed(
                        Duration(milliseconds: Globals.navigatorDelay),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotesPage(),
                            ),
                          ).then((value) {
                            setState(() {});
                          });
                        },
                      )
                    : saveNote(verseBid).then((value) {
                        setState(() {});
                      });

                break;
              case 4:
                // Copy

                copyVerseWrapper(context);
                break;
            }
          },
        ),
      ),
    );
  }
}
