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

  // Establece la posición inicial en Madrid
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(40.416775, -3.703790), // Coordenadas de Madrid
    zoom: 12.0,
  );

  // Lista de floristerías (coordenadas y nombres)
  final List<Map<String, dynamic>> flowerShops = [
    {
      'name': 'Floristería El Jardín',
      'lat': 40.416775,  // Coordenada de latitud
      'lng': -3.703790,  // Coordenada de longitud
    },
    {
      'name': 'Flores Madrid',
      'lat': 40.416770,  // Coordenada de latitud
      'lng': -3.707400,  // Coordenada de longitud
    },
    {
      'name': 'Plantas y Flores Sánchez',
      'lat': 50.418000,  // Coordenada de latitud
      'lng': -20.709800,  // Coordenada de longitud
    },
    // Agrega más floristerías aquí
  ];

  @override
  void initState() {
    super.initState();
    // Agrega marcadores de floristerías en el mapa
    for (var shop in flowerShops) {
      _addMarker(LatLng(shop['lat'], shop['lng']), shop['name']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.local_florist, // O el icono que prefieras para Leafy
              color: Colors.green,
              size: 30,
            ),
            const SizedBox(width: 8), // Espacio entre el icono y el texto
            const Text(
              'Floristerías',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ],
        ),
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
  void _addMarker(LatLng position, String name) {
    final marker = Marker(
      markerId: MarkerId(position.toString()),
      position: position,
      infoWindow: InfoWindow(
        title: name,
        snippet: '¡Tu tienda de plantas favorita!',
      ),
    );

    setState(() {
      _markers.add(marker);
    });
  }
}
