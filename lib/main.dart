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
    TrustLocation.start(2);
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
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Verificador de GPS Emulado'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
              child: Column(
            children: [
              if (_isMockLocation == true)
                const AlertDialog(
                  title: Text(
                    'ALERTA',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                  ),
                  content: Text(
                    'Ubicacion falsa detectada uso de GPS FALSO',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                  ),
                ),
              if (_isMockLocation == false)
                const Text(
                  'Ubicacion real detectada sin problemas',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green, fontSize: 30),
                ),
              const Spacer(),
              if (_latitude != null)
                Text(
                  'Latitud: $_latitude',
                  style: const TextStyle(fontSize: 20),
                ),
              if (_longitude != null)
                Text(
                  'Longitud: $_longitude',
                  style: const TextStyle(fontSize: 20),
                ),
              if (_latitude == null && _longitude == null)
                const Text('No se pudo obtener la ubicacion'),
            ],
          )),
        ),
      ),
    );
  }
}
