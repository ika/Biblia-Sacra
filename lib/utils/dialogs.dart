import 'package:flutter/material.dart';

enum ConfirmAction { cancel, accept }

class Dialogs {

  Future<dynamic> confirmDialog(BuildContext context, arr) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(arr[0].toString()),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(arr[1].toString()),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('YES',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.accept);
              },
            ),
            TextButton(
              child: const Text('NO',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.cancel);
              },
            ),
          ],
        );
      },
    );
  }
}
