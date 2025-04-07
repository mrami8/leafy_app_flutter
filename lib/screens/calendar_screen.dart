import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

/// Provider para gestionar las notificaciones por fecha
class NotificationProvider extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  final Map<DateTime, List<String>> _notifications = {};

  DateTime get selectedDate => _selectedDate;

  List<String> get notificationsForSelectedDate =>
      _notifications[_selectedDate] ?? [];

  void selectDate(DateTime date) {
    _selectedDate = DateTime(date.year, date.month, date.day); // limpiar hora
    notifyListeners();
  }

  void addNotification(String message) {
    final dateKey = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );
    _notifications.putIfAbsent(dateKey, () => []);
    _notifications[dateKey]!.add(message);
    notifyListeners();
  }
}

/// Pantalla principal del calendario
class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario'),
      ),
      body: Column(
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
          ),
          const SizedBox(height: 16),
          const Expanded(child: NotificationList()),
          const AddNotificationForm(),
        ],
      ),
    );
  }
}

/// Lista de notificaciones para la fecha seleccionada
class NotificationList extends StatelessWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationProvider>(context);
    final notifications = provider.notificationsForSelectedDate;

    if (notifications.isEmpty) {
      return const Center(
        child: Text('No hay notificaciones para esta fecha.'),
      );
    }

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (_, index) => ListTile(
        leading: const Icon(Icons.notifications),
        title: Text(notifications[index]),
      ),
    );
  }
}

/// Formulario para añadir una notificación
class AddNotificationForm extends StatefulWidget {
  const AddNotificationForm({Key? key}) : super(key: key);

  @override
  State<AddNotificationForm> createState() => _AddNotificationFormState();
}

class _AddNotificationFormState extends State<AddNotificationForm> {
  final _controller = TextEditingController();

  void _submit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      Provider.of<NotificationProvider>(context, listen: false)
          .addNotification(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Añadir notificación'),
              onSubmitted: (_) => _submit(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
