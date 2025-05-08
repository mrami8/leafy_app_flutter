import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Provider encargado de manejar notificaciones del calendario por fecha
class NotificationProvider extends ChangeNotifier {
  List<Map<String, dynamic>> notifications =
      []; // Lista de notificaciones cargadas
  DateTime? selectedDate; // Fecha actualmente seleccionada

  // Carga las notificaciones de una fecha concreta desde Supabase
  Future<void> getNotificationsForDate(DateTime date) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      print('Usuario no logueado');
      return; // No se puede continuar sin sesión
    }

    // Rango de tiempo para la fecha seleccionada (todo el día)
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    selectedDate = date; // Guardamos la fecha actual
    notifications = []; // Limpiamos notificaciones antes de cargar
    notifyListeners();

    try {
      // Consulta a la tabla 'calendario' filtrando por usuario y fecha
      final result = await Supabase.instance.client
          .from('calendario')
          .select()
          .eq('id_usuario', user.id)
          .gte('fecha', start.toIso8601String()) // fecha >= inicio del día
          .lt('fecha', end.toIso8601String()) // fecha < siguiente día
          .order('fecha', ascending: true); // ordenadas por hora

      // Convertimos el resultado a lista de mapas
      notifications = (result as List).cast<Map<String, dynamic>>();
      notifyListeners(); // Notificamos a los widgets que dependen
    } catch (e) {
      print('Error al obtener notificaciones: $e');
    }
  }

  // Añade una notificación con hora específica
  Future<void> addNotificationWithTime(
    String message,
    DateTime selectedTime,
  ) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null || selectedDate == null) {
      print('Usuario no logueado o fecha no seleccionada');
      return;
    }

    // ID de planta dummy (temporal)
    const dummyPlantId = 'fdd93415-6e05-412d-b32c-cd778d990896';
    final tipoCuidado = message;

    // Componemos la fecha final con la hora seleccionada
    final fechaFinal = DateTime.parse(
      '${selectedDate!.toIso8601String().split("T")[0]} ${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
    );

    // Creamos el nuevo registro que vamos a insertar
    final newRecord = {
      'id_usuario': user.id,
      'id_planta': dummyPlantId,
      'tipo_cuidado': tipoCuidado,
      'fecha': fechaFinal.toIso8601String(),
      'estado': false,
    };

    print('Registro a insertar con hora: $newRecord');

    try {
      // Insertamos el registro en Supabase
      await Supabase.instance.client
          .from('calendario')
          .insert(newRecord)
          .select(); // Necesario para evitar errores en algunos modos

      // Refrescamos las notificaciones del día seleccionado
      await getNotificationsForDate(selectedDate!);
    } catch (e) {
      print('Error al guardar la notificación con hora en Supabase: $e');
    }
  }

  // Elimina una notificación por tipo_cuidado para el día seleccionado
  Future<void> deleteNotification(String tipoCuidado) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null || selectedDate == null) return;

    // Rango de la fecha actual
    final start = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
    );
    final end = start.add(const Duration(days: 1));

    try {
      // Borramos solo la notificación con ese tipo y en ese día
      await Supabase.instance.client
          .from('calendario')
          .delete()
          .eq('id_usuario', user.id)
          .eq('tipo_cuidado', tipoCuidado)
          .gte('fecha', start.toIso8601String())
          .lt('fecha', end.toIso8601String());

      print('Notificación eliminada correctamente');

      // Recargamos la lista actualizada
      await getNotificationsForDate(selectedDate!);
    } catch (e) {
      print('Error al eliminar notificación: $e');
    }
  }
}
