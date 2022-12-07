import 'package:bibliasacra/colors/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaletteCubit extends Cubit<MaterialColor> {
  //final sharedPrefs = SharedPrefs();

  PaletteCubit() : super(Palette.p1);

//   void getState() => emit(state);

//   void setSearchAreaKey(int a) => emit(a);

  void getPalette() async => emit(Palette.p1);
 }
