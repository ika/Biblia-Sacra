import 'package:bibliasacra/colors/palette.dart';
import 'package:bibliasacra/cubit/paletteCubit.dart';
import 'package:bibliasacra/main/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

MaterialColor primarySwatch;

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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MainPage(),
      ),
    );
  }

  // static const Map colorsList = {
  //   'Pink': Palette.pinkPrimaryValue,
  //   'Red': Palette.redPrimaryValue,
  //   'DeepOrange': Palette.deepOrangePrimaryValue,
  //   'Orange': Palette.orangePrimaryValue,
  //   'Amber': Palette.amberPrimaryValue,
  //   'Yellow': Palette.yellowPrimaryValue,
  //   'Lime': Palette.limePrimaryValue,
  //   'LightGreen': Palette.lightGreenPrimaryValue,
  //   'Green': Palette.greenPrimaryValue,
  //   'Teal': Palette.tealPrimaryValue,
  //   'Cyan': Palette.cyanPrimaryValue,
  //   'LightBlue': Palette.lightBluePrimaryValue,
  //   'Blue': Palette.bluePrimaryValue,
  //   'Indego': Palette.indegoPrimaryValue,
  //   'Purple': Palette.purplePrimaryValue,
  //   'DeepPurple': Palette.deepPurplePrimaryValue,
  //   'BlueGrey': Palette.blueGreyPrimaryValue,
  //   'Brown': Palette.brownPrimaryValue,
  //   'Grey': Palette.greyPrimaryValue
  // };

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
          title: const Text('Color Selector'),
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
                    BlocProvider.of<PaletteCubit>(context)
                        .setPalette(Palette.colorsList.values.elementAt(i));
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.only(bottom: 8, left: 20, right: 20),
                    height: 55,
                    color: Palette.colorsList.values.elementAt(i),
                    child: Center(child: Text(Palette.colorsList.keys.elementAt(i),style: const TextStyle(fontSize: 18),)),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
