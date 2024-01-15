import 'package:bibliasacra/bmarks/bm_model.dart';
import 'package:bibliasacra/bmarks/bm_queries.dart';
import 'package:bibliasacra/high/hl_model.dart';
import 'package:bibliasacra/high/hl_queries.dart';
import 'package:bibliasacra/notes/no_model.dart';
import 'package:bibliasacra/notes/no_queries.dart';

class GetLists {
  static List<NtModel>? notesList;
  static List<HlModel>? highsList;
  static List<BmModel>? booksList;

  GetLists() {
    notesList = [];
    highsList = [];
    booksList = [];
  }

  Future<void> updateActiveLists(int bibleVersion) async {
    notesList = await NtQueries().getAllVersionNotes(bibleVersion);
    highsList = await HlQueries().getHighVersionList(bibleVersion);
    booksList = await BmQueries().getBookMarksVersionList(bibleVersion);
    //debugPrint(jsonEncode(booksList));
  }
}
