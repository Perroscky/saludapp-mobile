class User {
  final int id;
  final String email;
  final String nombre;
  final String apellido;
  final String? telefono;

  User({
    required this.id,
    required this.email,
    required this.nombre,
    required this.apellido,
    this.telefono,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    email: json['email'],
    nombre: json['nombre'],
    apellido: json['apellido'],
    telefono: json['telefono'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'nombre': nombre,
    'apellido': apellido,
    'telefono': telefono,
  };

  String get fullName => '$nombre $apellido';
}