import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MapaFlowershop extends StatefulWidget {
  const MapaFlowershop({super.key});

  @override
  State<MapaFlowershop> createState() => _MapaFlowershopState();
}

class _MapaFlowershopState extends State<MapaFlowershop> {
  late GoogleMapController mapController;
  LatLng? _currentPosition;
  Set<Marker> _markers = {};

  final String _googleApiKey = 'AIzaSyCb9Y_E11TwvEBJxjRga-q3EYYaBsvqmnw';

  @override
  void initState() {
    super.initState();
    _obtenerUbicacion();
  }

  Future<void> _obtenerUbicacion() async {
    final permiso = await Geolocator.requestPermission();
    if (permiso == LocationPermission.deniedForever || permiso == LocationPermission.denied) return;

    final posicion = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(posicion.latitude, posicion.longitude);
    });

    _buscarFloristerias();
  }

  Future<void> _buscarFloristerias() async {
    if (_currentPosition == null) return;

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
      '?location=${_currentPosition!.latitude},${_currentPosition!.longitude}'
      '&radius=3000&type=florist&key=$_googleApiKey',
    );

    final response = await http.get(url);
    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      final results = data['results'] as List;

      setState(() {
        _markers = results.map((place) {
          final lat = place['geometry']['location']['lat'];
          final lng = place['geometry']['location']['lng'];
          final name = place['name'];

          return Marker(
            markerId: MarkerId(place['place_id']),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: name),
          );
        }).toSet();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _currentPosition!,
        zoom: 14,
      ),
      markers: _markers,
      onMapCreated: (controller) => mapController = controller,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
    );
  }
}
