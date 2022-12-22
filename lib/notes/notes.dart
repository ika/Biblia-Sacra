import 'dart:async';

import 'package:bibliasacra/cubit/paletteCubit.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/main/dbQueries.dart';
import 'package:bibliasacra/notes/edit.dart';
import 'package:bibliasacra/notes/nModel.dart';
import 'package:bibliasacra/notes/nQueries.dart';
import 'package:bibliasacra/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

NtQueries _ntQueries = NtQueries();
DbQueries _dbQueries = DbQueries();
Dialogs _dialogs = Dialogs();

//final DateFormat formatter = DateFormat('E d MMM y H:mm:ss');

MaterialColor primarySwatch;

class NotesPage extends StatefulWidget {
  const NotesPage({Key key}) : super(key: key);

  @override
  NotesPageState createState() => NotesPageState();
}

class NotesPageState extends State<NotesPage> {
  // FutureOr onReturnSetState() {
  //   setState(() {});
  // }

  @override
  void initState() {
    Globals.scrollToVerse = false;
    Globals.initialScroll = false;
    primarySwatch = BlocProvider.of<PaletteCubit>(context).state;
    super.initState();
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
          setState(() {});
        });
      },
    );
  }

  // backPopButton(BuildContext context) {
  //   Future.delayed(
  //     const Duration(milliseconds: 200),
  //     () {
  //       Navigator.pop(context);
  //     },
  //   );
  // }

  deleteWrapper(context, list, index) {
    var arr = List.filled(4, '');
    arr[0] = "DELETE?";
    arr[1] = "Do you want to delete this note?";
    arr[2] = 'YES';
    arr[3] = 'NO';

    _dialogs.confirmDialog(context, arr).then(
      (value) {
        if (value == ConfirmAction.accept) {
          _ntQueries.deleteNote(list[index].id).then(
            (value) {
              _dbQueries.updateNoteId(0, list[index].bid).then((value) {
                ScaffoldMessenger.of(context).showSnackBar(noteDeletedSnackBar);
                setState(() {}); //onReturnSetState();
              });
            },
          );
        }
      },
    );
  }

  noteChoiceWrapper(BuildContext context, list, int index) {
    var arr = List.filled(4, '');
    arr[0] = "VIEW OR EDIT?";
    arr[1] = "Do you want to go to the verse, or edit the note?";
    arr[2] = 'GOTO';
    arr[3] = 'EDIT';

    _dialogs.confirmDialog(context, arr).then(
      (value) {
        if (value == ConfirmAction.accept) {
          debugPrint('GOTO');
        } else if (value == ConfirmAction.cancel) {
          final model = NtModel(
              id: list[index].id,
              title: list[index].title,
              contents: list[index].contents,
              bid: list[index].bid);
          _addEditPage(model);
        }
      },
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
            //leading: Icon(Icons.arrow_right, color: primarySwatch[700]),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            title: Text(
              list[index].title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(list[index].contents),
            // child: ListTile(
            //   contentPadding:
            //       const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            //   title: Text(
            //     (list[index].title != null)
            //         ? list[index].title
            //         : 'Title not given',
            //     style: const TextStyle(
            //         color: Colors.white, fontWeight: FontWeight.bold),
            //   ),
            //   subtitle: Row(
            //     children: [
            //       const Icon(Icons.linear_scale, color: Colors.amber),
            //       Flexible(
            //         child: RichText(
            //           overflow: TextOverflow.ellipsis,
            //           strutStyle: const StrutStyle(fontSize: 12.0),
            //           text: TextSpan(
            //               //style: const TextStyle(color: Colors.white),
            //               text: '${list[index].contents}'),
            //         ),
            //       ),
            //     ],
            //   ),
            onTap: () {
              noteChoiceWrapper(context, list, index);
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
    return FutureBuilder<List<NtModel>>(
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
    );
  }
}
