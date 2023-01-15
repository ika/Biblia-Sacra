import 'package:bibliasacra/notes/nModel.dart';
import 'package:bibliasacra/notes/nQueries.dart';

NtQueries _ntQueries = NtQueries();

class NotesList {
  static List<NtModel> notesList = [];
  NotesList();

  void updateActiveNotesList() async {
    notesList = await _ntQueries.getAllNotes();
  }
}
