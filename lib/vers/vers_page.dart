import 'package:bibliasacra/bloc/bloc_version.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/vers/vers_model.dart';
import 'package:bibliasacra/vers/vers_queries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Versions

late VkQueries vkQueries;
late int bibleVersion;

int counter = 0;

class VersionsPage extends StatefulWidget {
  const VersionsPage({super.key});

  @override
  VersionsPageState createState() => VersionsPageState();
}

class VersionsPageState extends State<VersionsPage> {
  @override
  void initState() {
    counter = 0;
    super.initState();
  }

  Widget versionsWidget() {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: FutureBuilder<List<VkModel>>(
        future: vkQueries.getAllVersions(bibleVersion),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  //controlAffinity: ListTileControlAffinity.trailing,
                  title: Text(
                    snapshot.data![index].m!,
                    // style: TextStyle(fontSize: primaryTextSize),
                  ),
                  value: snapshot.data![index].a == 1 ? true : false,
                  onChanged: (value) {
                    int active = value == true ? 1 : 0;
                    vkQueries
                        .updateActiveState(active, snapshot.data![index].n!)
                        .then(
                      (value) async {
                        //Utilities(bibleVersion).getDialogeHeight();
                        Globals.activeVersionCount =
                            await vkQueries.getActiveVersionCount();
                        setState(() {});
                      },
                    );
                  },
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bibleVersion = context.read<VersionBloc>().state;
    vkQueries = VkQueries();
    return PopScope(
      canPop: false,
      child: Scaffold(
        //backgroundColor: Theme.of(
        appBar: AppBar(
          //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          centerTitle: true,
          elevation: 5,
          leading: GestureDetector(
            child: const Icon(Globals.backArrow),
            onTap: () {
              Future.delayed(
                Duration(milliseconds: Globals.navigatorDelay),
                () {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              );
            },
          ),
          title: const Text(
            'Bibles',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        body: versionsWidget(),
      ),
    );
  }
}
