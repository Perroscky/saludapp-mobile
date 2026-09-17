import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Appointment {
  final int id;
  final int userId;
  final int doctorId;
  final DateTime fecha;
  final int duracionMinutos;
  final String estado;
  final String? notas;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? doctorNombre;
  final String? doctorEspecialidad;
  final String? doctorConsultorio;

  Appointment({
    required this.id,
    required this.userId,
    required this.doctorId,
    required this.fecha,
    this.duracionMinutos = 30,
    this.estado = 'pendiente',
    this.notas,
    required this.createdAt,
    required this.updatedAt,
    this.doctorNombre,
    this.doctorEspecialidad,
    this.doctorConsultorio,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    DateTime toDateTime(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is DateTime) return value;
      if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
      return DateTime.now();
    }

    return Appointment(
      id: toInt(json['id']),
      userId: toInt(json['userId']),
      doctorId: toInt(json['doctorId']),
      fecha: toDateTime(json['fecha']),
      duracionMinutos: toInt(json['duracionMinutos']),
      estado: json['estado']?.toString() ?? 'pendiente',
      notas: json['notas']?.toString(),
      createdAt: toDateTime(json['createdAt']),
      updatedAt: toDateTime(json['updatedAt']),
      doctorNombre: json['doctor']?['nombre']?.toString(),
      doctorEspecialidad: json['doctor']?['especialidad']?.toString(),
      doctorConsultorio: json['doctor']?['consultorio']?.toString(),
    );
  }

  String get fechaFormateada {
    final format = DateFormat('dd/MM/yyyy HH:mm');
    return format.format(fecha.toLocal());
  }

  String get estadoFormateado {
    switch (estado) {
      case 'pendiente': return 'Pendiente';
      case 'confirmada': return 'Confirmada';
      case 'cancelada': return 'Cancelada';
      case 'completada': return 'Completada';
      default: return estado;
    }
  }

  Color get estadoColor {
    switch (estado) {
      case 'pendiente': return Colors.orange;
      case 'confirmada': return Colors.green;
      case 'cancelada': return Colors.red;
      case 'completada': return Colors.blue;
      default: return Colors.grey;
    }
  }

  String get nombreDoctor => doctorNombre ?? 'Doctor no asignado';
}