// notification_provider.dart
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  final Map<DateTime, List<String>> _notifications = {};

  DateTime get selectedDate => _selectedDate;

  List<String> get notificationsForSelectedDate =>
      _notifications[_selectedDate] ?? [];

  void selectDate(DateTime date) {
    _selectedDate = DateTime(date.year, date.month, date.day);
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
