import 'dart:io';
import 'package:bibliasacra/bloc/bloc_book.dart';
import 'package:bibliasacra/bloc/bloc_font.dart';
import 'package:bibliasacra/bloc/bloc_italic.dart';
import 'package:bibliasacra/bloc/bloc_verse.dart';
import 'package:bibliasacra/bloc/bloc_version.dart';
import 'package:bibliasacra/bloc/bloc_themedata.dart';
import 'package:bibliasacra/theme/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:bibliasacra/bloc/bloc_chapters.dart';
import 'package:bibliasacra/bloc/bloc_search.dart';
import 'package:bibliasacra/main/main_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory(),
    );
  }

  runApp(
    const BibleApp(),
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
        BlocProvider<ItalicBloc>(create: (context) => ItalicBloc()),
        BlocProvider<FontBloc>(create: (context) => FontBloc()),
        BlocProvider<ThemeBloc>(create: (context) => ThemeBloc()),
        BlocProvider<SearchBloc>(create: (context) => SearchBloc()),
        BlocProvider<VersionBloc>(create: (context) => VersionBloc()),
        BlocProvider<BookBloc>(create: (context) => BookBloc()),
        BlocProvider<ChapterBloc>(create: (context) => ChapterBloc()),
        BlocProvider<VerseBloc>(create: (context) => VerseBloc()),
      ],
      child: BlocBuilder<ThemeBloc, bool>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Bible App',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: state ? ThemeMode.light : ThemeMode.dark,
            home: const MainPage(),
          );
        },
      ),
    );
  }
}
