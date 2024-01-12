import 'package:bibliasacra/bmarks/bm_model.dart';
import 'package:bibliasacra/bmarks/bm_queries.dart';
import 'package:bibliasacra/high/hl_model.dart';
import 'package:bibliasacra/high/hl_queries.dart';
import 'package:bibliasacra/notes/no_model.dart';
import 'package:bibliasacra/notes/no_queries.dart';

// final NtQueries _ntQueries = NtQueries();
// final HlQueries _hlQueries = HlQueries();
// final BmQueries _bmQueries = BmQueries();

class GetLists {
  static List<NtModel>? notesList;
  static List<HlModel>? highsList;
  static List<BmModel>? booksList;

  GetLists() {
    notesList = [];
    highsList = [];
    booksList = [];
  }

  // Future<void> updateActiveLists(int v) async {
  //   notesList = await NtQueries().getAllVersionNotes(v);
  //   highsList = await HlQueries().getHighVersionList(v);
  //   booksList = await BmQueries().getBookMarksVersionList(v);

  //   //debugPrint(jsonEncode(booksList));
  // }

  Future<void> updateActiveNotesList(int bibleVersion) async {
    notesList = await NtQueries().getAllVersionNotes(bibleVersion);
    //debugPrint(jsonEncode(notesList));
  }

  Future<void> updateActiveBookMarkList(int bibleVersion) async {
    booksList = await BmQueries().getBookMarksVersionList(bibleVersion);
    //debugPrint(jsonEncode(booksList));
  }

  Future<void> updateActiveHighLightList(int bibleVersion) async {
    highsList = await HlQueries().getHighVersionList(bibleVersion);
    //debugPrint(jsonEncode(highsList));
  }
}
