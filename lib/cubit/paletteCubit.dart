import 'package:bibliasacra/colors/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaletteCubit extends Cubit<MaterialColor> {
  //final sharedPrefs = SharedPrefs();

  static const MaterialColor initialColor = Palette.bluePrimaryValue;

  PaletteCubit() : super(initialColor);

  void setPalette(MaterialColor p) => emit(p);

  void getPalette() async => emit(initialColor);
}
