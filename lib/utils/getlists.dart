import 'package:bibliasacra/bmarks/bmModel.dart';
import 'package:bibliasacra/bmarks/bmQueries.dart';
import 'package:bibliasacra/high/hlModel.dart';
import 'package:bibliasacra/high/hlQueries.dart';
import 'package:bibliasacra/notes/Model.dart';
import 'package:bibliasacra/notes/Queries.dart';

NtQueries _ntQueries = NtQueries();
HlQueries _hlQueries = HlQueries();
BmQueries _bmQueries = BmQueries();

class GetLists {
  static List<NtModel> notesList;
  static List<HlModel> highsList;
  static List<BmModel> booksList;

  GetLists() {
    notesList = [];
    highsList = [];
    booksList = [];
  }

  void updateActiveLists(String mode, int v) async {
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
  }
}
