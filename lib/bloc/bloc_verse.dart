import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

// -------------------------------------------------
// Event
// -------------------------------------------------
@immutable
abstract class VerseEvent {}

class InitiateVerse extends VerseEvent {}

class UpdateVerse extends VerseEvent {
  final int verse;
  UpdateVerse({required this.verse});
}

// -------------------------------------------------
// State
// -------------------------------------------------
// class VerseState {
//   int verse;
//   VerseState({required this.verse});
// }

// class InitiateVerseState extends VerseState {
//   InitiateVerseState({required super.verse});
// }

// class UpdateVerseState extends VerseState {
//   UpdateVerseState({required super.verse});
// }

// -------------------------------------------------
// Bloc
// -------------------------------------------------
class VerseBloc extends HydratedBloc<VerseEvent, int> {
  VerseBloc() : super(1) {
    on<InitiateVerse>((event, emit) async {
      emit(state);
    });

    on<UpdateVerse>((event, emit) {
      emit(event.verse);
    });
  }

  @override
  int? fromJson(Map<String, dynamic> json) => json['verse'] as int;

  @override
  Map<String, dynamic>? toJson(int state) => {'verse': state};
}
