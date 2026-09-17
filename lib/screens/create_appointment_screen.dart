import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';
import '../routes/app_routes.dart';

class CreateAppointmentScreen extends StatefulWidget {
  const CreateAppointmentScreen({super.key});

  @override
  State<CreateAppointmentScreen> createState() => _CreateAppointmentScreenState();
}

class _CreateAppointmentScreenState extends State<CreateAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedDoctorId;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  final _notasController = TextEditingController();
  bool _isLoading = false;

  // 🔥 Estado para errores de validación del backend
  Map<String, String> _fieldErrors = {};

  final List<Map<String, dynamic>> _doctores = [
    {'id': 1, 'nombre': 'Dr. Juan Pérez', 'especialidad': 'Cardiología'},
    {'id': 2, 'nombre': 'Dra. María García', 'especialidad': 'Dermatología'},
    {'id': 3, 'nombre': 'Dr. Carlos López', 'especialidad': 'Pediatría'},
  ];

  Future<void> _crearCita() async {
    // 🔥 Limpiar errores anteriores
    setState(() {
      _fieldErrors = {};
    });

    if (!_formKey.currentState!.validate()) return;
    if (_selectedDoctorId == null) {
      setState(() {
        _fieldErrors['doctorId'] = 'Selecciona un doctor';
      });
      Fluttertoast.showToast(
        msg: 'Selecciona un doctor',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await ApiService.createAppointment(
      doctorId: _selectedDoctorId!,
      fecha: _selectedDate,
      notas: _notasController.text.isNotEmpty ? _notasController.text : null,
    );

    setState(() => _isLoading = false);

    // 🔥 Manejo de errores 422 (validación del backend)
    if (!result['success']) {
      final error = result['error'] ?? 'Error al crear cita';

      if (error.contains('doctor')) {
        setState(() {
          _fieldErrors['doctorId'] = 'El doctor seleccionado no es válido';
        });
      } else if (error.contains('fecha') || error.contains('date')) {
        setState(() {
          _fieldErrors['fecha'] = 'La fecha seleccionada no es válida';
        });
      } else if (error.contains('disponible')) {
        setState(() {
          _fieldErrors['fecha'] = 'El doctor no está disponible en ese horario';
        });
      } else {
        Fluttertoast.showToast(
          msg: error,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
      return;
    }

    // 🔥 PROGRAMAR NOTIFICACIÓN DE RECORDATORIO
    final doctorName = _doctores.firstWhere(
      (d) => d['id'] == _selectedDoctorId,
    )['nombre'] as String;

    await NotificationService.scheduleAppointmentReminder(
      appointmentId: result['id'] ?? 0,
      fecha: _selectedDate,
      doctorName: doctorName,
    );

    Fluttertoast.showToast(
      msg: '✅ Cita creada. Recibirás recordatorio.',
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );

    // 🔥 Navegación con enrutador
    Navigator.pushReplacementNamed(context, AppRoutes.appointments);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Cita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // 🔥 Dropdown con manejo de errores 422
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Selecciona un doctor',
                  border: const OutlineInputBorder(),
                  errorText: _fieldErrors['doctorId'],
                ),
                value: _selectedDoctorId,
                items: _doctores.map((doctor) {
                  return DropdownMenuItem<int>(
                    value: doctor['id'],
                    child: Text('${doctor['nombre']} - ${doctor['especialidad']}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDoctorId = value;
                    _fieldErrors.remove('doctorId');
                  });
                },
                validator: (value) {
                  if (value == null) return 'Selecciona un doctor';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 🔥 Fecha con manejo de errores 422
              ListTile(
                title: const Text('Fecha y hora'),
                subtitle: Text(_selectedDate.toLocal().toString()),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 90)),
                  );
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_selectedDate),
                    );
                    if (time != null) {
                      setState(() {
                        _selectedDate = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute,
                        );
                        _fieldErrors.remove('fecha');
                      });
                    }
                  }
                },
              ),
              if (_fieldErrors.containsKey('fecha'))
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8),
                  child: Text(
                    _fieldErrors['fecha']!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _notasController,
                decoration: const InputDecoration(
                  labelText: 'Notas adicionales',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _crearCita,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Agendar cita', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}