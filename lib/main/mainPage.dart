import 'dart:async';

import 'package:bibliasacra/bmarks/bmModel.dart';
import 'package:bibliasacra/bmarks/bmQueries.dart';
import 'package:bibliasacra/bmarks/bookMarksPage.dart';
import 'package:bibliasacra/cubit/chapters_cubit.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/high/highMarksPage.dart';
import 'package:bibliasacra/high/hlModel.dart';
import 'package:bibliasacra/high/hlQueries.dart';
import 'package:bibliasacra/main/dbModel.dart';
import 'package:bibliasacra/main/dbQueries.dart';
import 'package:bibliasacra/main/mainContextMenu.dart';
import 'package:bibliasacra/main/mainVersMenu.dart';
import 'package:bibliasacra/main/mainSearch.dart';
import 'package:bibliasacra/main/mainSelector.dart';
import 'package:bibliasacra/notes/edit.dart';
import 'package:bibliasacra/notes/nModel.dart';
import 'package:bibliasacra/notes/nQueries.dart';
import 'package:bibliasacra/notes/notes.dart';
import 'package:bibliasacra/utils/dialogs.dart';
import 'package:bibliasacra/utils/sharedPrefs.dart';
import 'package:bibliasacra/utils/utilities.dart';
import 'package:bibliasacra/vers/versionsPage.dart';
import 'package:bibliasacra/main/mainCompare.dart';
import 'package:bibliasacra/vers/vkQueries.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

PageController pageController;
ItemScrollController initialScrollController;

