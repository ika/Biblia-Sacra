import 'package:bibliasacra/bloc/bloc_book.dart';
import 'package:bibliasacra/bloc/bloc_version.dart';
import 'package:bibliasacra/main/db_model.dart';
import 'package:bibliasacra/main/db_queries.dart';
import 'package:bibliasacra/main/main_versmenu.dart';
import 'package:bibliasacra/vers/vers_queries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Compare versions

late int bibleBook;
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

    List activeVersions = await VkQueries(bibleVersion).getActiveVersionNumbers();

    for (int x = 0; x < activeVersions.length; x++) {
      int bibleVersion = activeVersions[x]['number'];

      String bookName =
          bookLists.getBookByNumber(bibleBook, activeVersions[x]['lang']);

      String abbr = activeVersions[x]['abbr'];

      List<Bible> verse =
          await DbQueries(bibleVersion).getVerse(model.b!, model.c!, model.v!);

      abbr = (abbr.isNotEmpty) ? abbr : 'Unknown';
      bookName = (bookName.isNotEmpty) ? bookName : 'Unknown';

      int c = verse.first.c ?? 0;
      int v = verse.first.v ?? 0;
      String t = verse.first.t ?? 'Unknown';

      final cModel = CompareModel(a: abbr, b: bookName, c: c, v: v, t: t);

      compareList.add(cModel);
    }

    return compareList;
  }
}

Future<dynamic> mainCompareDialog(BuildContext context, Bible bible) {
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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ComparePage(model: bible),
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
  const ComparePage({Key? key, required this.model}) : super(key: key);

  final Bible model;

  @override
  State<StatefulWidget> createState() => _ComparePage();
}

class _ComparePage extends State<ComparePage> {
  List<CompareModel> list = List<CompareModel>.empty();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        bibleBook = context.read<BookBloc>().state;
        bibleVersion = context.read<VersionBloc>().state;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  // style:
                  //     TextStyle(fontWeight: FontWeight.bold, fontSize: primaryTextSize),
                ),
                subtitle: Text(
                  list[index].t,
                  // style: TextStyle(fontSize: primaryTextSize),
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
