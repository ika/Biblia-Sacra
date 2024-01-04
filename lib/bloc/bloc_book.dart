import 'package:bibliasacra/utils/utils_sharedprefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

SharedPrefs sharedPrefs = SharedPrefs();

// -------------------------------------------------
// Event
// -------------------------------------------------
@immutable
abstract class BookEvent {}

class InitiateBook extends BookEvent {}

class UpdateBook extends BookEvent {
  final int book;
  UpdateBook({required this.book});
}

class Loaded extends BookEvent {}

// -------------------------------------------------
// State
// -------------------------------------------------
class BookState {
  int book;
  BookState({required this.book});
}

class InitiateBookState extends BookState {
  InitiateBookState({required super.book});
}

class UpdateBookState extends BookState {
  UpdateBookState({required super.book});
}

// -------------------------------------------------
// Bloc
// -------------------------------------------------
class BookBloc extends Bloc<BookEvent, BookState> {
  BookBloc() : super(InitiateBookState(book: 43)) {
    on<InitiateBook>((InitiateBook event, Emitter<BookState> emit) async {
      sharedPrefs.getBookPref().then((value) {
        emit(InitiateBookState(book: value));
      });
    });

    on<UpdateBook>((UpdateBook event, Emitter<BookState> emit) {
      sharedPrefs.setBookPref(event.book);
      emit(UpdateBookState(book: event.book));
    });
  }
}
