import 'package:bibliasacra/utils/utils_sharedprefs.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

SharedPrefs sharedPrefs = SharedPrefs();

@immutable
abstract class ThemeEvent {}

class InitialThemeSetEvent extends ThemeEvent {}

class ThemeSwitchEvent extends ThemeEvent {}

class ThemeState {
  final ThemeData themeData;

  ThemeState(this.themeData);

  static ThemeState get lightTheme => ThemeState(FlexThemeData.light(
        scheme: FlexScheme.amber,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 7,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 10,
          blendOnColors: false,
          useTextTheme: true,
          useM2StyleDividerInM3: true,
          alignedDropdown: true,
          useInputDecoratorThemeInDialogs: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: false,
        swapLegacyOnMaterial3: true,
        fontFamily: GoogleFonts.notoSans().fontFamily,
      ));

  static ThemeState get darkTheme => ThemeState(FlexThemeData.dark(
        scheme: FlexScheme.amber,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 13,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
          useTextTheme: true,
          useM2StyleDividerInM3: true,
          alignedDropdown: true,
          useInputDecoratorThemeInDialogs: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: false,
        swapLegacyOnMaterial3: true,
        fontFamily: GoogleFonts.notoSans().fontFamily,
      ));
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState.lightTheme) {

    on<InitialThemeSetEvent>((event, emit) async {
      final bool isDark = await sharedPrefs.getBoolPref('theme') ?? false;
      (isDark) ? emit(ThemeState.darkTheme) : emit(ThemeState.lightTheme);
    });

    on<ThemeSwitchEvent>((event, emit) async {
      final bool isDark = await sharedPrefs.getBoolPref('theme') ?? false;
      (isDark) ? emit(ThemeState.lightTheme) : emit(ThemeState.darkTheme);
      sharedPrefs.setBoolPref('theme', !isDark);
    });
  }
}
