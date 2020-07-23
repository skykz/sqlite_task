import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:test_project/model/location.dart';
import 'package:test_project/repository/repository_service.dart';

class AddLocationScreen extends StatefulWidget {
  @override
  _AddLocationScreenState createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  Location location = Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  Timer timer;

  Future<List<LocationObject>> locationFuture;

  @override
  void initState() {
    getCurrentLocationPermission();

    // get all records, if there are some values
    locationFuture = MainRepositoryServiceOrder.getAllRecordsLocations();

    // make current location request every 10 sec.
    timer = Timer.periodic(
        Duration(seconds: 10), (Timer t) => _getCurrentLocationDataAndSave());
    super.initState();
  }

  //check Location permission for app and make request
  getCurrentLocationPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  //get location after we have permission then save it in database and refresh widget tree
  _getCurrentLocationDataAndSave() async {
    _locationData = await location.getLocation();
    log("$_locationData");
    if (_locationData != null) {
      int count = await MainRepositoryServiceOrder.locationsCount();
      final location = LocationObject(count, _locationData.latitude.toString(),
          _locationData.longitude.toString());
      await MainRepositoryServiceOrder.createLocationRecord(location);
      if (this.mounted)
        setState(() {
          locationFuture = MainRepositoryServiceOrder.getAllRecordsLocations();
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: const Text('Добавить геопозицию'),
      ),
      body: FutureBuilder<List<LocationObject>>(
        future: locationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(
              child: CircularProgressIndicator(
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
                  return buildLocationItem(snapshot.data[index], index);
                });
          }

          return const Center(child: Text('Пока нету записей'));
        },
      ),
    );
  }

  ListTile buildLocationItem(LocationObject location, int index) {
    return ListTile(
      leading: const Icon(
        Icons.location_on,
        size: 25,
      ),
      title: Text(
        '${location.lat}  -  ${location.lng}',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
