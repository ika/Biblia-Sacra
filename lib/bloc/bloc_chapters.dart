import 'package:bibliasacra/utils/utils_sharedprefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

SharedPrefs sharedPrefs = SharedPrefs();

// -------------------------------------------------
// Event
// -------------------------------------------------
@immutable
abstract class ChapterEvent {}

class InitiateChapter extends ChapterEvent {}

class UpdateChapter extends ChapterEvent {
  UpdateChapter({required this.chapter});
  final int chapter;
}

// -------------------------------------------------
// State
// -------------------------------------------------
class ChapterState {
  int chapter;
  ChapterState({required this.chapter});
}

class InitiateChapterState extends ChapterState {
  InitiateChapterState({required super.chapter});
}

class UpdateChapterState extends ChapterState {
  UpdateChapterState({required super.chapter});
}

// -------------------------------------------------
// Bloc
// -------------------------------------------------
class ChapterBloc extends Bloc<ChapterEvent, ChapterState> {
  ChapterBloc() : super(InitiateChapterState(chapter: 1)) {
    on<InitiateChapter>((InitiateChapter event, Emitter<ChapterState> emit) {
      sharedPrefs.getChapterPref().then((value) {
        emit(InitiateChapterState(chapter: value));
      });
    });

    on<UpdateChapter>((UpdateChapter event, Emitter<ChapterState> emit) {
      sharedPrefs.setChapterPref(event.chapter);
      emit(UpdateChapterState(chapter: event.chapter));
    });
  }
}
