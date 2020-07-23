import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:test_project/model/order.dart';
import 'package:test_project/page/add_item.dart';
import 'package:test_project/repository/repository_service.dart';
import 'package:intl/intl.dart';

import 'add_location.dart';

class MyListOrderScreen extends StatefulWidget {
  MyListOrderScreen({this.title});
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyListOrderScreen> {
  @override
  void initState() {
    initializeDateFormatting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: "geo",
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddLocationScreen(),
              ),
            ),
            tooltip: 'Геопозиция',
            backgroundColor: Colors.blue[300],
            child: Icon(
              Icons.add_location,
              size: 35,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          FloatingActionButton(
            heroTag: "add",
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddItemScreen(),
                )).then((value) => setState(() {})),
            tooltip: 'Добавить',
            backgroundColor: Colors.green[300],
            child: Icon(
              Icons.add,
              size: 35,
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Order>>(
        future: MainRepositoryServiceOrder.getAllRecords(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                backgroundColor: Colors.green,
              ),
            );

          if (snapshot.data.length != 0) {
            return ListView.separated(
                padding: const EdgeInsets.only(top: 10),
                itemCount: snapshot.data.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    height: 2,
                    color: Colors.grey,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return buildItem(snapshot.data[index], index);
                });
          }

          return const Center(child: Text('Пока нету заказов'));
        },
      ),
    );
  }

  ListTile buildItem(Order order, int index) {
    return ListTile(
      leading: Column(
        children: <Widget>[
          const Icon(
            Icons.assignment,
            size: 25,
          ),
          Text("${index + 1}")
        ],
      ),
      title: Text(
        '${order.name}',
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${order.description}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            '${formatTimeStamp(order.createdDate)}',
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          )
        ],
      ),
      isThreeLine: true,
      trailing: IconButton(
        icon: const Icon(
          Icons.cancel,
          color: Colors.red,
        ),
        onPressed: () => deleteOrder(order),
      ),
    );
  }

  deleteOrder(Order order) async {
    await MainRepositoryServiceOrder.deleteOrder(order);
    setState(() {});
  }

  String formatTimeStamp(String dateTime) {
    var date = DateTime.parse(dateTime);
    String hourMinute = DateFormat.Hm().format(date);
    String dayMonthYear = DateFormat.yMMMd('ru').format(date);

    return hourMinute + " / " + dayMonthYear;
  }
}
