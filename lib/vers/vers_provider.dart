import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:bibliasacra/utils/utils_constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// Version Key helper

class VkProvider {
  static VkProvider? _vkProvider;
  static Database? _database;

  final String dataBaseName = Constants.vkeyDbname;
  //final String tableName = 'versions';

  VkProvider._createInstance();

  factory VkProvider() {
    _vkProvider ??= VkProvider._createInstance();
    return _vkProvider!;
  }

  Future<Database> get database async {
    _database ??= await initDB();
    return _database!;
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

  Future close() async {
    return _database!.close();
  }
}
