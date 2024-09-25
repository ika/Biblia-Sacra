import 'package:bibliasacra/bloc/bloc_book.dart';
import 'package:bibliasacra/bloc/bloc_chapters.dart';
import 'package:bibliasacra/bloc/bloc_verse.dart';
import 'package:bibliasacra/bloc/bloc_version.dart';
import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/high/hl_model.dart';
import 'package:bibliasacra/high/hl_queries.dart';
import 'package:bibliasacra/main/main_page.dart';
import 'package:bibliasacra/utils/utils_snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// hi_page.dart

HlQueries _hlQueries = HlQueries();

class HighLightsPage extends StatefulWidget {
  const HighLightsPage({super.key});

  @override
  State<StatefulWidget> createState() => _HighLightsPage();
}

class _HighLightsPage extends State<HighLightsPage> {
  List<HlModel> list = List<HlModel>.empty();

  // @override
  // void initState() {
  //   super.initState();
  // }

  Future confirmDialog(arr) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(arr[0].toString()),
        content: Text(arr[1].toString()),
        actions: [
          TextButton(
            child:
                const Text('NO', style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('YES',
                style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }

  void deleteWrapper(context, list, index) {
    final buffer = <String>[list[index].title, "\n", list[index].subtitle];
    final sb = StringBuffer();
    sb.writeAll(buffer);

    var arr = List.filled(2, '');
    arr[0] = "Delete this Highlight?";
    arr[1] = sb.toString();

    confirmDialog(arr).then(
      (value) {
        if (value) {
          _hlQueries.deleteHighLight(list[index].bid).then(
            (value) {
              //Globals.listReadCompleted = false;
              ScaffoldMessenger.of(context)
                  .showSnackBar(hiLightDeletedSnackBar);
              // ActiveHighLightList()
              //     .updateActiveHighLightList(list[index].version!);
              setState(() {});
            },
          );
        }
      }, //_deleteWrapper,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HlModel>>(
      future: _hlQueries.getHighLightList(),
      builder: (context, AsyncSnapshot<List<HlModel>> snapshot) {
        if (snapshot.hasData) {
          list = snapshot.data!;
          return PopScope(
            canPop: false,
            child: Scaffold(
              //backgroundColor: Theme.of(context).colorScheme.background,
              appBar: AppBar(
                //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                centerTitle: true,
                elevation: 5,
                leading: GestureDetector(
                  child: const Icon(Globals.backArrow),
                  onTap: () {
                    Future.delayed(
                      Duration(milliseconds: Globals.navigatorDelay),
                      () {
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                    );
                  },
                ),
                //elevation: 0.1,
                title: const Text(
                  'Highlights',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView.separated(
                  // scrollDirection: Axis.vertical,
                  // shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onHorizontalDragEnd: (DragEndDetails details) {
                        if (details.primaryVelocity! > 0 ||
                            details.primaryVelocity! < 0) {
                          deleteWrapper(context, list, index);
                        }
                      },
                      child: ListTile(
                        trailing: Icon(Icons.arrow_right,
                            color: Theme.of(context).colorScheme.primary),
                        title: Text(
                          list[index].title!,
                          // style: TextStyle(
                          //     fontWeight: FontWeight.bold, fontSize: primaryTextSize),
                        ),
                        subtitle: Text(
                          list[index].subtitle!,
                          // style: TextStyle(fontSize: primaryTextSize),
                        ),
                        onTap: () {
                          context.read<VersionBloc>().add(UpdateVersion(
                              bibleVersion: list[index].version!));

                          context.read<BookBloc>().add(UpdateBook(
                              book: list[index].book!)); // UpdateBook

                          context.read<ChapterBloc>().add(
                              UpdateChapter(chapter: list[index].chapter!));

                          context.read<VerseBloc>().add(UpdateVerse(
                              verse: list[index].verse!)); // UpdateVerse

                          Route route = MaterialPageRoute(
                            builder: (context) => const MainPage(),
                          );
                          Future.delayed(
                            Duration(milliseconds: Globals.navigatorDelay),
                            () {
                              if (context.mounted) {
                                Navigator.push(context, route);
                              }
                            },
                          );
                          //});
                        },
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                ),
              ),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
