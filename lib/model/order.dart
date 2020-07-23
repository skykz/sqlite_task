import 'package:test_project/database/database_class.dart';

class Order {
  int id;
  String name;
  String description;
  String createdDate;
  bool isDeleted;

  Order(this.id, this.name, this.description, this.isDeleted, this.createdDate);

  Order.fromJson(Map<String, dynamic> jsonObject) {
    this.id = jsonObject[DatabaseSqlClass.id];
    this.name = jsonObject[DatabaseSqlClass.name];
    this.description = jsonObject[DatabaseSqlClass.description];
    this.createdDate = jsonObject[DatabaseSqlClass.createdAt];
    this.isDeleted = jsonObject[DatabaseSqlClass.isDeleted] == 1;
  }
}
