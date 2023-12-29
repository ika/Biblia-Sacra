import 'package:bibliasacra/utils/utils_sharedprefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

SharedPrefs sharedPrefs = SharedPrefs();

// -------------------------------------------------
// Event
// -------------------------------------------------
@immutable
abstract class ChapterEvent {}

class GetChapter extends ChapterEvent {}

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

class GetChapterState extends ChapterState {
  GetChapterState({required super.chapter});
}

class UpdateChapterState extends ChapterState {
  UpdateChapterState({required super.chapter});
}

// -------------------------------------------------
// Bloc
// -------------------------------------------------
class ChapterBloc extends Bloc<ChapterEvent, ChapterState> {
  ChapterBloc() : super(GetChapterState(chapter: 1)) {
    
    on<GetChapter>((GetChapter event, Emitter<ChapterState> emit) async {
      sharedPrefs.getIntPref('chapter').then((value) {
        emit(GetChapterState(chapter: value ?? 1));
      });
    });

    on<UpdateChapter>((UpdateChapter event, Emitter<ChapterState> emit) async {
      sharedPrefs.setIntPref('chapter', event.chapter).then((value) {
        emit(UpdateChapterState(chapter: event.chapter));
      });
    });
  }
}
