// import 'package:bibliasacra/globals/globals.dart';
// import 'package:bibliasacra/utils/sharedPrefs.dart';

// SharedPrefs _sharedPrefs = SharedPrefs();

// Future<void> readGlobals() async {
//   // version
//   _sharedPrefs.readVersion().then(
//     (a) {
//       Globals.bibleVersion = a;
//       // language
//       _sharedPrefs.readLang().then(
//         (b) {
//           Globals.bibleLang = b;
//           // version abbreviation
//           _sharedPrefs.readVerAbbr().then(
//             (c) {
//               Globals.versionAbbr = c;
//               // Book
//               _sharedPrefs.readBook().then(
//                 (d) {
//                   Globals.bibleBook = d;
//                   // Chapter
//                   _sharedPrefs.readChapter().then(
//                     (e) {
//                       Globals.bookChapter = e;
//                       // Verse
//                       _sharedPrefs.readVerse().then(
//                         (f) {
//                           Globals.chapterVerse = f;
//                           // Book Name
//                           _sharedPrefs.readBookName().then(
//                             (g) {
//                               Globals.bookName = g;
//                             },
//                           );
//                         },
//                       );
//                     },
//                   );
//                 },
//               );
//             },
//           );
//         },
//       );
//     },
//   );
// }
