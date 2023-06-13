import 'package:bibliasacra/cubit/cub_settings.dart';
import 'package:bibliasacra/cubit/cub_textsize.dart';
import 'package:bibliasacra/globals/globs_main.dart';
import 'package:bibliasacra/main/db_queries.dart';
import 'package:bibliasacra/main/main_page.dart';
import 'package:bibliasacra/utils/utils_utilities.dart';
import 'package:bibliasacra/vers/vers_model.dart';
import 'package:bibliasacra/vers/vers_queries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Versions

VkQueries vkQueries = VkQueries();
Utilities utilities = Utilities();
DbQueries dbQueries = DbQueries();

int counter = 0;

MaterialColor? primarySwatch;
double? primaryTextSize;

class VersionsPage extends StatefulWidget {
  const VersionsPage({Key? key}) : super(key: key);

  @override
  VersionsPageState createState() => VersionsPageState();
}

class VersionsPageState extends State<VersionsPage> {
  @override
  void initState() {
    counter = 0;
    primarySwatch = BlocProvider.of<SettingsCubit>(context).state.themeData.primaryColor as MaterialColor?;
    primaryTextSize = BlocProvider.of<TextSizeCubit>(context).state;
    super.initState();
  }

  backButton(BuildContext context) {
    Future.delayed(
      Duration(milliseconds: Globals.navigatorDelay),
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
        );
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
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  //controlAffinity: ListTileControlAffinity.trailing,
                  title: Text(
                    snapshot.data![index].m!,
                    style: TextStyle(fontSize: primaryTextSize),
                  ),
                  value: snapshot.data![index].a == 1 ? true : false,
                  onChanged: (value) {
                    int active = value == true ? 1 : 0;
                    vkQueries
                        .updateActiveState(active, snapshot.data![index].n!)
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
        elevation: 0.1,
        leading: GestureDetector(
          child: const Icon(Globals.backArrow),
          onTap: () {
            backButton(context);
          },
        ),
        title: Text(
          'Bibles',
          style: TextStyle(fontSize: Globals.appBarFontSize),
        ),
      ),
      body: versionsWidget(),
    );
  }
}
