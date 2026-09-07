import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/appointments_screen.dart';
import '../screens/create_appointment_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/appointment_detail_screen.dart';

class AppRoutes {
  // 🔥 Nombres de rutas
  static const String login = '/';
  static const String register = '/register';
  static const String home = '/home';
  static const String appointments = '/appointments';
  static const String createAppointment = '/create-appointment';
  static const String profile = '/profile';
  static const String appointmentDetail = '/appointment/:id';

  // 🔥 Generador de rutas
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      
      case appointments:
        return MaterialPageRoute(builder: (_) => const AppointmentsScreen());
      
      case createAppointment:
        return MaterialPageRoute(builder: (_) => const CreateAppointmentScreen());
      
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      
      case appointmentDetail:
        final id = settings.arguments as int?;
        return MaterialPageRoute(
          builder: (_) => AppointmentDetailScreen(appointmentId: id ?? 0),
        );
      
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }

  // 🔥 Función para navegar con parámetros
  static void navigateToAppointmentDetail(BuildContext context, int id) {
    Navigator.pushNamed(
      context,
      appointmentDetail,
      arguments: id,
    );
  }
}