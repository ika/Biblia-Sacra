import 'package:bibliasacra/cubit/SettingsCubit.dart';
import 'package:bibliasacra/cubit/textSizeCubit.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/main/mainPage.dart';
import 'package:bibliasacra/utils/sharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

MaterialColor? primarySwatch;
double? primaryTextSize;
SharedPrefs sharedPrefs = SharedPrefs();

class FontsPage extends StatefulWidget {
  const FontsPage({Key? key}) : super(key: key);

  @override
  State<FontsPage> createState() => _FontsPageState();
}

class _FontsPageState extends State<FontsPage> {
  @override
  void initState() {
    primarySwatch =
        BlocProvider.of<SettingsCubit>(context).state.themeData.primaryColor as MaterialColor?;
    primaryTextSize = BlocProvider.of<TextSizeCubit>(context).state;
    super.initState();
  }

  backButton(BuildContext context) {
    Future.delayed(
      Duration(milliseconds: Globals.navigatorDelay),
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
        );
      },
    );
  }

  List<String> fontsList = [
    'Montserrat',
    'OpenSans',
    'PlayFairDisplay',
    'Roboto',
    'Raleway',
    'Courgette',
    'Kalam'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey,
      appBar: AppBar(
        actions: const [],
        leading: GestureDetector(
          child: const Icon(Globals.backArrow),
          onTap: () {
            backButton(context);
          },
        ),
        elevation: 16,
        title: Text(
          'Font Selector',
          style: TextStyle(fontSize: Globals.appBarFontSize),
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
                  String fontSel = fontsList[i];
                  final settings = context.read<SettingsCubit>();
                  sharedPrefs.setStringPref('fontSel', fontSel).then((value) {
                    Globals.initialFont = fontSel;
                    settings.setFont(fontSel);
                    backButton(context);
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8, left: 20, right: 20),
                  height: 55,
                  color: primarySwatch![300],
                  child: Center(
                    child: Text(
                      'For God so loved the world ...',
                      style: TextStyle(
                          fontFamily: fontsList[i], fontSize: primaryTextSize),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
