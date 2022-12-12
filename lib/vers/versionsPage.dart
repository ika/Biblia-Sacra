import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/main/dbQueries.dart';
import 'package:bibliasacra/utils/utilities.dart';
import 'package:bibliasacra/vers/vkModel.dart';
import 'package:bibliasacra/vers/vkQueries.dart';
import 'package:flutter/material.dart';

// Versions

VkQueries vkQueries = VkQueries();
Utilities utilities = Utilities();
DbQueries dbQueries = DbQueries();

int counter;

class VersionsPage extends StatefulWidget {
  const VersionsPage({Key key}) : super(key: key);

  @override
  VersionsPageState createState() => VersionsPageState();
}

class VersionsPageState extends State<VersionsPage> {
  @override
  void initState() {
    super.initState();
    counter = 0;
  }

  backButton(BuildContext context) {
    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        Navigator.pop(context);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const MainPage(),
        //   ),
        // );
      },
    );
  }

  Widget versionsWidget() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: FutureBuilder<List<VkModel>>(
        future: vkQueries.getAllVersions(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.trailing,
                  title: Text(
                    snapshot.data[index].m,
                  ),
                  value: snapshot.data[index].a == 1 ? true : false,
                  onChanged: (value) {
                    int active = value == true ? 1 : 0;
                    vkQueries
                        .updateActiveState(active, snapshot.data[index].n)
                        .then(
                      (value) async {
                        //utilities.getDialogeHeight();
                        setState(() {});
                      },
                    );
                  },
                );
              },
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
    return WillPopScope(
      onWillPop: () async {
        Globals.scrollToVerse = false;
        backButton(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: GestureDetector(
            onTap: () {
              counter++;
              if (counter > 4) {
                counter = 0;
                vkQueries.updateHiddenState().then((value) {
                  setState(() {});
                });
              }
            },
          ),
          elevation: 0.1,
          title: const Text('Bibles'),
        ),
        body: versionsWidget(),
      ),
    );
  }
}
