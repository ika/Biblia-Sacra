import 'package:bibliasacra/bloc/bloc_themedata.dart';
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Theme Switcher'),
        // actions: [
        //   Switch(
        //     value: (context.read<ThemeBloc>()) ? true : false,
        //     onChanged: (bool value) {
        //       context.read<ThemeBloc>().add(ChangeTheme(value));
        //     },
        //   ),
        // ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Switch between Light and Dark Themes:',
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: () =>
                      context.read<ThemeBloc>().add(ChangeTheme(false)),
                  child: const Text('Light'),
                ),
                const SizedBox(width: 10),
                FilledButton(
                  onPressed: () =>
                      context.read<ThemeBloc>().add(ChangeTheme(true)),
                  child: const Text('Dark'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
