import 'package:bibliasacra/cubit/SettingsCubit.dart';
import 'package:bibliasacra/cubit/chaptersCubit.dart';
import 'package:bibliasacra/cubit/textSizeCubit.dart';
import 'package:bibliasacra/globals/write.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/main/mainPage.dart';
import 'package:bibliasacra/utils/dialogs.dart';
import 'package:bibliasacra/utils/getlists.dart';
import 'package:bibliasacra/utils/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:bibliasacra/bmarks/bmModel.dart';
import 'package:bibliasacra/bmarks/bmQueries.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Bookmarks

BmQueries _bmQueries = BmQueries();
Dialogs _dialogs = Dialogs();
GetLists _lists = GetLists();

MaterialColor primarySwatch;
double primaryTextSize;

class BookMarksPage extends StatefulWidget {
  const BookMarksPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BookMarkState();
}

class _BookMarkState extends State<BookMarksPage> {
  List<BmModel> list = List<BmModel>.empty();

  @override
  void initState() {
    primaryTextSize = BlocProvider.of<TextSizeCubit>(context).state;
    primarySwatch = BlocProvider.of<SettingsCubit>(context).state.themeData.primaryColor;
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
    _lists.updateActiveLists('all', model.version);
    writeVars(model).then((value) {
      backButton(context);
    });
  }

  deleteWrapper(context, list, index) {
    final buffer = <String>[list[index].title, "\n", list[index].subtitle];
    final sb = StringBuffer();
    sb.writeAll(buffer);

    var arr = List.filled(4, '');
    arr[0] = "Delete this Bookmark?";
    arr[1] = sb.toString();
    arr[2] = 'YES';
    arr[3] = 'NO';

    _dialogs.confirmDialog(context, arr).then(
      (value) {
        if (value == ConfirmAction.accept) {
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
            if (details.primaryVelocity > 0 || details.primaryVelocity < 0) {
              deleteWrapper(context, list, index);
            }
          },
          child: ListTile(
            trailing: Icon(Icons.arrow_right, color: primarySwatch[700]),
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
          list = snapshot.data;
          return bookMarksList(list, context);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
