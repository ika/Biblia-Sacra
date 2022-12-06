import 'package:bibliasacra/cubit/chapters_cubit.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/globals/write.dart';
import 'package:bibliasacra/high/hlModel.dart';
import 'package:bibliasacra/high/hlQueries.dart';
import 'package:bibliasacra/main/dbQueries.dart';
import 'package:bibliasacra/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Highlights

HlQueries _hlQueries = HlQueries();
DbQueries _dbQueries = DbQueries();
Dialogs _dialogs = Dialogs();

class HighLightsPage extends StatefulWidget {
  const HighLightsPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HighLightsPage();
}

class _HighLightsPage extends State<HighLightsPage> {
  List<HlModel> list = List<HlModel>.empty();

  SnackBar hlDeletedSnackBar = const SnackBar(
    content: Text('HighLight Deleted!'),
  );

  backButton(BuildContext context) {
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        Navigator.pop(context);
      },
    );
  }

  // backButton(BuildContext context) {
  //   Future.delayed(
  //     const Duration(milliseconds: 200),
  //     () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const MainPage(),
  //         ),
  //       );
  //     },
  //   );
  // }

  onHilightTap(WriteVarsModel model) {
    writeVars(model).then((value) {
      backButton(context);
    });
  }

  deleteWrapper(context, list, index) {
    final buffer = <String>[list[index].title, "\n", list[index].subtitle];
    final sb = StringBuffer();
    sb.writeAll(buffer);

    var arr = List.filled(2, '');
    arr[0] = "Delete this Highlight?";
    arr[1] = sb.toString();

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
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            title: Text(
              list[index].title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Row(
              children: [
                const Icon(Icons.linear_scale, color: Colors.amber),
                Flexible(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    strutStyle: const StrutStyle(fontSize: 12.0),
                    text: TextSpan(
                        style: const TextStyle(color: Colors.white),
                        text: ' ${list[index].subtitle}'),
                  ),
                ),
              ],
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
              onHilightTap(model);
            },
          ),
        );

    Card makeCard(list, int index) => Card(
          elevation: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Container(
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.primary),
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
      elevation: 0.1,
      title: const Text('Highlights'),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: topAppBar,
      body: makeBody,
    );
  }

  @override
  Widget build(BuildContext context) {
    Globals.scrollToVerse = Globals.initialScroll = true;
    return WillPopScope(
      onWillPop: () async {
        Globals.scrollToVerse = false;
        Navigator.pop(context);
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
