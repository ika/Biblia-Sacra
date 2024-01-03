import 'dart:io';
import 'package:bibliasacra/bloc/bloc_book.dart';
import 'package:bibliasacra/bloc/bloc_verse.dart';
import 'package:bibliasacra/bloc/bloc_version.dart';
import 'package:bibliasacra/bloc/bloc_themedata.dart';
import 'package:flutter/material.dart';
import 'package:bibliasacra/bloc/bloc_chapters.dart';
import 'package:bibliasacra/bloc/bloc_search.dart';
import 'package:bibliasacra/globals/globs_main.dart';
import 'package:bibliasacra/main/main_page.dart';
import 'package:bibliasacra/utils/utils_sharedprefs.dart';
import 'package:bibliasacra/utils/utils_utilities.dart';
import 'package:bibliasacra/vers/vers_queries.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// https://rydmike.com/flexcolorscheme/themesplayground-latest/

SharedPrefs _sharedPrefs = SharedPrefs();

// void getActiveVersionsCount() async {
//   Globals.activeVersionCount = await VkQueries().getActiveVersionCount();
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // language
  _sharedPrefs.getStringPref('language').then(
    (b) {
      Globals.bibleLang = b ?? 'eng';
      // version abbreviation
      _sharedPrefs.getStringPref('verabbr').then(
        (c) {
          Globals.versionAbbr = c ?? 'KVJ';

          //getActiveVersionsCount();
          runApp(
            const BibleApp(),
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
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc()..add(InitiateTheme()),
        ),
        BlocProvider<SearchBloc>(
          create: (context) => SearchBloc()..add(InitiateSearchArea()),
        ),
        BlocProvider<VersionBloc>(
          create: (context) => VersionBloc()..add(InitiateVersion()),
        ),
        BlocProvider<BookBloc>(
          create: (context) => BookBloc()..add(InitiateBook()),
        ),
        BlocProvider<ChapterBloc>(
          create: (context) => ChapterBloc()..add(InitiateChapter()),
        ),
        BlocProvider<VerseBloc>(
          create: (context) => VerseBloc()..add(InitiateVerse()),
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
