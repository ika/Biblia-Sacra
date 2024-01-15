import 'package:bibliasacra/fonts/font_picker.dart';
import 'package:flutter/material.dart';

class FontsPage extends StatefulWidget {
  const FontsPage({super.key});

  @override
  FontsPageState createState() => FontsPageState();
}

class FontsPageState extends State<FontsPage> {
  String _selectedFont = 'Roboto';
  
  TextStyle? _selectedFontTextStyle;
  final List<String> _myGoogleFonts = [
    "Abril Fatface",
    "Aclonica",
    "Alegreya Sans",
    "Architects Daughter",
    "Archivo",
    "Archivo Narrow",
    "Bebas Neue",
    "Bitter",
    "Bree Serif",
    "Bungee",
    "Cabin",
    "Cairo",
    "Coda",
    "Comfortaa",
    "Comic Neue",
    "Cousine",
    "Croissant One",
    "Faster One",
    "Forum",
    "Great Vibes",
    "Heebo",
    "Inconsolata",
    "Josefin Slab",
    "Lato",
    "Libre Baskerville",
    "Lobster",
    "Lora",
    "Merriweather",
    "Montserrat",
    "Mukta",
    "Nunito",
    "Offside",
    "Open Sans",
    "Oswald",
    "Overlock",
    "Pacifico",
    "Playfair Display",
    "Poppins",
    "Raleway",
    "Roboto",
    "Roboto Mono",
    "Source Sans Pro",
    "Space Mono",
    "Spicy Rice",
    "Squada One",
    "Sue Ellen Francisco",
    "Trade Winds",
    "Ubuntu",
    "Varela",
    "Vollkorn",
    "Work Sans",
    "Zilla Slab",
  ];
  @override
  Widget build(BuildContext context) {
    //_selectedFont = BlocProvider.of<ThemeDataCubit>(context).state.themeData;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Fonts'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text('Pick a font'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FontPicker(
                        showFontInfo: true,
                        recentsCount: 10,
                        onFontChanged: (font) {
                          setState(() {
                            _selectedFont = font.fontFamily;
                            _selectedFontTextStyle = font.toTextStyle();
                          });
                          debugPrint(
                            "${font.fontFamily} with font weight ${font.fontWeight} and font style ${font.fontStyle}. FontSpec: ${font.toFontSpec()}",
                          );
                        },
                        googleFonts: _myGoogleFonts,
                      ),
                    ),
                  );
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blueGrey,
                        width: 2.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Font Selected: $_selectedFont',
                              style: _selectedFontTextStyle,
                            ),
                            Text(
                              'The quick brown fox jumped',
                              style: _selectedFontTextStyle,
                            ),
                            Text(
                              'over the lazy dog',
                              style: _selectedFontTextStyle,
                            ),
                          ],
                        ),
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
