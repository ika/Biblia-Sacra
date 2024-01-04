import 'package:bibliasacra/bloc/bloc_chapters.dart';
import 'package:bibliasacra/globals/globs_main.dart';
import 'package:bibliasacra/globals/globs_write.dart';
import 'package:bibliasacra/main/main_page.dart';
import 'package:bibliasacra/notes/no_model.dart';
import 'package:bibliasacra/notes/no_queries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

NtQueries _ntQueries = NtQueries();

//double? primaryTextSize;

class EditNotePage extends StatefulWidget {
  const EditNotePage({super.key, required this.mode, required this.model});

  final String mode;
  final NtModel model;

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final _titleController = TextEditingController();
  final _contentsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    // primarySwatch = BlocProvider.of<SettingsCubit>(context)
    //     .state
    //     .themeData
    //     .primaryColor as MaterialColor?;
    //primaryTextSize = Globals.initialTextSize;

    _titleController.text = widget.model.title!;
    _contentsController.text = widget.model.contents!;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentsController.dispose();
    super.dispose();
  }

  Future<void> updateEdit() async {
    if (_titleController.text.isEmpty & _contentsController.text.isEmpty) {
      await _ntQueries.deleteNote(widget.model.id!);
    } else {
      widget.model.title = _titleController.text;
      widget.model.contents = _contentsController.text;
      await _ntQueries.updateNote(widget.model);
    }
  }

  backButton(BuildContext context) {
    Route route = MaterialPageRoute(
      builder: (context) => const MainPage(),
    );
    Future.delayed(
      Duration(milliseconds: Globals.navigatorDelay),
      () {
        Navigator.push(context, route);
      },
    );
  }

  onGoToVerseTap(WriteVarsModel model) {
    // _lists.updateActiveLists('all', model.version!);
    //Globals.bibleLang = model.lang!;
    writeVars(model).then((value) {
      backButton(context);
    });
  }

  Widget showGotoVerse() {
    if (widget.model.bid! > 0 && widget.mode.isNotEmpty) {
      return FloatingActionButton.extended(
        //backgroundColor: Theme.of(context).colorScheme.primary,
        label: const Text('Go to Verse'),
        icon: const Icon(Icons.arrow_circle_right_outlined),
        onPressed: () {
          context
              .read<ChapterBloc>()
              .add(UpdateChapter(chapter: widget.model.chapter!));

          final model = WriteVarsModel(
              lang: widget.model.lang,
              version: widget.model.version,
              abbr: widget.model.abbr,
              book: widget.model.book,
              //chapter: widget.model.chapter,
              verse: widget.model.verse,
              name: widget.model.name);
          onGoToVerseTap(model);
        },
      );
    } else {
      return Container();
    }
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

  deleteWrapper() {
    var arr = List.filled(2, '');
    arr[0] = "Delete?";
    arr[1] = "Do you want to delete this note?";

    confirmDialog(arr).then(
      (value) {
        if (value) {
          _ntQueries.deleteNote(widget.model.id!).then(
            (value) {
              Navigator.pop(context, 'deleted');
            },
          );
        }
      }, //_deleteWrapper,
    );
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          //backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            //backgroundColor: Theme.of(context).colorScheme.primary,
            centerTitle: true,
            leading: GestureDetector(
              child: const Icon(Globals.backArrow),
              onTap: () {
                //Navigator.of(context).pop();
                // if (_formKey.currentState!.validate()) {
                updateEdit().then((value) {
                  Navigator.of(context).pop();
                });
                // }
              },
            ),
            title: const Text(
              'Edit Note',
              //style: TextStyle(fontSize: Globals.appBarFontSize),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  deleteWrapper();
                },
              )
            ],
          ),
          body: Material(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _titleController,
                            maxLength: 50,
                            maxLines: 1, // auto line break
                            autofocus: false,
                            decoration: InputDecoration(
                              labelText: 'Title',
                              labelStyle:
                                  Theme.of(context).textTheme.titleMedium,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Title is required!';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: _contentsController,
                            maxLength: 256,
                            maxLines: null, // auto line break
                            autofocus: false,
                            decoration: InputDecoration(
                              labelText: 'Text',
                              labelStyle:
                                  Theme.of(context).textTheme.titleMedium,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Text is required!';
                              }
                              return null;
                            },
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      updateEdit().then((value) {
                                        Navigator.of(context).pop();
                                      });
                                    }
                                  },
                                  child: const Text('Submit'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: showGotoVerse(),
        ),
      );
}
