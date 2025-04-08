import 'package:flutter/material.dart';
import 'package:leafy_app_flutter/models/plant.dart';

class PlantDetailScreen extends StatelessWidget {
  final Plant plant;

  PlantDetailScreen({required this.plant}) {
    // Agregar un print aquí para verificar los datos
    print('Datos recibidos en la pantalla de detalles: ${plant.frecuenciaAbono}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(plant.nombre)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            plant.imagenPrincipal.isNotEmpty
                ? Image.network(plant.imagenPrincipal)
                : Placeholder(),
            Text(plant.nombreCientifico),
            Text(plant.descripcion),
            SizedBox(height: 8),
            Text("Riego: ${plant.riego}"),
            Text("Luz: ${plant.luz}"),
            Text("Temperatura: ${plant.temperatura}"),
            Text("Humedad: ${plant.humedad}"),
            Text("Tipo de Sustrato: ${plant.tipoSustrato}"),
            Text("Frecuencia de Abono: ${plant.frecuenciaAbono}"),
            Text("Plagas Comunes: ${plant.plagasComunes}"),
            Text("Cuidados Especiales: ${plant.cuidadosEspeciales}"),
            Text("Toxicidad: ${plant.toxicidad}"),
            Text("Floración: ${plant.floracion}"),
            Text("Uso Recomendado: ${plant.usoRecomendado}"),
            SizedBox(height: 16),
            Text("Imágenes de la Planta:"),
            SizedBox(height: 8),
            // Mostrar las imágenes de la planta
            if (plant.imagenes.isNotEmpty)
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: plant.imagenes.length,
                itemBuilder: (context, index) {
                  return Image.network(plant.imagenes[index]);
                },
              ),
          ],
        ),
      ),
    );
  }
}

