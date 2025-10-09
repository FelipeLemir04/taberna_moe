import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UbicacionScreen extends StatefulWidget {
  UbicacionScreen({Key? key}) : super(key: key);

  @override
  State<UbicacionScreen> createState() => _UbicacionScreenState();
}

class _UbicacionScreenState extends State<UbicacionScreen> {
  late GoogleMapController _controller;
  final LatLng _moeLocation = LatLng(-32.889, -68.845); // ejemplo Mendoza

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ubicación')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _moeLocation, zoom: 16),
        onMapCreated: (c) => _controller = c,
        markers: {
          Marker(markerId: const MarkerId('moe'), position: _moeLocation, infoWindow: const InfoWindow(title: 'Taberna Moe'))
        },
      ),
    );
  }
}



