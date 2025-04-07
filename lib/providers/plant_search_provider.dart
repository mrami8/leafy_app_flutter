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
          .select()
          .ilike('nombre', '%$query%') // Filtramos por el nombre de la planta
          .or('nombre_cientifico.ilike.%$query%'); // También filtramos por nombre científico

      // Comprobamos si la respuesta tiene datos
      if (response.isNotEmpty) {
        final List<dynamic> data = response;
        plants = data.map((e) => Plant.fromMap(e)).toList();
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
