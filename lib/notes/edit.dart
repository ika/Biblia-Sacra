import 'package:bibliasacra/main/dbQueries.dart';
import 'package:bibliasacra/notes/nModel.dart';
import 'package:bibliasacra/notes/nQueries.dart';
import 'package:bibliasacra/utils/utilities.dart';
import 'package:flutter/material.dart';

import '../utils/dialogs.dart';

NtQueries _ntQueries = NtQueries();
Utilities _utilities = Utilities();
DbQueries _dbQueries = DbQueries();
Dialogs _dialogs = Dialogs();

int id;
int time = 0;
String title = '';
String contents = '';
int bid;
String noteFunction;

class EditNotePage extends StatefulWidget {
  const EditNotePage({Key key, this.model}) : super(key: key);

  final NtModel model;

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  @override
  initState() {
    super.initState();
    id = widget.model.id;
    bid = widget.model.bid;
    title = widget.model.title;
    contents = widget.model.contents;
    (id == null) ? noteFunction = 'Add Note' : noteFunction = 'Edit Note';
  }

  handleOnChange() {
    (id == null) ? saveEdit() : updateEdit();
  }

  saveEdit() async {
    if (id == null) {
      id = 0; // prevent race situation
      if (contents.isNotEmpty) {
        id = await _ntQueries.insertNote(
          NtModel(
              title:
                  title.isEmpty ? _utilities.reduceLength(25, contents) : title,
              contents: contents,
              bid: widget.model.bid),
        ); // populate 'id' so that it is not saved more than once
      }
    }
  }

  updateEdit() async {
    if (id != null) {
      await _ntQueries.updateNote(
        NtModel(
            id: id, title: title, contents: contents, bid: widget.model.bid),
      );
    }
  }

  SnackBar noteDeletedSnackBar = const SnackBar(
    content: Text('Note Deleted!'),
  );

  backButton(BuildContext context) {
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        Navigator.pop(context);
      },
    );
  }

  deleteWrapper(BuildContext context) {
    var arr = List.filled(2, '');
    arr[0] = "DELETE?";
    arr[1] = "Are you sure you want to delete this note?";

    _dialogs.confirmDialog(context, arr).then(
      (value) {
        if (value == ConfirmAction.accept) {
          //debugPrint("PRESSES $value NOTEID $id BID $bid");
          _ntQueries.deleteNote(id).then(
            (value) {
              _dbQueries.updateNoteId(0, bid).then((value) {
                ScaffoldMessenger.of(context).showSnackBar(noteDeletedSnackBar);
                backButton(context);
              });
            },
          );
        }
      }, //_deleteWrapper,
    );
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
          onWillPop: () async {
            backButton(context);
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(noteFunction),
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    deleteWrapper(context);
                  },
                )
              ],
            ),
            body: Padding(
              padding:
                  const EdgeInsets.only(top: 30.0, left: 15.0, right: 15.0),
              child: Column(
                children: [
                  TextFormField(
                    initialValue: contents,
                    maxLength: 256,
                    maxLines: null, // auto line break
                    autofocus: false,
                    // decoration: InputDecoration(
                    //   labelText: 'Enter your text',
                    //   labelStyle: Theme.of(context).textTheme.subtitle1,
                    //   border: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(5.0),
                    //   ),
                    // ),
                    onChanged: (text) {
                      contents = text;
                      handleOnChange();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
