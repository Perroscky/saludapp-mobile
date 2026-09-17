import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // 🔥 Inicializar notificaciones
  static Future<void> initialize() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Guayaquil'));

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);
  }

  // 🔥 Solicitar permiso de notificaciones EN EL MOMENTO DE USO
  static Future<bool> requestPermission(BuildContext context) async {
    final shouldRequest = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recordatorios de citas'),
        content: const Text(
          'SaludApp necesita permiso para enviarte recordatorios de tus citas médicas. '
          '¿Deseas activar las notificaciones?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Ahora no'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Activar'),
          ),
        ],
      ),
    );

    if (shouldRequest != true) return false;

    final status = await Permission.notification.request();

    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      if (context.mounted) {
        _showPermanentDenialDialog(context);
      }
      return false;
    } else {
      return false;
    }
  }

  // 🔥 Diálogo para denegación permanente
  static void _showPermanentDenialDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permiso denegado permanentemente'),
        content: const Text(
          'Has denegado el permiso de notificaciones permanentemente. '
          'Para activarlas, ve a los ajustes del sistema.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text('Abrir ajustes'),
          ),
        ],
      ),
    );
  }

  // 🔥 Programar recordatorio de cita
  static Future<void> scheduleAppointmentReminder({
    required int appointmentId,
    required DateTime fecha,
    required String doctorName,
  }) async {
    final hasPermission = await Permission.notification.isGranted;
    if (!hasPermission) {
      print('⚠️ Sin permiso de notificaciones. No se programó recordatorio.');
      return;
    }

    try {
      await _notifications.zonedSchedule(
        appointmentId,
        'Recordatorio de cita',
        'Tienes una cita con $doctorName el ${fecha.day}/${fecha.month}/${fecha.year} a las ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}',
        tz.TZDateTime.from(fecha, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'appointments_channel',
            'Recordatorios de citas',
            channelDescription: 'Notificaciones para recordar tus citas médicas',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        // 🔥 CORRECCIÓN: Asignar valor obligatorio
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      print('✅ Recordatorio programado para: $fecha');
    } catch (e) {
      print('❌ Error al programar recordatorio: $e');
    }
  }
}