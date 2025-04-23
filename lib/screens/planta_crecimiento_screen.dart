import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/progress_provider.dart';

class PlantGrowthPage extends StatefulWidget {
  final String jardinId;

  const PlantGrowthPage({super.key, required this.jardinId});

  @override
  State<PlantGrowthPage> createState() => _PlantGrowthPageState();
}

class _PlantGrowthPageState extends State<PlantGrowthPage> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ProgressProvider>(context, listen: false);
    provider.cargarFotos(widget.jardinId);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProgressProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFEAF4E4),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_a_photo),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder:
                (context) => Wrap(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.camera),
                      title: const Text('Cámara'),
                      onTap: () {
                        Navigator.pop(context);
                        provider.subirFoto(ImageSource.camera);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo),
                      title: const Text('Galería'),
                      onTap: () {
                        Navigator.pop(context);
                        provider.subirFoto(ImageSource.gallery);
                      },
                    ),
                  ],
                ),
          );
        },
      ),
      body: Column(
        children: [
          // Barra superior con botón de volver
          Container(
            height: 50,
            width: double.infinity,
            color: const Color(0xFFD7EAC8),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: const [
                BackButton(color: Colors.black87),
                SizedBox(width: 8),
                Text(
                  'Progreso de la planta',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child:
                provider.fotos.isEmpty
                    ? const Center(child: Text('No hay fotos aún.'))
                    : GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: provider.fotos.length,
                      itemBuilder: (context, index) {
                        final foto = provider.fotos[index];

                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                foto['imagen_url'],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        const Center(
                                          child: Icon(Icons.broken_image),
                                        ),
                              ),
                            ),
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder:
                                          (_) => AlertDialog(
                                            title: const Text(
                                              '¿Eliminar imagen?',
                                            ),
                                            content: const Text(
                                              'Esta acción no se puede deshacer.',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.pop(
                                                      context,
                                                      false,
                                                    ),
                                                child: const Text('Cancelar'),
                                              ),
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.pop(
                                                      context,
                                                      true,
                                                    ),
                                                child: const Text('Eliminar'),
                                              ),
                                            ],
                                          ),
                                    );

                                    if (confirm == true) {
                                      final success = await provider
                                          .eliminarFoto(foto['path']);
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              success
                                                  ? 'Imagen eliminada con éxito.'
                                                  : 'No se pudo eliminar la imagen.',
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
