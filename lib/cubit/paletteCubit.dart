import 'package:bibliasacra/colors/palette.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaletteCubit extends Cubit<MaterialColor> {
  static MaterialColor initialColor =
      Palette.colorsList.values.elementAt(Globals.colorListNumber);

  PaletteCubit() : super(initialColor);

  void setPalette(MaterialColor p) => emit(p);

  void getPalette() async => emit(initialColor);
}
