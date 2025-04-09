import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationProvider extends ChangeNotifier {
  List<Map<String, dynamic>> notifications = [];
  DateTime? selectedDate;

  // Obtiene las notificaciones (tipo_cuidado) para la fecha seleccionada desde Supabase
  Future<void> getNotificationsForDate(DateTime date) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;
    // Formatea la fecha a 'YYYY-MM-DD' para usar en la consulta (asumiendo columna de tipo date)
    final dateString = "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    // Limpia notificaciones actuales y establece la nueva fecha seleccionada
    selectedDate = date;
    notifications = [];
    notifyListeners();
    try {
      final result = await Supabase.instance.client
          .from('calendario')
          .select()
          .eq('id_usuario', userId)
          .eq('fecha', dateString);
      // Actualiza la lista de notificaciones con los resultados obtenidos
      notifications = (result as List).cast<Map<String, dynamic>>();
      notifyListeners();
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }

  // Añade una nueva notificación (tipo_cuidado) para la fecha seleccionada en Supabase
  Future<void> addNotification(String message) async {
    if (selectedDate == null) return;
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;
    // Formatea la fecha seleccionada a 'YYYY-MM-DD'
    final dateString = "${selectedDate!.year.toString().padLeft(4, '0')}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";
    final newRecord = {
      'id_usuario': userId,
      'tipo_cuidado': message,
      'fecha': dateString,
      'estado': false,
    };
    try {
      await Supabase.instance.client.from('calendario').insert(newRecord);
      // Agrega la nueva notificación a la lista local y notifica a los listeners
      notifications.add({'tipo_cuidado': message, 'estado': false});
      notifyListeners();
    } catch (e) {
      print('Error adding notification: $e');
    }
  }

  // Elimina una notificación (tipo_cuidado) para la fecha seleccionada en Supabase
  Future<void> deleteNotification(String message) async {
    if (selectedDate == null) return;
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;
    // Formatea la fecha seleccionada a 'YYYY-MM-DD'
    final dateString = "${selectedDate!.year.toString().padLeft(4, '0')}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";
    try {
      await Supabase.instance.client
          .from('calendario')
          .delete()
          .match({'id_usuario': userId, 'fecha': dateString, 'tipo_cuidado': message});
      // Remueve la notificación de la lista local y notifica a los listeners
      notifications.removeWhere((item) => item['tipo_cuidado'] == message);
      notifyListeners();
    } catch (e) {
      print('Error deleting notification: $e');
    }
  }
}
