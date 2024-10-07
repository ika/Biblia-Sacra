import 'dart:async';
import 'package:path/path.dart';
import 'package:bibliasacra/utils/utils_constants.dart';
import 'package:sqflite/sqflite.dart';

// Version Key helper

class VkProvider {
  final int newDbVersion = 2;
  final String dataBaseName = Constants.vkeyCvsName;
  final String tableName = 'version_key';

  VkProvider.internal();
  static final VkProvider _instance = VkProvider.internal();
  static Database? _database;

  factory VkProvider() => _instance;

  Future<Database> get database async {
    _database ??= await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, dataBaseName);

    Database db = await openDatabase(path);

    int oldDbVersion = await db.getVersion();

    if (oldDbVersion < newDbVersion) {
      db.close();
      await deleteDatabase(path);

      //debugPrint('///////////// -VERSE PROVIDER- /////////////////////');

      db = await openDatabase(
        path,
        version: newDbVersion,
        onOpen: (db) async {},
        onCreate: (Database db, int version) async {
          await db.execute('''
              CREATE TABLE IF NOT EXISTS $tableName (
              "id" INTEGER PRIMARY KEY,
              "number" INTEGER,
              "active" INTEGER,
              "abbr" TEXT,
              "lang" TEXT,
              "name" TEXT
              )
          ''');

          await db.rawInsert(
              "INSERT INTO $tableName (number,active,abbr,lang,name) VALUES (?,?,?,?,?)",
              ['1', '1', 'KJV', 'eng', 'King James']);
          await db.rawInsert(
              "INSERT INTO $tableName (number,active,abbr,lang,name) VALUES (?,?,?,?,?)",
              ['2', '1', 'CLVUL', 'lat', 'Vulgata Clementina']);
          await db.rawInsert(
              "INSERT INTO $tableName (number,active,abbr,lang,name) VALUES (?,?,?,?,?)",
              ['3', '1', 'CPDV', 'eng', 'Catholic Public Domain']);
          await db.rawInsert(
              "INSERT INTO $tableName (number,active,abbr,lang,name) VALUES (?,?,?,?,?)",
              ['4', '1', 'NVUL', 'lat', 'Nova Vulgata']);
          await db.rawInsert(
              "INSERT INTO $tableName (number,active,abbr,lang,name) VALUES (?,?,?,?,?)",
              ['7', '1', 'UKJV', 'eng', 'Updated King James']);
          await db.rawInsert(
              "INSERT INTO $tableName (number,active,abbr,lang,name) VALUES (?,?,?,?,?)",
              ['8', '1', 'WEBBE', 'eng', 'World English Bible']);
          await db.rawInsert(
              "INSERT INTO $tableName (number,active,abbr,lang,name) VALUES (?,?,?,?,?)",
              ['10', '1', 'ASV', 'eng', 'American Standard']);
        },
      );
    }
    return db;
  }

  Future close() async {
    return _database!.close();
  }
}
