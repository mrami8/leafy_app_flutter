import 'package:flutter/material.dart';
import 'services/supabase_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const PlantasScreen(),
    );
  }
}

class PlantasScreen extends StatefulWidget {
  const PlantasScreen({super.key});

  @override
  _PlantasScreenState createState() => _PlantasScreenState();
}

class _PlantasScreenState extends State<PlantasScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  List<Map<String, dynamic>> _plantas = [];

  @override
  void initState() {
    super.initState();
    _cargarPlantas();
  }

  Future<void> _cargarPlantas() async {
    final plantas = await _supabaseService.getPlantas();
    setState(() {
      _plantas = plantas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wiki de Plantas')),
      body: _plantas.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _plantas.length,
              itemBuilder: (context, index) {
                final planta = _plantas[index];
                return ListTile(
                  title: Text(planta['nombre']),
                  subtitle: Text(planta['nombre_cientifico'] ?? ''),
                  leading: planta['imagenes'] != null && planta['imagenes'].isNotEmpty
                      ? Image.network(planta['imagenes'][0], width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.local_florist),
                );
              },
            ),
    );
  }
}
