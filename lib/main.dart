import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BuscarPlantasPage extends StatefulWidget {
  @override
  _BuscarPlantasPageState createState() => _BuscarPlantasPageState();
}

class _BuscarPlantasPageState extends State<BuscarPlantasPage> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _resultados = [];

  Future<void> _buscarPlantas(String query) async {
    if (query.isEmpty) {
      setState(() {
        _resultados = [];
      });
      return;
    }

    final url = Uri.parse("https://localhost/leafy_api/buscar_plantas.php?query=$query");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _resultados = json.decode(response.body);
      });
    } else {
      print("Error en la petición: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Buscar Plantas")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _buscarPlantas,  // Llama a la función cada vez que cambia el texto
              decoration: InputDecoration(
                hintText: "Buscar planta...",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _resultados.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_resultados[index]["nombre"]),
                  subtitle: Text(_resultados[index]["descripcion"]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
