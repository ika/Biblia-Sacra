import 'package:bibliasacra/globals/globals.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TextSizeCubit extends Cubit<double> {
  TextSizeCubit() : super(Globals.initialTextSize);

  void setSize(double state) => emit(state);

  void getSize() async => emit(Globals.initialTextSize);
}
