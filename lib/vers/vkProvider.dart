import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:bibliasacra/utils/constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// Version Key helper

class VkProvider {
  static VkProvider _vkProvider;
  static Database _database;

  final String dataBaseName = Constants.vkeyDbname;
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
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dataBaseName);

    //var db = await databaseFactory.openDatabase(path);
    //var db = await openDatabase(path, version: 1);

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) async {},
      onCreate: (Database db, int version) async {
        db.execute('''
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
    //return db;
  }

  Future close() async {
    return _database.close();
  }
}
