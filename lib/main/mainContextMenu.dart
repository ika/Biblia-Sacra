import 'package:flutter/material.dart';

Future<dynamic> contextMenuDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return SimpleDialog(
        children: [
          SizedBox(
            height: 300.0,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ContextDialogList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}

class ContextDialogList extends StatelessWidget {
  ContextDialogList({Key key}) : super(key: key);

  final List<String> contextMenu = [
    'Compare',
    'Copy',
    'Bookmark',
    'Highlight',
    'Notes'
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: contextMenu.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          //leading: const Icon(Icons.linear_scale),
          trailing: const Icon(Icons.arrow_right),
          title: Text(
            contextMenu[index],
          ),
          onTap: () {
            Navigator.of(context).pop(index);
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          const Divider(height: 2.0),
    );
  }
}
