import 'package:flutter/material.dart';
import 'package:leafy_app_flutter/models/plant.dart';

class PlantDetailScreen extends StatelessWidget {
  final Plant plant;

  const PlantDetailScreen({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4E4), // Fondo verde muy claro
      body: SafeArea(
        child: Column(
          children: [
            // Encabezado
            Container(
              color: const Color(0xFFD6E8C4), // Verde pastel
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, size: 24),
                  ),
                  Expanded(
                    child: Text(
                      plant.nombre,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ),

            // Contenido principal
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Imagen principal
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: plant.imagenPrincipal.isNotEmpty
                          ? Image.network(
                              plant.imagenPrincipal,
                              height: 240,
                              fit: BoxFit.cover,
                            )
                          : const Placeholder(fallbackHeight: 240),
                    ),

                    const SizedBox(height: 16),

                    // Nombre científico
                    Center(
                      child: Text(
                        plant.nombreCientifico,
                        style: TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Contenedor verde con toda la información
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD0E4C3), // Verde más oscuro que el fondo general
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSection("📝 Descripción", plant.descripcion),
                          _buildSection("💧 Riego", plant.riego),
                          _buildSection("🌞 Luz", plant.luz),
                          _buildSection("🌡️ Temperatura", plant.temperatura),
                          _buildSection("💦 Humedad", plant.humedad),
                          _buildSection("🌱 Tipo de Sustrato", plant.tipoSustrato),
                          _buildSection("🌿 Frecuencia de Abono", plant.frecuenciaAbono),
                          _buildSection("🐛 Plagas Comunes", plant.plagasComunes),
                          _buildSection("🩺 Cuidados Especiales", plant.cuidadosEspeciales),
                          _buildSection("☠️ Toxicidad", plant.toxicidad),
                          _buildSection("🌸 Floración", plant.floracion),
                          _buildSection("🏡 Uso Recomendado", plant.usoRecomendado),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Galería de imágenes adicionales (comentada por ahora)
                    /*
                    const Text(
                      "📷 Imágenes de la Planta",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (plant.imagenes.isNotEmpty)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1,
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
                      const Text(
                        "No hay imágenes adicionales.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    */
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para secciones de texto con título e información
  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D5B2F),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
