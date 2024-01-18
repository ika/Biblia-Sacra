// class FontList {
//   String? font;
//   int? num;

//   void init() {
//     SharedPrefs().getFontListNumber().then((n) {
//       //saveFontData(n);
//       num = n;
//       font = fontsList[n];
//     });
//   }

//   String getFont() {
//     return font!;
//   }

//   int getNum() {
//     return num!;
//   }

//   saveFontData(int n) {
//     num = n;
//     font = fontsList[n];
//     // debugPrint("Font $font");
//   }

//   void setFont(int num) {
//     SharedPrefs().setFontListNumber(num);
//   }

List<String> fontsList = [
  "OpenSans",
  "Roboto",
  "Raleway",
  "Lato",
  "Montserrat",
  "MerriweatherSans",
  "NotoSans",
  "Ubuntu",
  "PlayfairDisplay",
  "Poppins"
];
//}
