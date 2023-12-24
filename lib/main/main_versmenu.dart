import 'package:bibliasacra/globals/globs_main.dart';
import 'package:bibliasacra/langs/lang_booklists.dart';
import 'package:bibliasacra/main/main_page.dart';
import 'package:bibliasacra/utils/utils_getlists.dart';
import 'package:bibliasacra/vers/vers_model.dart';
import 'package:bibliasacra/utils/utils_sharedprefs.dart';
import 'package:bibliasacra/vers/vers_queries.dart';
import 'package:flutter/material.dart';

VkQueries _vkQueries = VkQueries(); // version key
SharedPrefs sharedPrefs = SharedPrefs();
GetLists _lists = GetLists();
BookLists bookLists = BookLists();

String returnPath = 'main';

Future<dynamic> versionsDialog(BuildContext context, String ret) {
  returnPath = ret;
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return SimpleDialog(
        children: [
          SizedBox(
            height: Globals.dialogHeight,
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

class AppBarVersions extends StatelessWidget {
  const AppBarVersions({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<VkModel>>(
      future: _vkQueries.getActiveVersions(),
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
                _lists.updateActiveLists(snapshot.data![index].n!);

                Globals.bibleLang = snapshot.data![index].l!;
                Globals.bibleVersion = snapshot.data![index].n!;
                Globals.versionAbbr = snapshot.data![index].r!;
                //Globals.chapterVerse = 0; //reset verse number

                Globals.dictionaryMode = false;

                sharedPrefs.setStringPref('language', Globals.bibleLang);
                sharedPrefs.setIntPref('version', Globals.bibleVersion);
                sharedPrefs.setStringPref('verabbr', Globals.versionAbbr);

                bookLists.readBookName(Globals.bibleBook).then(
                  (value) {
                    Globals.bookName = value;
                    backToMainButton(context);
                  },
                );

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
