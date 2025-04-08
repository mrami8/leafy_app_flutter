import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:leafy_app_flutter/providers/plant_search_provider.dart';
import 'package:leafy_app_flutter/models/plant.dart';
import 'plantDetailScreen.dart'; // Importamos la pantalla de detalle

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buscar Plantas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(hintText: 'Buscar plantas'),
              onChanged: (query) {
                Provider.of<PlantSearchProvider>(context, listen: false)
                    .searchPlants(query);
              },
            ),
          ),
          Expanded(
            child: Consumer<PlantSearchProvider>(
              builder: (context, provider, _) {
                if (provider.plants.isEmpty) {
                  return Center(child: Text('No se encontraron plantas.'));
                }
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: provider.plants.length,
                  itemBuilder: (context, index) {
                    final plant = provider.plants[index];
                    return GestureDetector(
                      onTap: () {
                        // Navegamos a la pantalla de detalle
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlantDetailScreen(plant: plant),    
                        ),
                      );

                      },
                      child: Card(
                        elevation: 4.0,
                        child: Column(
                          children: [
                            Image.network(
                              plant.imagenPrincipal,
                              fit: BoxFit.cover,
                              height: 100,
                              width: double.infinity,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    plant.nombre,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(plant.nombreCientifico),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
