import 'package:bibliasacra/high/hlModel.dart';
import 'package:bibliasacra/high/hlQueries.dart';
import 'package:bibliasacra/notes/nModel.dart';
import 'package:bibliasacra/notes/nQueries.dart';

NtQueries _ntQueries = NtQueries();
HlQueries _hlQueries = HlQueries();

class GetLists {
  static List<NtModel> notesList;
  static List<HlModel> highsList;

  GetLists() {
    notesList = [];
    highsList = [];
  }

  void updateActiveLists(String mode, int v) async {
    switch (mode) {
      case 'notes':
        notesList = await _ntQueries.getAllVersionNotes(v);
        break;
      case 'highs':
        highsList = await _hlQueries.getHighVersionList(v);
        break;
      case 'all':
        notesList = await _ntQueries.getAllVersionNotes(v);
        highsList = await _hlQueries.getHighVersionList(v);
        break;
    }
  }
}
