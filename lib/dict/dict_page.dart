import 'dart:async';
import 'package:bibliasacra/dict/dict_queries.dart';
import 'package:bibliasacra/globals/globs_main.dart';
import 'package:flutter/material.dart';

DictQueries _dictQueries = DictQueries();

Future<List<DicModel>>? blankSearch;
Future<List<DicModel>>? filteredSearch;
Future<List<DicModel>>? results;

String _contents = '';

MaterialColor? primarySwatch;
//double? primaryTextSize;

class DictSearch extends StatefulWidget {
  const DictSearch({super.key});

  @override
  State<DictSearch> createState() => _DicSearchState();
}

class _DicSearchState extends State<DictSearch> {
  @override
  initState() {
    blankSearch = Future.value([]);
    filteredSearch = blankSearch;
    // primarySwatch =
    //     BlocProvider.of<SettingsCubit>(context).state.themeData.primaryColor as MaterialColor?;
    //primaryTextSize = Globals.initialTextSize;
    super.initState();
  }

  Future<List<DicModel>> repeatSearch(String enterdKeyWord) async {
    List<DicModel> searchList = [];

    enterdKeyWord = enterdKeyWord.trim();

    //enterdKeyWord = enterdKeyWord.replaceAll(RegExp(r'[^\w\s]+'), '');

    do {
      //debugPrint("ENTEREDKEYWORD $enterdKeyWord");
      searchList = await _dictQueries.getSearchedValues(enterdKeyWord);
      enterdKeyWord = enterdKeyWord.characters.skipLast(1).toString();
    } while (searchList.first.trans!.isEmpty);

    return searchList;
  }

  void runFilter(String enterdKeyWord) {
    enterdKeyWord.isEmpty
        ? results = blankSearch
        : results = repeatSearch(enterdKeyWord);

    setState(
      () {
        filteredSearch = results;
      },
    );
  }

  backButton(BuildContext context) {
    Future.delayed(
      Duration(milliseconds: Globals.navigatorDelay),
      () {
        Navigator.of(context).pop();
      },
    );
  }

  Future emptyInputDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Empty Input!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Please enter search text.'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget searchWidget() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TextFormField(
            initialValue: '',
            maxLength: 40,
            maxLines: 1,
            autofocus: false,
            onTap: () {
              filteredSearch = Future.value([]);
            },
            onChanged: (value) {
              _contents = value;
            },
            decoration: InputDecoration(
              labelText: 'Search',
              //labelStyle: TextStyle(fontSize: primaryTextSize),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Future.delayed(
                    Duration(milliseconds: Globals.navigatorDelay),
                    () {
                      _contents.isEmpty
                          ? emptyInputDialog(context)
                          : runFilter(_contents);
                    },
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<DicModel>>(
              future: filteredSearch,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.separated(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return listTileMethod(snapshot, index);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  ListTile listTileMethod(AsyncSnapshot<List<DicModel>> snapshot, int index) {
    return ListTile(
      title: Text(
        snapshot.data![index].word!,
        // style:
        //     TextStyle(fontWeight: FontWeight.bold, fontSize: primaryTextSize),
      ),
      subtitle: Text(
        snapshot.data![index].trans!,
        // style:
        //     TextStyle(fontWeight: FontWeight.normal, fontSize: primaryTextSize),
      ),
      //onTap: () {},
    );
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          //backgroundColor: Theme.of(context).colorScheme.background,

          appBar: AppBar(
            //backgroundColor: Theme.of(context).colorScheme.primary,
            centerTitle: true,
            leading: GestureDetector(
              child: const Icon(Globals.backArrow),
              onTap: () {
                backButton(context);
              },
            ),
            title: const Text(
              'Latin Word List',
              //style: TextStyle(fontSize: Globals.appBarFontSize),
            ),
          ),
          body: searchWidget(),
        ),
      );
}
