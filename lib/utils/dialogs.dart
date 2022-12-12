import 'package:flutter/material.dart';

enum ConfirmAction { cancel, accept }

class Dialogs {
  confirmDialog(BuildContext context, arr) {
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
              child: Text(arr[2].toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.accept);
              },
            ),
            TextButton(
              child: Text(arr[3].toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
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
