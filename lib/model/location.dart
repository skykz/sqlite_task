import 'package:test_project/database/database_class.dart';

class LocationObject {
  int id;
  String lat;
  String lng;

  LocationObject(this.id, this.lat, this.lng);

  LocationObject.fromJson(Map<String, dynamic> jsonObject) {
    this.id = jsonObject[DatabaseSqlClass.id];
    this.lat = jsonObject[DatabaseSqlClass.lat];
    this.lng = jsonObject[DatabaseSqlClass.lng];
  }
}
