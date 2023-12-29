import 'dart:io';
import 'package:bibliasacra/bloc/bloc_globals.dart';
import 'package:bibliasacra/cubit/cub_themedata.dart';
import 'package:flutter/material.dart';
import 'package:bibliasacra/cubit/cub_chapters.dart';
import 'package:bibliasacra/cubit/cub_search.dart';
import 'package:bibliasacra/globals/globs_main.dart';
import 'package:bibliasacra/langs/lang_booklists.dart';
import 'package:bibliasacra/main/main_page.dart';
import 'package:bibliasacra/utils/utils_sharedprefs.dart';
import 'package:bibliasacra/utils/utils_utilities.dart';
import 'package:bibliasacra/vers/vers_queries.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// https://rydmike.com/flexcolorscheme/themesplayground-latest/

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

  // _sharedPrefs.getIntPref('bibleVersion').then(
  //   (a) {
  //     Globals.bibleVersion = a ?? 1;
  //     GetLists().updateActiveLists(Globals.bibleVersion);
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
              // Verse
              _sharedPrefs.getIntPref('verse').then((f) {
                Globals.chapterVerse = f ?? 1;
                // Book Name
                BookLists().readBookName(Globals.bibleBook).then(
                  (g) {
                    Globals.bookName = g;
                    getActiveVersionsCount();
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
  //   },
  // );
}

class BibleApp extends StatefulWidget {
  const BibleApp({super.key});

  @override
  State<BibleApp> createState() => _BibleAppState();
}

class _BibleAppState extends State<BibleApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChapterBloc>(
          create: (context) => ChapterBloc()..add(GetChapter()),
        ),
        BlocProvider<SearchBloc>(
          create: (context) => SearchBloc()..add(GetSearchArea()),
        ),
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc()..add(InitialThemeSetEvent()),
        ),
        BlocProvider<GlobalsBloc>(
          create: (context) => GlobalsBloc()..add(GetGlobals()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Bible App',
              theme: state.themeData,
              home: const MainPage(),
            );
        },
      ),
    );
  }
}
