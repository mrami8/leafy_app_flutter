import 'package:flutter/material.dart';
import 'package:leafy_app_flutter/models/plant.dart';

class PlantDetailScreen extends StatelessWidget {
  final Plant plant;

  PlantDetailScreen({required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(plant.nombre)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(plant.imagenPrincipal, fit: BoxFit.cover),
              SizedBox(height: 10),
              Text(
                plant.nombre,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                plant.nombreCientifico,
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 10),
              Text(
                'Descripción:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(plant.descripcion),
              SizedBox(height: 10),
              Text(
                'Cuidados:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(plant.cuidados),
              SizedBox(height: 10),
              Text(
                'Riego:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(plant.riego),
              SizedBox(height: 10),
              Text(
                'Luz:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(plant.luz),
              SizedBox(height: 10),
              Text(
                'Temperatura:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(plant.temperatura),
              SizedBox(height: 10),
              Text(
                'Sustrato:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(plant.sustrato),
            ],
          ),
        ),
      ),
    );
  }
}
