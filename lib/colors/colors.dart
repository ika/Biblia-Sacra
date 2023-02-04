import 'package:bibliasacra/colors/palette.dart';
import 'package:bibliasacra/cubit/paletteCubit.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/main/mainPage.dart';
import 'package:bibliasacra/utils/sharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

MaterialColor primarySwatch;
SharedPrefs _sharedPrefs = SharedPrefs();

class ColorsPage extends StatefulWidget {
  const ColorsPage({Key key}) : super(key: key);

  @override
  State<ColorsPage> createState() => _ColorsPageState();
}

class _ColorsPageState extends State<ColorsPage> {
  @override
  void initState() {
    primarySwatch = BlocProvider.of<PaletteCubit>(context).state;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [],
        elevation: 16,
        title: Text(
          'Color Selector',
          style: TextStyle(fontSize: Globals.appBarFontSize),
        ),
        leading: GestureDetector(
          child: const Icon(Icons.arrow_back),
          onTap: () {
            backButton(context);
          },
        ),
      ),
      body: Center(
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            for (int i = 0; i < Palette.colorsList.length; i++)
              InkWell(
                onTap: () {
                  _sharedPrefs.setIntPref('colorsList', i);
                  BlocProvider.of<PaletteCubit>(context)
                      .setPalette(Palette.colorsList.values.elementAt(i));
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8, left: 20, right: 20),
                  height: 55,
                  color: Palette.colorsList.values.elementAt(i),
                  child: Center(
                      child: Text(
                    Palette.colorsList.keys.elementAt(i),
                    style: const TextStyle(fontSize: 18),
                  )),
                ),
              )
          ],
        ),
      ),
    );
  }
}
