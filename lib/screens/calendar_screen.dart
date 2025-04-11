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
  @override
  void initState() {
    super.initState();
    // cargar notificaciones de hoy al abrir
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(context, listen: false).getAllNotifications();

    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationProvider>(context);
    final focusedDate = provider.selectedDate ?? DateTime.now();
    

    return Scaffold(
      appBar: AppBar(title: const Text('Calendario')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: focusedDate,
              selectedDayPredicate: (day) =>
                  provider.selectedDate != null &&
                  isSameDay(provider.selectedDate, day),
              onDaySelected: (selectedDay, _) {
                provider.getNotificationsForDate(selectedDay);
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
              availableCalendarFormats: const {
                CalendarFormat.month: 'Mes',
              },
            ),
            const SizedBox(height: 12),
            const AddNotificationForm(),
            const SizedBox(height: 12),
            const Expanded(child: NotificationList()),
          ],
        ),
      ),
    );
  }
}

class NotificationList extends StatelessWidget {
  const NotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationProvider>(context);
    final notifications = provider.notifications;

    if (notifications.isEmpty) {
      return const Center(child: Text('No hay notificaciones para esta fecha.'));
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (_, index) {
          final notification = notifications[index];
          final mensaje = notification['tipo_cuidado'] ?? 'Sin mensaje';
          final fecha = provider.selectedDate != null
              ? '${provider.selectedDate!.day.toString().padLeft(2, '0')}/${provider.selectedDate!.month.toString().padLeft(2, '0')}'
              : '';

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(mensaje)),
              Text(fecha, style: const TextStyle(color: Colors.grey)),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  provider.deleteNotification(mensaje);
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
