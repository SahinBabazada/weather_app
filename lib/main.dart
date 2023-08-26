import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:weather_app_v2/services/get_weather_status.dart';

import 'models/weather_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Location location = Location();

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  bool isGetLocation = false;

  void getCoordinate() async {
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
    _locationData = await location.getLocation();
  }

  @override
  void initState() {
    super.initState();
    _locationData;

    getCoordinate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: getWeather(_locationData.latitude, _locationData.longitude),
        builder: ((context, snapshot) {
          Weather? weather = snapshot.data;
          debugPrint(weather!.name);
          return snapshot.hasData
              ? Center(
                  child: Column(
                    children: [
                      Text(
                        'City: ${weather!.name}',
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  ), // This trailing comma makes auto-formatting nicer for build methods.
                )
              : Container();
        }),
      ),
    );
  }
}
