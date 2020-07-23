import 'package:flutter/material.dart';
import 'package:test_project/model/order.dart';
import 'package:test_project/repository/repository_service.dart';

class AddItemScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String _name;
  String _description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить заказ'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Form(key: _formKey, child: _builTextField()),
              FlatButton(
                color: Colors.green[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: () => createNewOrder(context),
                splashColor: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Text(
                      "Добавить заказ",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _builTextField() {
    return Column(
      children: <Widget>[
        TextFormField(
          maxLines: null,
          cursorWidth: 1.0,
          keyboardType: TextInputType.text,
          maxLength: 50,
          onChanged: (value) {
            value.trim();
          },
          validator: (value) {
            if (value.isEmpty) {
              return 'Обязательное поле!';
            } else {
              return null;
            }
          },
          onSaved: (value) => _name = value,
          cursorColor: Colors.green,
          decoration: InputDecoration(
            hintText: "Название заказа",
            labelText: "Напишите название *",
            labelStyle: TextStyle(fontSize: 16),
            hintStyle: TextStyle(fontSize: 16),
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 15.0),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          maxLines: null,
          cursorWidth: 1.0,
          keyboardType: TextInputType.text,
          maxLength: 150,
          validator: (value) {
            if (value.isEmpty) {
              return 'Обязательное поле!';
            } else {
              return null;
            }
          },
          onSaved: (value) => _description = value,
          onChanged: (value) {
            value.trim();
          },
          cursorColor: Colors.green,
          decoration: InputDecoration(
            hintText: "Описание",
            labelText: "Напишите описание *",
            labelStyle: TextStyle(fontSize: 16),
            hintStyle: TextStyle(fontSize: 16),
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 15.0),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  void createNewOrder(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      int count = await MainRepositoryServiceOrder.ordersCount();
      final order =
          Order(count, _name, _description, false, DateTime.now().toString());
      _formKey.currentState.reset();
      MainRepositoryServiceOrder.createOrder(order);
      Navigator.pop(context);
    }
  }
}
