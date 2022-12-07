import 'dart:async';

import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/main/dbQueries.dart';
import 'package:bibliasacra/notes/edit.dart';
import 'package:bibliasacra/notes/nModel.dart';
import 'package:bibliasacra/notes/nQueries.dart';
import 'package:bibliasacra/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

NtQueries _ntQueries = NtQueries();
DbQueries _dbQueries = DbQueries();
Dialogs _dialogs = Dialogs();

final DateFormat formatter = DateFormat('E d MMM y H:mm:ss');

class NotesPage extends StatefulWidget {
  const NotesPage({Key key}) : super(key: key);

  @override
  NotesPageState createState() => NotesPageState();
}

class NotesPageState extends State<NotesPage> {
  FutureOr onReturnSetState() {
    setState(() {});
  }

  SnackBar noteDeletedSnackBar = const SnackBar(
    content: Text('Note Deleted!'),
  );

  _addEditPage(NtModel model) async {
    Route route = MaterialPageRoute(
      builder: (context) => EditNotePage(model: model),
    );
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        Navigator.push(context, route).then((value) {
          onReturnSetState();
        });
      },
    );
  }

  backButton(BuildContext context) {
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        Navigator.pop(context);
      },
    );
  }

  deleteWrapper(context, list, index) {
    var arr = List.filled(2, '');
    arr[0] = "DELETE?";
    arr[1] = "Are you sure you want to delete this note?";

    _dialogs.confirmDialog(context, arr).then(
      (value) {
        if (value == ConfirmAction.accept) {
          _ntQueries.deleteNote(list[index].id).then(
            (value) {
              _dbQueries.updateNoteId(0, list[index].bid).then((value) {
                ScaffoldMessenger.of(context).showSnackBar(noteDeletedSnackBar);
                onReturnSetState();
              });
            },
          );
        }
      }, //_deleteWrapper,
    );
  }

  Widget notesList(list, context) {
    GestureDetector makeListTile(list, int index) => GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) {
            if (details.primaryVelocity > 0 || details.primaryVelocity < 0) {
              deleteWrapper(context, list, index);
            }
          },
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            title: Text(
              list[index].title,
              // formatter.format(
              //     DateTime.fromMicrosecondsSinceEpoch(list[index].time)),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Row(
              children: [
                const Icon(Icons.linear_scale, color: Colors.amber),
                Flexible(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    strutStyle: const StrutStyle(fontSize: 12.0),
                    text: TextSpan(
                        style: const TextStyle(color: Colors.white),
                        text: '${list[index].contents}'),
                  ),
                ),
              ],
            ),
            onTap: () {
              final model = NtModel(
                  id: list[index].id,
                  contents: list[index].contents,
                  bid: list[index].bid);
              _addEditPage(model);
            },
          ),
        );

    Card makeCard(list, int index) => Card(
          elevation: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Container(
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.primary),
            child: makeListTile(list, index),
          ),
        );

    final makeBody = ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (BuildContext context, int index) {
        return makeCard(list, index);
      },
    );

    final topAppBar = AppBar(
      elevation: 0.1,
      title: const Text('Notes'),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: topAppBar,
      body: makeBody,
      floatingActionButton: FloatingActionButton(
        //backgroundColor: Colors.amber,
        onPressed: () {
          final model = NtModel(id: null, title: '', contents: '', bid: 0);
          _addEditPage(model);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Globals.scrollToVerse = Globals.initialScroll = true;
    return WillPopScope(
      onWillPop: () async {
        Globals.scrollToVerse = false;
        backButton(context);
        return false;
      },
      child: FutureBuilder<List<NtModel>>(
        future: _ntQueries.getAllNotes(),
        builder: (context, AsyncSnapshot<List<NtModel>> snapshot) {
          if (snapshot.hasData) {
            // List<NtModel> dialogList = [];
            // dialogList['contents'] = snapshot.data;
            return notesList(snapshot.data, context);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
