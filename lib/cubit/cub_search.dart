import 'package:bibliasacra/utils/utils_sharedprefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

SharedPrefs sharedPrefs = SharedPrefs();

// -------------------------------------------------
// Event
// -------------------------------------------------
@immutable
abstract class SearchEvent {}

class GetSearchArea extends SearchEvent {}

class UpdateSearchArea extends SearchEvent {
  UpdateSearchArea({required this.area});
  final int area;
}

// -------------------------------------------------
// State
// -------------------------------------------------
class SearchState {
  int area;
  SearchState({required this.area});
}

class GetSearchState extends SearchState {
  GetSearchState({required super.area});
}

class UpdateSearchState extends SearchState {
  UpdateSearchState({required super.area});
}

// -------------------------------------------------
// Bloc
// -------------------------------------------------
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(GetSearchState(area: 0)) {

    on<GetSearchArea>((GetSearchArea event, Emitter<SearchState> emit) async {
      sharedPrefs.getIntPref('searchArea').then((value) {
        emit(GetSearchState(area: value ?? 5));
      });
    });

    on<UpdateSearchArea>(
        (UpdateSearchArea event, Emitter<SearchState> emit) async {
      sharedPrefs.setIntPref('searchArea', event.area).then((value) {
        emit(UpdateSearchState(area: event.area));
      });
    });
  }
}
