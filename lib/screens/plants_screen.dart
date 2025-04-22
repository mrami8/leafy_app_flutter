import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:leafy_app_flutter/screens/planta_crecimiento_screen.dart';

class PlantsScreen extends StatefulWidget {
  const PlantsScreen({super.key});

  @override
  State<PlantsScreen> createState() => _PlantsScreenState();
}

class _PlantsScreenState extends State<PlantsScreen> {
  List<Map<String, dynamic>> plantas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarPlantas();
  }

  Future<void> cargarPlantas() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final result = await Supabase.instance.client
        .from('jardin')
        .select('id, nombre_personalizado, plantas (nombre, imagen_principal)')
        .eq('id_usuario', user.id);

    setState(() {
      plantas = (result as List).cast<Map<String, dynamic>>();
      isLoading = false;
    });
  }

  void mostrarFormularioNuevaPlanta() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Añadir nueva planta'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Nombre personalizado',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final nombre = controller.text.trim();
                  if (nombre.isNotEmpty) {
                    Navigator.pop(context);
                    await anadirPlantaDummy(nombre);
                  }
                },
                child: const Text('Añadir'),
              ),
            ],
          ),
    );
  }

  // ⚠️ Esto es temporal: añade una planta dummy con un id_planta fijo
  Future<void> anadirPlantaDummy(String nombrePersonalizado) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    const dummyPlantaId =
        'fdd93415-6e05-412d-b32c-cd778d990896'; // <-- cambia si lo necesitas

    await Supabase.instance.client.from('jardin').insert({
      'id_usuario': user.id,
      'id_planta': dummyPlantaId,
      'nombre_personalizado': nombrePersonalizado,
      'fecha_adquisicion': DateTime.now().toIso8601String(),
    });

    await cargarPlantas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi jardín')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: mostrarFormularioNuevaPlanta,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : plantas.isEmpty
              ? const Center(
                child: Text('Aún no tienes plantas en tu jardín 🌿'),
              )
              : GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: plantas.length,
                itemBuilder: (context, index) {
                  final jardinItem = plantas[index];
                  final info = jardinItem['plantas'];
                  final nombre =
                      jardinItem['nombre_personalizado'] ?? info['nombre'];
                  final imagen = info['imagen_principal'];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) =>
                                  PlantGrowthPage(jardinId: jardinItem['id']),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child:
                                imagen != null && imagen.toString().isNotEmpty
                                    ? Image.network(
                                      imagen,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    )
                                    : Container(
                                      color: Colors.green[100],
                                      child: const Center(
                                        child: Icon(
                                          Icons.local_florist,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          nombre,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
