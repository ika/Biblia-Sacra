import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

// bloc_book.dart

// -------------------------------------------------
// Event
// -------------------------------------------------
@immutable
abstract class BookEvent {}

class UpdateBook extends BookEvent {
  UpdateBook({required this.book});
  final int book;
}

// -------------------------------------------------
// Bloc
// -------------------------------------------------
class BookBloc extends HydratedBloc<BookEvent, int> {
  BookBloc() : super(43) {
    on<UpdateBook>((event, emit) {
      emit(event.book);
    });
  }

  @override
  int? fromJson(Map<String, dynamic> json) => json['book'] as int;

  @override
  Map<String, dynamic>? toJson(int state) => {'book': state};
}
