import 'package:bibliasacra/utils/constants.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class NtProvider {
  static NtProvider _ntProvider;
  static Database _database;

  final String _dbName = Constants.notesDbname;
  final String _tableName = 'notes';

  NtProvider._createInstance();

  factory NtProvider() {
    _ntProvider ??= NtProvider._createInstance();
    return _ntProvider;
  }

  Future<Database> get database async {
    _database ??= await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    var databasesPath = await getDatabasesPath();
    var path = p.join(databasesPath, _dbName);

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) async {},
      onCreate: (Database db, int version) async {
        // Create the note table
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

  Future close() async {
    return _database.close();
  }
}
