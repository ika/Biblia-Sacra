import 'dart:async';
import 'package:bibliasacra/utils/constants.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

// Bookmarks database helper

class BmProvider {
  final String dataBaseName = Constants.bmksDbname;
  final String tableName = 'bmks_table';

  static BmProvider _dbProvider;
  static Database _database;

  BmProvider._createInstance();

  factory BmProvider() {
    _dbProvider ??= BmProvider._createInstance();
    return _dbProvider;
  }

  Future<Database> get database async {
    _database ??= await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    var databasesPath = await getDatabasesPath();
    var path = p.join(databasesPath, dataBaseName);

    return await openDatabase(
      path,
      version: 1,
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
                    name TEXT DEFAULT ''
                )
            ''');
      },
    );
  }

  Future close() async {
    return _database.close();
  }
}
