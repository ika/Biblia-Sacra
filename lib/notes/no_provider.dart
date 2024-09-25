import 'dart:async';
import 'package:path/path.dart';
import 'package:bibliasacra/utils/utils_constants.dart';
import 'package:sqflite/sqflite.dart';

// no_provider.dart

class NtProvider {
  final int newDbVersion = 1;
  final String dataBaseName = Constants.notesDbname;
  final String _tableName = 'notes';

  NtProvider();

  NtProvider.internal();
  static final NtProvider _instance = NtProvider.internal();
  static Database? _database;

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
        },
      );
    }
    return db;
  }

  Future close() async {
    return _database!.close();
  }
}
