import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/main/mainPage.dart';
import 'package:bibliasacra/utils/getlists.dart';
import 'package:bibliasacra/vers/vkModel.dart';
import 'package:bibliasacra/utils/sharedPrefs.dart';
import 'package:bibliasacra/vers/vkQueries.dart';
import 'package:flutter/material.dart';

VkQueries _vkQueries = VkQueries(); // version key
SharedPrefs sharedPrefs = SharedPrefs();
GetLists _lists = GetLists();

Future<dynamic> versionsDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return SimpleDialog(
        children: [
          SizedBox(
            height: Globals.dialogHeight,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
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
  const AppBarVersions({Key key}) : super(key: key);

  backButton(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MainPage(),
      ),
    );
  }

  void versionChangeSnackBar(BuildContext context, String snackBarText) {
    Future.delayed(
      const Duration(milliseconds: 800),
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
        int l = (snapshot.data != null) ? snapshot.data.length : 0;
        return ListView.separated(
          itemCount: l,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              trailing: const Icon(Icons.arrow_right),
              title: Text(
                snapshot.data[index].m,
              ),
              onTap: () {
                Globals.bibleLang = snapshot.data[index].l;
                Globals.bibleVersion = snapshot.data[index].n;
                Globals.versionAbbr = snapshot.data[index].r;

                sharedPrefs.saveLang(Globals.bibleLang);
                sharedPrefs.saveVersion(Globals.bibleVersion);
                sharedPrefs.saveVerAbbr(Globals.versionAbbr);

                Globals.dictionaryMode = false;

                _lists.updateActiveLists('all', Globals.bibleVersion);

                sharedPrefs.readBookName(Globals.bibleBook).then(
                  (value) {
                    Globals.bookName = value;
                    //Navigator.of(context).pop();
                    versionChangeSnackBar(context, snapshot.data[index].m);
                  },
                );

                backButton(context);
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
