import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

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
// abstract class VersionState {
//   int bibleVersion;
//   VersionState({required this.bibleVersion});
// }

// class InitialVersionState extends VersionState {
//   InitialVersionState({required super.bibleVersion});
// }

// class UpdateGlobalsState extends VersionState {
//   UpdateGlobalsState({required super.bibleVersion});
// }

// -------------------------------------------------
// Bloc
// -------------------------------------------------
class VersionBloc extends HydratedBloc<VersionEvent, int> {
  VersionBloc() : super(1) {
    on<InitiateVersion>((event, emit) async {
      emit(state);
    });

    on<UpdateVersion>((event, emit) {
      emit(event.bibleVersion);
    });
  }

  @override
  int? fromJson(Map<String, dynamic> json) => json['bibleVersion'] as int;

  @override
  Map<String, dynamic>? toJson(int state) => {'bibleVersion': state};
}
