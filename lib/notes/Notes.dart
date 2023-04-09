import 'package:bibliasacra/cubit/SettingsCubit.dart';
import 'package:bibliasacra/cubit/textSizeCubit.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/globals/write.dart';
import 'package:bibliasacra/main/mainPage.dart';
import 'package:bibliasacra/notes/Edit.dart';
import 'package:bibliasacra/notes/Model.dart';
import 'package:bibliasacra/notes/Queries.dart';
import 'package:bibliasacra/utils/getlists.dart';
import 'package:bibliasacra/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

NtQueries _ntQueries = NtQueries();
GetLists _lists = GetLists();
Dialogs _dialogs = Dialogs();

//final DateFormat formatter = DateFormat('E d MMM y H:mm:ss');

MaterialColor primarySwatch;
double primaryTextSize;

class NotesPage extends StatefulWidget {
  const NotesPage({Key key}) : super(key: key);

  @override
  NotesPageState createState() => NotesPageState();
}

class NotesPageState extends State<NotesPage> {
  @override
  void initState() {
    primarySwatch =
        BlocProvider.of<SettingsCubit>(context).state.themeData.primaryColor;
    primaryTextSize = BlocProvider.of<TextSizeCubit>(context).state;
    super.initState();
  }

  Future<void> addEditPage(NtModel model, String mode) async {
    Route route = MaterialPageRoute(
      builder: (context) => EditNotePage(model: model, mode: mode),
    );
    Navigator.push(context, route).then(
      (value) {
        setState(() {});
      },
    );
  }

  backButton(BuildContext context) {
    Future.delayed(
      Duration(milliseconds: Globals.navigatorDelay),
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
        );
      },
    );
  }

  // onIconButtonPress(WriteVarsModel model) {
  //   _lists.updateActiveLists('notes', model.version);
  //   writeVars(model).then((value) {
  //     backButton(context);
  //   });
  // }

  deleteWrapper(context, list, index) {
    var arr = List.filled(4, '');
    arr[0] = "Delete?";
    arr[1] = "Do you want to delete this note?";
    arr[2] = 'YES';
    arr[3] = 'NO';

    _dialogs.confirmDialog(context, arr).then((value) {
      if (value == ConfirmAction.accept) {
        _ntQueries.deleteNote(list[index].id).then((value) {
          _lists.updateActiveLists('notes', Globals.bibleVersion);
          setState(() {});
        });
      }
    });
  }

  // doWrapper(context, list, index) {
  //   var arr = List.filled(4, '');
  //   arr[0] = "Edit or Goto?";
  //   arr[1] = "What would you like to do?";
  //   arr[2] = 'EDIT';
  //   arr[3] = 'GOTO';

  //   _dialogs.confirmDialog(context, arr).then((value) {
  //     if (value == ConfirmAction.accept) {
  //       // Edit
  //       final model = NtModel(
  //           id: list[index].id,
  //           title: list[index].title,
  //           contents: list[index].contents,
  //           bid: list[index].bid);
  //       addEditPage(model);
  //     } else if (value == ConfirmAction.cancel) {
  //       // Goto
  //       Globals.scrollToVerse = true;
  //       final model = WriteVarsModel(
  //           lang: list[index].lang,
  //           version: list[index].version,
  //           abbr: list[index].abbr,
  //           book: list[index].book,
  //           chapter: list[index].chapter,
  //           verse: list[index].verse,
  //           name: list[index].name);

  //       writeVars(model).then((value) {
  //         _lists.updateActiveLists('all', model.version);
  //         backButton(context);
  //       });

  //       // _ntQueries.deleteNote(list[index].id).then(
  //       //   (value) {
  //       //     _lists.updateActiveLists('notes', Globals.bibleVersion);
  //       //     setState(() {});
  //       //   },
  //       // );
  //     }
  //   });
  // }

  // IconButton showIconButton(list, index) {
  //   return IconButton(
  //     icon: Icon(Icons.arrow_right, color: primarySwatch[700]),
  //     onPressed: () {
  //       final model = WriteVarsModel(
  //         lang: list[index].lang,
  //         version: list[index].version,
  //         abbr: list[index].abbr,
  //         book: list[index].book,
  //         chapter: list[index].chapter,
  //         verse: list[index].verse,
  //         name: list[index].name,
  //       );
  //       onIconButtonPress(model);
  //     },
  //   );
  // }

  Widget notesList(list, context) {
    GestureDetector makeListTile(list, int index) => GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) {
            if (details.primaryVelocity > 0 || details.primaryVelocity < 0) {
              deleteWrapper(context, list, index);
            }
          },
          child: ListTile(
              trailing: Icon(Icons.arrow_right, color: primarySwatch[700]),
              // trailing: SizedBox(
              //   height: 30,
              //   width: 20,
              //   child: (list[index].bid != null)
              //       ? showIconButton(list, index)
              //       : null,
              // ),
              // contentPadding:
              //     const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              title: Text(
                "${list[index].title}",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: primaryTextSize),
              ),
              subtitle: Text(list[index].contents,
                  style: TextStyle(fontSize: primaryTextSize)),
              onTap: () {
                final model = NtModel(
                    id: list[index].id,
                    title: list[index].title,
                    contents: list[index].contents,
                    bid: list[index].bid);
                addEditPage(model, 'edit');
              }

              // onTap: () {
              //   final model = NtModel(
              //       id: list[index].id,
              //       title: list[index].title,
              //       contents: list[index].contents,
              //       bid: list[index].bid);
              //   _addEditPage(model);
              // },
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

    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        leading: GestureDetector(
          child: const Icon(Globals.backArrow),
          onTap: () {
            backButton(context);
          },
        ),
        title: Text(
          'Notes',
          style: TextStyle(fontSize: Globals.appBarFontSize),
        ),
      ),
      body: makeBody,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final model = NtModel(id: null, title: '', contents: '', bid: null);
          addEditPage(model, 'add');
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
          return notesList(snapshot.data, context);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
