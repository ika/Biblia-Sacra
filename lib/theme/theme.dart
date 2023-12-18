import 'package:flutter/material.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({Key? key}) : super(key: key);

  @override
  ThemePageState createState() => ThemePageState();
}

class ThemePageState extends State<ThemePage> {
  ThemeMode themeMode = ThemeMode.system;

  bool useMaterial3 = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: null,
    );
  }
}
