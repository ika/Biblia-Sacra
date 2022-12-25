import 'package:bibliasacra/cubit/paletteCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

MaterialColor primarySwatch;

class ColorsPage extends StatelessWidget {
  ColorsPage({Key key}) : super(key: key);

  final Map colorsList = {
    'Blue': 0xff61afef,
    'Cyan': 0xff56b6c2,
    'Green': 0xff98C379,
    'Gray': 0xff3e4451,
    'Magneta': 0xffc678dd,
    'Orange': 0xffd19a66,
    'Red': 0xffe06c75,
    'Yellow': 0xffe5c07b
  };

  Widget makeContainers() {
    return Expanded(
      child: Container(
          height: 100,
          width: 100,
          color: Colors.green //colorsList.values.elementAt(1),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    primarySwatch = BlocProvider.of<PaletteCubit>(context).state;
    return Scaffold(
      appBar: AppBar(
        actions: const [],
        elevation: 16,
        backgroundColor: primarySwatch[700],
        title: const Text('Color Selector'),
      ),
      body: Center(
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            for (int i = 0; i < colorsList.length; i++)
              InkWell(
                onTap: () {
                  debugPrint('onTap');
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8,left: 20,right: 20),
                  height: 55,
                  color: Color(colorsList.values.elementAt(i)),
                  child: Center(child: Text(colorsList.keys.elementAt(i))),
                ),
              )

            //makeContainers()
          ],
        ),
      ),
    );
  }
}
