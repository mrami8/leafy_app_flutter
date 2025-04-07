import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:leafy_app_flutter/models/plant.dart'; // Asumimos que tienes un modelo Plant para manejar la estructura de los datos

class PlantSearchProvider with ChangeNotifier {
  final SupabaseClient supabaseClient;
  List<Plant> plants = [];

  PlantSearchProvider(this.supabaseClient);

  Future<void> searchPlants(String query) async {
    if (query.isEmpty) {
      plants = [];
      notifyListeners();
      return;
    }

    try {
      final response = await supabaseClient
          .from('plantas')
          .select('id, nombre, nombre_cientifico, descripcion, imagen_principal, imagenes')
          .ilike('nombre', '%$query%')
          .or('nombre_cientifico.ilike.%$query%');

      // Comprobamos si la respuesta tiene datos
      if (response.isNotEmpty) {
        final List<dynamic> data = response;
        plants = data.map((e) {
          // Asumimos que el primer valor de 'imagenes' es la imagen principal
          e['imagen_principal'] = e['imagenes'] != null && e['imagenes'].isNotEmpty ? e['imagenes'][0] : '';
          return Plant.fromMap(e);
        }).toList();
      } else {
        plants = [];
      }

      notifyListeners();
    } catch (e) {
      print('Error al buscar plantas: $e');
      plants = [];
      notifyListeners();
    }
  }
}
