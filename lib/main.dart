import 'package:bibliasacra/cubit/SettingsCubit.dart';
import 'package:bibliasacra/cubit/chaptersCubit.dart';
import 'package:bibliasacra/cubit/searchCubit.dart';
import 'package:bibliasacra/cubit/textSizeCubit.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/langs/bookLists.dart';
import 'package:bibliasacra/main/mainPage.dart';
import 'package:bibliasacra/utils/getlists.dart';
import 'package:bibliasacra/utils/sharedPrefs.dart';
import 'package:bibliasacra/utils/utilities.dart';
import 'package:bibliasacra/vers/vkQueries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:sqflite/sqflite.dart';
//import 'package:sqflite_common_ffi/sqflite_ffi.dart';

MaterialColor palette;

SharedPrefs _sharedPrefs = SharedPrefs();
Utilities utilities = Utilities();
GetLists _lists = GetLists();
VkQueries _vkQueries = VkQueries();
BookLists bookLists = BookLists();

void getActiveVersionsCount() async {
  Globals.activeVersionCount = await _vkQueries.getActiveVersionCount();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // if (Platform.isWindows || Platform.isLinux) {
  //   debugPrint('IS LINUX');
  //   sqfliteFfiInit();
  //   databaseFactory = databaseFactoryFfi;
  // }

  // sqfliteFfiInit();
  // databaseFactory = databaseFactoryFfi;

  utilities.getDialogeHeight();

  _sharedPrefs.getIntPref('colorsList').then((p) {
    Globals.colorListNumber = (p != null) ? p : 12;
    _sharedPrefs.getIntPref('version').then(
      (a) {
        Globals.bibleVersion = (a != null) ? a : 1;
        _lists.updateActiveLists('all', Globals.bibleVersion);
        // language
        _sharedPrefs.getStringPref('language').then(
          (b) {
            Globals.bibleLang = (b != null) ? b : 'eng';
            // version abbreviation
            _sharedPrefs.getStringPref('verabbr').then(
              (c) {
                Globals.versionAbbr = (c != null) ? c : 'KVJ';
                // Book
                _sharedPrefs.getIntPref('book').then(
                  (d) {
                    Globals.bibleBook = (d != null) ? d : 43;
                    // Chapter
                    _sharedPrefs.getIntPref('chapter').then(
                      (e) {
                        Globals.bookChapter = (e != null) ? e : 1;
                        // Verse
                        _sharedPrefs.getIntPref('verse').then(
                          (f) {
                            Globals.chapterVerse = (f != null) ? f : 0;
                            // Book Name
                            bookLists.readBookName(Globals.bibleBook).then(
                              (g) {
                                Globals.bookName = g;
                                _sharedPrefs
                                    .getDoublePref('textSize')
                                    .then((t) {
                                  Globals.initialTextSize =
                                      (t != null) ? t : 16;
                                  _sharedPrefs
                                      .getStringPref('fontSel')
                                      .then((f) {
                                    Globals.initialFont =
                                        (f != null) ? f : 'Roboto';
                                    getActiveVersionsCount();
                                  });
                                });
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
  });
}

String getFontFamily() {
  return 'Roboto';
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
        BlocProvider<TextSizeCubit>(
          create: (context) => TextSizeCubit()..getSize(),
        ),
        BlocProvider<SettingsCubit>(
          create: (context) => SettingsCubit(),
        )
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: ((context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Bible App',
            theme: state.themeData,
            home: const MainPage(),
          );
        }),
      ),
    );
  }
}
