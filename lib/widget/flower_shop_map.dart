import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class FlowerShopsScreen extends StatefulWidget {
  const FlowerShopsScreen({super.key});

  @override
  _FlowerShopsScreenState createState() => _FlowerShopsScreenState();
}

class _FlowerShopsScreenState extends State<FlowerShopsScreen> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  final String _apiKey = 'AIzaSyCb9Y_E11TwvEBJxjRga-q3EYYaBsvqmnw';  // Tu API key de Google Places

  // Coordenadas de Madrid (puedes cambiar esto para buscar en otras ciudades)
  final LatLng _center = LatLng(40.416775, -3.703790);  // Coordenadas de Madrid

  @override
  void initState() {
    super.initState();
    _getFlowerShops();
  }

  // Llamada a la API de Places para obtener floristerías
  Future<void> _getFlowerShops() async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_center.latitude},${_center.longitude}&radius=5000&type=florist&key=$_apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'];

      // Crear un marcador para cada floristería
      Set<Marker> markers = {};
      for (var result in results) {
        double lat = result['geometry']['location']['lat'];
        double lng = result['geometry']['location']['lng'];
        String name = result['name'];
        String address = result['vicinity'] ?? 'Sin dirección';

        markers.add(Marker(
          markerId: MarkerId(name),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: name,
            snippet: address,
          ),
        ));
      }

      setState(() {
        _markers = markers;
      });
    } else {
      throw Exception('Failed to load flower shops');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Floristerías en España'),
        backgroundColor: const Color(0xFFD7EAC8),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 12,
        ),
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        markers: _markers,  // Añadir los marcadores de las floristerías
      ),
    );
  }
}
