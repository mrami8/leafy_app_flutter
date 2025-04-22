import 'package:flutter/material.dart';
import 'package:leafy_app_flutter/models/plant.dart';

class PlantDetailScreen extends StatelessWidget {
  final Plant plant;

  PlantDetailScreen({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4E4),
      body: SafeArea(
        child: Column(
          children: [
            // Encabezado
            Container(
              color: const Color(0xFFD6E8C4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, size: 24),
                  ),
                  Text(
                    plant.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 24), // espacio para alinear
                ],
              ),
            ),

            // Contenido scrollable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: plant.imagenPrincipal.isNotEmpty
                          ? Image.network(
                              plant.imagenPrincipal,
                              fit: BoxFit.cover,
                              height: 200,
                            )
                          : const Placeholder(
                              fallbackHeight: 200,
                            ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        plant.nombreCientifico,
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Descripción
                    _buildSectionTitle("Descripción"),
                    Text(plant.descripcion),

                    const SizedBox(height: 12),
                    _buildSectionTitle("Riego"),
                    Text(plant.riego),

                    const SizedBox(height: 12),
                    _buildSectionTitle("Luz"),
                    Text(plant.luz),

                    const SizedBox(height: 12),
                    _buildSectionTitle("Temperatura"),
                    Text(plant.temperatura),

                    const SizedBox(height: 12),
                    _buildSectionTitle("Humedad"),
                    Text(plant.humedad),

                    const SizedBox(height: 12),
                    _buildSectionTitle("Tipo de Sustrato"),
                    Text(plant.tipoSustrato),

                    const SizedBox(height: 12),
                    _buildSectionTitle("Frecuencia de Abono"),
                    Text(plant.frecuenciaAbono),

                    const SizedBox(height: 12),
                    _buildSectionTitle("Plagas Comunes"),
                    Text(plant.plagasComunes),

                    const SizedBox(height: 12),
                    _buildSectionTitle("Cuidados Especiales"),
                    Text(plant.cuidadosEspeciales),

                    const SizedBox(height: 12),
                    _buildSectionTitle("Toxicidad"),
                    Text(plant.toxicidad),

                    const SizedBox(height: 12),
                    _buildSectionTitle("Floración"),
                    Text(plant.floracion),

                    const SizedBox(height: 12),
                    _buildSectionTitle("Uso Recomendado"),
                    Text(plant.usoRecomendado),

                    const SizedBox(height: 16),
                    _buildSectionTitle("Imágenes de la Planta:"),

                    const SizedBox(height: 8),
                    if (plant.imagenes.isNotEmpty)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: plant.imagenes.length,
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              plant.imagenes[index],
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      )
                    else
                      const Text("No hay imágenes adicionales."),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        decoration: TextDecoration.underline,
      ),
    );
  }
}
