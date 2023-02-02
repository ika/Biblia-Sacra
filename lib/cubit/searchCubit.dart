import 'package:bibliasacra/utils/sharedPrefs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<int> {
  final sharedPrefs = SharedPrefs();

  SearchCubit() : super(0);

  void getState() => emit(state);

  void setSearchAreaKey(int a) => emit(a);

  void getSearchAreaKey() async =>
      emit(await (sharedPrefs.getIntPref('searchArea')) ?? 12);
}
