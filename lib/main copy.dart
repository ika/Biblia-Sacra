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
import 'package:bibliasacra/notes/no_page.dart';
import 'package:bibliasacra/utils/utils_getlists.dart';
import 'package:bibliasacra/utils/utils_sharedprefs.dart';
import 'package:bibliasacra/utils/utils_utilities.dart';
import 'package:bibliasacra/vers/vers_page.dart';
import 'package:bibliasacra/vers/vers_queries.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:google_fonts/google_fonts.dart';

SharedPrefs _sharedPrefs = SharedPrefs();

void getActiveVersionsCount() async {
  Globals.activeVersionCount = await VkQueries().getActiveVersionCount();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Utilities().getDialogeHeight();

  _sharedPrefs.getIntPref('colorsList').then((p) {
    Globals.colorListNumber = p ?? 4; // Amber
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
  });
}

class BibleApp extends StatefulWidget {
  const BibleApp({super.key});

  @override
  State<BibleApp> createState() => _BibleAppState();
}

class _BibleAppState extends State<BibleApp> {
  // Used to select if we use the dark or light theme, start with system mode.
  ThemeMode themeMode = ThemeMode.light;
  // Opt in/out on Material 3
  bool useMaterial3 = true;

  @override
  Widget build(BuildContext context) {
    // Select the predefined FlexScheme color scheme to use. Modify the
    // used FlexScheme enum value below to try other pre-made color schemes.
    const FlexScheme usedScheme = FlexScheme.rosewood;
    const double appBarElevation = 0.5;
    const double appBarOpacity = 0.94;
    final String? fontFamily = GoogleFonts.notoSans().fontFamily;

    // DrawerThemeData drawerThemeData =
    //     const DrawerThemeData(backgroundColor: FlexColor.rosewoodLightPrimary);

    //AppBarTheme appBarTheme = const AppBarTheme(centerTitle: true);

    // final ColorScheme colorScheme = ColorScheme.fromSeed(
    //     brightness: MediaQuery.platformBrightnessOf(context),
    //     seedColor: Colors.blue);

    // ThemeData lightTheme = ThemeData(
    //   colorScheme: colorScheme,
    //   scaffoldBackgroundColor: Colors.grey[200],
    //   appBarTheme: AppBarTheme(
    //     backgroundColor: colorScheme.primary,
    //     centerTitle: true,
    //   ),
    //   fontFamily: GoogleFonts.notoSans().fontFamily,
    //   textTheme: const TextTheme(),
    // );

    //ThemeData darkTheme = ThemeData(colorScheme: colorScheme);

    return MultiBlocProvider(
      providers: [
        BlocProvider<ChapterCubit>(
          create: (context) => ChapterCubit()..getChapter(),
        ),
        // BlocProvider<SearchCubit>(
        //   create: (context) => SearchCubit()..getSearchAreaKey(),
        // ),
        // BlocProvider<TextSizeCubit>(
        //   create: (context) => TextSizeCubit()..getSize(),
        // ),
        // BlocProvider<SettingsCubit>(
        //   create: (context) => SettingsCubit(),
        // )
      ],
      // child: BlocBuilder<SettingsCubit, SettingsState>(
      //   builder: ((context, state) {
      //     return MaterialApp(
      //       debugShowCheckedModeBanner: false,
      //       title: 'Bible App',
      //       theme: state.themeData,
      //       home: const MainPage(),
      //     );
      //   }),
      // ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bible App',

        theme: FlexThemeData.light(
          scheme: usedScheme,
          useMaterial3: useMaterial3,
          fontFamily: fontFamily,
          appBarStyle: FlexAppBarStyle.primary,
          appBarElevation: appBarElevation,
          appBarOpacity: appBarOpacity,
          scaffoldBackground: Colors.grey[200],
          typography: Typography.material2021(platform: defaultTargetPlatform),
        ),
        // Same definition for the dark theme, but using FlexThemeData.dark().
        darkTheme: FlexThemeData.dark(
          scheme: usedScheme,
          useMaterial3: useMaterial3,
          fontFamily: fontFamily,
          typography: Typography.material2021(platform: defaultTargetPlatform),
        ),
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
