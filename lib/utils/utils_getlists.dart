import 'package:bibliasacra/bmarks/bm_model.dart';
import 'package:bibliasacra/bmarks/bm_queries.dart';
import 'package:bibliasacra/high/hl_model.dart';
import 'package:bibliasacra/high/hl_queries.dart';
import 'package:bibliasacra/notes/no_model.dart';
import 'package:bibliasacra/notes/no_queries.dart';

NtQueries _ntQueries = NtQueries();
HlQueries _hlQueries = HlQueries();
BmQueries _bmQueries = BmQueries();

class GetLists {
  static List<NtModel>? notesList;
  static List<HlModel>? highsList;
  static List<BmModel>? booksList;

  GetLists() {
    notesList = [];
    highsList = [];
    booksList = [];
  }

  Future<void> updateActiveLists(String mode, int v) async {
    switch (mode) {
      case 'notes':
        notesList = await _ntQueries.getAllVersionNotes(v);
        break;
      case 'highs':
        highsList = await _hlQueries.getHighVersionList(v);
        break;
      case 'books':
        booksList = await _bmQueries.getBookMarksVersionList(v);
        break;
      case 'all':
        notesList = await _ntQueries.getAllVersionNotes(v);
        highsList = await _hlQueries.getHighVersionList(v);
        booksList = await _bmQueries.getBookMarksVersionList(v);
        break;
    }
    //debugPrint(jsonEncode(booksList));
  }
}
