import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

// -------------------------------------------------
// Event
// -------------------------------------------------
@immutable
abstract class ThemeEvent {}

class InitiateTheme extends ThemeEvent {}

class ChangeTheme extends ThemeEvent {
  ChangeTheme(this.isDark);
  final bool isDark;
}

// -------------------------------------------------
// Bloc
// -------------------------------------------------
class ThemeBloc extends Bloc<ThemeEvent, ThemeMode> {
  ThemeBloc() : super(ThemeMode.light) {

    // on<InitiateTheme>((event, emit) {
    //   emit(state);
    // });

    on<ChangeTheme>((event, emit) {
      emit(event.isDark ? ThemeMode.light : ThemeMode.dark);
    });
  }

  // @override
  // ThemeMode? fromJson(Map<String, dynamic> json) => json['theme'] as ThemeMode;

  // @override
  // Map<String, dynamic>? toJson(ThemeMode state) => {'theme': state};
}
