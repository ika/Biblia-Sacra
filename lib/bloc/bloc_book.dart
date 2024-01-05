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
  UpdateBook({required this.book});
  final int book;
}

// -------------------------------------------------
// State
// -------------------------------------------------
class BookState {
  BookState({required this.book});
  int book;
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
      emit(InitiateBookState(book: await sharedPrefs.getBookPref()));
    });

    on<UpdateBook>((UpdateBook event, Emitter<BookState> emit) {
      sharedPrefs.setBookPref(event.book);
      emit(UpdateBookState(book: event.book));
    });

    // on<UpdateBook>((UpdateBook event, Emitter<BookState> emit) {
    //   sharedPrefs.setBookPref(event.book).then((value) {
    //     emit(UpdateBookState(book: event.book));
    //   });
    // });
  }
}
