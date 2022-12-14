import 'dart:async';
import 'package:bibliasacra/dict/dicQueries.dart';
import 'package:flutter/material.dart';

DictQueries _dictQueries = DictQueries();

Future<List<DicModel>> blankSearch;
Future<List<DicModel>> filteredSearch;
Future<List<DicModel>> results;

String _contents = '';

class DictSearch extends StatefulWidget {
  const DictSearch({Key key}) : super(key: key);

  @override
  State<DictSearch> createState() => _DicSearchState();
}

class _DicSearchState extends State<DictSearch> {
  @override
  initState() {
    super.initState();
    blankSearch = Future.value([]);
    filteredSearch = blankSearch;
  }

  void runFilter(String enterdKeyWord) {
    enterdKeyWord.isEmpty
        ? results = blankSearch
        : results = _dictQueries.getSearchedValues(enterdKeyWord);

    setState(
      () {
        filteredSearch = results;
      },
    );
  }

  backPopButton(BuildContext context) {
    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        Navigator.pop(context);
      },
    );
  }

  Future emptyInputDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Empty Input!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const [
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
      padding: const EdgeInsets.all(8.0),
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
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Future.delayed(
                    const Duration(milliseconds: 200),
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
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return listTileMethod(snapshot, index);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                      height: 2.0,
                    ),
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
        snapshot.data[index].word,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        snapshot.data[index].trans,
        style: const TextStyle(fontWeight: FontWeight.normal),
      ),
      onTap: () {},
    );
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
          onWillPop: () async {
            FocusScope.of(context).unfocus();
            backPopButton(context);
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Latin Word List',
                style: TextStyle(fontSize: 16),
              ),
            ),
            body: searchWidget(),
          ),
        ),
      );
}