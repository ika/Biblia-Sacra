import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:bibliasacra/bloc/bloc_book.dart';
import 'package:bibliasacra/bloc/bloc_font.dart';
import 'package:bibliasacra/bloc/bloc_italic.dart';
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
import 'package:bibliasacra/utils/utils_snackbars.dart';
import 'package:bibliasacra/utils/utils_utilities.dart';
import 'package:bibliasacra/vers/vers_page.dart';
import 'package:bibliasacra/vers/vers_queries.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share/share.dart';
import 'package:word_selectable_text/word_selectable_text.dart';
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
//late int fontListNum;

// int _selectedIndex = 0;
late int verseBid;

List<BmModel> bookMarksList = [];
List<HlModel> hiLightsList = [];
List<NtModel>? notesList = [];

// late AnimationController animationController;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}

// enum TapMenuItemEnum {
//   delete,
//   view,
// }

// extension MemberTapTapMenuItemEnum on TapMenuItemEnum {
//   String toName() {
//     return 'THIS';
//   }
// }

class MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  //var containerKey = GlobalKey();
  // var tapPositon = const Offset(0, 0);
//  Size get sizeQuery => MediaQuery.of(context).size;

  @override
  initState() {
    super.initState();

    // animationController = AnimationController(
    //     vsync: this, duration: const Duration(milliseconds: 500));

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

  // @override
  // void dispose() {
  //   animationController.dispose();
  //   super.dispose();
  // }

  ItemScrollController? itemScrollControllerSelector() {
    if (initialPageScroll!) {
      initialPageScroll = false;
      return initialScrollController; // initial scroll
    } else {
      return ItemScrollController(); // PageView scroll
    }
  }

  // Future confirmDialog(arr) async {
  //   return await showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) => AlertDialog(
  //       title: Text(arr[0].toString()),
  //       content: Text(arr[1].toString()),
  //       actions: [
  //         TextButton(
  //           child:
  //               const Text('NO', style: TextStyle(fontWeight: FontWeight.bold)),
  //           onPressed: () => Navigator.of(context).pop(false),
  //         ),
  //         TextButton(
  //           child: const Text('YES',
  //               style: TextStyle(fontWeight: FontWeight.bold)),
  //           onPressed: () => Navigator.of(context).pop(true),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
    bibleBookChapter = context.read<ChapterBloc>().state;
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
    _bmQueries.saveBookMark(model);
    // _bmQueries.saveBookMark(model).then((value) {
    //   Globals.listReadCompleted = false;
    // });
  }

  Future<void> insertHighLight(int bid) async {
    bibleBookChapter = context.read<ChapterBloc>().state;
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

    _hlQueries.saveHighLight(model);

    // _hlQueries.saveHighLight(model).then((value) {
    //   Globals.listReadCompleted = false;
    // });
  }

  Future<void> saveNote(int bid) async {
    bibleBookChapter = context.read<ChapterBloc>().state;
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
    _ntQueries.insertNote(model);
    // _ntQueries.insertNote(model).then((value) {
    //   Globals.listReadCompleted = false;
    // });
  }

  bool getBookMarksMatch(int bid) {
    bool match = false;
    if (bookMarksList.isNotEmpty) {
      for (int b = 0; b < bookMarksList.length; b++) {
        if (bookMarksList[b].bid == bid) {
          match = true;
          break;
        }
      }
    }
    return match;
  }

  bool getNotesMatch(int bid) {
    bool match = false;
    if (notesList!.isNotEmpty) {
      for (int n = 0; n < notesList!.length; n++) {
        if (notesList![n].bid == bid) {
          match = true;
        }
      }
    }
    return match;
  }

  bool getHighLightMatch(int bid) {
    bool match = false;
    if (hiLightsList.isNotEmpty) {
      for (int h = 0; h < hiLightsList.length; h++) {
        if (hiLightsList[h].bid == bid) {
          match = true;
          break;
        }
      }
    }
    return match;
  }

  bool getBackGroundMatch(int bid) {
    bool match = false;
    if (getBookMarksMatch(bid)) {
      match = true;
    } else if (getHighLightMatch(bid)) {
      match = true;
    } else if (getNotesMatch(bid)) {
      match = true;
    }
    return match;
  }

  // Widget dicVerseText(BuildContext context, snapshot, index) {
  //   if (snapshot.data[index].v != 0) {
  //     return WordSelectableText(
  //       selectable: true,
  //       highlight: true,
  //       text: "${snapshot.data[index].v}:  ${snapshot.data[index].t}",
  //       style: TextStyle(
  //           fontFamily: fontsList[context.read<FontBloc>().state],
  //           fontStyle: (context.read<ItalicBloc>().state)
  //               ? FontStyle.italic
  //               : FontStyle.normal),
  //       onWordTapped: (word, index) {
  //         Globals.dictionaryLookup = word;
  //         dictDialog(context);
  //       },
  //     );
  //   } else {
  //     return const Text('');
  //   }
  // }

  // Widget normalVerseText(snapshot, index) {
  //   if (snapshot.data[index].v != 0) {
  //     return Text(
  //       "${snapshot.data[index].v}:  ${snapshot.data[index].t}",
  //       style: TextStyle(
  //           //fontSize: primaryTextSize,
  //           //fontFamily: fontsList[fontNumber],
  //           backgroundColor: (getHighLightMatch(snapshot.data[index].id))
  //               ? Theme.of(context).colorScheme.primaryContainer
  //               : null),
  //     );
  //   } else {
  //     return const Text('');
  //   }
  // }

  // SizedBox showNoteIcon(snapshot, index) {
  //   if (getNotesMatch(snapshot.data[index].id)) {
  //     return SizedBox(
  //       height: 30,
  //       width: 30,
  //       child: IconButton(
  //         icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
  //         onPressed: () {
  //           Future.delayed(
  //             Duration(milliseconds: Globals.navigatorDelay),
  //             () {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => const NotesPage(),
  //                 ),
  //               ).then((value) {
  //                 setState(() {});
  //               });
  //             },
  //           );
  //         },
  //       ),
  //     );
  //   } else {
  //     return const SizedBox(height: 0, width: 0);
  //   }
  // }

  // SizedBox showBookMarkIcon(snapshot, index) {
  //   if (getBookMarksMatch(snapshot.data[index].id)) {
  //     return SizedBox(
  //       height: 30,
  //       width: 30,
  //       child: IconButton(
  //         icon: Icon(Icons.bookmark_border_outlined,
  //             color: Theme.of(context).colorScheme.primary),
  //         onPressed: () {
  //           Future.delayed(
  //             Duration(milliseconds: Globals.navigatorDelay),
  //             () {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => const BookMarksPage(),
  //                 ),
  //               ).then((value) {
  //                 setState(() {});
  //               });
  //             },
  //           );
  //         },
  //       ),
  //     );
  //   } else {
  //     return const SizedBox(height: 0, width: 0);
  //   }
  // }

  // void onTapItem(TapMenuItemEnum tap) {
  //   debugPrint("$tap");
  // }

  // void getTapPosition(TapDownDetails tapDownDetails) {
  //   final renderBox = context.findRenderObject() as RenderBox;
  //   setState(() {
  //     tapPositon = renderBox.globalToLocal(tapDownDetails.globalPosition);
  //   });
  // }

  // void showContextMenu() async {
  //   await showMenu(
  //       context: context,
  //       position: RelativeRect.fromLTRB(
  //         tapPositon.dx,
  //         tapPositon.dy,
  //         sizeQuery.width - tapPositon.dx,
  //         sizeQuery.height - tapPositon.dy,
  //       ),
  //       items: TapMenuItemEnum.values
  //           .map((e) => PopupMenuItem(
  //                 child: Text(e.toName()),
  //                 onTap: () => onTapItem(e),
  //               ))
  //           .toList()
  //       // items: [
  //       // PopupMenuItem(
  //       //   child: const Text('View'),
  //       //   onTap: () => onTapItem(TapMenuItemEnum.view),
  //       // ),
  //       //   PopupMenuItem(
  //       //     child: const Text('Delete'),
  //       //     onTap: () => onTapItem(TapMenuItemEnum.delete),
  //       //   ),
  //       // ],
  //       );
  // }

  Widget dictionaryMode(BuildContext context, snapshot, index) {
    return Container(
      margin: const EdgeInsets.only(top: 5, right: 5, left: 5),
      child: Row(
        children: [
          Expanded(
            child: (snapshot.data[index].v != 0)
                ? WordSelectableText(
                    selectable: true,
                    highlight: true,
                    text:
                        "${snapshot.data[index].v}:  ${snapshot.data[index].t}",
                    style: TextStyle(
                        fontFamily: fontsList[context.read<FontBloc>().state],
                        fontStyle: (context.read<ItalicBloc>().state)
                            ? FontStyle.italic
                            : FontStyle.normal),
                    onWordTapped: (word, index) {
                      Globals.dictionaryLookup = word;
                      dictDialog(context);
                    },
                  )
                : const Text(''),
          ),
        ],
      ),
    );
  }

  Widget normalMode(BuildContext context, snapshot, index) {
    return GestureDetector(
      onTap: () {
        chapterNumber = snapshot.data[index].c;
        verseNumber = snapshot.data[index].v;
        verseText = snapshot.data[index].t;
        verseBid = snapshot.data[index].id;
        showPopupMenu(verseNumber, verseBid);
      },
      child: Container(
        margin: const EdgeInsets.only(
            top: 6, right: 5, left: 5), //requited to stop jumping
        child: Row(
          children: [
            Expanded(
              child: (snapshot.data[index].v != 0)
                  ? Text(
                      "${snapshot.data[index].v}:  ${snapshot.data[index].t}",
                      style: TextStyle(
                          fontFamily: fontsList[context.read<FontBloc>().state],
                          fontStyle: (context.read<ItalicBloc>().state)
                              ? FontStyle.italic
                              : FontStyle.normal,
                          backgroundColor:
                              getBackGroundMatch(snapshot.data[index].id)
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : null),
                    )
                  : const Text(''),
            ),
            // showNoteIcon(snapshot, index),
            // showBookMarkIcon(snapshot, index)
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

  showModes() {
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
      //return Container();
    }
  }

  void onShareLink() async {
    //String subject = 'Westminster Confession';
    String uri =
        'https://play.google.com/store/apps/details?id=org.armstrong.ika.bibliasacra';
    await Share.share(uri);
  }

  getPageController() {
    pageController =
        PageController(initialPage: context.read<ChapterBloc>().state - 1);
  }

  Widget showDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
              // image: DecorationImage(
              //   fit: BoxFit.fill,
              //   image: AssetImage('path/to/header_background.png'),
              // ),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 20.0,
                  //left: 16.0,
                  child: Text(
                    "Biblia Sacra",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 32.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: fontsList[context.read<FontBloc>().state],
                        fontStyle: FontStyle.italic),
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
                  Navigator.push(context, route).then((value) {
                    setState(() {});
                  });
                  // Navigator.push(context, route);
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
                  Navigator.push(context, route).then((value) {
                    setState(() {});
                  });
                  // Navigator.push(context, route);
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
                  //Navigator.push(context, route);
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
                  //Navigator.push(context, route);
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
          (Platform.isAndroid)
              ? ListTile(
                  trailing: const Icon(Icons.arrow_right),
                  //color: Theme.of(context).colorScheme.primary),
                  title: const Text(
                    'Share',
                    // style: TextStyle(
                    //     //color: Colors.white,
                    //     fontSize: 16.0,
                    //     fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    // Route route = MaterialPageRoute(
                    //   builder: (context) => const ThemePage(),
                    // );
                    Future.delayed(
                      Duration(milliseconds: Globals.navigatorDelay),
                      () {
                        Navigator.pop(context);
                        onShareLink();
                      },
                    );
                  },
                )
              : Container()
        ],
      ),
    );
  }

  // Widget offsetPopup() => PopupMenuButton<int>(
  //       itemBuilder: (context) => [
  //         const PopupMenuItem(
  //           value: 1,
  //           child: Text(
  //             "Flutter Open",
  //             style:
  //                 TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
  //           ),
  //         ),
  //         const PopupMenuItem(
  //           value: 2,
  //           child: Text(
  //             "Flutter Tutorial",
  //             style:
  //                 TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
  //           ),
  //         ),
  //       ],
  //       // icon: Container(
  //       //   height: double.infinity,
  //       //   width: double.infinity,
  //       //   decoration: const ShapeDecoration(
  //       //       color: Colors.blue,
  //       //       shape: StadiumBorder(
  //       //         side: BorderSide(color: Colors.white, width: 2),
  //       //       )),
  //       //   //child: Icon(Icons.menu, color: Colors.white), <-- You can give your icon here
  //       // ));
  //     );

  void populateBookMarksList() {
    BmQueries().getBookMarksVersionList(bibleVersion).then((value) {
      bookMarksList = value;
    });
  }

  void populateHiLightsList() {
    HlQueries().getHighVersionList(bibleVersion).then((value) {
      hiLightsList = value;
    });
  }

  void populateNotesList() {
    NtQueries().getAllVersionNotes(bibleVersion).then((value) {
      notesList = value;
    });
  }

  showPopupMenu(int verseNumber, int verseBid) async {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height * .3;

    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(width, height, 50, 0),
      items: [
        PopupMenuItem(
          child: const Text("Compare"),
          onTap: () {
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
          },
        ),
        PopupMenuItem(
          child: const Text("Bookmark"),
          onTap: () {
            (!getBookMarksMatch(verseBid))
                ? insertBookMark(verseBid).then((value) {
                    Future.delayed(
                        Duration(milliseconds: Globals.navigatorLongDelay), () {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(bookMarkSnackBar);
                    });

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
                        //animationController.reverse();
                        setState(() {});
                      });
                    },
                  );
          },
        ),
        PopupMenuItem(
          child: const Text("Highlight"),
          onTap: () {
            (!getHighLightMatch(verseBid))
                ? insertHighLight(verseBid).then((value) {
                    Future.delayed(
                        Duration(milliseconds: Globals.navigatorLongDelay), () {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(hiLightAddedSnackBar);
                    });

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
          },
        ),
        PopupMenuItem(
          child: const Text("Note"),
          onTap: () {
            (!getNotesMatch(verseBid))
                ? saveNote(verseBid).then((value) {
                    Future.delayed(
                        Duration(milliseconds: Globals.navigatorLongDelay), () {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(noteAddedSnackBar);
                    });
                    setState(() {});
                  })
                : Future.delayed(
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
        PopupMenuItem(
          child: const Text("Copy"),
          onTap: () {
            copyVerseWrapper(context);
          },
        ),
      ],
      elevation: 8.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    initialPageScroll = true;

    //italicIsOn = context.read<ItalicBloc>().state;

    bibleBook = context.read<BookBloc>().state;

    bibleVersion = context.read<VersionBloc>().state;

    versionAbbr = Utilities(bibleVersion).getVersionAbbr();
    bibleLang = Utilities(bibleVersion).getLanguage();
    bookName = BookLists().readBookName(bibleBook, bibleVersion);

    getPageController();

    populateBookMarksList();

    populateHiLightsList();

    populateNotesList();

    // initialize font from list
    // FontList().init();
    // String f = FontList().getFont();
    // debugPrint("FONT $f");

    _dbQueries = DbQueries(bibleVersion);

    // if (!Globals.listReadCompleted) {
    //   GetLists().updateActiveLists(bibleVersion);
    //   Globals.listReadCompleted = true;
    // }

    return PopScope(
      canPop: false,
      child: Scaffold(
        //backgroundColor: theme.colorScheme.background,
        drawer: showDrawer(context),
        // //floatingActionButtonLocation: StandardFabLocation,
        // floatingActionButton: FloatingActionButton(onPressed: () {  },),
        appBar: AppBar(
          //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          elevation: 5,
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
                behavior:
                    ScrollConfiguration.of(context).copyWith(dragDevices: {
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
        // bottomNavigationBar: SizeTransition(
        //   sizeFactor: animationController,
        //   axisAlignment: -1.0,
        //   child: BottomNavigationBar(
        //     type: BottomNavigationBarType.fixed,
        //     //backgroundColor: Colors.blueAccent,
        //     //elevation: 0,
        //     //iconSize: 40,
        //     //selectedFontSize: 20,
        //     //selectedIconTheme: const IconThemeData(color: Colors.redAccent, size: 40),
        //     selectedItemColor: Theme.of(context).colorScheme.primary,
        //     //selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        //     //  unselectedIconTheme: IconThemeData(
        //     //   color: Colors.deepOrangeAccent,
        //     // ),
        //     // unselectedItemColor: Colors.deepOrangeAccent,
        //     // showSelectedLabels: false,
        //     // showUnselectedLabels: false,
        //     items: const <BottomNavigationBarItem>[
        //       //New
        //       BottomNavigationBarItem(
        //         icon: Icon(Icons.compare),
        //         label: 'Compare',
        //       ),
        //       BottomNavigationBarItem(
        //         icon: Icon(Icons.bookmark),
        //         label: 'Bookmark',
        //       ),
        //       BottomNavigationBarItem(
        //         icon: Icon(Icons.highlight),
        //         label: 'Highlight',
        //       ),
        //       BottomNavigationBarItem(
        //         icon: Icon(Icons.note),
        //         label: 'Notes',
        //       ),
        //       BottomNavigationBarItem(
        //         icon: Icon(Icons.copy),
        //         label: 'Copy',
        //       ),
        //     ],
        //     currentIndex: _selectedIndex,
        //     onTap: (int index) {
        //       setState(() {
        //         _selectedIndex = index;
        //       });

        //       switch (index) {
        //         case 0:
        //           // Compare

        //           //animationController.reverse();

        //           final model = Bible(
        //               id: 0,
        //               b: bibleBook,
        //               c: context.read<ChapterBloc>().state,
        //               v: verseNumber,
        //               t: '');

        //           (Globals.activeVersionCount! > 1)
        //               ? mainCompareDialog(context, model)
        //               : Future.delayed(
        //                   Duration(milliseconds: Globals.navigatorLongDelay), () {
        //                   ScaffoldMessenger.of(context)
        //                       .showSnackBar(moreVersionsSnackBar);
        //                 });

        //           break;
        //         case 1:
        //           // Bookmark

        //           //animationController.reverse();

        //           (!getBookMarksMatch(verseBid))
        //               ? insertBookMark(verseBid).then((value) {
        //                   setState(() {});
        //                 })
        //               : Future.delayed(
        //                   Duration(milliseconds: Globals.navigatorDelay),
        //                   () {
        //                     Navigator.push(
        //                       context,
        //                       MaterialPageRoute(
        //                         builder: (context) => const BookMarksPage(),
        //                       ),
        //                     ).then((value) {
        //                       //animationController.reverse();
        //                       setState(() {});
        //                     });
        //                   },
        //                 );

        //           break;
        //         case 2:
        //           // Highlight

        //           //animationController.reverse();

        //           (!getHighLightMatch(verseBid))
        //               ? insertHighLight(verseBid).then((value) {
        //                   setState(() {});
        //                 })
        //               : Future.delayed(
        //                   Duration(milliseconds: Globals.navigatorDelay),
        //                   () {
        //                     Navigator.push(
        //                       context,
        //                       MaterialPageRoute(
        //                           builder: (context) => const HighLightsPage()),
        //                     ).then((value) {
        //                       setState(() {});
        //                     });
        //                   },
        //                 );

        //           break;
        //         case 3:
        //           // Note

        //           //animationController.reverse();

        //           (getNotesMatch(verseBid))
        //               ? Future.delayed(
        //                   Duration(milliseconds: Globals.navigatorDelay),
        //                   () {
        //                     Navigator.push(
        //                       context,
        //                       MaterialPageRoute(
        //                         builder: (context) => const NotesPage(),
        //                       ),
        //                     ).then((value) {
        //                       setState(() {});
        //                     });
        //                   },
        //                 )
        //               : saveNote(verseBid).then((value) {
        //                   setState(() {});
        //                 });

        //           break;
        //         case 4:
        //           // Copy

        //           //animationController.reverse();

        //           copyVerseWrapper(context);
        //           break;
        //       }
        //     },
        //   ),
        // ),
      ),
    );
  }
}
