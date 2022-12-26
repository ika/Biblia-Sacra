import 'dart:math';

import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/main/mainPage.dart';
import 'package:bibliasacra/vers/vkModel.dart';
import 'package:bibliasacra/utils/sharedPrefs.dart';
import 'package:bibliasacra/vers/vkQueries.dart';
import 'package:flutter/material.dart';

VkQueries _vkQueries = VkQueries(); // version key
SharedPrefs sharedPrefs = SharedPrefs();

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

  Future<String> readVersionKey(int v) async {
    List<VkModel> value = List<VkModel>.empty();
    value = await _vkQueries.getVersionKey(v);
    String r = value.first.r; // abbreviation
    return r;
  }

  Future<String> readVersionAbbr(int v) async {
    String verKeys = await readVersionKey(v);
    var vKeys = verKeys.split('|');
    String r = vKeys[0];
    return r;
  }

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
      const Duration(milliseconds: 750),
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
                int v = snapshot.data[index].n; // version
                String l = snapshot.data[index].l; // language
                sharedPrefs.saveLang(l).then(
                  (value) {
                    Globals.bibleLang = l;
                    sharedPrefs.saveVersion(v).then(
                      (value) async {
                        Globals.bibleVersion = v;
                        readVersionAbbr(v).then(
                          (r) {
                            sharedPrefs.saveVerAbbr(r).then(
                              (value) {
                                Globals.versionAbbr = r;
                                sharedPrefs
                                    .readBookName(Globals.bibleBook)
                                    .then(
                                  (value) {
                                    Globals.bookName = value;
                                    versionChangeSnackBar(
                                        context, snapshot.data[index].m);
                                  },
                                );
                              },
                            );
                          },
                        );
                        backButton(context);
                      },
                    );
                  },
                );
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(height: 2.0,),
        );
      },
    );
  }
}
