class Constants {
  // 🔥 URL DEL BACKEND - CAMBIA SEGÚN DONDE EJECUTES
  
  // Opción 1: Navegador o Windows (localhost)
  static const String baseUrl = 'http://localhost:8080';
  
  // Opción 2: Emulador Android
  // static const String baseUrl = 'http://10.0.2.2:8080';
  
  // Opción 3: Dispositivo físico (usa tu IP)
  // static const String baseUrl = 'http://192.168.x.x:8080';
  
  static const String register = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';
  static const String appointments = '$baseUrl/api/appointments';
  static const String especialidades = '$baseUrl/api/especialidades';
  
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
}