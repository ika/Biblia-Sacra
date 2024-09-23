import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:bibliasacra/utils/utils_constants.dart';
import 'package:sqflite/sqflite.dart';

// bm_provider.dart

class BmProvider {
  final int newDbVersion = 0;
  final String dataBaseName = Constants.bmksDbname;
  final String tableName = 'bmks_table';

  BmProvider.internal();
  static dynamic _database;

  static final BmProvider _instance = BmProvider.internal();

  factory BmProvider() => _instance;

  Future<Database> get database async {
    _database ??= await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, dataBaseName);

    Database db = await openDatabase(path);

    if (await db.getVersion() < newDbVersion) {
      db.close();
      await deleteDatabase(path);

      db = await openDatabase(
        path,
        version: newDbVersion,
        onOpen: (db) async {},
        onCreate: (Database db, int version) async {
          await db.execute('''
                CREATE TABLE IF NOT EXISTS $tableName (
                    id INTEGER PRIMARY KEY,
                    title TEXT DEFAULT '',
                    subtitle TEXT DEFAULT '',
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
        },
      );
    }
    return db;
  }

  Future close() async {
    return _database!.close();
  }
}
