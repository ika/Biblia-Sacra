import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

// bloc_chapters.dart

// -------------------------------------------------
// Event
// -------------------------------------------------
@immutable
abstract class ChapterEvent {}

class UpdateChapter extends ChapterEvent {
  UpdateChapter({required this.chapter});
  final int chapter;
}

// -------------------------------------------------
// Bloc
// -------------------------------------------------
class ChapterBloc extends HydratedBloc<ChapterEvent, int> {
  ChapterBloc() : super(1) {
    on<UpdateChapter>((event, emit) {
      emit(event.chapter);
    });
  }

  @override
  int? fromJson(Map<String, dynamic> json) => json['chapter'] as int;

  @override
  Map<String, dynamic>? toJson(int state) => {'chapter': state};
}
