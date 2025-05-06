import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationProvider extends ChangeNotifier {
  List<Map<String, dynamic>> notifications = [];
  DateTime? selectedDate;

  Future<void> getNotificationsForDate(DateTime date) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      print('Usuario no logueado');
      return;
    }

    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    selectedDate = date;
    notifications = [];
    notifyListeners();

    try {
      final result = await Supabase.instance.client
          .from('calendario')
          .select()
          .eq('id_usuario', user.id)
          .gte('fecha', start.toIso8601String())
          .lt('fecha', end.toIso8601String())
          .order('fecha', ascending: true);

      notifications = (result as List).cast<Map<String, dynamic>>();
      notifyListeners();
    } catch (e) {
      print('Error al obtener notificaciones: $e');
    }
  }

  Future<void> addNotificationWithTime(String message, DateTime selectedTime) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null || selectedDate == null) {
      print('Usuario no logueado o fecha no seleccionada');
      return;
    }

    const dummyPlantId = 'fdd93415-6e05-412d-b32c-cd778d990896';
    final tipoCuidado = message;
    final hora = selectedTime;
    final fechaFinal = DateTime.parse(
      '${selectedDate!.toIso8601String().split("T")[0]} ${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}',
    );

    final newRecord = {
      'id_usuario': user.id,
      'id_planta': dummyPlantId,
      'tipo_cuidado': tipoCuidado,
      'fecha': fechaFinal.toIso8601String(), 
      'estado': false,
    };

    print('Registro a insertar con hora: $newRecord');

    try {
      await Supabase.instance.client
          .from('calendario')
          .insert(newRecord)
          .select();

      await getNotificationsForDate(selectedDate!);
    } catch (e) {
      print('Error al guardar la notificación con hora en Supabase: $e');
    }
  }

  Future<void> deleteNotification(String tipoCuidado) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null || selectedDate == null) return;

    final start = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
    );
    final end = start.add(const Duration(days: 1));

    try {
      await Supabase.instance.client
          .from('calendario')
          .delete()
          .eq('id_usuario', user.id)
          .eq('tipo_cuidado', tipoCuidado)
          .gte('fecha', start.toIso8601String())
          .lt('fecha', end.toIso8601String());

      print('Notificación eliminada correctamente');
      await getNotificationsForDate(selectedDate!);
    } catch (e) {
      print('Error al eliminar notificación: $e');
    }
  }
}
