import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart'; // Widget de calendario
import 'package:leafy_app_flutter/providers/Calendar/notification_provider.dart'; // Provider para notificaciones
import 'package:leafy_app_flutter/widget/add_notification_form.dart'; // Formulario para añadir notificación

// Página que muestra el calendario y las notificaciones del día
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now(); // Día visible en el calendario
  DateTime? _selectedDay; // Día actualmente seleccionado por el usuario

  @override
  void initState() {
    super.initState();
    // Carga las notificaciones del día actual al abrir la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(
        context,
        listen: false,
      ).getNotificationsForDate(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationProvider>(
      context,
    ); // Acceso al provider
    final notifications =
        provider.notifications; // Lista actual de notificaciones

    return Scaffold(
      backgroundColor: const Color(0xFFEAF4E4), // Fondo verde pastel suave
      body: SafeArea(
        child: Column(
          children: [
            // Barra superior con título
            Container(
              height: 60,
              width: double.infinity,
              color: const Color(0xFFD6E8C4), // Color del header
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
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.energy_savings_leaf,
                    color: Colors.green,
                    size: 30,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Calendario para seleccionar días
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                // Cuando se selecciona un día en el calendario
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                // Cargamos las notificaciones del día seleccionado
                Provider.of<NotificationProvider>(
                  context,
                  listen: false,
                ).getNotificationsForDate(selectedDay);
              },
              calendarStyle: const CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.green, // Día seleccionado
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.lightGreen, // Día actual
                  shape: BoxShape.circle,
                ),
              ),
              calendarFormat: CalendarFormat.month, // Vista mensual
            ),

            const SizedBox(height: 16),

            // Formulario para añadir nuevas notificaciones
            const AddNotificationForm(),

            const SizedBox(height: 16),

            // Lista de notificaciones para el día seleccionado
            Expanded(
              child:
                  notifications.isEmpty
                      // Mensaje si no hay notificaciones
                      ? const Center(
                        child: Text('No hay notificaciones para esta fecha.'),
                      )
                      : ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notif = notifications[index];
                          final tipoCuidado =
                              notif['tipo_cuidado'] ?? 'Sin tipo';
                          final fecha = DateTime.parse(notif['fecha']);
                          final horaFormateada =
                              '${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';

                          return ListTile(
                            title: Text(
                              '$horaFormateada - $tipoCuidado',
                            ), // Muestra la hora y tipo de cuidado
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Elimina la notificación al pulsar el icono
                                Provider.of<NotificationProvider>(
                                  context,
                                  listen: false,
                                ).deleteNotification(tipoCuidado);
                              },
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
