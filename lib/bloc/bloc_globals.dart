import 'dart:convert';

import 'package:bibliasacra/globals/globs_main.dart';
import 'package:bibliasacra/utils/utils_getlists.dart';
import 'package:bibliasacra/utils/utils_sharedprefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

SharedPrefs sharedPrefs = SharedPrefs();

// -------------------------------------------------
// Globals
// -------------------------------------------------

// class BlocGlobals {
//   int? bibleVersion;

//   BlocGlobals({required this.bibleVersion});
// }

// -------------------------------------------------
// Event
// -------------------------------------------------
@immutable
abstract class GlobalsEvent {}

class GetGlobals extends GlobalsEvent {}

class UpdateGlobals extends GlobalsEvent {
  final int bibleVersion;
  UpdateGlobals({required this.bibleVersion});
}

// -------------------------------------------------
// State
// -------------------------------------------------
abstract class GlobalsState {
  int bibleVersion;
  GlobalsState({required this.bibleVersion});
}

class GetGlobalsState extends GlobalsState {
  GetGlobalsState({required super.bibleVersion});
}

class UpdateGlobalsState extends GlobalsState {
  UpdateGlobalsState({required super.bibleVersion});
}

// -------------------------------------------------
// Bloc
// -------------------------------------------------
class GlobalsBloc extends Bloc<GlobalsEvent, GlobalsState> {
  GlobalsBloc() : super(GetGlobalsState(bibleVersion: 1)) {

    on<GetGlobals>((GetGlobals event, Emitter<GlobalsState> emit) async {
      sharedPrefs.getIntPref('bibleVersion').then((value) {
        value ??= 1;
        Globals.bibleVersion = value;
        emit(GetGlobalsState(bibleVersion: value));
      });
    });

    on<UpdateGlobals>((UpdateGlobals event, Emitter<GlobalsState> emit) async {
      sharedPrefs.setIntPref('bibleVersion', event.bibleVersion).then((value) {
        Globals.bibleVersion = event.bibleVersion;
        emit(UpdateGlobalsState(bibleVersion: event.bibleVersion));
      });
    });
  }
}
