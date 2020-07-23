import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database db;

class DatabaseSqlClass {
  // order table
  static const mainTable = 'orders';
  static const id = 'id';
  static const name = 'name';
  static const description = 'text';
  static const isDeleted = 'isDeleted';
  static const createdAt = 'created_at';

  //location table
  static const locationTable = 'locations';
  static const lat = 'lat';
  static const lng = 'lng';

  static void dbLog(String funcName, String sql,
      [List<Map<String, dynamic>> selectQueryResult,
      int insertAndUpdateQueryResult]) {
    log("function Name --> $funcName");
    print("SQL  --> $sql");

    if (selectQueryResult != null) {
      print("select query result --> $selectQueryResult");
    } else if (insertAndUpdateQueryResult != null) {
      print("insert & update result --> $insertAndUpdateQueryResult");
    }
  }

  Future<void> createOrderTable(Database db) async {
    final orderCreateTableSql = '''CREATE TABLE $mainTable
    (
      $id INTEGER PRIMARY KEY,
      $name TEXT,      
      $description TEXT,
      $isDeleted BIT NOT NULL,
      $createdAt TEXT
    )''';

    await db.execute(orderCreateTableSql);
  }

  Future<void> createLocationTable(Database db) async {
    final locationCreateTableSql = '''CREATE TABLE $locationTable
    (
      $id INTEGER PRIMARY KEY,
      $lat TEXT,      
      $lng TEXT
    )''';

    await db.execute(locationCreateTableSql);
  }

  Future<String> getDbPath(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbName, dbPath);

    if (await Directory(dirname(path)).exists()) {
      await deleteDatabase(path);
    } else {
      await Directory(dirname(path)).create(recursive: true);
    }
    return path;
  }

  Future<void> initSqlDb() async {
    final dbPath = await getDbPath(mainTable);
    db = await openDatabase(dbPath, version: 1, onCreate: onCreateFunction);
    log("$db");
  }

  Future<void> onCreateFunction(Database db, int version) async {
    await createOrderTable(db);
    await createLocationTable(db);
  }
}
