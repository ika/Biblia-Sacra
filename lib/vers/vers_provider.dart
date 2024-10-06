import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:bibliasacra/utils/utils_constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:csv/csv.dart';

// Version Key helper

class VkProvider {
  final int newDbVersion = 1;
  final String dataBaseName = Constants.vkeyDbname;
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

    if (await db.getVersion() < newDbVersion) {
      db.close();
      await deleteDatabase(path);

      final vkeycsv = await rootBundle.loadString('asset/vkey/vkey.csv');
      List<List<dynamic>> csvRows = const CsvToListConverter().convert(vkeycsv);

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
          Batch batch = db.batch();
          for (int i = 0; i < csvRows.length; i++) {
            batch.rawInsert(
                "INSERT INTO $tableName (number,active,abbr,lang,name) VALUES (?,?,?,?,?)",
                [
                  "${csvRows[i][0]}",
                  "${csvRows[i][1]}",
                  "${csvRows[i][2]}",
                  "${csvRows[i][3]}",
                  "${csvRows[i][4]}"
                ]);
          }
          await batch.commit();
        },
      );
    }
    return db;
  }

  Future close() async {
    return _database!.close();
  }
}
