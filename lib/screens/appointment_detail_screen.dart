import 'package:flutter/material.dart';
import '../models/appointment.dart';

class AppointmentDetailScreen extends StatelessWidget {
  final int appointmentId;

  const AppointmentDetailScreen({
    super.key,
    required this.appointmentId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Cita'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.calendar_today,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 24),
              Text(
                'Detalle de la cita #$appointmentId',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Esta pantalla se construye a partir de la URL',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ruta: /appointment/:id',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}