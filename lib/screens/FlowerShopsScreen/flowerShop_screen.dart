import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FlowerShopsScreen extends StatefulWidget {
  const FlowerShopsScreen({super.key});

  @override
  State<FlowerShopsScreen> createState() => _FlowerShopsScreenState();
}

class _FlowerShopsScreenState extends State<FlowerShopsScreen> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(19.432608, -99.133209), // Coordenadas de ejemplo (Ciudad de México)
    zoom: 12.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Floristerías'),
        backgroundColor: const Color(0xFFD6E8C4), // Asegúrate de usar el color que ya tienes
      ),
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        markers: _markers,
      ),
    );
  }

  // Función para agregar un marcador en el mapa (floristería)
  void _addMarker(LatLng position) {
    final marker = Marker(
      markerId: MarkerId(position.toString()),
      position: position,
      infoWindow: InfoWindow(
        title: 'Floristería',
        snippet: '¡Tu tienda de plantas favorita!',
      ),
    );

    setState(() {
      _markers.add(marker);
    });
  }
}
