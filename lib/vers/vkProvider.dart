import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:bibliasacra/utils/constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// Version Key helper

class VkProvider {
  static VkProvider _vkProvider;
  static Database _database;

  final String dataBaseName = Constants.vkeyDbname;
  //final String tableName = 'versions';

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
    String path = p.join(documentsDirectory.path, dataBaseName);

    if (!await databaseExists(path)) {
      try {
        await io.Directory(p.dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data =
          await rootBundle.load(p.join("assets/vkey", dataBaseName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await io.File(path).writeAsBytes(bytes, flush: true);
    }

    return await databaseFactory.openDatabase(path);
  }

  // Future<Database> initDB() async {
  //   io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
  //   String path = p.join(documentsDirectory.path, dataBaseName);

  //   //   var databaseFactory = databaseFactoryFfi;
  //   //  var db = await databaseFactory.openDatabase(path);

  //   var db = await openDatabase(path);

  //   await db.execute('''
  //               CREATE TABLE IF NOT EXISTS $tableName(
  //                   id INTEGER PRIMARY KEY,
  //                   number INTEGER DEFAULT 0,
  //                   active INTEGER DEFAULT 0,
  //                   abbr TEXT DEFAULT '',
  //                   lang TEXT DEFAULT '',
  //                   name TEXT DEFAULT ''
  //               )
  //           ''');
  //   await db.execute(
  //       '''INSERT INTO $tableName ('number', 'active', 'abbr', 'lang', 'name')
  //           values (?, ?, ?, ?, ?)''',
  //       [1, 1, 'KJV', 'eng', 'King James Version']);
  //   await db.execute(
  //       '''INSERT INTO $tableName ('number', 'active', 'abbr', 'lang', 'name')
  //           values (?, ?, ?, ?, ?)''',
  //       [2, 1, 'CLVUL', 'lat', 'Vulgata Clementina']);
  //   await db.execute(
  //       '''INSERT INTO $tableName ('number', 'active', 'abbr', 'lang', 'name')
  //           values (?, ?, ?, ?, ?)''',
  //       [3, 1, 'CPDV', 'eng', 'Catholic Pub Domain version']);
  //   await db.execute(
  //       '''INSERT INTO $tableName ('number', 'active', 'abbr', 'lang', 'name')
  //           values (?, ?, ?, ?, ?)''', [4, 1, 'NVUL', 'lat', 'Nova Vulgata']);
  //   await db.execute(
  //       '''INSERT INTO $tableName ('number', 'active', 'abbr', 'lang', 'name')
  //           values (?, ?, ?, ?, ?)''',
  //       [7, 1, 'UKJV', 'eng', 'Updated King James version']);
  //   await db.execute(
  //       '''INSERT INTO $tableName ('number', 'active', 'abbr', 'lang', 'name')
  //           values (?, ?, ?, ?, ?)''',
  //       [8, 1, 'WEBBE', 'eng', 'World English Bible']);
  //   await db.execute(
  //       '''INSERT INTO $tableName ('number', 'active', 'abbr', 'lang', 'name')
  //           values (?, ?, ?, ?, ?)''',
  //       [10, 1, 'ASV', 'eng', 'American Standard Version']);

  //   return db;
  // }

  Future close() async {
    return _database.close();
  }
}
