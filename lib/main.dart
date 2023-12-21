import 'dart:io';

import 'package:bibliasacra/bmarks/bm_page.dart';
import 'package:bibliasacra/cubit/cub_chapters.dart';
import 'package:bibliasacra/cubit/cub_search.dart';
import 'package:bibliasacra/dict/dict_page.dart';
import 'package:bibliasacra/globals/globs_main.dart';
import 'package:bibliasacra/high/hi_page.dart';
import 'package:bibliasacra/langs/lang_booklists.dart';
import 'package:bibliasacra/main/main_page.dart';
import 'package:bibliasacra/main/main_search.dart';
import 'package:bibliasacra/main/main_selector.dart';
import 'package:bibliasacra/main/search_areas.dart';
import 'package:bibliasacra/notes/no_page.dart';
import 'package:bibliasacra/utils/utils_getlists.dart';
import 'package:bibliasacra/utils/utils_sharedprefs.dart';
import 'package:bibliasacra/utils/utils_utilities.dart';
import 'package:bibliasacra/vers/vers_page.dart';
import 'package:bibliasacra/vers/vers_queries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

SharedPrefs _sharedPrefs = SharedPrefs();

void getActiveVersionsCount() async {
  Globals.activeVersionCount = await VkQueries().getActiveVersionCount();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  Utilities().getDialogeHeight();

  // _sharedPrefs.getIntPref('searchArea').then((p) {
  //   Globals.areaSearchTitle = areasList[p ?? 5]; // the Gospels
  _sharedPrefs.getIntPref('version').then(
    (a) {
      Globals.bibleVersion = a ?? 1;
      GetLists().updateActiveLists(Globals.bibleVersion);
      // language
      _sharedPrefs.getStringPref('language').then(
        (b) {
          Globals.bibleLang = b ?? 'eng';
          // version abbreviation
          _sharedPrefs.getStringPref('verabbr').then(
            (c) {
              Globals.versionAbbr = c ?? 'KVJ';
              // Book
              _sharedPrefs.getIntPref('book').then(
                (d) {
                  Globals.bibleBook = d ?? 43;
                  // Chapter
                  _sharedPrefs.getIntPref('chapter').then(
                    (e) {
                      Globals.bookChapter = e ?? 1;
                      // Verse
                      _sharedPrefs.getIntPref('verse').then((f) {
                        Globals.chapterVerse = f ?? 1;
                        // Book Name
                        BookLists().readBookName(Globals.bibleBook).then(
                          (g) {
                            Globals.bookName = g;
                            getActiveVersionsCount();
                            // _sharedPrefs
                            //     .getDoublePref('textSize')
                            //     .then((t) {
                            //   Globals.initialTextSize = t ?? 16;
                            //   _sharedPrefs
                            //       .getStringPref('fontSel')
                            //       .then((f) {
                            //     Globals.initialFont = f ?? 'Roboto';
                            //     getActiveVersionsCount();
                            //   });
                            // });
                            runApp(
                              const BibleApp(),
                            );
                          },
                        );
                      });
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

class BibleApp extends StatefulWidget {
  const BibleApp({super.key});

  @override
  State<BibleApp> createState() => _BibleAppState();
}

class _BibleAppState extends State<BibleApp> {
  ThemeMode themeMode = ThemeMode.light;
  bool useMaterial3 = false;
  MaterialColor useColor = Colors.blue;

  // AppBarTheme appBarTheme = AppBarTheme(
  //     backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
  //     // foregroundColor: Colors.amber[700],
  //     centerTitle: true);

  // DrawerThemeData drawerTheme =
  //     DrawerThemeData(backgroundColor: Colors.amber[200]);

  // ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
  //     style: ButtonStyle(
  //         backgroundColor: MaterialStatePropertyAll(Colors.amber[400])));

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
        debugShowCheckedModeBanner: false,
        title: 'Bible App',
        theme: ThemeData(
            colorSchemeSeed: useColor,
            brightness: Brightness.light,
            useMaterial3: useMaterial3),
        darkTheme: ThemeData(
            colorSchemeSeed: useColor,
            brightness: Brightness.dark,
            useMaterial3: useMaterial3),
        themeMode: themeMode,
        initialRoute: '/MainPage',
        routes: {
          '/MainPage': (context) => const MainPage(),
          '/MainSelector': (context) => const MainSelector(),
          '/MainSearch': (context) => const MainSearch(),
          '/DictSearch': (context) => const DictSearch(),
          '/BookMarksPage': (context) => const BookMarksPage(),
          '/HighLightsPage': (context) => const HighLightsPage(),
          '/NotesPage': (context) => const NotesPage(),
          '/VersionsPage': (context) => const VersionsPage()
        },
      ),
    );
  }
}
