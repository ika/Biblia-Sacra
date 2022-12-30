import 'package:bibliasacra/cubit/paletteCubit.dart';
import 'package:bibliasacra/cubit/textSizeCubit.dart';
import 'package:bibliasacra/main/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

MaterialColor primarySwatch;

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
        builder: (context) => const MainPage(),
      ),
    );
  }

  List<double> sizesList = [14, 16, 18, 20, 22, 24, 26, 28];

  void setTextSize(BuildContext context, int size) {
    switch (size) {
      case 14:
        BlocProvider.of<TextSizeCubit>(context).setSize(size.toDouble());
        break;
      case 16:
        BlocProvider.of<TextSizeCubit>(context).setSize(size.toDouble());
        break;
      case 18:
        BlocProvider.of<TextSizeCubit>(context).setSize(size.toDouble());
        break;
      case 20:
        BlocProvider.of<TextSizeCubit>(context).setSize(size.toDouble());
        break;
      case 22:
        BlocProvider.of<TextSizeCubit>(context).setSize(size.toDouble());
        break;
      case 24:
        BlocProvider.of<TextSizeCubit>(context).setSize(size.toDouble());
        break;
      case 26:
        BlocProvider.of<TextSizeCubit>(context).setSize(size.toDouble());
        break;
      case 28:
        BlocProvider.of<TextSizeCubit>(context).setSize(size.toDouble());
        break;
    }
    backButton(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        backButton(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: const [],
          elevation: 16,
          title: const Text('Text Size Selector'),
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
                    // debugPrint('text size ${sizesList[i]}');
                    setTextSize(context, sizesList[i].toInt());
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
