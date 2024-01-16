import 'package:bibliasacra/bloc/bloc_font.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bibliasacra/fonts/list.dart';

late int selectedFont;

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

  backButton(BuildContext context) {
    Future.delayed(
      Duration(milliseconds: Globals.navigatorDelay),
      () {
        Navigator.of(context).pop();
      },
    );
  }

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
            backButton(context);
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
                  context.read<FontBloc>().add(UpdateFont(font: i));
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
                      'For God so loved the world ...',
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
