import 'package:bibliasacra/cubit/chapters_cubit.dart';
import 'package:bibliasacra/cubit/search_cubit.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/main/mainPage.dart';
import 'package:bibliasacra/utils/sharedPrefs.dart';
import 'package:bibliasacra/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

SharedPrefs _sharedPrefs = SharedPrefs();
Utilities utilities = Utilities();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //utilities.getDialogeHeight();

  _sharedPrefs.readVersion().then(
    (a) {
      Globals.bibleVersion = a;
      // language
      _sharedPrefs.readLang().then(
        (b) {
          Globals.bibleLang = b;
          // version abbreviation
          _sharedPrefs.readVerAbbr().then(
            (c) {
              Globals.versionAbbr = c;
              // Book
              _sharedPrefs.readBook().then(
                (d) {
                  Globals.bibleBook = d;
                  // Chapter
                  _sharedPrefs.readChapter().then(
                    (e) {
                      Globals.bookChapter = e;
                      // Verse
                      _sharedPrefs.readVerse().then(
                        (f) {
                          Globals.chapterVerse = f;
                          // Book Name
                          _sharedPrefs.readBookName(Globals.bibleBook).then(
                            (g) {
                              Globals.bookName = g;
                              runApp(
                                const BibleApp(),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      );
    },
  );
}

class BibleApp extends StatelessWidget {
  const BibleApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChapterCubit>(
          create: (context) => ChapterCubit()..getChapter(),
        ),
        BlocProvider<SearchCubit>(
          create: (context) => SearchCubit()..getSearchAreaKey(),
        ),
      ],
      child: MaterialApp(
        title: 'Bible App',
        theme: ThemeData(
          primarySwatch: Colors.brown,
        ),
        home: const MainPage(),
      ),
    );
  }
}
