import 'dart:io';
import 'package:flutter/material.dart';
import 'package:bibliasacra/cubit/cub_chapters.dart';
import 'package:bibliasacra/cubit/cub_search.dart';
import 'package:bibliasacra/globals/globs_main.dart';
import 'package:bibliasacra/langs/lang_booklists.dart';
import 'package:bibliasacra/main/main_page.dart';
import 'package:bibliasacra/utils/utils_getlists.dart';
import 'package:bibliasacra/utils/utils_sharedprefs.dart';
import 'package:bibliasacra/utils/utils_utilities.dart';
import 'package:bibliasacra/vers/vers_queries.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
  bool useMaterial3 = false;

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
        theme: FlexThemeData.light(
          scheme: FlexScheme.amber,
          surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
          blendLevel: 7,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 10,
            blendOnColors: false,
            useTextTheme: true,
            useM2StyleDividerInM3: true,
            alignedDropdown: true,
            useInputDecoratorThemeInDialogs: true,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: useMaterial3,
          swapLegacyOnMaterial3: true,
          // To use the Playground font, add GoogleFonts package and uncomment
          fontFamily: GoogleFonts.notoSans().fontFamily
        ),
        darkTheme: FlexThemeData.dark(
          scheme: FlexScheme.sanJuanBlue,
          surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
          blendLevel: 13,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 20,
            useTextTheme: true,
            useM2StyleDividerInM3: true,
            alignedDropdown: true,
            useInputDecoratorThemeInDialogs: true,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: useMaterial3,
          swapLegacyOnMaterial3: true,
          // To use the Playground font, add GoogleFonts package and uncomment
          fontFamily: GoogleFonts.notoSans().fontFamily,
        ),
// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
        themeMode: ThemeMode.system,

        home: const MainPage(),
      ),
    );
  }
}
