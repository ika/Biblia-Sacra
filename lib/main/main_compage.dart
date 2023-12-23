import 'package:bibliasacra/main/main_comp.dart';
import 'package:bibliasacra/main/db_model.dart';
import 'package:flutter/material.dart';

// Compare versions

Compare _compare = Compare();
//double? primaryTextSize;

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
    //primaryTextSize = Globals.initialTextSize;
    super.initState();
  }

  Widget compareList(list, context) {
    makeListTile(list, int index) {
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
    }

    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (BuildContext context, int index) {
        return makeListTile(list, index);
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CompareModel>>(
      future: _compare.activeVersions(widget.model),
      builder: (context, AsyncSnapshot<List<CompareModel>> snapshot) {
        if (snapshot.hasData) {
          list = snapshot.data!;
          return compareList(list, context);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
