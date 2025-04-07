import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:leafy_app_flutter/providers/plant_search_provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Buscar Plantas")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (query) {
                context.read<PlantSearchProvider>().searchPlants(query);
              },
              decoration: InputDecoration(
                hintText: 'Buscar planta...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Consumer<PlantSearchProvider>(
              builder: (context, provider, child) {
                if (provider.plants.isEmpty) {
                  return Center(child: Text("No se encontraron plantas"));
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: provider.plants.length,
                    itemBuilder: (context, index) {
                      final plant = provider.plants[index];
                      return ListTile(
                        title: Text(plant.nombre),
                        subtitle: Text(plant.nombreCientifico),
                        onTap: () {
                          // Aquí puedes navegar a la pantalla de detalles
                          // Y pasar el id o la planta completa
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
