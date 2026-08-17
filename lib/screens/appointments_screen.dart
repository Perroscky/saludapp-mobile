import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/api_service.dart';
import '../models/appointment.dart';
import '../screens/create_appointment_screen.dart';
import 'home_screen.dart'; // 👈 Importar home_screen para usar la clave global

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  List<Appointment> _appointments = [];
  bool _isLoading = true;
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadAppointments();
  }

  Future<void> _loadUserData() async {
    final user = await ApiService.getCurrentUser();
    setState(() {
      _userName = user?.nombre ?? 'Usuario';
    });
  }

  Future<void> _loadAppointments() async {
    setState(() => _isLoading = true);

    try {
      final appointments = await ApiService.getAppointments();
      setState(() {
        _appointments = appointments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _appointments = [];
        _isLoading = false;
      });
    }
  }

  void _goToCreateAppointment() {
    // 🔥 Usar la clave global para acceder a HomeScreen
    final homeState = homeScreenKey.currentState;
    if (homeState != null) {
      homeState.goToTab(1); // Ir a la pestaña "Crear" (índice 1)
    } else {
      // Fallback: si no encuentra HomeScreen, ir directamente a la pantalla de crear cita
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CreateAppointmentScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_appointments.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadAppointments,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _appointments.length,
        itemBuilder: (context, index) {
          final appointment = _appointments[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: appointment.estadoColor,
                child: Text(
                  appointment.nombreDoctor[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(appointment.nombreDoctor),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (appointment.doctorEspecialidad != null)
                    Text(appointment.doctorEspecialidad!),
                  if (appointment.doctorConsultorio != null)
                    Text('Consultorio: ${appointment.doctorConsultorio}'),
                  const SizedBox(height: 4),
                  Text(appointment.fechaFormateada),
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: appointment.estadoColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  appointment.estadoFormateado,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🌟 Icono animado
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_today,
                size: 80,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 24),

            // 👋 Mensaje de bienvenida
            Text(
              '¡Hola, $_userName! 👋',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // 📝 Subtítulo
            const Text(
              'Tu salud es nuestra prioridad',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),

            // 🏥 Tarjeta informativa
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: const Column(
                children: [
                  Icon(Icons.medical_services, size: 40, color: Colors.blue),
                  SizedBox(height: 12),
                  Text(
                    'No tienes citas agendadas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Agenda tu primera cita médica',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 🚀 Botón para crear cita
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _goToCreateAppointment,
                icon: const Icon(Icons.add),
                label: const Text(
                  'Agendar nueva cita',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}