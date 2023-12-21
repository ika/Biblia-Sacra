import 'package:bibliasacra/cubit/cub_chapters.dart';
import 'package:bibliasacra/globals/globs_main.dart';
import 'package:bibliasacra/globals/globs_write.dart';
import 'package:bibliasacra/high/hl_model.dart';
import 'package:bibliasacra/high/hl_queries.dart';
import 'package:bibliasacra/utils/utils_getlists.dart';
import 'package:bibliasacra/utils/utils_snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Highlights

HlQueries _hlQueries = HlQueries();
GetLists _lists = GetLists();

double? primaryTextSize;

class HighLightsPage extends StatefulWidget {
  const HighLightsPage({super.key});

  @override
  State<StatefulWidget> createState() => _HighLightsPage();
}

class _HighLightsPage extends State<HighLightsPage> {
  List<HlModel> list = List<HlModel>.empty();

  @override
  void initState() {
    // primarySwatch = BlocProvider.of<SettingsCubit>(context)
    //     .state
    //     .themeData
    //     .primaryColor as MaterialColor?;
    primaryTextSize = Globals.initialTextSize;
    super.initState();
  }

  backButton(BuildContext context) {
    Future.delayed(
      Duration(milliseconds: Globals.navigatorDelay),
      () {
        Navigator.of(context).pushNamed('/MainPage');
        //Navigator.of(context).pop();
      },
    );
  }

  onHilightTap(WriteVarsModel model) {
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
    arr[0] = "Delete this Highlight?";
    arr[1] = sb.toString();

    confirmDialog(arr).then(
      (value) {
        if (value) {
          _hlQueries.deleteHighLight(list[index].bid).then(
            (value) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(hiLightDeletedSnackBar);
              _lists.updateActiveLists(list[index].version);
              setState(() {});
            },
          );
        }
      }, //_deleteWrapper,
    );
  }

  Widget highLightList(list, context) {
    GestureDetector makeListTile(list, int index) => GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) {
            if (details.primaryVelocity! > 0 || details.primaryVelocity! < 0) {
              deleteWrapper(context, list, index);
            }
          },
          child: ListTile(
            trailing: Icon(Icons.arrow_right,
                color: Theme.of(context).colorScheme.primary),
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
              onHilightTap(model);
            },
          ),
        );

    return Scaffold(
      //backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        //backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        leading: GestureDetector(
          child: const Icon(Globals.backArrow),
          onTap: () {
            backButton(context);
          },
        ),
        //elevation: 0.1,
        title: const Text(
          'Highlights',
          //style: TextStyle(fontSize: Globals.appBarFontSize),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: list == null ? 0 : list.length,
              itemBuilder: (BuildContext context, int index) {
                return makeListTile(list, index);
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HlModel>>(
      future: _hlQueries.getHighLightList(),
      builder: (context, AsyncSnapshot<List<HlModel>> snapshot) {
        if (snapshot.hasData) {
          list = snapshot.data!;
          return highLightList(list, context);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
