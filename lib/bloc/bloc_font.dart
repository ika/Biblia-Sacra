import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

// bloc_font.dart

// -------------------------------------------------
// Event
// -------------------------------------------------
@immutable
abstract class FontEvent {}

class UpdateFont extends FontEvent {
  UpdateFont({required this.font});
  final int font;
}

// -------------------------------------------------
// Bloc
// -------------------------------------------------
class FontBloc extends HydratedBloc<FontEvent, int> {
  FontBloc() : super(7) {

    on<UpdateFont>((event, emit) {
      emit(event.font);
    });
  }

  @override
  int? fromJson(Map<String, dynamic> json) => json['font'] as int;

  @override
  Map<String, dynamic>? toJson(int state) => {'font': state};
}
