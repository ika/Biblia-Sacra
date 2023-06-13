import 'package:bibliasacra/cubit/cub_settings.dart';
import 'package:bibliasacra/cubit/cub_textsize.dart';
import 'package:bibliasacra/globals/globs_main.dart';
import 'package:bibliasacra/notes/no_model.dart';
import 'package:bibliasacra/notes/no_queries.dart';
import 'package:bibliasacra/utils/utils_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

NtQueries _ntQueries = NtQueries();
Dialogs _dialogs = Dialogs();

MaterialColor? primarySwatch;
double? primaryTextSize;

class EditNotePage extends StatefulWidget {
  const EditNotePage({Key? key, required this.model, required this.mode}) : super(key: key);

  final NtModel model;
  final String mode;

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
    primarySwatch =
        BlocProvider.of<SettingsCubit>(context).state.themeData.primaryColor as MaterialColor?;
    primaryTextSize = BlocProvider.of<TextSizeCubit>(context).state;

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
    widget.model.title = _titleController.text;
    widget.model.contents = _contentsController.text;
    await _ntQueries.updateNote(widget.model);
  }

  Widget showGotoVerse() {
    if (widget.model.bid! > 0 && widget.mode.isNotEmpty) {
      return FloatingActionButton.extended(
        label: const Text('Go to Verse'),
        icon: const Icon(Icons.arrow_circle_right_outlined),
        onPressed: () {
          debugPrint('PRESSED');
        },
      );
    } else {
      return Container();
    }
  }

  deleteWrapper() {
    var arr = List.filled(4, '');
    arr[0] = "Delete?";
    arr[1] = "Do you want to delete this note?";
    arr[2] = 'YES';
    arr[3] = 'NO';

    _dialogs.confirmDialog(context, arr).then(
      (value) {
        if (value == ConfirmAction.accept) {
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
          appBar: AppBar(
            leading: GestureDetector(
              child: const Icon(Globals.backArrow),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              'Edit Note',
              style: TextStyle(fontSize: Globals.appBarFontSize),
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
            child: Container(
              margin: const EdgeInsets.only(top: 20.0),
              padding: const EdgeInsets.only(top: 12.0, left: 12, right: 12),
              child: Form(
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
                          labelStyle: Theme.of(context).textTheme.titleMedium,
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
                          labelStyle: Theme.of(context).textTheme.titleMedium,
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
                          children: <Widget>[
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
            ),
          ),
          floatingActionButton: showGotoVerse(),
        ),
      );
}
