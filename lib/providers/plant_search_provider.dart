import 'package:flutter/material.dart';
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
    .select('*')
    .or('nombre.ilike.%$query%,nombre_cientifico.ilike.%$query%');
    
    print('Respuesta de la consulta: $response');


    if (response != null && response is List<dynamic>) {
      plants = response.map((e) => Plant.fromSearchMap(e)).toList();
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
