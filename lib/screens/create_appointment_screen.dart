import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/api_service.dart';

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

  final List<Map<String, dynamic>> _doctores = [
    {'id': 1, 'nombre': 'Dr. Juan Pérez', 'especialidad': 'Cardiología'},
    {'id': 2, 'nombre': 'Dra. María García', 'especialidad': 'Dermatología'},
    {'id': 3, 'nombre': 'Dr. Carlos López', 'especialidad': 'Pediatría'},
  ];

  Future<void> _crearCita() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDoctorId == null) {
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

    if (result['success']) {
      Fluttertoast.showToast(
        msg: '✅ Cita creada exitosamente',
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      Navigator.pop(context, true);
    } else {
      Fluttertoast.showToast(
        msg: result['error'] ?? 'Error al crear cita',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
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
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Selecciona un doctor',
                  border: OutlineInputBorder(),
                ),
                value: _selectedDoctorId,
                items: _doctores.map((doctor) {
                  return DropdownMenuItem<int>(
                    value: doctor['id'],
                    child: Text('${doctor['nombre']} - ${doctor['especialidad']}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedDoctorId = value);
                },
                validator: (value) {
                  if (value == null) return 'Selecciona un doctor';
                  return null;
                },
              ),
              const SizedBox(height: 16),

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
                      });
                    }
                  }
                },
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