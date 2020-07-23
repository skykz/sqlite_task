import 'package:flutter/material.dart';
import 'package:test_project/page/list_items.dart';

import 'database/database_class.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseSqlClass().initSqlDb();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter task for ZigZag Group',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyListOrderScreen(title: 'Список заказов'),
    );
  }
}
