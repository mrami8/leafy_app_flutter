import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(PlantasApp());
}

class PlantasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BuscarPlantasScreen(),
    );
  }
}

class BuscarPlantasScreen extends StatefulWidget {
  @override
  _BuscarPlantasScreenState createState() => _BuscarPlantasScreenState();
}

class _BuscarPlantasScreenState extends State<BuscarPlantasScreen> {
  TextEditingController _controller = TextEditingController();
  List<dynamic> _resultados = [];
  bool _cargando = false;

  Future<void> buscarPlantas(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _cargando = true;
    });

    final url = Uri.parse("https://tu-servidor.com/buscar_plantas.php?query=$query");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          _resultados = json.decode(response.body);
          _cargando = false;
        });
      } else {
        throw Exception("Error al buscar plantas");
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Buscar Plantas")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Buscar planta...",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => buscarPlantas(_controller.text),
                ),
              ),
            ),
          ),
          _cargando
              ? CircularProgressIndicator()
              : Expanded(
                  child: ListView.builder(
                    itemCount: _resultados.length,
                    itemBuilder: (context, index) {
                      final planta = _resultados[index];
                      return ListTile(
                        title: Text(planta["nombre"]),
                        subtitle: Text("Detalles: ${planta["descripcion"] ?? 'Sin descripción'}"),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
