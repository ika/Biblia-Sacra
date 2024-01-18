import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

// -------------------------------------------------
// Event
// -------------------------------------------------
@immutable
abstract class ItalicEvent {}

class ChangeItalic extends ItalicEvent {
  ChangeItalic(this.italicIsOn);
  final bool italicIsOn;
}

// -------------------------------------------------
// Bloc
// -------------------------------------------------
class ItalicBloc extends HydratedBloc<ItalicEvent, bool> {
  ItalicBloc() : super(false) {

    on<ChangeItalic>((event, emit) {
      emit(event.italicIsOn);
    });
  }

  @override
  bool? fromJson(Map<String, dynamic> json) => json['italic'] as bool;

  @override
  Map<String, dynamic>? toJson(bool state) => {'italic': state};
}