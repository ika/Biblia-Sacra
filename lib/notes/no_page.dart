import 'package:bibliasacra/globals/globs_main.dart';
import 'package:bibliasacra/notes/no_edit.dart';
import 'package:bibliasacra/notes/no_model.dart';
import 'package:bibliasacra/notes/no_queries.dart';
import 'package:bibliasacra/utils/utils_getlists.dart';
import 'package:flutter/material.dart';

NtQueries _ntQueries = NtQueries();
GetLists _lists = GetLists();

//final DateFormat formatter = DateFormat('E d MMM y H:mm:ss');

double? primaryTextSize;

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  NotesPageState createState() => NotesPageState();
}

class NotesPageState extends State<NotesPage> {
  @override
  void initState() {
    // primarySwatch = BlocProvider.of<SettingsCubit>(context)
    //     .state
    //     .themeData
    //     .primaryColor as MaterialColor?;
    primaryTextSize = Globals.initialTextSize;
    super.initState();
  }

  Future<void> addPage(NtModel model) async {
    _ntQueries.insertNote(model).then((noteid) {
      model.id = noteid;
      gotoEditNote(model);
    });
  }

  Future<void> gotoEditNote(NtModel model) async {
    Route route = MaterialPageRoute(
      builder: (context) => EditNotePage(model: model, mode: 'note'),
    );
    Navigator.push(context, route).then(
      (value) {
        setState(() {
          _lists.updateActiveLists(Globals.bibleVersion);
        });
      },
    );
  }

  backButton(BuildContext context) {
    Future.delayed(
      Duration(milliseconds: Globals.navigatorDelay),
      () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const MainPage(),
        //   ),
        // );
        Navigator.of(context).pushNamed('/MainPage');
      },
    );
  }

  // onIconButtonPress(WriteVarsModel model) {
  //   _lists.updateActiveLists('notes', model.version);
  //   writeVars(model).then((value) {
  //     backButton(context);
  //   });
  // }

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
          _lists.updateActiveLists(Globals.bibleVersion);
          setState(() {});
        });
      }
    });
  }

  Widget notesList(list, context) {
    GestureDetector makeListTile(list, int index) => GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) {
            if (details.primaryVelocity! > 0 || details.primaryVelocity! < 0) {
              deleteWrapper(context, list, index);
            }
          },
          child: ListTile(
            trailing: Icon(Icons.arrow_right, color: Theme.of(context).colorScheme.primary),
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
                  lang: list[index].lang,
                  version: list[index].version,
                  abbr: list[index].abbr,
                  book: list[index].book,
                  chapter: list[index].chapter,
                  verse: list[index].verse,
                  name: list[index].name,
                  bid: list[index].bid);
              gotoEditNote(model);
            },
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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
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
          addPage(model);
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
