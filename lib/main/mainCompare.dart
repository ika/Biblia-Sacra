import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/main/compare.dart';
import 'package:bibliasacra/main/dbModel.dart';
import 'package:flutter/material.dart';

// Compare versions

Compare _compare = Compare();

class ComparePage extends StatefulWidget {
  const ComparePage({Key key, this.model}) : super(key: key);

  final Bible model;

  @override
  State<StatefulWidget> createState() => _ComparePage();
}

class _ComparePage extends State<ComparePage> {
  List<CompareModel> list = List<CompareModel>.empty();

  @override
  void initState() {
    Globals.scrollToVerse = false;
    Globals.initialScroll = false;
    super.initState();
  }

  Widget compareList(list, context) {
    makeListTile(list, int index) {
      return ListTile(
        //leading: Icon(Icons.arrow_right, color: primarySwatch[700]),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        title: Text(
          "${list[index].a} - ${list[index].b} ${list[index].c}:${list[index].v}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(list[index].t),
        // return ListTile(
        //   contentPadding:
        //       const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        //   title: Text(
        //     "${list[index].a} - ${list[index].b} ${list[index].c}:${list[index].v}",
        //     style:
        //         const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        //   ),
        //   subtitle: Row(
        //     children: [
        //       Flexible(
        //         child: RichText(
        //           //overflow: TextOverflow.ellipsis,
        //           strutStyle: const StrutStyle(fontSize: 16.0),
        //           text: TextSpan(
        //               style: const TextStyle(color: Colors.white),
        //               text: '${list[index].t}'),
        //         ),
        //       ),
        //     ],
        //   ),
        // );
      );
    }

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
      title: const Text('Compare Versions'),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: topAppBar,
      body: makeBody,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CompareModel>>(
      future: _compare.activeVersions(widget.model),
      builder: (context, AsyncSnapshot<List<CompareModel>> snapshot) {
        if (snapshot.hasData) {
          list = snapshot.data;
          return compareList(list, context);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
