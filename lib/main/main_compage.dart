import 'package:bibliasacra/bloc/bloc_version.dart';
import 'package:bibliasacra/main/main_model.dart';
import 'package:bibliasacra/main/main_queries.dart';
import 'package:bibliasacra/main/main_versmenu.dart';
import 'package:bibliasacra/vers/vers_queries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// main_compage.dart

late int bibleVersion;

class CompareModel {
  String a; // abbr
  String b; // book name
  int c; // chapter
  int v; // verse
  String t; // text

  CompareModel(
      {required this.a,
      required this.b,
      required this.c,
      required this.v,
      required this.t});
}

class Compare {
  Future<List<CompareModel>> activeVersions(Bible model) async {
    List<CompareModel> compareList = [];

    List activeVersions =
        await VkQueries().getActiveVersionNumbers(bibleVersion);

    for (int x = 0; x < activeVersions.length; x++) {
      int bibleVer = activeVersions[x]['number'];

      String bookName =
          bookLists.getBookByNumber(model.b!, activeVersions[x]['lang']);

      String abbr = activeVersions[x]['abbr'];

      List<Bible> verse =
          await DbQueries(bibleVer).getVerse(model.b!, model.c!, model.v!);

      abbr = (abbr.isNotEmpty) ? abbr : 'Unknown';
      bookName = (bookName.isNotEmpty) ? bookName : 'Unknown';

      int c = verse.first.c ?? 0;
      int v = verse.first.v ?? 0;
      String t = verse.first.t ?? 'Unknown';

      final cModel = CompareModel(a: abbr, b: bookName, c: c, v: v, t: t);

      compareList.add(cModel);
    }

    DbQueries(bibleVersion); // resotre version

    return compareList;
  }
}

Future<dynamic> mainCompareDialog(BuildContext context, Bible model) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return SimpleDialog(
        children: [
          SizedBox(
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ComparePage(model: model),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}

class ComparePage extends StatefulWidget {
  const ComparePage({super.key, required this.model});

  final Bible model;

  @override
  State<StatefulWidget> createState() => _ComparePage();
}

class _ComparePage extends State<ComparePage> {
  List<CompareModel> list = List<CompareModel>.empty();

  @override
  Widget build(BuildContext context) {
    bibleVersion = context.read<VersionBloc>().state;
    return FutureBuilder<List<CompareModel>>(
      future: Compare().activeVersions(widget.model),
      builder: (context, AsyncSnapshot<List<CompareModel>> snapshot) {
        if (snapshot.hasData) {
          list = snapshot.data!;
          //return compareList(list, context);
          return ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              //return makeListTile(list, index);
              return ListTile(
                title: Text(
                  "${list[index].a} - ${list[index].b} ${list[index].c}:${list[index].v}",
                ),
                subtitle: Text(
                  list[index].t,
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
