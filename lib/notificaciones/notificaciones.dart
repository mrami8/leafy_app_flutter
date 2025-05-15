import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Plugin global de notificaciones
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Inicializa y programa la notificación diaria automáticamente
Future<void> configurarNotificacionesDiarias() async {
  // 1. Inicializar zonas horarias (una sola vez)
  tz.initializeTimeZones();

  // 2. Configurar el plugin
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidSettings);

  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (response) {
      debugPrint('Notificación tocada: ${response.payload}');
    },
  );

  // 3. Solicitar permisos en Android 13+
  final androidPlugin =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  await androidPlugin?.requestNotificationsPermission();
  final exactPermitted = await androidPlugin?.requestExactAlarmsPermission() ?? false;

  // 4. Programar la notificación diaria a las 9:00 AM
  final fecha = _proximaHora(6, 45); // puedes cambiar a otra hora si quieres
  await flutterLocalNotificationsPlugin.zonedSchedule(
    101,
    'Cuidado de plantas 🪴',
    '¡Es hora de cuidar tus plantas! 🌿💧',
    fecha,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'canal_am',
        'Recordatorio diario',
        channelDescription: 'Te recordaremos cuidar tus plantas a las 9:00 AM',
        importance: Importance.high,
        priority: Priority.high,
      ),
    ),
    androidScheduleMode: exactPermitted
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

/// Calcula la siguiente hora válida
tz.TZDateTime _proximaHora(int hora, int minuto) {
  final ahora = tz.TZDateTime.now(tz.local);
  var programada = tz.TZDateTime(tz.local, ahora.year, ahora.month, ahora.day, hora, minuto);
  if (programada.isBefore(ahora)) {
    programada = programada.add(const Duration(days: 1));
  }
  return programada;
}
