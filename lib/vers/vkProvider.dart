import 'dart:async';
import 'package:bibliasacra/utils/constants.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

// Version Key helper

class VkProvider {
  static VkProvider _vkProvider;
  static Database _database;

  final String _dbName = Constants.vkeyDbname;
  final String tableName = 'versions';

  VkProvider._createInstance();

  factory VkProvider() {
    _vkProvider ??= VkProvider._createInstance();
    return _vkProvider;
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
        await db.execute('''
                CREATE TABLE IF NOT EXISTS $tableName(
                    id INTEGER PRIMARY KEY,
                    number INTEGER DEFAULT 0,
                    active INTEGER DEFAULT 0,
                    abbr TEXT DEFAULT '',
                    lang TEXT DEFAULT '',
                    name TEXT DEFAULT ''
                )
            ''');
        await db.execute(
            '''INSERT INTO $tableName ('id', 'number', 'active', 'abbr', 'lang', 'name') 
            values (?, ?, ?, ?, ?, ?)''',
            [0, 1, 1, 'KJV', 'eng', 'King James Version']);
        await db.execute(
            '''INSERT INTO $tableName ('id', 'number', 'active', 'abbr', 'lang', 'name') 
            values (?, ?, ?, ?, ?, ?)''',
            [1, 2, 1, 'CLVUL', 'lat', 'Vulgata Clementina']);
        await db.execute(
            '''INSERT INTO $tableName ('id', 'number', 'active', 'abbr', 'lang', 'name') 
            values (?, ?, ?, ?, ?, ?)''',
            [2, 3, 1, 'CPDV', 'eng', 'Catholic Pub Domain version']);
        await db.execute(
            '''INSERT INTO $tableName ('id', 'number', 'active', 'abbr', 'lang', 'name') 
            values (?, ?, ?, ?, ?, ?)''',
            [3, 4, 1, 'NVUL', 'lat', 'Nova Vulgata']);
        await db.execute(
            '''INSERT INTO $tableName ('id', 'number', 'active', 'abbr', 'lang', 'name') 
            values (?, ?, ?, ?, ?, ?)''',
            [6, 7, 1, 'UKJV', 'eng', 'Updated King James version']);
        await db.execute(
           '''INSERT INTO $tableName ('id', 'number', 'active', 'abbr', 'lang', 'name') 
            values (?, ?, ?, ?, ?, ?)''',
            [7, 8, 1, 'WEBBE', 'eng', 'World English Bible']);
        await db.execute(
           '''INSERT INTO $tableName ('id', 'number', 'active', 'abbr', 'lang', 'name') 
            values (?, ?, ?, ?, ?, ?)''',
            [9, 10, 1, 'ASV', 'eng', 'American Standard Version']);
      },
    );
  }

  Future close() async {
    return _database.close();
  }
}
