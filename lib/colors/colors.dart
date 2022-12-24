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
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: colorsList.length,
            itemBuilder: (BuildContext context, index) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 5, left: 20, right: 20),
                  color: Color(colorsList.values.elementAt(index)),
                  child: ListTile(
                    title: Center(
                      child: Text(colorsList.keys.elementAt(index),
                          style: const TextStyle(color: Colors.white)),
                    ),
                    onTap: () {
                      debugPrint(colorsList.keys.elementAt(index));
                    },
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
