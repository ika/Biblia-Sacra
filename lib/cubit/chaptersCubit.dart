import 'package:bibliasacra/globals/globals.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChapterCubit extends Cubit<int> {

  ChapterCubit() : super(1);

  void setChapter(int c) => emit(c);

  //void getChapter() async => emit(await _sharedPrefs.readChapter());
  void getChapter() {
    emit(Globals.bookChapter);
  }
}
