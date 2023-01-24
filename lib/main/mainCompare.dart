import 'package:bibliasacra/cubit/textSizeCubit.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/main/compare.dart';
import 'package:bibliasacra/main/dbModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Compare versions

Compare _compare = Compare();
double primaryTextSize;

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
    primaryTextSize = BlocProvider.of<TextSizeCubit>(context).state;
    super.initState();
  }

  Widget compareList(list, context) {
    makeListTile(list, int index) {
      return ListTile(
        //leading: Icon(Icons.arrow_right, color: primarySwatch[700]),
        // contentPadding:
        //     const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        title: Text(
          "${list[index].a} - ${list[index].b} ${list[index].c}:${list[index].v}",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: primaryTextSize),
        ),
        subtitle: Text(list[index].t, style: TextStyle(fontSize: primaryTextSize),),
      );
    }

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

    return Scaffold(
      appBar: AppBar(
      elevation: 0.1,
      title: const Text('Compare Versions'),
    ),
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
