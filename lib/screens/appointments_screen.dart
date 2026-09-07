import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/api_service.dart';
import '../models/appointment.dart';
import '../models/state_status.dart';
import '../screens/create_appointment_screen.dart';
import '../screens/appointment_detail_screen.dart';
import '../routes/app_routes.dart';
import 'home_screen.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  // 🔥 Estado de la aplicación usando tipos cerrados
  AppointmentsState _state = const AppointmentsLoading();
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
    setState(() {
      _state = const AppointmentsLoading();
    });

    try {
      final appointments = await ApiService.getAppointments();
      
      if (appointments.isEmpty) {
        setState(() {
          _state = const AppointmentsEmpty();
        });
      } else {
        setState(() {
          _state = AppointmentsLoaded(appointments);
        });
      }
    } catch (e) {
      setState(() {
        _state = AppointmentsError('Error al cargar citas: $e');
      });
    }
  }

  void _goToCreateAppointment() {
    final homeState = homeScreenKey.currentState;
    if (homeState != null) {
      homeState.goToTab(1);
    } else {
      Navigator.pushNamed(context, AppRoutes.createAppointment);
    }
  }

  void _goToAppointmentDetail(int id) {
    AppRoutes.navigateToAppointmentDetail(context, id);
  }

  @override
  Widget build(BuildContext context) {
    return switch (_state) {
      AppointmentsLoading() => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Cargando citas...'),
            ],
          ),
        ),
      
      AppointmentsEmpty() => _buildEmptyState(),
      
      AppointmentsLoaded(data: final appointments) => RefreshIndicator(
          onRefresh: _loadAppointments,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index] as Appointment;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () => _goToAppointmentDetail(appointment.id),
                  borderRadius: BorderRadius.circular(12),
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
                ),
              );
            },
          ),
        ),
      
      AppointmentsError(message: final message) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadAppointments,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            Text(
              '¡Hola, $_userName! 👋',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tu salud es nuestra prioridad',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
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