import 'package:test_project/database/database_class.dart';
import 'package:test_project/model/location.dart';
import 'package:test_project/model/order.dart';

class MainRepositoryServiceOrder {
  /// orders table
  static Future<List<Order>> getAllRecords() async {
    final sqlQuery = '''
    SELECT * FROM ${DatabaseSqlClass.mainTable} 
      WHERE ${DatabaseSqlClass.isDeleted} == 0
    ''';
    final jsonData = await db.rawQuery(sqlQuery);
    List<Order> orders = List();

    for (var item in jsonData) {
      final order = Order.fromJson(item);
      orders.add(order);
    }

    return orders;
  }

  static Future<void> createOrder(Order order) async {
    final createSql = '''INSERT INTO ${DatabaseSqlClass.mainTable}
        (
          ${DatabaseSqlClass.id},
          ${DatabaseSqlClass.name},
          ${DatabaseSqlClass.description},
          ${DatabaseSqlClass.createdAt},
          ${DatabaseSqlClass.isDeleted}
        )
        VALUES (?,?,?,?,?)''';
    List<dynamic> params = [
      order.id,
      order.name,
      order.description,
      order.createdDate,
      order.isDeleted ? 1 : 0
    ];
    final resultInsert = await db.rawInsert(createSql, params);
    DatabaseSqlClass.dbLog('Add Order', createSql, null, resultInsert);
  }

  static Future<void> deleteOrder(Order order) async {
    final updateSql = '''
      UPDATE ${DatabaseSqlClass.mainTable}
        SET ${DatabaseSqlClass.isDeleted} = 1
          WHERE ${DatabaseSqlClass.id} == ${order.id}
    ''';

    final deleteResult = await db.rawUpdate(updateSql);
    DatabaseSqlClass.dbLog('Add Order', updateSql, null, deleteResult);
  }

  static Future<int> ordersCount() async {
    final data = await db
        .rawQuery('''SELECT COUNT(*) FROM ${DatabaseSqlClass.mainTable}''');

    int count = data[0].values.elementAt(0);
    int idForNewItem = count++;
    return idForNewItem;
  }

  //Location table queries

  static Future<void> createLocationRecord(LocationObject location) async {
    final createSql = '''INSERT INTO ${DatabaseSqlClass.locationTable}
        (
          ${DatabaseSqlClass.id},
          ${DatabaseSqlClass.lat},
          ${DatabaseSqlClass.lng}         
        )
        VALUES (?,?,?)''';
    List<dynamic> params = [location.id, location.lat, location.lng];
    final resultInsert = await db.rawInsert(createSql, params);
    DatabaseSqlClass.dbLog(
        'Add Current Location', createSql, null, resultInsert);
  }

  static Future<List<LocationObject>> getAllRecordsLocations() async {
    final sqlQuery = '''
    SELECT * FROM ${DatabaseSqlClass.locationTable}''';
    final jsonData = await db.rawQuery(sqlQuery);
    List<LocationObject> locations = List();

    for (var item in jsonData) {
      final location = LocationObject.fromJson(item);
      locations.add(location);
    }

    return locations;
  }

  static Future<int> locationsCount() async {
    final data = await db
        .rawQuery('''SELECT COUNT(*) FROM ${DatabaseSqlClass.locationTable}''');

    int count = data[0].values.elementAt(0);
    int idForNewItem = count++;
    return idForNewItem;
  }
}
