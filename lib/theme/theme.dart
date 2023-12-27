import 'package:bibliasacra/cubit/cub_themedata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  ThemePageState createState() => ThemePageState();
}

class ThemePageState extends State<ThemePage> {
  @override
  Widget build(BuildContext context) {
    final themeBloc = BlocProvider.of<ThemeBloc>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Theme Switcher'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Switch between Dark and Light Themes:',
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: () => themeBloc.add(ThemeEvent.toggleDark),
                  child: const Text('Dark'),
                ),
                const SizedBox(width: 10),
                FilledButton(
                  onPressed: () => themeBloc.add(ThemeEvent.toggleLight),
                  child: const Text('Light'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
