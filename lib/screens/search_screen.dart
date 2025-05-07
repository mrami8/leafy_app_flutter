// Importaciones necesarias
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:leafy_app_flutter/providers/plant_search_provider.dart';
import 'plantDetailScreen.dart';

// Pantalla que permite buscar y visualizar plantas desde la base de datos
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
    // Al iniciar la pantalla, se buscan todas las plantas sin filtro
    Future.microtask(() {
      Provider.of<PlantSearchProvider>(context, listen: false).searchPlants('');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4E4), // Color de fondo general
      body: SafeArea(
        child: Column(
          children: [
            // Encabezado superior con el texto LEAFY y un ícono de hoja
            Container(
              color: const Color(0xFFD6E8C4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "LEAFY",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.energy_savings_leaf,
                    color: Colors.green,
                    size: 30,
                  ),
                ],
              ),
            ),

            // Barra de búsqueda para filtrar plantas
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: TextField(
                  // Al cambiar el texto, se actualizan los resultados de búsqueda
                  onChanged: (query) {
                    Provider.of<PlantSearchProvider>(
                      context,
                      listen: false,
                    ).searchPlants(query);
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        // Al hacer clic en la X, se limpia la búsqueda
                        Provider.of<PlantSearchProvider>(
                          context,
                          listen: false,
                        ).searchPlants('');
                      },
                    ),
                    hintText: 'Buscar plantas',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            // Lista de resultados de búsqueda en formato grid
            Expanded(
              child: Consumer<PlantSearchProvider>(
                builder: (context, provider, _) {
                  // Si no hay resultados, mostrar mensaje
                  if (provider.plants.isEmpty) {
                    return const Center(
                      child: Text('No se encontraron plantas.'),
                    );
                  }

                  // Muestra los resultados en un grid de 2 columnas
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                      childAspectRatio: 1,
                    ),
                    itemCount: provider.plants.length,
                    itemBuilder: (context, index) {
                      final plant = provider.plants[index];

                      return GestureDetector(
                        onTap: () {
                          // Al tocar una planta, navega a la pantalla de detalles
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PlantDetailScreen(plant: plant),
                            ),
                          );
                        },
                        child: Card(
                          color: const Color.fromARGB(255, 251, 255, 247), // Color del fondo de la tarjeta
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          margin: EdgeInsets.zero,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Imagen principal de la planta
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Container(
                                  height: 120,
                                  color: const Color.fromARGB(255, 226, 253, 230),
                                  child: Image.network(
                                    plant.imagenPrincipal,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.broken_image,
                                        size: 50,
                                        color: Colors.grey,
                                      );
                                    },
                                  ),
                                ),
                              ),

                              // Nombre común y científico
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (plant.nombre.trim().isNotEmpty)
                                      Text(
                                        plant.nombre,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    if (plant.nombreCientifico.trim().isNotEmpty)
                                      Text(
                                        plant.nombreCientifico,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[600],
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
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
      ),
    );
  }
}
