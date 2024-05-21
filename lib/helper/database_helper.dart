import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class WeatherDatabase {
  static Database? _database;

  static const String tableName = 'weather';
  static const String columnCity = 'city';
  static const String temperature = 'temperature';
  static const String minTemperature = 'minTemperature';
  static const String maxTemperature = 'maxTemperature';
  static const String weatherCondition = 'weatherCondition';
  static const String humidity = 'humidity';
  static const String windSpeed = 'windSpeed';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'weather.db');
    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  void _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        $columnCity TEXT PRIMARY KEY,
        $temperature INTEGER,
        $minTemperature INTEGER,
        $maxTemperature INTEGER,
        $weatherCondition TEXT,
        $humidity INTEGER,
        $windSpeed REAL
      )
    ''');
  }

  Future<void> insertWeather(String city, int temp, int min, int max,
      int humiditys, double wind, String condition) async {
    final db = await database;
    await db.insert(
        tableName,
        {
          columnCity: city,
          temperature: temp,
          minTemperature: min,
          maxTemperature: max,
          weatherCondition: condition,
          humidity: humiditys,
          windSpeed: windSpeed,
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    final db = await database;
    return await db.query(tableName);
  }
}
