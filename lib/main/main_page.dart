import 'dart:async';
import 'dart:ui';
import 'package:bibliasacra/bloc/bloc_book.dart';
import 'package:bibliasacra/bloc/bloc_verse.dart';
import 'package:bibliasacra/bloc/bloc_version.dart';
import 'package:bibliasacra/bmarks/bm_model.dart';
import 'package:bibliasacra/bmarks/bm_page.dart';
import 'package:bibliasacra/bmarks/bm_queries.dart';
import 'package:bibliasacra/bloc/bloc_chapters.dart';
import 'package:bibliasacra/dict/dict_page.dart';
import 'package:bibliasacra/fonts/fonts.dart';
import 'package:bibliasacra/globals/globs_main.dart';
import 'package:bibliasacra/high/hi_page.dart';
import 'package:bibliasacra/high/hl_model.dart';
import 'package:bibliasacra/high/hl_queries.dart';
import 'package:bibliasacra/langs/lang_booklists.dart';
import 'package:bibliasacra/main/db_model.dart';
import 'package:bibliasacra/main/db_queries.dart';
import 'package:bibliasacra/main/main_contmenu.dart';
import 'package:bibliasacra/main/main_dict.dart';
import 'package:bibliasacra/main/main_search.dart';
import 'package:bibliasacra/main/main_selector.dart';
import 'package:bibliasacra/main/main_versmenu.dart';
import 'package:bibliasacra/notes/no_edit.dart';
import 'package:bibliasacra/notes/no_model.dart';
import 'package:bibliasacra/notes/no_page.dart';
import 'package:bibliasacra/notes/no_queries.dart';
import 'package:bibliasacra/theme/theme.dart';
import 'package:bibliasacra/utils/utils_getlists.dart';
import 'package:bibliasacra/utils/utils_snackbars.dart';
import 'package:bibliasacra/main/main_compage.dart';
import 'package:bibliasacra/utils/utils_utilities.dart';
import 'package:bibliasacra/vers/vers_page.dart';
import 'package:bibliasacra/vers/vers_queries.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:word_selectable_text/word_selectable_text.dart';

PageController? pageController;
//ItemScrollController? initialScrollController;

late DbQueries _dbQueries;
BmQueries _bmQueries = BmQueries();
HlQueries _hlQueries = HlQueries();
NtQueries _ntQueries = NtQueries();
GetLists _lists = GetLists();

String verseText = '';
int verseNumber = 0;

bool? initialPageScroll;
bool isShowing = true;

