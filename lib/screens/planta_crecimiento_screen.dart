import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/progress_provider.dart'; // ajusta el path si es necesario

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
      appBar: AppBar(title: const Text('Progreso de la planta')),
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
      body:
          provider.fotos.isEmpty
              ? const Center(child: Text('No hay fotos aún.'))
              : GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: provider.fotos.length,
                itemBuilder: (context, index) {
                  final foto = provider.fotos[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(foto['imagen_url'], fit: BoxFit.cover),
                  );
                },
              ),
    );
  }
}