DbQueries _dbQueries; // Bible
SharedPrefs _sharedPrefs = SharedPrefs();
BmQueries _bmQueries = BmQueries();
HlQueries _hlQueries = HlQueries();
NtQueries _ntQueries = NtQueries();
Utilities utilities = Utilities();
VkQueries vkQueries = VkQueries();
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

  FutureOr onReturnSetState() {
    setState(() {});
  }

  SnackBar textCopiedSnackBar = const SnackBar(
    content: Text('Text Copied!'),
  );

  SnackBar moreVersionsSnackBar = const SnackBar(
    content: Text('Activate more versions!'),
  );

  SnackBar bookMarkSnackBar = const SnackBar(
    content: Text('Book Mark Saved!'),
  );

  SnackBar hiLightExistsSnackBar = const SnackBar(
    content: Text('Verse is already highlighted!'),
  );

  SnackBar errorSnackBar = const SnackBar(
    content: Text('Error occured!'),
  );

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

  void exitWrapper(context) {
    var arr = List.filled(2, '');
    arr[0] = "Exit";
    arr[1] = "Are you sure you want to exit?";

    _dialogs.confirmDialog(context, arr).then(
      (value) {
        if (value == ConfirmAction.accept) {
          SystemNavigator.pop();
        }
      }, //_deleteWrapper,
    );
  }

  saveBookMark() {
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
        value != null
            ? ScaffoldMessenger.of(context).showSnackBar(bookMarkSnackBar)
            : ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
      },
    );
  }

  saveHighLight(int id, int h) {
    if (h == 0) {
      // if no hilight alredy exists
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
          bid: id);
      _hlQueries.saveHighLight(model).then(
        (h) {
          // h = highlight insert id
          // id = bible verse id
          _dbQueries.updateHighlightId(h, id).then((value) {
            // value = number of affected rows
            value == 1
                ? onReturnSetState()
                : ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
          });
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(hiLightExistsSnackBar);
    }
  }

  saveAndGotoNote(NtModel model) {
    _ntQueries.insertNote(model).then((noteid) {
      // returns insert id
      _dbQueries.updateNoteId(noteid, model.bid).then((value) {
        final mod = NtModel(
            id: noteid,
            title: model.title,
            contents: model.contents,
            bid: model.bid);
        //debugPrint("NOTE ID ${mod.id} BIBLE ID ${mod.bid}");
        gotoEditNote(mod);
      });
    });
  }

  gotoEditNote(NtModel model) {
    Route route = MaterialPageRoute(
      builder: (context) => EditNotePage(model: model),
    );
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        Navigator.push(context, route).then(
          (value) {
            onReturnSetState();
          },
        );
      },
    );
  }

  Future<NtModel> getNote(int id) async {
    NtModel model = await _ntQueries.getNoteById(id).then((vars) {
      final model = NtModel(
        id: vars[0].id, // notes id
        title: vars[0].title,
        contents: vars[0].contents,
        bid: vars[0].bid, // bible id
      );
      return model;
    });
    return model;
  }

  gotoCompare(Bible model) async {
    Route route = MaterialPageRoute(
      builder: (context) => ComparePage(model: model),
    );
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        Navigator.push(context, route);
      },
    );
  }

  selectBackground(snapshot, index) {
    if (snapshot.data[index].h != 0) {
      return Text(
        "${snapshot.data[index].t}",
        style: const TextStyle(
          fontSize: 16,
          backgroundColor: Colors.amberAccent,
        ),
      );
    } else {
      return Text(
        "${snapshot.data[index].t}",
        style: const TextStyle(fontSize: 16),
      );
    }
  }

  showVerse(snapshot, index) {
    // if (snapshot.data[index].n) {
    //   iconNote = const Icon(Icons.note_alt_outlined);
    // }
    return Container(
      margin: const EdgeInsets.only(bottom: 6.0),
      child: IntrinsicHeight(
        child: Row(
          //crossAxisAlignment: CrossAxisAlignment.stretch, not sure if this is necessary
          children: [
            Expanded(
              flex: 1,
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${snapshot.data[index].v}: '),
                ],
              ),
            ),
            Expanded(
              flex: 9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    children: [selectBackground(snapshot, index)],
                  ),
                ],
              ),
              //),
            ),
            showNoteIcon(snapshot, index)
          ],
        ),
      ),
    );
  }

  showNoteIcon(snapshot, index) {
    if (snapshot.data[index].n != 0) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: Icon(Icons.note_alt_outlined, size: 18.0),
      );
    } else {
      return const SizedBox(height: 20, width: 20);
    }
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
                                t: '',
                                h: 0,
                                n: 0,
                                m: 0);

                            vkQueries.getActiveVersionCount().then((value) => {
                                  if (value > 1)
                                    {gotoCompare(model)}
                                  else
                                    {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(moreVersionsSnackBar)
                                    }
                                });

                            break;

                          case 1: // copy

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
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(textCopiedSnackBar);
                            });

                            break;

                          case 2: // bookmarks
                            saveBookMark();
                            break;
                          case 3: // highlight
                            saveHighLight(snapshot.data[index].id,
                                snapshot.data[index].h);
                            break;
                          case 4: // notes

                            if (snapshot.data[index].n == 0) {
                              final buffer = <String>[
                                Globals.versionAbbr,
                                ' ',
                                Globals.bookName,
                                ' ',
                                snapshot.data[index].c.toString(),
                                ':',
                                snapshot.data[index].v.toString()
                              ];

                              final sb = StringBuffer();
                              sb.writeAll(buffer);

                              final model = NtModel(
                                  id: null,
                                  title: sb.toString(),
                                  contents: snapshot.data[index].t,
                                  bid: snapshot.data[index].id // bible id
                                  );
                              saveAndGotoNote(model);
                            } else {
                              getNote(snapshot.data[index].n).then((model) {
                                gotoEditNote(model);
                              });
                            }
                            break;
                          default:
                            break;
                        }
                      },
                    );
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: showVerse(snapshot, index),
                      ),
                    ],
                  ),
                );
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

  @override
  Widget build(BuildContext context) {
    pageController = PageController(initialPage: Globals.bookChapter - 1);
    _dbQueries = DbQueries();
    return WillPopScope(
      onWillPop: () async {
        exitWrapper(context);
        return false;
      },
      child: Scaffold(
          drawer: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                // DrawerHeader(
                //   decoration: BoxDecoration(
                //     color: Theme.of(context).colorScheme.primary,
                //   ),
                //   child: const Text('Drawer Header'),
                // ),
                DrawerHeader(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    // image: DecorationImage(
                    //   fit: BoxFit.fill,
                    //   image: AssetImage('path/to/header_background.png'),
                    // ),
                  ),
                  child: Stack(
                    children: const [
                      Positioned(
                        bottom: 12.0,
                        left: 16.0,
                        child: Text(
                          "Biblia Sacra",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: const Text('Bookmarks'),
                  onTap: () {
                    Navigator.pop(context);
                    Future.delayed(
                      const Duration(milliseconds: 200),
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BookMarksPage(),
                          ),
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  title: const Text('Highlights'),
                  onTap: () {
                    Navigator.pop(context);
                    Route route = MaterialPageRoute(
                      builder: (context) => const HighLightsPage(),
                    );
                    Future.delayed(
                      const Duration(milliseconds: 200),
                      () {
                        Navigator.push(context, route).then(
                          (value) {
                            onReturnSetState();
                          },
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  title: const Text('Notes'),
                  onTap: () {
                    Navigator.pop(context);
                    Future.delayed(
                      const Duration(milliseconds: 200),
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotesPage(),
                          ),
                        ).then((value) {
                          onReturnSetState();
                        });
                      },
                    );
                  },
                ),
                ListTile(
                  title: const Text('Search'),
                  onTap: () {
                    Navigator.pop(context);
                    Future.delayed(
                      const Duration(milliseconds: 200),
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainSearch(),
                          ),
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  title: const Text('Bible Versions'),
                  onTap: () {
                    Navigator.pop(context);
                    Future.delayed(
                      const Duration(milliseconds: 200),
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VersionsPage(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          appBar: AppBar(
            elevation: 16,
            actions: [
              Row(
                children: [
                  ElevatedButton(
                    //style: raisedButtonStyle,
                    onPressed: () async {
                      vkQueries.getActiveVersionCount().then(
                            (value) => {
                              if (value > 1)
                                {
                                  versionsDialog(context).then((value) {
                                    // doesn't work
                                    // ScaffoldMessenger.of(context)
                                    //     .showSnackBar(moreVersionsSnackBar);
                                  })
                                }
                              else
                                {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(moreVersionsSnackBar)
                                }
                            },
                          );
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
                    //style: raisedButtonStyle,
                    onPressed: () {
                      Future.delayed(
                        const Duration(milliseconds: 200),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainSelector(),
                            ),
                          );
                        },
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
