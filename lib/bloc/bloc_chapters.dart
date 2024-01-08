import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

// -------------------------------------------------
// Event
// -------------------------------------------------
@immutable
abstract class ChapterEvent {}

// class InitiateChapter extends ChapterEvent {}

class UpdateChapter extends ChapterEvent {
  UpdateChapter({required this.chapter});
  final int chapter;
}

// -------------------------------------------------
// State
// -------------------------------------------------
// class ChapterState {
//   ChapterState({required this.chapter});
//     int chapter;
// }

// class InitiateChapterState extends ChapterState {
//   InitiateChapterState({required super.chapter});
// }

// class UpdateChapterState extends ChapterState {
//   UpdateChapterState({required super.chapter});
// }

// -------------------------------------------------
// Bloc
// -------------------------------------------------
class ChapterBloc extends HydratedBloc<ChapterEvent, int> {
  ChapterBloc() : super(1) {
    
    // on<InitiateChapter>((event, emit) {
    //   emit(state);
    // });

    on<UpdateChapter>((event, emit) {
      emit(event.chapter);
    });
  }

  @override
  int? fromJson(Map<String, dynamic> json) => json['chapter'] as int;

  @override
  Map<String, dynamic>? toJson(int state) => {'chapter': state};
}
