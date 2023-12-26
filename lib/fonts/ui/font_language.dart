import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../constants/translations.dart';

class FontLanguage extends StatefulWidget {
  final ValueChanged<String?> onFontLanguageSelected;
  final String selectedFontLanguage;
  const FontLanguage({
    super.key,
    required this.selectedFontLanguage,
    required this.onFontLanguageSelected,
  });

  @override
  FontLanguageState createState() => FontLanguageState();
}

class FontLanguageState extends State<FontLanguage> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: widget.selectedFontLanguage,
        isDense: true,
        style: TextStyle(
          fontSize: 12.0,
          color: DefaultTextStyle.of(context).style.color,
        ),
        icon: const Icon(Icons.arrow_drop_down_sharp),
        onChanged: widget.onFontLanguageSelected,
        items:
            googleFontLanguages.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(translations.d[value]!),
          );
        }).toList(),
      ),
    );
  }
}
