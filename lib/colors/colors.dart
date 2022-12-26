import 'package:bibliasacra/colors/palette.dart';
import 'package:bibliasacra/cubit/paletteCubit.dart';
import 'package:bibliasacra/main/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

MaterialColor primarySwatch;

class ColorsPage extends StatelessWidget {
  ColorsPage({Key key}) : super(key: key);

  backButton(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MainPage(),
      ),
    );
  }

  final Map colorsList = {
    //'Blue': 0xff61afef,
    'Blue': Palette.bluePrimaryValue,
    'Cyan': Palette.cyanPrimaryValue,
    'Green': Palette.greenPrimaryValue,
    'Gray': Palette.grayPrimaryValue,
    'Magneta': Palette.magnetaPrimaryValue,
    'Orange': Palette.orangePrimaryValue,
    'Red': Palette.redPrimaryValue,
    'Yellow': Palette.yellowPrimaryValue
  };

  void setColorPalette(BuildContext context, String color) {
    switch (color) {
      case 'Blue':
        BlocProvider.of<PaletteCubit>(context).setPalette(Palette.p1);
        break;
      case 'Cyan':
        BlocProvider.of<PaletteCubit>(context).setPalette(Palette.p2);
        break;
      case 'Green':
        BlocProvider.of<PaletteCubit>(context).setPalette(Palette.p3);
        break;
      case 'Gray':
        BlocProvider.of<PaletteCubit>(context).setPalette(Palette.p4);
        break;
      case 'Magneta':
        BlocProvider.of<PaletteCubit>(context).setPalette(Palette.p5);
        break;
      case 'Orange':
        BlocProvider.of<PaletteCubit>(context).setPalette(Palette.p6);
        break;
      case 'Red':
        BlocProvider.of<PaletteCubit>(context).setPalette(Palette.p8);
        break;
      case 'Yellow':
        BlocProvider.of<PaletteCubit>(context).setPalette(Palette.p9);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    primarySwatch = BlocProvider.of<PaletteCubit>(context).state;
    return WillPopScope(
      onWillPop: () async {
        backButton(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: const [],
          elevation: 16,
          //backgroundColor: primarySwatch[700],
          title: const Text('Color Selector'),
        ),
        body: Center(
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              for (int i = 0; i < colorsList.length; i++)
                InkWell(
                  onTap: () {
                    setColorPalette(context, colorsList.keys.elementAt(i));
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.only(bottom: 8, left: 20, right: 20),
                    height: 55,
                    color: Color(colorsList.values.elementAt(i)),
                    child: Center(child: Text(colorsList.keys.elementAt(i))),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
