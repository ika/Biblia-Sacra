import 'package:bibliasacra/bloc/bloc_book.dart';
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
            height: 300, //Globals.dialogHeight,
            width: MediaQuery.of(context).size.width,
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

backToMainButton(BuildContext context) {
  Route route = MaterialPageRoute(
    builder: (context) => const MainPage(),
  );
  Future.delayed(
    Duration(milliseconds: Globals.navigatorDelay),
    () {
      Navigator.push(context, route);
    },
  );
}

// void backToSearchButton(BuildContext context) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => const MainSearch(),
//     ),
//   );
//   //Navigator.pop(context);
// }

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
  // @override
  // void initState() {
  //   super.initState();

  //   WidgetsBinding.instance.addPostFrameCallback(
  //     (_) {
  //       bibleBook = context.read<BookBloc>().state.book;
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    bibleBook = context.read<BookBloc>().state;
    bibleVersion = context.read<VersionBloc>().state;
    versionAbbr = Utilities(bibleVersion).getVersionAbbr();

    return FutureBuilder<List<VkModel>>(
      future: VkQueries().getActiveVersions(bibleVersion),
      builder: (BuildContext context, AsyncSnapshot<List<VkModel>> snapshot) {
        int len = (snapshot.data != null) ? snapshot.data!.length : 0;
        return ListView.separated(
          itemCount: len,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              trailing: Icon(Icons.arrow_right,
                  color: Theme.of(context).colorScheme.primary),
              title: Text(
                snapshot.data![index].m!,
              ),
              onTap: () {
                //_lists.updateActiveLists(snapshot.data![index].n!);

                //Globals.bibleLang = snapshot.data![index].l!;
                //Globals.bibleVersion = snapshot.data![index].n!;
                versionAbbr = snapshot.data![index].r!;
                //Globals.chapterVerse = 0; //reset verse number

                Globals.dictionaryMode = false;

                Globals.listReadCompleted = false;

                //sharedPrefs.setStringPref('language', Globals.bibleLang);
                //sharedPrefs.setIntPref('version', Globals.bibleVersion);
                //sharedPrefs.setStringPref('verabbr', versionAbbr);

                context
                    .read<VersionBloc>()
                    .add(UpdateVersion(bibleVersion: snapshot.data![index].n!));

                backToMainButton(context);

                // (returnPath == 'main')
                //     ? backToMainButton(context)
                //     : backToSearchButton(context);
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        );
      },
    );
  }
}
