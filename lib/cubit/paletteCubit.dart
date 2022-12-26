import 'package:bibliasacra/colors/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaletteCubit extends Cubit<MaterialColor> {
  //final sharedPrefs = SharedPrefs();

  //Palette palette = Palette();

  PaletteCubit() : super(Palette.p1);

  void setPalette(MaterialColor p) => emit(p);

  void getPalette() async => emit(Palette.p1);
}
