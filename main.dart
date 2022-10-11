import 'package:flutter/material.dart';
import 'dart:async';
import 'package:trust_location/trust_location.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _latitude = '';
  String? _longitude;
  bool? _isMockLocation;

  /// initialize state.
  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    // input seconds into parameter for getting location with repeating by timer.
    // this example set to 5 seconds.
    TrustLocation.start(5);
    getLocation();
  }

  /// get location method, use a try/catch PlatformException.
  Future<void> getLocation() async {
  await TrustLocation.onChange.listen((values) => setState(() {
             _latitude = values.latitude;
            _longitude = values.longitude;
            _isMockLocation = values.isMockLocation;
          }));

  }

  /// request location permission at runtime.
  void requestLocationPermission() async {
    PermissionStatus permission = await Permission.location.request();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Trust Location Plugin'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
              child: Column(
            children: <Widget>[
              if (_isMockLocation == true)
                const Text(
                  'Ubicacion falsa detectada',
                  style: TextStyle(color: Colors.red),
                ),
              if (_isMockLocation == false)
                const Text(
                  'Ubicacion real detectada',
                  style: TextStyle(color: Colors.green),
                ),
              if (_latitude != null && _longitude != null)
                Text('Latitud: $_latitude, Longitud: $_longitude'),
              if (_latitude == null && _longitude == null)
                const Text('No se pudo obtener la ubicacion'),

              
              
            ],
          )),
        ),
      ),
    );
  }
}
