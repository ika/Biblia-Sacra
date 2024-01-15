import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

// -------------------------------------------------
// Event
// -------------------------------------------------
@immutable
abstract class SearchEvent {}

class UpdateSearchArea extends SearchEvent {
  UpdateSearchArea({required this.area});
  final int area;
}

// -------------------------------------------------
// Bloc
// -------------------------------------------------
class SearchBloc extends HydratedBloc<SearchEvent, int> {
  SearchBloc() : super(5) {
    
    on<UpdateSearchArea>((event, emit) {
      emit(event.area);
    });
  }
  @override
  int? fromJson(Map<String, dynamic> json) => json['area'] as int;

  @override
  Map<String, dynamic>? toJson(int state) => {'area': state};
}
