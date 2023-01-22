import 'package:bibliasacra/colors/palette.dart';
import 'package:bibliasacra/cubit/paletteCubit.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [],
        elevation: 16,
        title: const Text('Color Selector'),
        leading: GestureDetector(
            child: const Icon(Icons.arrow_back),
            onTap: () {
              Navigator.of(context).pop();
            }),
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
                  _sharedPrefs.saveColorListNumber(i);
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
