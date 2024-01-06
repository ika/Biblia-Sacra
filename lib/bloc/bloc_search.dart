import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

// -------------------------------------------------
// Event
// -------------------------------------------------
@immutable
abstract class SearchEvent {}

class InitiateSearchArea extends SearchEvent {}

class UpdateSearchArea extends SearchEvent {
  UpdateSearchArea({required this.area});
  final int area;
}

// -------------------------------------------------
// State
// -------------------------------------------------
// class SearchState {
//   int area;
//   SearchState({required this.area});
// }

// class InitiateSearchState extends SearchState {
//   InitiateSearchState({required super.area});
// }

// class UpdateSearchState extends SearchState {
//   UpdateSearchState({required super.area});
// }

// -------------------------------------------------
// Bloc
// -------------------------------------------------
class SearchBloc extends HydratedBloc<SearchEvent, int> {
  SearchBloc() : super(5) {
    on<InitiateSearchArea>((event, emit) {
      emit(state);
    });

    on<UpdateSearchArea>((event, emit) {
      emit(event.area);
    });
  }
  @override
  int? fromJson(Map<String, dynamic> json) => json['area'] as int;

  @override
  Map<String, dynamic>? toJson(int state) => {'area': state};
}
