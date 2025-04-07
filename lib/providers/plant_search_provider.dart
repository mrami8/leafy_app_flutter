import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:leafy_app_flutter/models/plant.dart'; // Asegúrate de tener este modelo

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
          .select()
          .ilike('nombre', '%$query%') // Filtramos por el nombre de la planta
          .or('nombre_cientifico.ilike.%$query%'); // También filtramos por nombre científico

      if (response != null && response is List<dynamic>) {
        plants = response.map((e) {
          // Extraemos la imagen principal
          final imageUrl = e['imagen_principal'] ?? ''; // Usamos imagen_principal
          return Plant.fromMap(e, imageUrl); // Asumimos que el modelo 'Plant' puede aceptar la imagen
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
