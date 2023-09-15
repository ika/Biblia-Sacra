import 'package:bibliasacra/cubit/cub_settings.dart';
import 'package:bibliasacra/cubit/cub_chapters.dart';
import 'package:bibliasacra/cubit/cub_textsize.dart';
import 'package:bibliasacra/globals/globs_write.dart';
import 'package:bibliasacra/globals/globs_main.dart';
import 'package:bibliasacra/main/main_page.dart';
import 'package:bibliasacra/utils/utils_getlists.dart';
import 'package:bibliasacra/utils/utils_snackbars.dart';
import 'package:flutter/material.dart';
import 'package:bibliasacra/bmarks/bm_model.dart';
import 'package:bibliasacra/bmarks/bm_queries.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Bookmarks

BmQueries _bmQueries = BmQueries();
GetLists _lists = GetLists();

MaterialColor? primarySwatch;
double? primaryTextSize;

class BookMarksPage extends StatefulWidget {
  const BookMarksPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BookMarkState();
}

class _BookMarkState extends State<BookMarksPage> {
  List<BmModel> list = List<BmModel>.empty();

  @override
  void initState() {
    primaryTextSize = BlocProvider.of<TextSizeCubit>(context).state;
    primarySwatch = BlocProvider.of<SettingsCubit>(context)
        .state
        .themeData
        .primaryColor as MaterialColor?;
    super.initState();
  }

  backButton(BuildContext context) {
    Future.delayed(
      Duration(milliseconds: Globals.navigatorDelay),
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
        );
      },
    );
  }

  onBookMarkTap(WriteVarsModel model) {
    _lists.updateActiveLists(model.version!);
    writeVars(model).then((value) {
      backButton(context);
    });
  }

  Future confirmDialog(arr) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(arr[0].toString()),
        content: Text(arr[1].toString()),
        actions: [
          TextButton(
            child:
                const Text('NO', style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('YES',
                style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }

  deleteWrapper(context, list, index) {
    final buffer = <String>[list[index].title, "\n", list[index].subtitle];
    final sb = StringBuffer();
    sb.writeAll(buffer);

    var arr = List.filled(2, '');
    arr[0] = "Delete this Bookmark?";
    arr[1] = sb.toString();

    confirmDialog(arr).then(
      (value) {
        if (value) {
          _bmQueries.deleteBookMark(list[index].id).then(
            (value) {
              ScaffoldMessenger.of(context).showSnackBar(bmDeletedSnackBar);
              setState(() {});
            },
          );
        }
      }, //_deleteWrapper,
    );
  }

  Widget bookMarksList(list, context) {
    GestureDetector makeListTile(list, int index) => GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) {
            if (details.primaryVelocity! > 0 || details.primaryVelocity! < 0) {
              deleteWrapper(context, list, index);
            }
          },
          child: ListTile(
            trailing: Icon(Icons.arrow_right, color: primarySwatch![700]),
            title: Text(
              list[index].title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: primaryTextSize),
            ),
            subtitle: Text(
              list[index].subtitle,
              style: TextStyle(fontSize: primaryTextSize),
            ),
            onTap: () {
              BlocProvider.of<ChapterCubit>(context)
                  .setChapter(list[index].chapter);

              final model = WriteVarsModel(
                lang: list[index].lang,
                version: list[index].version,
                abbr: list[index].abbr,
                book: list[index].book,
                chapter: list[index].chapter,
                verse: list[index].verse,
                name: list[index].name,
              );
              onBookMarkTap(model);
            },
          ),
        );

    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        leading: GestureDetector(
          child: const Icon(Globals.backArrow),
          onTap: () {
            backButton(context);
          },
        ),
        title: Text(
          'Bookmarks',
          style: TextStyle(fontSize: Globals.appBarFontSize),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 8),
        child: ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: list == null ? 0 : list.length,
          itemBuilder: (BuildContext context, int index) {
            return makeListTile(list, index);
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BmModel>>(
      future: _bmQueries.getBookMarkList(),
      builder: (context, AsyncSnapshot<List<BmModel>> snapshot) {
        if (snapshot.hasData) {
          list = snapshot.data!;
          return bookMarksList(list, context);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
