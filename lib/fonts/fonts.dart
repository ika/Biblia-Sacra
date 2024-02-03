import 'package:bibliasacra/bloc/bloc_font.dart';
import 'package:bibliasacra/bloc/bloc_italic.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bibliasacra/fonts/list.dart';

late int selectedFont;
late int fontNumber;
late bool italicIsOn;

class FontsPage extends StatefulWidget {
  const FontsPage({Key? key}) : super(key: key);

  @override
  State<FontsPage> createState() => _FontsPageState();
}

class _FontsPageState extends State<FontsPage> {
  @override
  void initState() {
    super.initState();
    selectedFont = context.read<FontBloc>().state;
    italicIsOn = context.read<ItalicBloc>().state;
  }

  Future<dynamic> fontConfirmDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text(fontsList[fontNumber]),
          content: Text(
            "The Lord is my shepherd, I lack nothing. He makes me lie down in green pastures, he leads me beside quiet waters, he refreshes my soul. He guides me along the right paths for his name’s sake. Even though I walk through the darkest valley, I will fear no evil, for you are with me; your rod and your staff, they comfort me. You prepare a table before me in the presence of my enemies. You anoint my head with oil; my cup overflows. Surely your goodness and love will follow me all the days of my life, and I will dwell in the house of the Lord forever.",
            softWrap: true,
            style: TextStyle(
              fontFamily: fontsList[fontNumber],
              fontStyle: (italicIsOn) ? FontStyle.italic : FontStyle.normal,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.30,
                  child: ElevatedButton(
                    onPressed: () {
                      context
                          .read<FontBloc>()
                          .add(UpdateFont(font: fontNumber));
                      Future.delayed(
                        Duration(milliseconds: Globals.navigatorDelay),
                        () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      );
                    },
                    child: const Text("Select"),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.01,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.30,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel"),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        //backgroundColor: Colors.grey,
        appBar: AppBar(
          centerTitle: true,
          //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          elevation: 5,
          actions: [
            Switch(
              value: italicIsOn,
              onChanged: (bool value) {
                context.read<ItalicBloc>().add(ChangeItalic(value));
                setState(() {
                  italicIsOn = value;
                });
              },
            )
          ],
          leading: GestureDetector(
            child: const Icon(Globals.backArrow),
            onTap: () {
              //backButton(context);
              Future.delayed(
                Duration(milliseconds: Globals.navigatorDelay),
                () {
                  Navigator.of(context).pop();
                },
              );
            },
          ),
          //elevation: 16,
          title: const Text(
            'Font Selector',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        body: Center(
          child: ListView(
            children: [
              const SizedBox(
                height: 50,
              ),
              for (int i = 0; i < fontsList.length; i++)
                InkWell(
                  onTap: () {
                    fontNumber = i;
                    fontConfirmDialog(context);
                  },
                  child: Container(
                    // color: (i == selectedFont)
                    //     ? Theme.of(context).colorScheme.tertiaryContainer
                    //     : null,
                    margin: const EdgeInsets.only(bottom: 8, left: 50, right: 50),
                    height: 55,
                    //color: primarySwatch![300],
                    child: Center(
                      child: Text(
                        "The Lord is my shepherd, I lack nothing.",
                        style: TextStyle(
                          backgroundColor: (i == selectedFont)
                              ? Theme.of(context).colorScheme.tertiaryContainer
                              : null,
                          fontStyle:
                              (italicIsOn) ? FontStyle.italic : FontStyle.normal,
                          fontFamily: fontsList[i],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
