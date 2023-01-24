import 'package:bibliasacra/cubit/paletteCubit.dart';
import 'package:bibliasacra/cubit/textSizeCubit.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/main/dbQueries.dart';
import 'package:bibliasacra/utils/utilities.dart';
import 'package:bibliasacra/vers/vkModel.dart';
import 'package:bibliasacra/vers/vkQueries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Versions

VkQueries vkQueries = VkQueries();
Utilities utilities = Utilities();
DbQueries dbQueries = DbQueries();

int counter = 0;

MaterialColor primarySwatch;
double primaryTextSize;

class VersionsPage extends StatefulWidget {
  const VersionsPage({Key key}) : super(key: key);

  @override
  VersionsPageState createState() => VersionsPageState();
}

class VersionsPageState extends State<VersionsPage> {
  @override
  void initState() {
    Globals.scrollToVerse = false;
    Globals.initialScroll = false;
    counter = 0;
    primarySwatch = BlocProvider.of<PaletteCubit>(context).state;
    primaryTextSize = BlocProvider.of<TextSizeCubit>(context).state;
    super.initState();
  }

  // backButton(BuildContext context) {
  //   Future.delayed(
  //     const Duration(milliseconds: 300),
  //     () {
  //       Navigator.pop(context);
  //       // Navigator.push(
  //       //   context,
  //       //   MaterialPageRoute(
  //       //     builder: (context) => const MainPage(),
  //       //   ),
  //       // );
  //     },
  //   );
  // }

  Widget versionsWidget() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: FutureBuilder<List<VkModel>>(
        future: vkQueries.getAllVersions(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  //controlAffinity: ListTileControlAffinity.trailing,
                  title: Text(
                    snapshot.data[index].m,
                    style: TextStyle(fontSize: primaryTextSize),
                  ),
                  value: snapshot.data[index].a == 1 ? true : false,
                  onChanged: (value) {
                    int active = value == true ? 1 : 0;
                    vkQueries
                        .updateActiveState(active, snapshot.data[index].n)
                        .then(
                      (value) async {
                        utilities.getDialogeHeight();
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
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: primarySwatch[700],
        // flexibleSpace: GestureDetector(
        //   onTap: () {
        //     counter++;
        //     if (counter > 4) {
        //       counter = 0;
        //       vkQueries.updateHiddenState().then((value) {
        //         setState(() {});
        //       });
        //     }
        //   },
        // ),
        elevation: 0.1,
        title: const Text('Bibles'),
      ),
      body: versionsWidget(),
    );
  }
}
