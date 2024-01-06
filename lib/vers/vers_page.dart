import 'package:bibliasacra/bloc/bloc_version.dart';
import 'package:bibliasacra/globals/globs_main.dart';
import 'package:bibliasacra/vers/vers_model.dart';
import 'package:bibliasacra/vers/vers_queries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Versions

late VkQueries vkQueries;
late int bibleVersion;
//DbQueries dbQueries = DbQueries();

int counter = 0;

//double? primaryTextSize;

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

  backButton(BuildContext context) {
    Future.delayed(
      Duration(milliseconds: Globals.navigatorDelay),
      () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget versionsWidget() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: FutureBuilder<List<VkModel>>(
        future: vkQueries.getAllVersions(),
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
    vkQueries = VkQueries(bibleVersion);
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
        title: const Text(
          'Bibles',
          // style: TextStyle(fontSize: Globals.appBarFontSize),
        ),
      ),
      body: versionsWidget(),
    );
  }
}
