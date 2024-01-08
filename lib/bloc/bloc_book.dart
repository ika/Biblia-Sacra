import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

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
// class BookState {
//   BookState({required this.book});
//   int book;
// }

// class InitiateBookState extends BookState {
//   InitiateBookState({required super.book});
// }

// class UpdateBookState extends BookState {
//   UpdateBookState({required super.book});
// }

// -------------------------------------------------
// Bloc
// -------------------------------------------------
class BookBloc extends HydratedBloc<BookEvent, int> {
  BookBloc() : super(43) {
    // on<InitiateBook>((event, emit) {
    //   emit(state);
    // });

    on<UpdateBook>((event, emit) {
      emit(event.book);
    });
  }

  @override
  int? fromJson(Map<String, dynamic> json) => json['book'] as int;

  @override
  Map<String, dynamic>? toJson(int state) => {'book': state};
}
