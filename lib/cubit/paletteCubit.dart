import 'package:bibliasacra/colors/palette.dart';
import 'package:bibliasacra/utils/sharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//int colorListId = 0;

// void readColorListId() async {
//   final sharedPrefs = SharedPrefs();
//   colorListId = await sharedPrefs.readColorsListNumber();
//   debugPrint('COLORLISTID ${colorListId.toString()}');
// }

class PaletteCubit extends Cubit<MaterialColor> {
  // SharedPrefs sharedPrefs = SharedPrefs();
  // final prefs = sharedPrefs.getIn

  // PaletteCubit(this.sharedPrefs) : super(Palette.colorsList.values.elementAt(sharedPrefs.));

  static MaterialColor initialColor = Palette.colorsList.values.elementAt(9);

  PaletteCubit() : super(initialColor);

  void setPalette(MaterialColor p) => emit(p);

  void getPalette() async => emit(initialColor);
}
