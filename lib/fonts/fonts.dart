import 'package:bibliasacra/bloc/bloc_font.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/main/db_model.dart';
import 'package:bibliasacra/main/db_queries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bibliasacra/fonts/list.dart';

late int selectedFont;
late int fontNumber;

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
  }

  // backButton(BuildContext context) {
  //   Route route = MaterialPageRoute(
  //     builder: (context) => const MainPage(),
  //   );
  //   Future.delayed(
  //     Duration(milliseconds: Globals.navigatorDelay),
  //     () {
  //       Navigator.push(context, route);
  //       //Navigator.of(context).pop();
  //     },
  //   );
  // }

  // Future<dynamic> fontConfirmDialog(BuildContext context) {
  //   return showDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     builder: (context) {
  //       return SimpleDialog(
  //         children: [
  //           SizedBox(
  //             height: 200, //Globals.dialogHeight,
  //             width: MediaQuery.of(context).size.width,
  //             child: const Padding(
  //               padding: EdgeInsets.all(10.0),
  //               child: Column(
  //                 // mainAxisAlignment: MainAxisAlignment.center,
  //                 // crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   Expanded(
  //                     child: FontSampleCode(),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           SimpleDialogOption(
  //             child: const Text("Select"),
  //             onPressed: () {
  //               context.read<FontBloc>().add(UpdateFont(font: fontNumber));
  //               Future.delayed(
  //                 Duration(milliseconds: Globals.navigatorDelay),
  //                 () {
  //                   Navigator.of(context).pop();
  //                   Navigator.of(context).pop();
  //                 },
  //               );
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // backButton(BuildContext context) {
  //   Future.delayed(
  //     Duration(milliseconds: Globals.navigatorDelay),
  //     () {
  //       Navigator.of(context).pop();
  //     },
  //   );
  // }

  Future<dynamic> fontConfirmDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          content: Text(
            "The Lord is my shepherd, I lack nothing. He makes me lie down in green pastures, he leads me beside quiet waters, he refreshes my soul. He guides me along the right paths for his name’s sake. Even though I walk through the darkest valley, I will fear no evil, for you are with me; your rod and your staff, they comfort me. You prepare a table before me in the presence of my enemies. You anoint my head with oil; my cup overflows. Surely your goodness and love will follow me all the days of my life, and I will dwell in the house of the Lord forever.",
            softWrap: true,
            style: TextStyle(
              fontFamily:
                  GoogleFonts.getFont(fontsList[fontNumber]).fontFamily,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.20,
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
                  width: MediaQuery.of(context).size.width * 0.20,
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

  // fontConfirmDialog(BuildContext context) {
  //   return ButtonBarTheme(
  //     data: const ButtonBarThemeData(alignment: MainAxisAlignment.center),
  //     child: AlertDialog(
  //       content: const Text(
  //           "CONTENT_CONTENT_CONTENT_CONTENT_CONTENT_CONTENT_CONTENT_CONTENT_CONTENT_CONTENT_CONTENT_CONTENT_CONTENT_CONTENT_CONTENT_CONTENT_CONTENT_"),
  //       actions: [
  //         Row(
  //           mainAxisSize: MainAxisSize.max,
  //           //mainAxisAlignment: MainAxisAlignment.center,
  //           //crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             SizedBox(
  //               width: MediaQuery.of(context).size.width * 0.20,
  //               child: ElevatedButton(
  //                 child: const Text(
  //                   'Save',
  //                   //style: TextStyle(color: Colors.white),
  //                 ),
  //                 //color: Color(0xFF121A21),
  //                 // shape:const RoundedRectangleBorder(
  //                 //   borderRadius: BorderRadius.circular(30.0),
  //                 //),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ),
  //             SizedBox(
  //               width: MediaQuery.of(context).size.width * 0.01,
  //             ),
  //             SizedBox(
  //               width: MediaQuery.of(context).size.width * 0.20,
  //               child: ElevatedButton(
  //                 child: const Text(
  //                   'Cancel',
  //                   //style: TextStyle(color: Colors.white),
  //                 ),
  //                 // color: Color(0xFF121A21),
  //                 // shape: new RoundedRectangleBorder(
  //                 //   borderRadius: new BorderRadius.circular(30.0),
  //                 // ),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ),
  //             SizedBox(
  //               height: MediaQuery.of(context).size.height * 0.02,
  //             ),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey,
      appBar: AppBar(
        centerTitle: true,
        actions: const [],
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
          //style: TextStyle(fontSize: Globals.appBarFontSize),
        ),
      ),
      body: Center(
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            for (int i = 0; i < fontsList.length; i++)
              InkWell(
                onTap: () {
                  fontNumber = i;
                  fontConfirmDialog(context);
                },
                child: Container(
                  color: (i == selectedFont)
                      ? Theme.of(context).colorScheme.inversePrimary
                      : null,
                  margin: const EdgeInsets.only(bottom: 8, left: 20, right: 20),
                  height: 55,
                  //color: primarySwatch![300],
                  child: Center(
                    child: Text(
                      'The Lord is my shepherd, I lack nothing.',
                      style: GoogleFonts.getFont(fontsList[i]),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
