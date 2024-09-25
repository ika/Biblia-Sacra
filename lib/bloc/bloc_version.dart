import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

// bloc_version.dart

// -------------------------------------------------
// Event
// -------------------------------------------------
@immutable
abstract class VersionEvent {}

class UpdateVersion extends VersionEvent {
  UpdateVersion({required this.bibleVersion});
  final int bibleVersion;
}

// -------------------------------------------------
// Bloc
// -------------------------------------------------
class VersionBloc extends HydratedBloc<VersionEvent, int> {
  VersionBloc() : super(1) {
    on<UpdateVersion>((event, emit) {
      emit(event.bibleVersion);
    });
  }

  @override
  int? fromJson(Map<String, dynamic> json) => json['bibleVersion'] as int;

  @override
  Map<String, dynamic>? toJson(int state) => {'bibleVersion': state};
}
