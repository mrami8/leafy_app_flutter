import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:leafy_app_flutter/screens/GardenScreen/planta_crecimiento_screen.dart';

/// Pantalla que muestra todas las plantas del jardín del usuario
class PlantsScreen extends StatefulWidget {
  const PlantsScreen({super.key});

  @override
  State<PlantsScreen> createState() => _PlantsScreenState();
}

class _PlantsScreenState extends State<PlantsScreen> {
  List<Map<String, dynamic>> plantas = []; // Lista de plantas del jardín
  bool isLoading = true; // Controla el estado de carga inicial

  @override
  void initState() {
    super.initState();
    cargarPlantas(); // Carga las plantas al iniciar la pantalla
  }

  /// Obtiene las plantas del usuario desde la tabla 'jardin' en Supabase
  Future<void> cargarPlantas() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final result = await Supabase.instance.client
        .from('jardin')
        .select('id, nombre_personalizado, plantas (nombre)')
        .eq('id_usuario', user.id);

    setState(() {
      plantas = (result as List).cast<Map<String, dynamic>>();
      isLoading = false; // Oculta el loader cuando termina
    });
  }

  /// Muestra un formulario emergente para añadir una nueva planta personalizada
  void mostrarFormularioNuevaPlanta() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Añadir nueva planta'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Nombre personalizado'),
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

  /// Inserta una planta dummy en el jardín con nombre personalizado
  Future<void> anadirPlantaDummy(String nombrePersonalizado) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    const dummyPlantaId = 'fdd93415-6e05-412d-b32c-cd778d990896'; // ID fijo

    await Supabase.instance.client.from('jardin').insert({
      'id_usuario': user.id,
      'id_planta': dummyPlantaId,
      'nombre_personalizado': nombrePersonalizado,
      'fecha_adquisicion': DateTime.now().toIso8601String(),
    });

    await cargarPlantas(); // Recarga lista con la nueva planta
  }

  /// Elimina una planta del jardín según su ID
  Future<void> eliminarJardin(String jardinId) async {
    await Supabase.instance.client.from('jardin').delete().eq('id', jardinId);
    await cargarPlantas(); // Refresca la lista después de eliminar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4E4),
      floatingActionButton: FloatingActionButton(
        onPressed: mostrarFormularioNuevaPlanta,
        child: const Icon(Icons.add), // Botón de añadir planta
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: const Color(0xFFD6E8C4),
          centerTitle: true,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "LEAFY",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.energy_savings_leaf, color: Colors.green, size: 30),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator()) // Spinner
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
                          final nombre = jardinItem['nombre_personalizado'] ?? info['nombre'];

                          return Stack(
                            children: [
                              // Cuadro de planta
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PlantGrowthPage(
                                        jardinId: jardinItem['id'], // Muestra progreso
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 139,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          'assets/platapredeterminada.png',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      nombre,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),

                              // Botón de eliminar
                              Positioned(
                                top: 6,
                                right: 6,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black45,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.white, size: 20),
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: const Text('¿Eliminar planta?'),
                                          content: const Text('Esta acción no se puede deshacer.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, false),
                                              child: const Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, true),
                                              child: const Text('Eliminar'),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (confirm == true) {
                                        await eliminarJardin(jardinItem['id']);
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Planta eliminada del jardín.'),
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
