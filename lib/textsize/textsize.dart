import 'package:bibliasacra/cubit/SettingsCubit.dart';
import 'package:bibliasacra/cubit/textSizeCubit.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/main/mainPage.dart';
import 'package:bibliasacra/utils/sharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

MaterialColor? primarySwatch;
SharedPrefs sharedPrefs = SharedPrefs();

class TextSizePage extends StatefulWidget {
  const TextSizePage({Key? key}) : super(key: key);

  @override
  State<TextSizePage> createState() => _TextSizePageState();
}

class _TextSizePageState extends State<TextSizePage> {
  @override
  void initState() {
    primarySwatch =
        BlocProvider.of<SettingsCubit>(context).state.themeData.primaryColor as MaterialColor?;
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

  List<double> sizesList = [14, 16, 18, 20, 22, 24, 26, 28];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [],
        leading: GestureDetector(
          child: const Icon(Globals.backArrow),
          onTap: () {
            backButton(context);
          },
        ),
        elevation: 16,
        title: Text(
          'Text Size Selector',
          style: TextStyle(fontSize: Globals.appBarFontSize),
        ),
      ),
      body: Center(
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            for (int i = 0; i < sizesList.length; i++)
              InkWell(
                onTap: () {
                  double tsize = sizesList[i].toDouble();
                  sharedPrefs.setDoublePref('textSize', tsize).then((value) {
                    BlocProvider.of<TextSizeCubit>(context).setSize(tsize);
                    backButton(context);
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8, left: 20, right: 20),
                  height: 55,
                  color: primarySwatch![300],
                  child: Center(
                    child: Text(
                      'In the beginning',
                      style: TextStyle(fontSize: sizesList[i]),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
