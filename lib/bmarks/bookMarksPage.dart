import 'package:bibliasacra/colors/palette.dart';
import 'package:bibliasacra/cubit/chaptersCubit.dart';
import 'package:bibliasacra/cubit/paletteCubit.dart';
import 'package:bibliasacra/globals/write.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/main/mainPage.dart';
import 'package:bibliasacra/utils/dialogs.dart';
import 'package:bibliasacra/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:bibliasacra/bmarks/bmModel.dart';
import 'package:bibliasacra/bmarks/bmQueries.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Bookmarks

BmQueries _bmQueries = BmQueries();
Dialogs _dialogs = Dialogs();
Utilities _utilities = Utilities();
MaterialColor primarySwatch;

class BookMarksPage extends StatefulWidget {
  const BookMarksPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BookMarkState();
}

class _BookMarkState extends State<BookMarksPage> {
  List<BmModel> list = List<BmModel>.empty();

  SnackBar bmDeletedSnackBar = const SnackBar(
    content: Text('Book Mark Deleted!'),
  );

  backPopButton(BuildContext context) {
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        Navigator.pop(context);
      },
    );
  }

  backButton(BuildContext context) {
    Future.delayed(
      const Duration(milliseconds: 200),
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
            leading: Icon(Icons.arrow_right, color: primarySwatch[700]),
            title: Text(
              list[index].title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(_utilities.reduceLength(40, list[index].subtitle)),
            // child: ListTile(
            //   contentPadding:
            //       const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            //   title: Text(
            //     list[index].title,
            //     style: const TextStyle(
            //         fontWeight: FontWeight.bold),
            //   ),
            //   subtitle: Row(
            //     children: [
            //       Icon(Icons.linear_scale, color: primarySwatch[700]),
            //       Flexible(
            //         child: RichText(
            //           overflow: TextOverflow.ellipsis,
            //           strutStyle: const StrutStyle(fontSize: 12.0),

            //           text: TextSpan(
            //               //style: TextStyle(color: primarySwatch[900]),
            //               text: ' ${list[index].subtitle}'),
            //         ),
            //       ),
            //     ],
            //   ),
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

    Card makeCard(list, int index) => Card(
          elevation: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Container(
            decoration: BoxDecoration(color: primarySwatch[500]),
            child: makeListTile(list, index),
          ),
        );

    final makeBody = ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (BuildContext context, int index) {
        return makeCard(list, index);
      },
    );

    final topAppBar = AppBar(
      backgroundColor: primarySwatch[500],
      elevation: 0.1,
      title: const Text('Bookmarks'),
    );

    return Scaffold(
      backgroundColor: primarySwatch[50],
      appBar: topAppBar,
      body: makeBody,
    );
  }

  @override
  Widget build(BuildContext context) {
    Globals.scrollToVerse = Globals.initialScroll = true;
    primarySwatch = BlocProvider.of<PaletteCubit>(context).state;
    return WillPopScope(
      onWillPop: () async {
        Globals.scrollToVerse = false;
        backPopButton(context);
        return false;
      },
      child: FutureBuilder<List<BmModel>>(
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
      ),
    );
  }
}
