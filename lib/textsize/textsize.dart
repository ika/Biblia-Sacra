import 'package:bibliasacra/cubit/paletteCubit.dart';
import 'package:bibliasacra/cubit/textSizeCubit.dart';
import 'package:bibliasacra/main/mainPage.dart';
import 'package:bibliasacra/utils/sharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

MaterialColor primarySwatch;
SharedPrefs sharedPrefs = SharedPrefs();

class TextSizePage extends StatefulWidget {
  const TextSizePage({Key key}) : super(key: key);

  @override
  State<TextSizePage> createState() => _TextSizePageState();
}

class _TextSizePageState extends State<TextSizePage> {
  @override
  void initState() {
    primarySwatch = BlocProvider.of<PaletteCubit>(context).state;
    super.initState();
  }

  backButton(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainPage(initialScroll: false),
      ),
    );
  }

  List<double> sizesList = [14, 16, 18, 20, 22, 24, 26, 28];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => backButton(context),
      child: Scaffold(
        appBar: AppBar(
          actions: const [],
          elevation: 16,
          title: const Text(
            'Text Size Selector',
            style: TextStyle(fontSize: 20),
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
                    BlocProvider.of<TextSizeCubit>(context).setSize(tsize);
                    sharedPrefs.saveTextSize(tsize).then((value) {
                      backButton(context);
                    });
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.only(bottom: 8, left: 20, right: 20),
                    height: 55,
                    color: primarySwatch[300],
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
      ),
    );
  }
}
