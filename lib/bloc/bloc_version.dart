import 'package:bibliasacra/utils/utils_sharedprefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

SharedPrefs sharedPrefs = SharedPrefs();

// -------------------------------------------------
// Event
// -------------------------------------------------
@immutable
abstract class VersionEvent {}

class InitiateVersion extends VersionEvent {}

class UpdateVersion extends VersionEvent {
  final int bibleVersion;
  UpdateVersion({required this.bibleVersion});
}

// -------------------------------------------------
// State
// -------------------------------------------------
abstract class VersionState {
  int bibleVersion;
  VersionState({required this.bibleVersion});
}

class InitialVersionState extends VersionState {
  InitialVersionState({required super.bibleVersion});
}

class UpdateGlobalsState extends VersionState {
  UpdateGlobalsState({required super.bibleVersion});
}

// -------------------------------------------------
// Bloc
// -------------------------------------------------
class VersionBloc extends Bloc<VersionEvent, VersionState> {
  VersionBloc() : super(InitialVersionState(bibleVersion: 1)) {
    on<InitiateVersion>((InitiateVersion event, Emitter<VersionState> emit) async {
        emit(InitialVersionState(bibleVersion: await sharedPrefs.getVersionPref()));
    });

    on<UpdateVersion>((UpdateVersion event, Emitter<VersionState> emit) {
      sharedPrefs.setVersionPref(event.bibleVersion);
      emit(UpdateGlobalsState(bibleVersion: event.bibleVersion));
    });
  }
}
