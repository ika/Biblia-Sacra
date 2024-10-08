import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/notes/no_edit.dart';
import 'package:bibliasacra/notes/no_model.dart';
import 'package:bibliasacra/notes/no_queries.dart';
import 'package:flutter/material.dart';

// no_page.dart

NtQueries _ntQueries = NtQueries();

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  NotesPageState createState() => NotesPageState();
}

class NotesPageState extends State<NotesPage> {
  List<NtModel> list = List<NtModel>.empty();

  Future<void> addPage(BuildContext context, NtModel model) async {
    _ntQueries.insertNote(model).then((noteid) {
      model.id = noteid;
      if (context.mounted) {
        gotoEditNote(context, model);
      }
    });
  }

  Future<void> gotoEditNote(BuildContext context, model) async {
    Route route = MaterialPageRoute(
      builder: (context) => EditNotePage(model: model, mode: 'note'),
    );
    Future.delayed(
      Duration(milliseconds: Globals.navigatorDelay),
      () {
        if (context.mounted) {
          Navigator.push(context, route).then((v) {
            setState(() {});
          });
        }
      },
    );
  }

  Future confirmDialog(arr) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(arr[0].toString()),
        content: Text(arr[1].toString()),
        actions: [
          TextButton(
            child:
                const Text('NO', style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('YES',
                style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }

  deleteWrapper(context, list, index) {
    var arr = List.filled(2, '');
    arr[0] = "Delete?";
    arr[1] = "Do you want to delete this note?";

    confirmDialog(arr).then((value) {
      if (value) {
        _ntQueries.deleteNote(list[index].id).then((value) {
          //Globals.listReadCompleted = false;
          //ActiveNotesList().updateActiveNotesList(bibleVersion);
          setState(() {});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NtModel>>(
      future: _ntQueries.getAllNotes(),
      builder: (context, AsyncSnapshot<List<NtModel>> snapshot) {
        if (snapshot.hasData) {
          //return notesList(snapshot.data, context);
          list = snapshot.data!;
          return PopScope(
            canPop: false,
            child: Scaffold(
              //backgroundColor: Theme.of(context).colorScheme.background,
              appBar: AppBar(
                //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                centerTitle: true,
                elevation: 5,
                leading: GestureDetector(
                  child: const Icon(Globals.backArrow),
                  onTap: () {
                    Future.delayed(
                      Duration(milliseconds: Globals.navigatorDelay),
                      () {
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                    );
                  },
                ),
                title: const Text(
                  'Notes',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView.separated(
                  // scrollDirection: Axis.vertical,
                  // shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    //return makeListTile(list, index);
                    return GestureDetector(
                      onHorizontalDragEnd: (DragEndDetails details) {
                        if (details.primaryVelocity! > 0 ||
                            details.primaryVelocity! < 0) {
                          deleteWrapper(context, list, index);
                        }
                      },
                      child: ListTile(
                        trailing: Icon(Icons.arrow_right,
                            color: Theme.of(context).colorScheme.primary),
                        title: Text(
                          "${list[index].title}",
                          // style: TextStyle(
                          //     fontWeight: FontWeight.bold, fontSize: primaryTextSize),
                        ),
                        subtitle: Text(
                          list[index].contents!,
                          //style: TextStyle(fontSize: primaryTextSize),
                        ),
                        onTap: () {
                          final model = NtModel(
                              id: list[index].id,
                              title: list[index].title,
                              contents: list[index].contents,
                              lang: list[index].lang,
                              version: list[index].version,
                              abbr: list[index].abbr,
                              book: list[index].book,
                              chapter: list[index].chapter,
                              verse: list[index].verse,
                              name: list[index].name,
                              bid: list[index].bid);
                          gotoEditNote(context, model);
                        },
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                //backgroundColor: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  final model = NtModel(
                      title: '',
                      contents: '',
                      lang: '',
                      version: 0,
                      abbr: '',
                      book: 0,
                      chapter: 0,
                      verse: 0,
                      name: '',
                      bid: 0);
                  addPage(context, model);
                },
                child: const Icon(Icons.add),
              ),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
