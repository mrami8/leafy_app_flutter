import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:leafy_app_flutter/providers/notification_provider.dart';
import 'package:leafy_app_flutter/widgets/add_notification_form.dart';



class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: provider.selectedDate,
              selectedDayPredicate: (day) =>
                  isSameDay(provider.selectedDate, day),
              onDaySelected: (selectedDay, focusedDay) {
                provider.selectDate(selectedDay);
              },
              calendarStyle: CalendarStyle(
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
    final notifications = provider.notificationsForSelectedDate;

    if (notifications.isEmpty) {
      return const Center(
        child: Text('No hay notificaciones para esta fecha.'),
      );
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (_, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(notifications[index])),
              Text(
                '${provider.selectedDate.day.toString().padLeft(2, '0')}/${provider.selectedDate.month.toString().padLeft(2, '0')}',
                style: const TextStyle(color: Colors.grey),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  provider.removeNotification(index);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notificación eliminada'),
                      duration: Duration(seconds: 2),
                    ),
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
