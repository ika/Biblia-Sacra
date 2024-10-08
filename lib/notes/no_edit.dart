import 'package:bibliasacra/bloc/bloc_book.dart';
import 'package:bibliasacra/bloc/bloc_chapters.dart';
import 'package:bibliasacra/bloc/bloc_verse.dart';
import 'package:bibliasacra/bloc/bloc_version.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/main/main_page.dart';
import 'package:bibliasacra/notes/no_model.dart';
import 'package:bibliasacra/notes/no_queries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// no_edit.dart

NtQueries _ntQueries = NtQueries();

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

  Widget showGotoVerse(BuildContext context) {
    if (widget.model.bid! > 0 && widget.mode.isNotEmpty) {
      return FloatingActionButton.extended(
        label: const Text('Go to Verse'),
        icon: const Icon(Icons.arrow_circle_right_outlined),
        onPressed: () {
          context
              .read<VersionBloc>()
              .add(UpdateVersion(bibleVersion: widget.model.version!));

          context.read<BookBloc>().add(UpdateBook(book: widget.model.book!));

          context
              .read<ChapterBloc>()
              .add(UpdateChapter(chapter: widget.model.chapter!));

          context
              .read<VerseBloc>()
              .add(UpdateVerse(verse: widget.model.verse!));

          Route route = MaterialPageRoute(
            builder: (context) => const MainPage(),
          );
          Future.delayed(
            Duration(milliseconds: Globals.navigatorDelay),
            () {
              if (context.mounted) {
                Navigator.push(context, route);
              }
            },
          );
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

  deleteWrapper(BuildContext context) {
    var arr = List.filled(2, '');
    arr[0] = "Delete?";
    arr[1] = "Do you want to delete this note?";

    confirmDialog(arr).then(
      (value) {
        if (value) {
          _ntQueries.deleteNote(widget.model.id!).then(
            (value) {
              if (context.mounted) {
                Navigator.pop(context, 'deleted');
              }
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: PopScope(
          canPop: false,
          child: Scaffold(
            //backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              //backgroundColor: Theme.of(context).colorScheme.primary,
              centerTitle: true,
              elevation: 5,
              leading: GestureDetector(
                child: const Icon(Globals.backArrow),
                onTap: () {
                  //Navigator.of(context).pop();
                  // if (_formKey.currentState!.validate()) {
                  updateEdit().then((value) {
                    Future.delayed(
                      Duration(milliseconds: Globals.navigatorDelay),
                      () {
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                    );
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
                    deleteWrapper(context);
                  },
                )
              ],
            ),
            body: Material(
              child: Padding(
                padding: const EdgeInsets.all(50.0),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        updateEdit().then(
                                          (value) {
                                            if (context.mounted) {
                                              Navigator.of(context).pop();
                                            }
                                          },
                                        );
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
            floatingActionButton: showGotoVerse(context),
          ),
        ),
      );
}
