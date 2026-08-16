class Constants {
  // 🔥 PARA EMULADOR ANDROID
  static const String baseUrl = 'http://10.0.2.2:8080';
  
  static const String register = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';
  static const String appointments = '$baseUrl/api/appointments';
  static const String especialidades = '$baseUrl/api/especialidades';
  
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
}