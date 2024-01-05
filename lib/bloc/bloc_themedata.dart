import 'package:bibliasacra/utils/utils_sharedprefs.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

SharedPrefs sharedPrefs = SharedPrefs();

// -------------------------------------------------
// Event
// -------------------------------------------------
@immutable
abstract class ThemeEvent {}

class InitiateTheme extends ThemeEvent {}

class ChangeTheme extends ThemeEvent {
  ChangeTheme(this.themeData);
  final ThemeData themeData;
}

// -------------------------------------------------
// State
// -------------------------------------------------
class ThemeState {
  ThemeData themeData;
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

// -------------------------------------------------
// Bloc
// -------------------------------------------------
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState.lightTheme) {
    
    on<InitiateTheme>((event, emit) async {
      final bool isDark = await sharedPrefs.getThemePref();
      (isDark) ? emit : emit(ThemeState.lightTheme);
    });

    on<ChangeTheme>((event, emit) async {
      final bool isDark = await sharedPrefs.getThemePref();
      (isDark) ? emit(ThemeState.lightTheme) : emit(ThemeState.darkTheme);
      sharedPrefs.setThemePref(!isDark);
    });
  }
}
