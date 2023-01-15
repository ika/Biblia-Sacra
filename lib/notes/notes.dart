import 'dart:async';

import 'package:bibliasacra/cubit/paletteCubit.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/globals/write.dart';
import 'package:bibliasacra/main/dbQueries.dart';
import 'package:bibliasacra/main/mainPage.dart';
import 'package:bibliasacra/notes/edit.dart';
import 'package:bibliasacra/notes/nModel.dart';
import 'package:bibliasacra/notes/nQueries.dart';
import 'package:bibliasacra/notes/nlist.dart';
import 'package:bibliasacra/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

NtQueries _ntQueries = NtQueries();
DbQueries _dbQueries = DbQueries();
NotesList _notesList = NotesList();
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
    Navigator.push(context, route).then(
      (value) {
        setState(() {});
      },
    );
  }

  backButton(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MainPage(),
      ),
    );
  }

  onIconButtonPress(WriteVarsModel model) {
    Globals.scrollToVerse = true;
    Globals.initialScroll = true;
    writeVars(model).then((value) {
      backButton(context);
    });
  }

  deleteWrapper(context, list, index) {
    var arr = List.filled(4, '');
    arr[0] = "DELETE?";
    arr[1] = "Do you want to delete this note?";
    arr[2] = 'YES';
    arr[3] = 'NO';

    _dialogs.confirmDialog(context, arr).then((value) {
      if (value == ConfirmAction.accept) {
        _ntQueries.deleteNote(list[index].id).then((value) {
          //ScaffoldMessenger.of(context).showSnackBar(noteDeletedSnackBar);
          _notesList.updateActiveNotesList();
          setState(() {});
        });
      }
    });
  }

  // noteChoiceWrapper(BuildContext context, list, int index) {
  //   var arr = List.filled(4, '');
  //   arr[0] = "VIEW OR EDIT?";
  //   arr[1] = "Do you want to go to the verse, or edit the note?";
  //   arr[2] = 'GOTO';
  //   arr[3] = 'EDIT';

  //   _dialogs.confirmDialog(context, arr).then(
  //     (value) {
  //       if (value == ConfirmAction.accept) {
  //         debugPrint('GOTO');
  //       } else if (value == ConfirmAction.cancel) {
  //         final model = NtModel(
  //             id: list[index].id,
  //             title: list[index].title,
  //             contents: list[index].contents,
  //             bid: list[index].bid);
  //         _addEditPage(model);
  //       }
  //     },
  //   );
  // }

  IconButton showIconButton(list, index) {
    return IconButton(
      icon: Icon(Icons.arrow_right, color: primarySwatch[700]),
      onPressed: () {
        final model = WriteVarsModel(
          lang: list[index].lang,
          version: list[index].version,
          abbr: list[index].abbr,
          book: list[index].book,
          chapter: list[index].chapter,
          verse: list[index].verse,
          name: list[index].name,
        );
        onIconButtonPress(model);
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
            trailing: SizedBox(
              height: 30,
              width: 20,
              child: (list[index].bid != null)
                  ? showIconButton(list, index)
                  : null,
            ),
            // contentPadding:
            //     const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            title: Text(
              "${list[index].title}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(list[index].contents),
            onTap: () {
              //noteChoiceWrapper(context, list, index);
              final model = NtModel(
                  id: list[index].id,
                  title: list[index].title,
                  contents: list[index].contents,
                  bid: list[index].bid);
              _addEditPage(model);
            },
            //       const SizedBox(
            //   height: 20,
            //   width: 20,
            //   child: Icon(Icons.notes, size: 18.0),
            // );
          ),
        );

    final makeBody = Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 8),
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (BuildContext context, int index) {
          return makeListTile(list, index);
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );

    final topAppBar = AppBar(
      elevation: 0.1,
      //backgroundColor: primarySwatch[700],
      title: const Text('Notes'),
    );

    return Scaffold(
      //backgroundColor: Theme.of(context).colorScheme.background,
      appBar: topAppBar,
      body: makeBody,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final model = NtModel(id: null, title: '', contents: '', bid: null);
          _addEditPage(model);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => backButton(context),
      child: FutureBuilder<List<NtModel>>(
        future: _ntQueries.getAllNotes(),
        builder: (context, AsyncSnapshot<List<NtModel>> snapshot) {
          if (snapshot.hasData) {
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
