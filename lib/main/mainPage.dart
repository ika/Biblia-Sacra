import 'dart:async';
import 'package:bibliasacra/bmarks/bmModel.dart';
import 'package:bibliasacra/bmarks/bmQueries.dart';
import 'package:bibliasacra/bmarks/bookMarksPage.dart';
import 'package:bibliasacra/colors/colors.dart';
import 'package:bibliasacra/cubit/chaptersCubit.dart';
import 'package:bibliasacra/cubit/paletteCubit.dart';
import 'package:bibliasacra/cubit/textSizeCubit.dart';
import 'package:bibliasacra/dict/dict.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/high/highMarksPage.dart';
import 'package:bibliasacra/high/hlModel.dart';
import 'package:bibliasacra/high/hlQueries.dart';
import 'package:bibliasacra/main/dbModel.dart';
import 'package:bibliasacra/main/dbQueries.dart';
import 'package:bibliasacra/main/mainContextMenu.dart';
import 'package:bibliasacra/main/mainDict.dart';
import 'package:bibliasacra/main/mainVersMenu.dart';
import 'package:bibliasacra/main/mainSearch.dart';
import 'package:bibliasacra/main/mainSelector.dart';
import 'package:bibliasacra/main/textsize/textsize.dart';
import 'package:bibliasacra/notes/edit.dart';
import 'package:bibliasacra/notes/nModel.dart';
import 'package:bibliasacra/notes/nQueries.dart';
import 'package:bibliasacra/utils/getlists.dart';
import 'package:bibliasacra/notes/notes.dart';
import 'package:bibliasacra/utils/dialogs.dart';
import 'package:bibliasacra/utils/sharedPrefs.dart';
import 'package:bibliasacra/utils/snackbars.dart';
import 'package:bibliasacra/vers/versionsPage.dart';
import 'package:bibliasacra/main/mainCompare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:word_selectable_text/word_selectable_text.dart';

PageController pageController;
ItemScrollController initialScrollController;
MaterialColor primarySwatch;
double primaryTextSize;

