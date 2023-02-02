import 'package:bibliasacra/cubit/chaptersCubit.dart';
import 'package:bibliasacra/cubit/paletteCubit.dart';
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
            Globals.bibleLang = (b.isNotEmpty) ? b : 'eng';
            // version abbreviation
            _sharedPrefs.getStringPref('verabbr').then(
              (c) {
                Globals.versionAbbr = (c.isNotEmpty) ? c : 'KVJ';
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
                            Globals.chapterVerse = (f != null) ? f : 1;
                            // Book Name
                            bookLists.readBookName(Globals.bibleBook).then(
                              (g) {
                                Globals.bookName = g;
                                _sharedPrefs
                                    .getDoublePref('textSize')
                                    .then((t) {
                                  Globals.initialTextSize =
                                      (t != null) ? t : 16;
                                  getActiveVersionsCount();
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
        BlocProvider<PaletteCubit>(
          create: (context) => PaletteCubit()..getPalette(),
        ),
        BlocProvider<TextSizeCubit>(
          create: (context) => TextSizeCubit()..getSize(),
        )
      ],
      child: BlocBuilder<PaletteCubit, MaterialColor>(
        builder: ((context, palette) {
          return MaterialApp(
            title: 'Bible App',
            theme: ThemeData(
              primarySwatch: palette,
            ),
            home: const MainPage(),
          );
        }),
      ),
    );
  }
}
