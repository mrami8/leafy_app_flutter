// Importaciones necesarias
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:leafy_app_flutter/providers/notification_provider.dart';

// Widget sin estado que representa un formulario para añadir notificaciones
class AddNotificationForm extends StatelessWidget {
  const AddNotificationForm({super.key});

  // Función privada que se encarga de añadir una notificación utilizando el provider
  void _addNotification(BuildContext context, String tipo, DateTime selectedTime) async {
    final provider = Provider.of<NotificationProvider>(context, listen: false);

    // Llama al método del provider para añadir la notificación con una hora específica
    await provider.addNotificationWithTime(tipo, selectedTime);

    // Muestra un mensaje emergente confirmando la acción
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notificación de $tipo añadida para ${selectedTime.hour}:${selectedTime.minute}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Inicializa la hora seleccionada con la hora actual
    DateTime selectedTime = DateTime.now();

    return Column(
      children: [
        // Título del formulario
        const Text(
          'Añadir tipo de cuidado:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        // Botón para seleccionar la hora
        TextButton(
          onPressed: () async {
            // Muestra un selector de hora al usuario
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(selectedTime),
            );

            // Si el usuario selecciona una hora, actualiza `selectedTime`
            if (time != null) {
              selectedTime = DateTime(
                selectedTime.year,
                selectedTime.month,
                selectedTime.day,
                time.hour,
                time.minute,
              );
            }
          },
          // Muestra la hora seleccionada en el botón
          child: Text('Seleccionar hora: ${selectedTime.hour}:${selectedTime.minute}'),
        ),

        const SizedBox(height: 12),

        // Botones agrupados para añadir diferentes tipos de cuidado
        Wrap(
          spacing: 16, // Espaciado horizontal entre botones
          runSpacing: 16, // Espaciado vertical si hay varias filas
          alignment: WrapAlignment.center, // Centrado del contenido
          children: [
            // Botón para añadir una notificación de Riego
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
              onPressed: () => _addNotification(context, 'Riego', selectedTime),
              icon: const Icon(Icons.water_drop),
              label: const Text('Riego'),
            ),

            // Botón para añadir una notificación de Poda
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
              onPressed: () => _addNotification(context, 'Poda', selectedTime),
              icon: const Icon(Icons.content_cut),
              label: const Text('Poda'),
            ),

            // Botón para añadir una notificación de Fertilización
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
              onPressed: () => _addNotification(context, 'Fertilización', selectedTime),
              icon: const Icon(Icons.local_florist),
              label: const Text('Fertilización'),
            ),
          ],
        ),
      ],
    );
  }
}
// Fin del código
// Este widget es un formulario que permite al usuario añadir notificaciones para diferentes tipos de cuidado de plantas.