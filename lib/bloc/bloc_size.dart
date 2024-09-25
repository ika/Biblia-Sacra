import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

// bloc_size.dart

// -------------------------------------------------
// Event
// -------------------------------------------------
@immutable
abstract class SizeEvent {}

class UpdateSize extends SizeEvent {
  UpdateSize({required this.size});
  final double size;
}

// -------------------------------------------------
// Bloc
// -------------------------------------------------
class SizeBloc extends HydratedBloc<SizeEvent, double> {
  SizeBloc() : super(14.0) {
    on<UpdateSize>((event, emit) {
      emit(event.size);
    });
  }

  @override
  double? fromJson(Map<String, dynamic> json) => json['size'] as double;

  @override
  Map<String, dynamic>? toJson(double state) => {'size': state};
}
