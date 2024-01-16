// import 'package:bibliasacra/bmarks/bm_page.dart';
// import 'package:bibliasacra/dict/dict_page.dart';
// import 'package:bibliasacra/fonts/fonts.dart';
// import 'package:bibliasacra/globals/globals.dart';
// import 'package:bibliasacra/high/hi_page.dart';
// import 'package:bibliasacra/main/main_search.dart';
// import 'package:bibliasacra/notes/no_page.dart';
// import 'package:bibliasacra/theme/theme.dart';
// import 'package:bibliasacra/vers/vers_page.dart';
// import 'package:flutter/material.dart';

// Widget showDrawer(BuildContext context) {
//   return Drawer(
//     backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//     child: ListView(
//       padding: const EdgeInsets.all(20),
//       children: [
//         DrawerHeader(
//           //decoration: const BoxDecoration(
//           //color: Theme.of(context).colorScheme.secondaryContainer,
//           // image: DecorationImage(
//           //   fit: BoxFit.fill,
//           //   image: AssetImage('path/to/header_background.png'),
//           // ),
//           // ),
//           child: Stack(
//             children: [
//               Positioned(
//                 bottom: 20.0,
//                 //left: 16.0,
//                 child: Text(
//                   "Biblia Sacra",
//                   style: TextStyle(
//                       color: Theme.of(context).colorScheme.primary,
//                       fontSize: 32.0),
//                   //fontWeight: FontWeight.w500),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 10,
//         ),
//         ListTile(
//           trailing: const Icon(Icons.arrow_right),
//           //color: Theme.of(context).colorScheme.primary),
//           title: const Text(
//             'Bookmarks',
//             // style: TextStyle(
//             //     //color: Colors.white,
//             //     fontSize: 16.0,
//             //     fontWeight: FontWeight.bold),
//           ),
//           onTap: () {
//             Route route = MaterialPageRoute(
//               builder: (context) => const BookMarksPage(),
//             );
//             Future.delayed(
//               Duration(milliseconds: Globals.navigatorDelay),
//               () {
//                 Navigator.push(context, route);
//               },
//             );
//           },
//         ),
//         ListTile(
//           trailing: const Icon(Icons.arrow_right),
//           //color: Theme.of(context).colorScheme.primary),
//           title: const Text(
//             'Hilights',
//             // style: TextStyle(
//             //     //color: Colors.white,
//             //     fontSize: 16.0,
//             //     fontWeight: FontWeight.bold),
//           ),
//           onTap: () {
//             Route route = MaterialPageRoute(
//               builder: (context) => const HighLightsPage(),
//             );
//             Future.delayed(
//               Duration(milliseconds: Globals.navigatorDelay),
//               () {
//                 Navigator.push(context, route);
//               },
//             );
//           },
//         ),
//         ListTile(
//           trailing: const Icon(Icons.arrow_right),
//           //color: Theme.of(context).colorScheme.primary),
//           title: const Text(
//             'Notes',
//             // style: TextStyle(
//             //     //color: Colors.white,
//             //     fontSize: 16.0,
//             //     fontWeight: FontWeight.bold),
//           ),
//           onTap: () {
//             Route route = MaterialPageRoute(
//               builder: (context) => const NotesPage(),
//             );
//             Future.delayed(
//               Duration(milliseconds: Globals.navigatorDelay),
//               () {
//                 Navigator.push(context, route);
//               },
//             );
//           },
//         ),
//         ListTile(
//           trailing: const Icon(Icons.arrow_right),
//           //color: Theme.of(context).colorScheme.primary),
//           title: const Text(
//             'Latin word list',
//             // style: TextStyle(
//             //     //color: Colors.white,
//             //     fontSize: 16.0,
//             //     fontWeight: FontWeight.bold),
//           ),
//           onTap: () {
//             Route route = MaterialPageRoute(
//               builder: (context) => const DictSearch(),
//             );
//             Future.delayed(
//               Duration(milliseconds: Globals.navigatorDelay),
//               () {
//                 Navigator.push(context, route);
//               },
//             );
//           },
//         ),
//         ListTile(
//           trailing: const Icon(Icons.arrow_right),
//           //color: Theme.of(context).colorScheme.primary),
//           title: const Text(
//             'Search',
//             // style: TextStyle(
//             //     //color: Colors.white,
//             //     fontSize: 16.0,
//             //     fontWeight: FontWeight.bold),
//           ),
//           onTap: () {
//             Route route = MaterialPageRoute(
//               builder: (context) => const MainSearch(),
//             );
//             Future.delayed(
//               Duration(milliseconds: Globals.navigatorDelay),
//               () {
//                 Navigator.push(context, route);
//               },
//             );
//           },
//         ),
//         ListTile(
//           trailing: const Icon(Icons.arrow_right),
//           //color: Theme.of(context).colorScheme.primary),
//           title: const Text(
//             'Bibles',
//             // style: TextStyle(
//             //     //color: Colors.white,
//             //     fontSize: 16.0,
//             //     fontWeight: FontWeight.bold),
//           ),
//           onTap: () {
//             Route route = MaterialPageRoute(
//               builder: (context) => const VersionsPage(),
//             );
//             Future.delayed(
//               Duration(milliseconds: Globals.navigatorDelay),
//               () {
//                 Navigator.push(context, route);
//               },
//             );
//           },
//         ),
//         ListTile(
//           trailing: const Icon(Icons.arrow_right),
//           //color: Theme.of(context).colorScheme.primary),
//           title: const Text(
//             'Fonts',
//             // style: TextStyle(
//             //     //color: Colors.white,
//             //     fontSize: 16.0,
//             //     fontWeight: FontWeight.bold),
//           ),
//           onTap: () {
//             Route route = MaterialPageRoute(
//               builder: (context) => const FontsPage(),
//             );
//             Future.delayed(
//               Duration(milliseconds: Globals.navigatorDelay),
//               () {
//                 Navigator.push(context, route);
//               },
//             );
//           },
//         ),
//         ListTile(
//           trailing: const Icon(Icons.arrow_right),
//           //color: Theme.of(context).colorScheme.primary),
//           title: const Text(
//             'Theme',
//             // style: TextStyle(
//             //     //color: Colors.white,
//             //     fontSize: 16.0,
//             //     fontWeight: FontWeight.bold),
//           ),
//           onTap: () {
//             Route route = MaterialPageRoute(
//               builder: (context) => const ThemePage(),
//             );
//             Future.delayed(
//               Duration(milliseconds: Globals.navigatorDelay),
//               () {
//                 Navigator.push(context, route);
//               },
//             );
//           },
//         ),
//       ],
//     ),
//   );
// }
