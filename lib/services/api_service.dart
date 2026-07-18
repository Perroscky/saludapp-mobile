import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import '../models/user.dart';
import '../models/appointment.dart';

class ApiService {
  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constants.tokenKey);
    
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // 📝 REGISTRAR
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String nombre,
    required String apellido,
    String? telefono,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(Constants.register),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'nombre': nombre,
          'apellido': apellido,
          'telefono': telefono,
        }),
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(Constants.tokenKey, data['token']);
        await prefs.setString(Constants.userKey, jsonEncode(data['user']));
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'error': data['error'] ?? 'Error al registrar'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Error de conexión: $e'};
    }
  }

  // 🔐 LOGIN
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(Constants.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(Constants.tokenKey, data['token']);
        await prefs.setString(Constants.userKey, jsonEncode(data['user']));
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'error': data['error'] ?? 'Credenciales inválidas'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Error de conexión: $e'};
    }
  }

  // 📋 OBTENER CITAS
  static Future<List<Appointment>> getAppointments() async {
    final headers = await _getHeaders();
    
    final response = await http.get(
      Uri.parse(Constants.appointments),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> appointmentsJson = data['data'] ?? [];
      return appointmentsJson.map((json) => Appointment.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  // ➕ CREAR CITA
  static Future<Map<String, dynamic>> createAppointment({
    required int doctorId,
    required DateTime fecha,
    String? notas,
  }) async {
    final headers = await _getHeaders();
    
    final response = await http.post(
      Uri.parse(Constants.appointments),
      headers: headers,
      body: jsonEncode({
        'doctorId': doctorId,
        'fecha': fecha.toIso8601String(),
        'notas': notas,
      }),
    );

    final data = jsonDecode(response.body);
    
    if (response.statusCode == 200) {
      return {'success': data['success'] ?? true, 'data': data};
    } else {
      return {'success': false, 'error': data['error'] ?? 'Error al crear cita'};
    }
  }

  // 🚪 CERRAR SESIÓN
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(Constants.tokenKey);
    await prefs.remove(Constants.userKey);
  }

  // 👤 OBTENER USUARIO
  static Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(Constants.userKey);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  // ✅ VERIFICAR AUTENTICACIÓN
  static Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constants.tokenKey);
    return token != null && token.isNotEmpty;
  }
}