DbQueries _dbQueries = DbQueries();
SharedPrefs _sharedPrefs = SharedPrefs();
BmQueries _bmQueries = BmQueries();
HlQueries _hlQueries = HlQueries();
NtQueries _ntQueries = NtQueries();
GetLists _lists = GetLists();
Dialogs _dialogs = Dialogs();

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();

    initialScrollController = ItemScrollController();
    pageController = PageController(initialPage: Globals.bookChapter - 1);
    primarySwatch = BlocProvider.of<PaletteCubit>(context).state;
    primaryTextSize = BlocProvider.of<TextSizeCubit>(context).state;

    if (Globals.scrollToVerse) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          scrollToIndex().then(
            (value) {
              Globals.scrollToVerse = false;
            },
          );
        },
      );
    }
  }

  Future<void> scrollToIndex() async {
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        if (initialScrollController.isAttached) {
          initialScrollController.scrollTo(
            index: Globals.chapterVerse, // from verse selector
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic,
          );
        }
      },
    );
  }

  Future<List<Bible>> getBookText(int book, int ch) async {
    return await _dbQueries.getBookChapter(book, ch);
  }

  Future<List<Bible>> getVersionText(int book, int ch) async {
    List<Bible> bible = List<Bible>.empty();

    Future<List<Bible>> futureBibleList = getBookText(book, ch);
    bible = await futureBibleList;
    return bible;
  }

  ItemScrollController itemScrollControllerSelector() {
    if (Globals.initialScroll) {
      Globals.initialScroll = false;
      return initialScrollController; // initial scroll
    } else {
      return ItemScrollController(); // PageView scroll
    }
  }

  void copyVerseWrapper(context, snapshot, index) {
    var arr = List.filled(4, '');
    arr[0] = "Copy";
    arr[1] = "Do you want to copy this verse?";
    arr[2] = 'YES';
    arr[3] = 'NO';

    _dialogs.confirmDialog(context, arr).then(
      (value) {
        if (value == ConfirmAction.accept) {
          final list = <String>[
            snapshot.data[index].t,
            ' ',
            Globals.versionAbbr,
            ' ',
            Globals.bookName,
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
      }, //_deleteWrapper,
    );
  }

  Future<bool> exitWrapper(context) async {
    var arr = List.filled(4, '');
    arr[0] = "Exit";
    arr[1] = "Are you sure you want to exit?";
    arr[2] = 'YES';
    arr[3] = 'NO';

    _dialogs.confirmDialog(context, arr).then(
      (value) {
        if (value == ConfirmAction.accept) {
          SystemNavigator.pop();
        }
      },
    );
    return false;
  }

  void deleteHighLightWrapper(BuildContext context, int bid) {
    var arr = List.filled(4, '');
    arr[0] = "Delete";
    arr[1] = "Do you want to delete this highlight?";
    arr[2] = 'YES';
    arr[3] = 'NO';

    _dialogs.confirmDialog(context, arr).then(
      (value) {
        if (value == ConfirmAction.accept) {
          _hlQueries.deleteHighLight(bid).then((value) {
            ScaffoldMessenger.of(context).showSnackBar(hiLightDeletedSnackBar);
            setState(() {
              _lists.updateActiveLists('highs', Globals.bibleVersion);
            });
          });
        }
      }, //_deleteWrapper,
    );
  }

  void insertBookMark() {
    List<String> stringTitle = [
      Globals.versionAbbr,
      ' ',
      Globals.bookName,
      ' ',
      '${Globals.bookChapter}',
      ':',
      '${Globals.verseNumber}'
    ];

    final model = BmModel(
        title: stringTitle.join(),
        subtitle: Globals.verseText,
        lang: Globals.bibleLang,
        version: Globals.bibleVersion,
        abbr: Globals.versionAbbr,
        book: Globals.bibleBook,
        chapter: Globals.bookChapter,
        verse: Globals.verseNumber,
        name: Globals.bookName);
    _bmQueries.saveBookMark(model).then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(bookMarkSnackBar);
      },
    );
  }

  void insertHighLight(int bid) async {
    List<String> stringTitle = [
      Globals.versionAbbr,
      ' ',
      Globals.bookName,
      ' ',
      '${Globals.bookChapter}',
      ':',
      '${Globals.verseNumber}'
    ];

    final model = HlModel(
        title: stringTitle.join(),
        subtitle: Globals.verseText,
        lang: Globals.bibleLang,
        version: Globals.bibleVersion,
        abbr: Globals.versionAbbr,
        book: Globals.bibleBook,
        chapter: Globals.bookChapter,
        verse: Globals.verseNumber,
        name: Globals.bookName,
        bid: bid);

    _hlQueries.saveHighLight(model).then((value) {
      setState(() {
        _lists.updateActiveLists('highs', Globals.bibleVersion);
      });
    });
  }

  void saveNote(int bid) {
    List<String> stringTitle = [
      Globals.versionAbbr,
      ' ',
      Globals.bookName,
      ' ',
      '${Globals.bookChapter}',
      ':',
      '${Globals.verseNumber}'
    ];

    final model = NtModel(
        title: stringTitle.join(),
        contents: Globals.verseText,
        lang: Globals.bibleLang,
        version: Globals.bibleVersion,
        abbr: Globals.versionAbbr,
        book: Globals.bibleBook,
        chapter: Globals.bookChapter,
        verse: Globals.verseNumber,
        name: Globals.bookName,
        bid: bid);
    _ntQueries.insertNote(model).then((noteid) {
      setState(() {
        _lists.updateActiveLists('notes', Globals.bibleVersion);
      });
    });
  }

  void delayedSnackbar(context) {
    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        ScaffoldMessenger.of(context).showSnackBar(noteDeletedSnackBar);
      },
    );
  }

  void gotoEditNote(NtModel model) {
    Route route = MaterialPageRoute(
      builder: (context) => EditNotePage(model: model),
    );
    Navigator.push(context, route).then((value) {
      setState(() {});
      if (value == 'deleted') {
        delayedSnackbar(context);
      }
    });
  }

  // void delayedsetState() {
  //   Future.delayed(
  //     const Duration(milliseconds: 50),
  //     () {
  //       setState(() {});
  //     },
  //   );
  // }

  Future<NtModel> getNoteModel(int bid) async {
    NtModel model =
        NtModel(id: 0, title: 'no title', contents: 'not contents', bid: bid);
    List<NtModel> vars = await _ntQueries.getNoteByBid(bid);
    if ((vars.isNotEmpty)) {
      return NtModel(
          id: vars[0].id, // notes id
          title: vars[0].title,
          contents: vars[0].contents,
          bid: vars[0].bid // bible id
          );
    } else {
      return model;
    }
  }

  // void gotoCompare(Bible model) async {
  //   Route route = MaterialPageRoute(
  //     builder: (context) => mainCompareDialog(model: model),
  //   );
  //   Navigator.push(context, route);
  // }

  bool getNotesMatch(int bid) {
    bool match = false;
    if (GetLists.notesList.isNotEmpty) {
      for (int n = 0; n < GetLists.notesList.length; n++) {
        if (GetLists.notesList[n].bid == bid) {
          match = true;
        }
      }
    }
    return match;
  }

  bool getHighLightMatch(int bid) {
    bool match = false;
    if (GetLists.highsList.isNotEmpty) {
      for (int h = 0; h < GetLists.highsList.length; h++) {
        if (GetLists.highsList[h].bid == bid) {
          match = true;
        }
      }
    }
    return match;
  }

  Widget dicVerseText(snapshot, index) {
    if (snapshot.data[index].v != 0) {
      return WordSelectableText(
        selectable: true,
        highlight: true,
        text: "${snapshot.data[index].v}:  ${snapshot.data[index].t}",
        style: TextStyle(fontSize: primaryTextSize),
        onWordTapped: (word, index) {
          Globals.dictionaryLookup = word;
          dictDialog(context);
        },
      );
    } else {
      return const Text('  ');
    }
  }

  Widget dictionaryMode(snapshot, index) {
    return Container(
      margin: const EdgeInsets.only(left: 5, bottom: 6.0),
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: (dicVerseText(snapshot, index)),
          ),
        ],
      ),
    );
  }

  Widget norVerseText(snapshot, index) {
    if (snapshot.data[index].v != 0) {
      return Text("${snapshot.data[index].v}:  ${snapshot.data[index].t}",
          style: TextStyle(
              fontSize: primaryTextSize,
              backgroundColor: (getHighLightMatch(snapshot.data[index].id))
                  ? primarySwatch[100]
                  : null));
    } else {
      return const Text('  ');
    }
  }

  Widget normalModeContainer(snapshot, index) {
    return Container(
      margin: const EdgeInsets.only(left: 5, bottom: 6.0),
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: (norVerseText(snapshot, index)),
          ),
          showNoteIcon(snapshot, index)
        ],
      ),

      // child: Row(
      //   children: [
      //     (snapshot.data[index].v != 0)
      //         ? Text('${snapshot.data[index].v}:')
      //         : const Text(' '),
      //     Wrap(
      //       children: [
      //         Text(
      //           "${snapshot.data[index].t}",
      //           style: TextStyle(
      //               fontSize: primaryTextSize,
      //               backgroundColor:
      //                   (getHighLightMatch(snapshot.data[index].id))
      //                       ? primarySwatch[100]
      //                       : null),
      //         ),
      //       ],
      //     ),
      //     showNoteIcon(snapshot, index)
      //   ],
      // ),
    );
  }

  SizedBox showNoteIcon(snapshot, index) {
    if (getNotesMatch(snapshot.data[index].id)) {
      return SizedBox(
        height: 30,
        width: 30,
        child: IconButton(
          icon: Icon(Icons.edit, color: primarySwatch[700]),
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

  Widget normalMode(snapshot, index) {
    return GestureDetector(
      onTap: () {
        Globals.verseNumber = snapshot.data[index].v;
        Globals.verseText = snapshot.data[index].t;
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

                (Globals.activeVersionCount > 1)
                    ? mainCompareDialog(context,model)
                    : ScaffoldMessenger.of(context)
                        .showSnackBar(moreVersionsSnackBar);

                break;

              case 1: // bookmarks

                insertBookMark();

                break;

              case 2: // highlight

                int bid = snapshot.data[index].id;

                (!getHighLightMatch(bid))
                    ? insertHighLight(bid)
                    : deleteHighLightWrapper(context, bid);

                break;

              case 3: // notes

                int bid = snapshot.data[index].id;

                (!getNotesMatch(bid))
                    ? saveNote(bid)
                    // : ScaffoldMessenger.of(context)
                    //     .showSnackBar(noteEditSnackBar);
                    : getNoteModel(bid).then(
                        (model) {
                          gotoEditNote(model);
                        },
                      );

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

  Widget showListView(int book, int ch) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: FutureBuilder<List<Bible>>(
        future: getVersionText(book, ch),
        builder: (context, AsyncSnapshot<List<Bible>> snapshot) {
          if (snapshot.hasData) {
            return ScrollablePositionedList.builder(
              itemCount: snapshot.data.length,
              itemScrollController: itemScrollControllerSelector(),
              itemBuilder: (context, index) {
                return (Globals.dictionaryMode)
                    ? dictionaryMode(snapshot, index)
                    : normalMode(snapshot, index);
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  List<Widget> chapterCountFunc(int book, int chapterCount) {
    List<Widget> pagesList = [];
    for (int ch = 1; ch <= chapterCount; ch++) {
      pagesList.add(showListView(book, ch));
    }
    return pagesList;
  }

  Widget chaptersList(int book) {
    return FutureBuilder<int>(
      future: _dbQueries.getChapterCount(book),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.hasData) {
          int chapterCount = snapshot.data.toInt();
          return PageView(
            controller: pageController,
            scrollDirection: Axis.horizontal,
            pageSnapping: true,
            physics: const BouncingScrollPhysics(),
            children: chapterCountFunc(book, chapterCount),
            onPageChanged: (index) {
              int c = index + 1;
              _sharedPrefs.saveChapter(c).then(
                (value) {
                  Globals.bookChapter = c;
                  BlocProvider.of<ChapterCubit>(context).setChapter(c);
                },
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  // void getActiveVersionsCount() async {
  //   activeVersionsCount = await _vkQueries.getActiveVersionCount();
  // }

  void showVersionsDialog(BuildContext context) {
    (Globals.activeVersionCount > 1)
        ? versionsDialog(context,'main')
        : ScaffoldMessenger.of(context).showSnackBar(moreVersionsSnackBar);
  }

  Widget showDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: primarySwatch[500],
              // image: DecorationImage(
              //   fit: BoxFit.fill,
              //   image: AssetImage('path/to/header_background.png'),
              // ),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 12.0,
                  right: 16.0,
                  child: Text(
                    "Version 1.0",
                    style: TextStyle(
                        color: primarySwatch[900],
                        fontSize: 10.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Positioned(
                  bottom: 20.0,
                  left: 16.0,
                  child: Text(
                    "Biblia Sacra",
                    style: TextStyle(
                        color: primarySwatch[900],
                        fontSize: 32.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            trailing: Icon(Icons.arrow_right, color: primarySwatch[700]),
            title: const Text(
              'Bookmarks',
              style: TextStyle(
                  //color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BookMarksPage(),
                ),
              );
            },
          ),
          ListTile(
            trailing: Icon(Icons.arrow_right, color: primarySwatch[700]),
            title: const Text(
              'Highlights',
              style: TextStyle(
                  //color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);
              Route route = MaterialPageRoute(
                builder: (context) => const HighLightsPage(),
              );
              Navigator.push(context, route);
            },
          ),
          ListTile(
            trailing: Icon(Icons.arrow_right, color: primarySwatch[700]),
            title: const Text(
              'Notes',
              style: TextStyle(
                  //color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);
              Route route = MaterialPageRoute(
                builder: (context) => const NotesPage(),
              );
              Navigator.push(context, route);
            },
          ),
          ListTile(
            trailing: Icon(Icons.arrow_right, color: primarySwatch[700]),
            title: const Text(
              'Dictionary',
              style: TextStyle(
                  //color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);
              Route route = MaterialPageRoute(
                builder: (context) => const DictSearch(),
              );
              Navigator.push(context, route);
            },
          ),
          ListTile(
            trailing: Icon(Icons.arrow_right, color: primarySwatch[700]),
            title: const Text(
              'Search',
              style: TextStyle(
                  //color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);
              Route route = MaterialPageRoute(
                builder: (context) => const MainSearch(),
              );
              Navigator.push(context, route);
            },
          ),
          ListTile(
            trailing: Icon(Icons.arrow_right, color: primarySwatch[700]),
            title: const Text(
              'Bibles',
              style: TextStyle(
                  //color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);
              Route route = MaterialPageRoute(
                builder: (context) => const VersionsPage(),
              );
              Navigator.push(context, route);
            },
          ),
          ListTile(
            trailing: Icon(Icons.arrow_right, color: primarySwatch[700]),
            title: const Text(
              'Colors',
              style: TextStyle(
                  //color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);
              Route route = MaterialPageRoute(
                builder: (context) => const ColorsPage(),
              );
              Navigator.push(context, route).then((value) {
                setState(() {
                  primarySwatch = BlocProvider.of<PaletteCubit>(context).state;
                });
              });
            },
          ),
          ListTile(
            trailing: Icon(Icons.arrow_right, color: primarySwatch[700]),
            title: const Text(
              'Text Size',
              style: TextStyle(
                  //color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);
              Route route = MaterialPageRoute(
                builder: (context) => const TextSizePage(),
              );
              Navigator.push(context, route);
            },
          ),
        ],
      ),
    );
  }

  Padding iconButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: IconButton(
        color: (Globals.dictionaryMode) ? Colors.red : primarySwatch[700],
        icon: const Icon(Icons.change_circle),
        onPressed: () {
          Globals.dictionaryMode = (Globals.dictionaryMode) ? false : true;
          (Globals.dictionaryMode)
              ? ScaffoldMessenger.of(context).showSnackBar(dicModeOnSnackBar)
              : ScaffoldMessenger.of(context).showSnackBar(dicModeOffSnackBar);
          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _dbQueries = DbQueries();
    return WillPopScope(
      onWillPop: () => exitWrapper(context),
      child: Scaffold(
          drawer: showDrawer(context),
          appBar: AppBar(
            elevation: 16,
            actions: [
              (Globals.bibleLang == 'lat') ? iconButton() : Container(),
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primarySwatch[700]),
                    onPressed: () {
                      showVersionsDialog(context);
                    },
                    child: Text(
                      Globals.versionAbbr,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primarySwatch[700]),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainSelector(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '${Globals.bookName}: ',
                          style: const TextStyle(fontSize: 16),
                        ),
                        BlocBuilder<ChapterCubit, int>(
                          builder: (context, chapter) {
                            return Text(
                              chapter.toString(),
                              style: const TextStyle(fontSize: 16),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    // right side border width
                    width: 16,
                  ),
                ],
              ),
            ],
          ),
          body: chaptersList(Globals.bibleBook) //MainChapters(),
          ),
    );
  }
}
