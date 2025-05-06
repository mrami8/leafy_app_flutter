import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:leafy_app_flutter/providers/notification_provider.dart';
import 'package:leafy_app_flutter/widget/add_notification_form.dart';

// Pantalla principal del calendario donde se muestran y gestionan notificaciones diarias
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  void initState() {
    super.initState();

    // Al cargar la pantalla, obtiene las notificaciones del día actual
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final today = DateTime.now();
      Provider.of<NotificationProvider>(
        context,
        listen: false,
      ).getNotificationsForDate(today);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationProvider>(context);
    final focusedDate =
        provider.selectedDate ?? DateTime.now(); // Fecha seleccionada

    return Scaffold(
      backgroundColor: const Color(0xFFEAF4E4), // Fondo verde claro
      body: SafeArea(
        child: Column(
          children: [
            // Barra superior con título
            Container(
              height: 60,
              width: double.infinity,
              color: const Color(0xFFD6E8C4), // Verde pastel suave
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'LEAFY',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      letterSpacing: 1.2,
                      color: Color.fromARGB(255, 0, 0, 0), // Texto verde
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.energy_savings_leaf, // Ícono de hoja
                    color: Colors.green,
                    size: 30,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Calendario interactivo
                    TableCalendar(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: focusedDate,
                      selectedDayPredicate:
                          (day) =>
                              provider.selectedDate != null &&
                              isSameDay(provider.selectedDate, day),
                      onDaySelected: (selectedDay, _) {
                        provider.getNotificationsForDate(selectedDay);
                      },
                      calendarStyle: const CalendarStyle(
                        selectedDecoration: BoxDecoration(
                          color: Color(0xFF4CAF50), // Verde más intenso para selección
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: Color(0xFF66BB6A), // Verde más suave para hoy
                          shape: BoxShape.circle,
                        ),
                      ),
                      availableCalendarFormats: const {
                        CalendarFormat.month: 'Mes',
                      },
                    ),
                    const SizedBox(height: 16),
                    const AddNotificationForm(), // Formulario para añadir notificaciones
                    const SizedBox(height: 16),
                    const Expanded(
                      child: NotificationList(),
                    ), // Lista de notificaciones
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget que muestra la lista de notificaciones del día seleccionado
class NotificationList extends StatelessWidget {
  const NotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationProvider>(context);
    final notifications = provider.notifications;

    // Si no hay notificaciones, muestra un mensaje informativo
    if (notifications.isEmpty) {
      return const Center(
        child: Text('No hay notificaciones para esta fecha.'),
      );
    }

    // Lista con diseño decorativo y separadores entre elementos
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F7E8), // Fondo más suave para la lista
        borderRadius: BorderRadius.circular(12), // Bordes redondeados
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: ListView.separated(
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (_, index) {
          final notification = notifications[index];
          final mensaje = notification['tipo_cuidado'] ?? 'Sin mensaje';

          // Formateo manual de la fecha seleccionada (día/mes)
          final fecha =
              provider.selectedDate != null
                  ? '${provider.selectedDate!.day.toString().padLeft(2, '0')}/${provider.selectedDate!.month.toString().padLeft(2, '0')}'
                  : '';

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(mensaje)), // Mensaje de la notificación
              Text(fecha, style: const TextStyle(color: Color(0xFFBDBDBD))), // Fecha
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  provider.deleteNotification(mensaje); // Elimina notificación
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notificación eliminada')),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
