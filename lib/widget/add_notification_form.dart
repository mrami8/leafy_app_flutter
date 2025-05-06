import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:leafy_app_flutter/providers/notification_provider.dart';

class AddNotificationForm extends StatelessWidget {
  const AddNotificationForm({super.key});

  // Función auxiliar para añadir una notificación llamando al provider
  void _addNotification(BuildContext context, String tipo, DateTime selectedTime) async {
    final provider = Provider.of<NotificationProvider>(context, listen: false);
    await provider.addNotificationWithTime(tipo, selectedTime); // Añade la notificación con hora

    // Muestra mensaje de confirmación en pantalla
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Notificación de $tipo añadida para ${selectedTime.hour}:${selectedTime.minute}')));
  }

  @override
  Widget build(BuildContext context) {
    DateTime selectedTime = DateTime.now();  // Hora por defecto al seleccionar

    return Column(
      children: [
        const Text(
          'Añadir tipo de cuidado:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        // Selector de hora
        TextButton(
          onPressed: () async {
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(selectedTime),
            );
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
          child: Text('Seleccionar hora: ${selectedTime.hour}:${selectedTime.minute}'),
        ),

        const SizedBox(height: 12),

        // Botones agrupados para añadir distintos tipos de notificación
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                textStyle: const TextStyle(fontSize: 16),
              ),
              onPressed: () => _addNotification(context, 'Riego', selectedTime),
              icon: const Icon(Icons.water_drop),
              label: const Text('Riego'),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                textStyle: const TextStyle(fontSize: 16),
              ),
              onPressed: () => _addNotification(context, 'Poda', selectedTime),
              icon: const Icon(Icons.content_cut),
              label: const Text('Poda'),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
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
