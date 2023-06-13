import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/langs/bookLists.dart';
import 'package:bibliasacra/main/mainPage.dart';
import 'package:bibliasacra/utils/getlists.dart';
import 'package:bibliasacra/vers/vkModel.dart';
import 'package:bibliasacra/utils/sharedPrefs.dart';
import 'package:bibliasacra/vers/vkQueries.dart';
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
              padding: EdgeInsets.all(8.0),
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
              trailing: const Icon(Icons.arrow_right),
              title: Text(
                snapshot.data![index].m,
              ),
              onTap: () {
                _lists.updateActiveLists('all', snapshot.data![index].n);

                Globals.bibleLang = snapshot.data![index].l;
                Globals.bibleVersion = snapshot.data![index].n;
                Globals.versionAbbr = snapshot.data![index].r;
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
              const Divider(height: 2.0),
        );
      },
    );
  }
}
