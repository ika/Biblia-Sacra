import 'package:bibliasacra/colors/palette.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsState {
  ThemeData themeData;
  SettingsState({this.themeData});

}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
      : super(
          SettingsState(
            themeData: ThemeData(
              fontFamily: Globals.initialFont,
              primarySwatch:
                  Palette.colorsList.values.elementAt(Globals.colorListNumber),
            ),
          ),
        );

  // static MaterialColor initialColor =
  //     Palette.colorsList.values.elementAt(Globals.colorListNumber);

  void setPalette(MaterialColor palette) => emit(
        SettingsState(
          themeData: ThemeData(
              fontFamily: Globals.initialFont, primarySwatch: palette),
        ),
      );

  void setFont(fontSel) => emit(
        SettingsState(
          themeData: ThemeData(
            fontFamily: fontSel,
            primarySwatch:
                Palette.colorsList.values.elementAt(Globals.colorListNumber),
          ),
        ),
      );
}
