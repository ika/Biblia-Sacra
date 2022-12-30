import 'package:flutter_bloc/flutter_bloc.dart';

class TextSizeCubit extends Cubit<double> {
  //final sharedPrefs = SharedPrefs();

  //Palette palette = Palette();

  TextSizeCubit() : super(16);

  void setSize(double state) => emit(state);

  void getSize() async => emit(16);
}
