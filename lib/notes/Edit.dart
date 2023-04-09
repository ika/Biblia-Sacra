import 'package:bibliasacra/cubit/SettingsCubit.dart';
import 'package:bibliasacra/cubit/textSizeCubit.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/globals/write.dart';
import 'package:bibliasacra/notes/Model.dart';
import 'package:bibliasacra/notes/Queries.dart';
import 'package:bibliasacra/utils/getlists.dart';
import 'package:bibliasacra/utils/dialogs.dart';
import 'package:bibliasacra/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

NtQueries _ntQueries = NtQueries();
Utilities _utilities = Utilities();
Dialogs _dialogs = Dialogs();
GetLists _lists = GetLists();

int id;
int bid;
String noteFunction;
MaterialColor primarySwatch;
double primaryTextSize;

class EditNotePage extends StatefulWidget {
  const EditNotePage({Key key, this.model, this.mode}) : super(key: key);

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
        BlocProvider.of<SettingsCubit>(context).state.themeData.primaryColor;
    primaryTextSize = BlocProvider.of<TextSizeCubit>(context).state;

    id = widget.model.id;
    bid = widget.model.bid;

    _titleController.text = widget.model.title;
    _contentsController.text = widget.model.contents;

    (widget.mode == 'add')
        ? noteFunction = 'Add Note'
        : noteFunction = 'Edit Note';

    // _titleController.addListener(handleOnChange);
    // _contentsController.addListener(handleOnChange);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentsController.dispose();
    super.dispose();
  }

  Future<void> handleOnChange() async {
    (id != null) ? saveEdit() : updateEdit();
  }

  void saveEdit() async {
    NtModel model = NtModel(
        title: _utilities.reduceLength(35, _titleController.text),
        contents: _utilities.reduceLength(256, _contentsController.text),
        bid: bid);

    id = await _ntQueries.insertNote(
        model); // populate 'id' so that it is not saved more than once

    writeVars(model as WriteVarsModel).then((value) {
      _lists.updateActiveLists('all', widget.model.version);
    });
  }

  void updateEdit() async {
    await _ntQueries.updateNote(
      NtModel(
          id: id,
          title: _utilities.reduceLength(35, _titleController.text),
          contents: _utilities.reduceLength(256, _contentsController.text),
          bid: bid),
    );
  }

  deleteWrapper(BuildContext context) {
    var arr = List.filled(4, '');
    arr[0] = "Delete?";
    arr[1] = "Do you want to delete this note?";
    arr[2] = 'YES';
    arr[3] = 'NO';

    _dialogs.confirmDialog(context, arr).then(
      (value) {
        if (value == ConfirmAction.accept) {
          _ntQueries.deleteNote(id).then(
            (value) {
              _lists.updateActiveLists('all', Globals.bibleVersion);
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
              noteFunction,
              style: TextStyle(fontSize: Globals.appBarFontSize),
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
          // body: Container(
          //   padding: const EdgeInsets.all(20.0),
          //   child: ListView(
          //     children: [
          //       TextFormField(
          //         controller: _titleController,
          //         style: TextStyle(fontSize: primaryTextSize),
          //         decoration: InputDecoration(
          //           labelText: 'Title',
          //           labelStyle: TextStyle(fontSize: primaryTextSize),
          //           border: const OutlineInputBorder(
          //               //borderRadius: BorderRadius.circular(5.0),
          //               ),
          //         ),
          //         maxLength: 35,
          //         maxLines: 1, // auto line break
          //         autofocus: false,
          //       ),
          //       TextFormField(
          //         controller: _contentsController,
          //         style: TextStyle(fontSize: primaryTextSize),
          //         decoration: InputDecoration(
          //           labelText: 'Text',
          //           labelStyle: TextStyle(fontSize: primaryTextSize),
          //           border: const OutlineInputBorder(
          //               //borderRadius: BorderRadius.circular(5.0),
          //               ),
          //         ),
          //         maxLength: 256,
          //         maxLines: null, // auto line break
          //         autofocus: false,
          //       ),
          //     ],
          //   ),
          // ),
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
                                if (_formKey.currentState.validate()) {
                                  handleOnChange().then((value) {
                                    Navigator.pop(context, '');
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
        ),
      );
}
