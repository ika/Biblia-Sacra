import 'package:bibliasacra/utils/utils_sharedprefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

SharedPrefs sharedPrefs = SharedPrefs();

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
class VerseState {
  int verse;
  VerseState({required this.verse});
}

class InitiateVerseState extends VerseState {
  InitiateVerseState({required super.verse});
}

class UpdateVerseState extends VerseState {
  UpdateVerseState({required super.verse});
}

// -------------------------------------------------
// Bloc
// -------------------------------------------------
class VerseBloc extends Bloc<VerseEvent, VerseState> {
  VerseBloc() : super(InitiateVerseState(verse: 1)) {

    on<InitiateVerse>((InitiateVerse event, Emitter<VerseState> emit) async {
      sharedPrefs.getVersePref().then((value) {
        //Globals.bibleBookChapter = value!;
        //debugPrint('InitiateChapter $value');
        emit(InitiateVerseState(verse: value!));
      });
    });

    on<UpdateVerse>((UpdateVerse event, Emitter<VerseState> emit) async {
      sharedPrefs.setVersePref(event.verse).then((v) {
        //Globals.bibleBookChapter = event.chapter;
        //debugPrint('UpdateChapter ${event.chapter}');
        emit(UpdateVerseState(verse: event.verse));
      });
    });
  }
}
