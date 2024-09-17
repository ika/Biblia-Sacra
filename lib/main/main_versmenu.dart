import 'package:bibliasacra/bloc/bloc_book.dart';
import 'package:bibliasacra/bloc/bloc_verse.dart';
import 'package:bibliasacra/bloc/bloc_version.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/langs/lang_booklists.dart';
import 'package:bibliasacra/main/main_page.dart';
import 'package:bibliasacra/utils/utils_utilities.dart';
import 'package:bibliasacra/vers/vers_model.dart';
import 'package:bibliasacra/vers/vers_queries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

BookLists bookLists = BookLists();

String returnPath = 'main';
late int bibleBook;
late String versionAbbr;

Future<dynamic> versionsDialog(BuildContext context, String ret) {
  returnPath = ret;
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return SimpleDialog(
        children: [
          SizedBox(
            height: Globals.activeVersionCount! * 55,
            width: MediaQuery.of(context).size.width * .8,
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppBarVersions(),
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

class AppBarVersions extends StatefulWidget {
  const AppBarVersions({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AppBarVersionsPage();
}

void versionChangeSnackBar(BuildContext context, String snackBarText) {
  Future.delayed(
    Duration(milliseconds: Globals.navigatorLongestDelay),
    () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(snackBarText),
        ),
      );
    },
  );
}

class AppBarVersionsPage extends State<AppBarVersions> {

  @override
  Widget build(BuildContext context) {
    bibleBook = context.read<BookBloc>().state;
    bibleVersion = context.read<VersionBloc>().state;
    versionAbbr = Utilities(bibleVersion).getVersionAbbr();

    return FutureBuilder<List<VkModel>>(
      future: VkQueries().getActiveVersions(bibleVersion),
      builder: (BuildContext context, AsyncSnapshot<List<VkModel>> snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                trailing: Icon(Icons.arrow_right,
                    color: Theme.of(context).colorScheme.primary),
                title: Text(
                  snapshot.data![index].m!,
                ),
                onTap: () {
                  versionAbbr = snapshot.data![index].r!;

                  Globals.dictionaryMode = false;

                  //Globals.listReadCompleted = false;

                  context.read<VerseBloc>().add(UpdateVerse(verse: 1));

                  context.read<VersionBloc>().add(
                      UpdateVersion(bibleVersion: snapshot.data![index].n!));

                  Route route = MaterialPageRoute(
                    builder: (context) => const MainPage(),
                  );
                  Future.delayed(
                    Duration(milliseconds: Globals.navigatorDelay),
                    () {
                      Navigator.push(context, route);
                    },
                  );
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          );
        }
        return Container();
      },
    );
  }
}
