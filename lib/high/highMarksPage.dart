import 'package:bibliasacra/cubit/chaptersCubit.dart';
import 'package:bibliasacra/cubit/paletteCubit.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/globals/write.dart';
import 'package:bibliasacra/high/hlModel.dart';
import 'package:bibliasacra/high/hlQueries.dart';
import 'package:bibliasacra/main/dbQueries.dart';
import 'package:bibliasacra/main/mainPage.dart';
import 'package:bibliasacra/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Highlights

HlQueries _hlQueries = HlQueries();
DbQueries _dbQueries = DbQueries();
Dialogs _dialogs = Dialogs();
MaterialColor primarySwatch;

class HighLightsPage extends StatefulWidget {
  const HighLightsPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HighLightsPage();
}

class _HighLightsPage extends State<HighLightsPage> {
  List<HlModel> list = List<HlModel>.empty();

  @override
  void initState() {
    Globals.scrollToVerse = false;
    Globals.initialScroll = false;
    primarySwatch = BlocProvider.of<PaletteCubit>(context).state;
    super.initState();
  }

  SnackBar hlDeletedSnackBar = const SnackBar(
    content: Text('HighLight Deleted!'),
  );

  // backPopButton(BuildContext context) {
  //   Future.delayed(
  //     const Duration(milliseconds: 200),
  //     () {
  //       Navigator.pop(context);
  //     },
  //   );
  // }

  backButton(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MainPage(),
      ),
    );
  }

  onHilightTap(WriteVarsModel model) {
    Globals.scrollToVerse = true;
    Globals.initialScroll = true;
    writeVars(model).then((value) {
      backButton(context);
    });
  }

  deleteWrapper(context, list, index) {
    final buffer = <String>[list[index].title, "\n", list[index].subtitle];
    final sb = StringBuffer();
    sb.writeAll(buffer);

    var arr = List.filled(4, '');
    arr[0] = "Delete this Highlight?";
    arr[1] = sb.toString();
    arr[2] = 'YES';
    arr[3] = 'NO';

    _dialogs.confirmDialog(context, arr).then(
      (value) {
        if (value == ConfirmAction.accept) {
          _hlQueries.deleteHighLight(list[index].id).then(
            (val) {
              _dbQueries.updateHighlightId(0, list[index].bid).then(
                (val) {
                  ScaffoldMessenger.of(context).showSnackBar(hlDeletedSnackBar);
                  setState(() {});
                },
              );
            },
          );
        }
      }, //_deleteWrapper,
    );
  }

  Widget highLightList(list, context) {
    GestureDetector makeListTile(list, int index) => GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) {
            if (details.primaryVelocity > 0 || details.primaryVelocity < 0) {
              deleteWrapper(context, list, index);
            }
          },
          child: ListTile(
            title: Text(
              list[index].title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(list[index]
                .subtitle), //, style: const TextStyle(color: Colors.white)),
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
              onHilightTap(model);
            },
          ),
        );

    // Card makeCard(list, int index) => Card(
    //       elevation: 8.0,
    //       margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
    //       child: Container(
    //         decoration: BoxDecoration(color: primarySwatch[500]),
    //         child: makeListTile(list, index),
    //       ),
    //     );

    final makeBody = Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 8),
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (BuildContext context, int index) {
          return makeListTile(list, index);
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );

    final topAppBar = AppBar(
      backgroundColor: primarySwatch[700],
      elevation: 0.1,
      title: const Text('Highlights'),
    );

    return Scaffold(
      //backgroundColor: primarySwatch[50],
      appBar: topAppBar,
      body: makeBody,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        backButton(context);
        return false;
      },
      child: FutureBuilder<List<HlModel>>(
        future: _hlQueries.getHighLightList(),
        builder: (context, AsyncSnapshot<List<HlModel>> snapshot) {
          if (snapshot.hasData) {
            list = snapshot.data;
            return highLightList(list, context);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