late int bibleVersion;
late int bibleBook;
late int bibleBookChapter;
//late int chapterVerse;
late String bibleLang;
late String versionAbbr;
late String bookName;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        GetLists().updateActiveLists(bibleVersion);

        VkQueries(bibleVersion).getActiveVersionCount().then((c) {
          Globals.activeVersionCount = c;
        });

        // initialScrollController = ItemScrollController();

        // Future.delayed(
        //   Duration(milliseconds: Globals.navigatorLongDelay),
        //   () {
        //     if (initialScrollController!.isAttached) {
        //       initialScrollController!.scrollTo(
        //         index: context.read<VerseBloc>().state.verse - 1,
        //         duration: Duration(milliseconds: Globals.navigatorLongDelay),
        //         curve: Curves.easeInOutCubic,
        //       );
        //     }
        //   },
        // );
      },
    );
  }

  // Future<List<Bible>> getBookText(int ch) async {
  //   return await _dbQueries.getBookChapter(bibleBook, ch);
  // }

  // Future<List<Bible>> getVersionText(int ch) async {
  //   //List<Bible> bible = List<Bible>.empty();

  //   //Future<List<Bible>> futureBibleList = getBookText(ch);
  //   return await _dbQueries.getBookChapter(bibleBook, ch);
  //   // bible = await futureBibleList;
  //   // return bible;
  // }

  // ItemScrollController? itemScrollControllerSelector() {
  //   if (initialPageScroll!) {
  //     initialPageScroll = false;
  //     return initialScrollController; // initial scroll
  //   } else {
  //     return ItemScrollController(); // PageView scroll
  //   }
  // }

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

  void copyVerseWrapper(BuildContext context, snapshot, index) {
    final list = <String>[
      snapshot.data[index].t,
      ' ',
      versionAbbr,
      ' ',
      bookName,
      ' ',
      snapshot.data[index].c.toString(),
      ':',
      snapshot.data[index].v.toString()
    ];

    final sb = StringBuffer();
    sb.writeAll(list);

    Clipboard.setData(
      ClipboardData(text: sb.toString()),
    ).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(textCopiedSnackBar);
    });
  }

  // void copyVerseWrapper(BuildContext context, snapshot, index) {
  //   var arr = List.filled(2, '');
  //   arr[0] = "Copy";
  //   arr[1] = "Do you want to copy this verse?";

  //   confirmDialog(arr).then(
  //     (value) {
  //       if (value) {
  //         final list = <String>[
  //           snapshot.data[index].t,
  //           ' ',
  //           Globals.versionAbbr,
  //           ' ',
  //           Globals.bookName,
  //           ' ',
  //           snapshot.data[index].c.toString(),
  //           ':',
  //           snapshot.data[index].v.toString()
  //         ];

  //         final sb = StringBuffer();
  //         sb.writeAll(list);

  //         Clipboard.setData(
  //           ClipboardData(text: sb.toString()),
  //         ).then((_) {
  //           ScaffoldMessenger.of(context).showSnackBar(textCopiedSnackBar);
  //         });
  //       }
  //     }, //_deleteWrapper,
  //   );
  // }

  // exitWrapper(BuildContext context) {
  //   var arr = List.filled(4, '');
  //   arr[0] = "Exit";
  //   arr[1] = "Are you sure you want to exit?";

  //   confirmDialog(arr).then(
  //     (value) {
  //       if (value) {
  //         SystemNavigator.pop();
  //       }
  //     },
  //   );
  // }

  void deleteHighLightWrapper(int bid) {
    var arr = List.filled(4, '');
    arr[0] = "Delete";
    arr[1] = "Do you want to delete this highlight?";

    confirmDialog(arr).then(
      (value) {
        if (value) {
          _hlQueries.deleteHighLight(bid).then((value) {
            ScaffoldMessenger.of(context).showSnackBar(hiLightDeletedSnackBar);
            setState(() {
              _lists.updateActiveLists(bibleVersion);
            });
          });
        }
      }, //_deleteWrapper,
    );
  }

  void deleteBookMarkWrapper(int bid) {
    var arr = List.filled(4, '');
    arr[0] = 'Delete';
    arr[1] = "Do you want to delete this bookmark?";

    confirmDialog(arr).then(
      (value) {
        if (value) {
          _bmQueries.deleteBookMarkbyBid(bid).then((value) {
            ScaffoldMessenger.of(context).showSnackBar(bmDeletedSnackBar);
            setState(() {
              _lists.updateActiveLists(bibleVersion);
            });
          });
        }
      }, //_deleteWrapper,
    );
  }

  void insertBookMark(int bid) {
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
    _bmQueries.saveBookMark(model).then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(bookMarkSnackBar);
        setState(() {
          _lists.updateActiveLists(bibleVersion);
        });
      },
    );
  }

  void insertHighLight(int bid) async {
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
      ScaffoldMessenger.of(context).showSnackBar(hiLightAddedSnackBar);
      setState(() {
        _lists.updateActiveLists(bibleVersion);
      });
    });
  }

  void saveNote(int bid) {
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
    _ntQueries.insertNote(model).then((noteid) {
      // setState(() {
      //   _lists.updateActiveLists('notes', Globals.bibleVersion);
      // });
      model.id = noteid;
      gotoEditNote(model);
    });
  }

  Future<void> gotoEditNote(NtModel model) async {
    Route route = MaterialPageRoute(
      builder: (context) => EditNotePage(model: model, mode: ''),
    );
    Future.delayed(
      Duration(milliseconds: Globals.navigatorDelay),
      () {
        Navigator.push(context, route).then((v) {
          setState(() {
            _lists.updateActiveLists(bibleVersion);
          });
        });
      },
    );
  }

  Future<NtModel> getNoteModel(int id) async {
    List<NtModel> vars = await _ntQueries.getNoteByBid(id);

    if ((vars.isNotEmpty)) {
      return NtModel(
          id: vars[0].id,
          title: vars[0].title,
          contents: vars[0].contents,
          lang: vars[0].lang,
          version: vars[0].version,
          abbr: vars[0].abbr,
          book: vars[0].book,
          chapter: vars[0].chapter,
          verse: vars[0].verse,
          name: vars[0].name,
          bid: vars[0].bid);
    } else {
      return NtModel(
          id: 0,
          title: '',
          contents: '',
          lang: '',
          version: 0,
          abbr: '',
          book: 0,
          chapter: 0,
          verse: 0,
          name: '',
          bid: id);
    }
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

  Widget normalModeContainer(snapshot, index) {
    return Container(
      margin: const EdgeInsets.only(left: 5, bottom: 6.0),
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: normalVerseText(snapshot, index),
          ),
          showNoteIcon(snapshot, index),
          showBookMarkIcon(snapshot, index)
        ],
      ),
    );
  }

  SizedBox showNoteIcon(snapshot, index) {
    if (getNotesMatch(snapshot.data[index].id)) {
      return SizedBox(
        height: 30,
        width: 30,
        child: IconButton(
          icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
          onPressed: () => getNoteModel(snapshot.data[index].id).then(
            (model) {
              gotoEditNote(model);
            },
          ),
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
            debugPrint('BOOKMARK PRESSES');
          },
          // onPressed: () => getNoteModel(snapshot.data[index].id).then(
          //   (model) {
          //     gotoEditNote(model);
          //   },
          // ),
        ),
      );
    } else {
      return const SizedBox(height: 0, width: 0);
    }
  }

  Widget normalMode(BuildContext context, snapshot, index) {
    return GestureDetector(
      onTap: () {
        verseNumber = snapshot.data[index].v;
        verseText = snapshot.data[index].t;
        contextMenuDialog(context).then(
          (value) {
            switch (value) {
              case 0: // compare
                final model = Bible(
                    id: 0,
                    b: snapshot.data[index].b,
                    c: snapshot.data[index].c,
                    v: snapshot.data[index].v,
                    t: '');

                (Globals.activeVersionCount! > 1)
                    ? mainCompareDialog(context, model)
                    : ScaffoldMessenger.of(context)
                        .showSnackBar(moreVersionsSnackBar);

                break;

              case 1: // bookmarks

                int bid = snapshot.data[index].id;

                (!getBookMarksMatch(bid))
                    ? insertBookMark(bid)
                    : deleteBookMarkWrapper(bid);

                break;

              case 2: // highlight

                int bid = snapshot.data[index].id;

                (!getHighLightMatch(bid))
                    ? insertHighLight(bid)
                    : deleteHighLightWrapper(bid);

                break;

              case 3: // notes

                int bid = snapshot.data[index].id;

                if (getNotesMatch(bid)) {
                  getNoteModel(bid).then((model) {
                    gotoEditNote(model);
                  });
                } else {
                  saveNote(bid);
                }

                break;

              case 4: // copy

                copyVerseWrapper(context, snapshot, index);

                break;

              default:
                break;
            }
          },
        );
      },
      child: normalModeContainer(snapshot, index),
    );
  }

  // Widget showListView(BuildContext context, int ch) {
  //   return Container(
  //     padding: const EdgeInsets.all(15.0),
  //     child: FutureBuilder<List<Bible>>(
  //       future: getVersionText(ch),
  //       builder: (context, AsyncSnapshot<List<Bible>> snapshot) {
  //         if (snapshot.hasData) {
  //           return ScrollablePositionedList.builder(
  //             itemCount: snapshot.data!.length,
  //             itemScrollController: itemScrollControllerSelector(),
  //             itemBuilder: (context, index) {
  //               return (Globals.dictionaryMode)
  //                   ? dictionaryMode(context, snapshot, index)
  //                   : normalMode(context, snapshot, index);
  //             },
  //           );
  //         }
  //         return const Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       },
  //     ),
  //   );
  // }

  // List<Widget> chapterCountFunc(BuildContext context, int chapterCount) {
  //   //debugPrint("CHAPTER $chapterCount");
  //   List<Widget> pagesList = [];
  //   for (int ch = 1; ch <= chapterCount; ch++) {
  //     pagesList.add(showListView(context, ch));
  //   }
  //   return pagesList;
  // }

  void showVersionsDialog(BuildContext context) {
    (Globals.activeVersionCount! > 1)
        ? versionsDialog(context, 'main')
        : ScaffoldMessenger.of(context).showSnackBar(moreVersionsSnackBar);
  }

  Widget showDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
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
              'Highlights',
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
                  Navigator.push(context, route);
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

  // void changeNotice(BuildContext context) {
  //   Future.delayed(
  //     Duration(milliseconds: Globals.navigatorDelay),
  //     () {
  //       (Globals.dictionaryMode)
  //           ? ScaffoldMessenger.of(context).showSnackBar(dicModeOnSnackBar)
  //           : ScaffoldMessenger.of(context).showSnackBar(dicModeOffSnackBar);
  //     },
  //   );
  // }

  // Padding showIconButton(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.only(right: 20),
  //     child: IconButton(
  //       color: (isShowing) ? Colors.white : Colors.transparent,
  //       icon: const Icon(Icons.change_circle),
  //       iconSize: 30,
  //       onPressed: () {
  //         Globals.dictionaryMode = (Globals.dictionaryMode) ? false : true;
  //         changeNotice(context);
  //         setState(() {});
  //       },
  //     ),
  //   );
  // }

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

  PageController getPageController() {
    bibleBookChapter = context.read<ChapterBloc>().state.chapter;
    return PageController(initialPage: bibleBookChapter - 1);
  }

  @override
  Widget build(BuildContext context) {
    initialPageScroll = true;
    bibleBook = context.read<BookBloc>().state.book;
    debugPrint("BIBLEBOOK $bibleBook");
    bibleVersion = context.read<VersionBloc>().state.bibleVersion;

    versionAbbr = Utilities(bibleVersion).getVersionAbbr();
    bibleLang = Utilities(bibleVersion).getLanguage();
    bookName = BookLists().readBookName(bibleBook, bibleVersion);

    _dbQueries = DbQueries(bibleVersion);

    return Scaffold(
      //backgroundColor: theme.colorScheme.background,
      drawer: showDrawer(context),
      appBar: AppBar(
        // backgroundColor: theme.colorScheme.primary,
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
                    BlocBuilder<ChapterBloc, ChapterState>(
                      builder: (context, state) {
                        return Text(
                          state.chapter.toString(),
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
      // body: FutureBuilder<int>(
      //   future: _dbQueries.getChapterCount(bibleBook),
      //   builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
      //     if (snapshot.hasData) {
      //       int chapterCount = snapshot.data!.toInt();
      //       return ScrollConfiguration(
      //         behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
      //           PointerDeviceKind.touch,
      //           PointerDeviceKind.mouse,
      //         }),
      //         child: PageView(
      //           controller: getPageController(), //pageController,
      //           scrollDirection: Axis.horizontal,
      //           pageSnapping: true,
      //           physics: const BouncingScrollPhysics(),
      //           children: chapterCountFunc(context, chapterCount),
      //           onPageChanged: (index) {
      //             context
      //                 .read<ChapterBloc>()
      //                 .add(UpdateChapter(chapter: index + 1));
      //             // move to top of next chapter
      //             context.read<VerseBloc>().add(UpdateVerse(verse: 1));
      //           },
      //         ),
      //       );
      //     }
      //     return const Center(child: CircularProgressIndicator());
      //   },
      // ),
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
                controller: getPageController(),
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
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
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
                  context
                      .read<ChapterBloc>()
                      .add(UpdateChapter(chapter: index + 1));
                  // move to top of next chapter
                  context.read<VerseBloc>().add(UpdateVerse(verse: 1));
                  //debugPrint("ONCHANGED $index");
                },
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: showModes(),
    );
  }
}
