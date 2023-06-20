import 'package:bibliasacra/bmarks/bm_model.dart';
import 'package:bibliasacra/bmarks/bm_queries.dart';
import 'package:bibliasacra/high/hl_model.dart';
import 'package:bibliasacra/high/hl_queries.dart';
import 'package:bibliasacra/notes/no_model.dart';
import 'package:bibliasacra/notes/no_queries.dart';

final NtQueries _ntQueries = NtQueries();
final HlQueries _hlQueries = HlQueries();
final BmQueries _bmQueries = BmQueries();

class GetLists {
  static List<NtModel>? notesList;
  static List<HlModel>? highsList;
  static List<BmModel>? booksList;

  GetLists() {
    notesList = [];
    highsList = [];
    booksList = [];
  }

  Future<void> updateActiveLists(int v) async {
    notesList = await _ntQueries.getAllVersionNotes(v);
    highsList = await _hlQueries.getHighVersionList(v);
    booksList = await _bmQueries.getBookMarksVersionList(v);

    //debugPrint(jsonEncode(booksList));
  }
}
