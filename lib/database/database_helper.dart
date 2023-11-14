import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:weather_app/models/location.dart';

class DatabaseHelper {
  static final nameDB = 'BD_WEATHER_1.2';
  static final versionDB = 1;

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    return _database = await _initDatabase();
  }

  _initDatabase() async {
    Directory folder = await getApplicationDocumentsDirectory();
    //print("initDataB");
    String pathDB = join(folder.path, nameDB);
    //print("rsdgdfgfdgfdgfdgfdgdfgfd");
    return await openDatabase(
      pathDB,
      version: versionDB,
      onCreate: _createTables,
    );
  }

  _createTables(Database db, int version) async {
    print("se está creando");
    String query = '''CREATE TABLE tblLocations (
      id INTEGER PRIMARY KEY,
      name VARCHAR(200),
      lon NUMERIC(30,20),
      lat NUMERIC(30,20)
    );''';
    await db.execute(query);
  }

  Future<int> INSERT(String tblName, Map<String, dynamic> data) async {
    var conexion = await database;
    return conexion.insert(tblName, data);
  }

  Future<int> UPDATE(String tblName, Map<String, dynamic> data) async {
    var conexion = await database;
    return conexion
        .update(tblName, data, where: 'id = ?', whereArgs: [data['id']]);
  }

  Future<int> DELETE(String tblName, int id) async {
    var conexion = await database;
    return conexion.delete(tblName, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<LocationModel>> GETALLLOCATIONS() async {
    var conexion = await database;
    var result = await conexion.query('tblLocations');
    return result.map((post) => LocationModel.fromMap(post)).toList();
  }
}
