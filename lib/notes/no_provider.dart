import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:bibliasacra/utils/utils_constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// no_provider.dart

class NtProvider {
  static NtProvider? _ntProvider;
  static Database? _database;

  final String dataBaseName = Constants.notesDbname;
  final String _tableName = 'notes';

  NtProvider._createInstance();

  factory NtProvider() {
    _ntProvider ??= NtProvider._createInstance();
    return _ntProvider!;
  }

  Future<Database> get database async {
    _database ??= await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dataBaseName);

    var db = await databaseFactory.openDatabase(path);

    await db.execute('''
                CREATE TABLE IF NOT EXISTS $_tableName (
                    id INTEGER PRIMARY KEY,
                    title TEXT DEFAULT '',
                    contents TEXT DEFAULT '',
                    lang TEXT DEFAULT '',
                    version INTEGER DEFAULT 0,
                    abbr TEXT DEFAULT '',
                    book INTEGER DEFAULT 0,
                    chapter INTEGER DEFAULT 0,
                    verse INTEGER DEFAULT 0,
                    name TEXT DEFAULT '',
                    bid INTEGER DEFAULT 0
                )
            ''');

    return db;
  }

  Future close() async {
    return _database!.close();
  }
}
