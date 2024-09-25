import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

// bloc_verse.dart

// -------------------------------------------------
// Event
// -------------------------------------------------
@immutable
abstract class VerseEvent {}

class UpdateVerse extends VerseEvent {
  UpdateVerse({required this.verse});
  final int verse;
}

// -------------------------------------------------
// Bloc
// -------------------------------------------------
class VerseBloc extends HydratedBloc<VerseEvent, int> {
  VerseBloc() : super(1) {
    on<UpdateVerse>((event, emit) {
      emit(event.verse);
    });
  }

  @override
  int? fromJson(Map<String, dynamic> json) => json['verse'] as int;

  @override
  Map<String, dynamic>? toJson(int state) => {'verse': state};
}
