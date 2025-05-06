import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:leafy_app_flutter/providers/notification_provider.dart';
import 'package:leafy_app_flutter/widget/add_notification_form.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(context, listen: false)
          .getNotificationsForDate(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationProvider>(context);
    final notifications = provider.notifications;

    return Scaffold(
      backgroundColor: const Color(0xFFEAF4E4), 
      body: SafeArea(
        child: Column(
          children: [
            // Barra superior con título
            Container(
              height: 60,
              width: double.infinity,
              color: const Color(0xFFD6E8C4), 
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
            // Calendario interactivo
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                Provider.of<NotificationProvider>(context, listen: false)
                    .getNotificationsForDate(selectedDay);
              },
              calendarStyle: const CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.lightGreen,
                  shape: BoxShape.circle,
                ),
              ),
              calendarFormat: CalendarFormat.month,
            ),
            const SizedBox(height: 16),
            const AddNotificationForm(),
            const SizedBox(height: 16),
            Expanded(
              child: notifications.isEmpty
                  ? const Center(child: Text('No hay notificaciones para esta fecha.'))
                  : ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notif = notifications[index];
                        final tipoCuidado = notif['tipo_cuidado'] ?? 'Sin tipo';
                        final fecha = DateTime.parse(notif['fecha']);
                        final horaFormateada =
                            '${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';

                        return ListTile(
                          title: Text('$horaFormateada - $tipoCuidado'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              Provider.of<NotificationProvider>(context, listen: false)
                                  .deleteNotification(tipoCuidado);
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
