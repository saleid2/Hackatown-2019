import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:polseinzer/database/model/sign.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  static final double earth_radius = 6378137;

  static final String _create_table_sql =
      "CREATE TABLE parking(id INTEGER PRIMARY KEY, poteauId INTEGER, x REAL, y REAL, desc TEXT, code TEXT, fleche INTEGER)";

  factory DatabaseHelper() => _instance;
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);

    return theDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(_create_table_sql);

    await populateFromCsv();
  }

  Future<void> populateFromCsv() async {
    String raw = await rootBundle.loadString("raw/parking.csv");
    List<String> lines = raw.split('\r\n');

    lines.sublist(1).forEach((String line) async {
      if (line.isNotEmpty) {
        List row = line.split(',');

        int id = int.parse(row[0]);
        // Longitude
        double x = double.parse(row[1]);
        // Latitude
        double y = double.parse(row[2]);
        int poteauId = int.parse(row[3]);
        String desc = row[4];
        String code = row[5];
        int fleche = int.parse(row[6]);

        Sign sign = new Sign(id, x, y, poteauId, desc, code, fleche);

        await addSign(sign);
      }
    });
  }

  Future<int> addSign(Sign sign) async {
    var dbClient = await db;

    List<Map> list = await dbClient
        .rawQuery('SELECT * FROM parking WHERE id == ?', [sign.id]);

    if (list.length > 0) {
      print("${sign.id} already exists");
      return -1;
    }

    int res = await dbClient.insert("parking", sign.toMap());
    print("${sign.id} added");
    return res;
  }

  /// Radius is in meters
  Future<List<Sign>> getZone(
      double latitude, double longitude, double radius) async {
    var dbClient = await db;

    double dLat = getLatitudeDelta(radius);
    double dLon = getLongitudeDelta(radius, longitude);

    List<Map> list = await dbClient.rawQuery(
        'SELECT x,y FROM parking '
        'WHERE (x BETWEEN ? AND ?) '
        'AND (y BETWEEN ? and ?)',
        [latitude - dLat, latitude + dLat, longitude - dLon, longitude + dLon]);

    List<Sign> signs = new List();

    for (Map item in list) {
      signs.add(new Sign.map(item));
    }

    return signs;
  }

  /// Radius is in meters
  double getLatitudeDelta(double radius) {
    return (180 / pi) * (radius / earth_radius);
  }

  double getLongitudeDelta(double radius, double latitude) {
    return getLatitudeDelta(radius) / cos(pi / (180 * latitude));
  }
}
