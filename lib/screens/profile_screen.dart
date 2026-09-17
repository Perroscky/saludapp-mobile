import 'dart:io';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/image_service.dart';
import '../services/notification_service.dart';
import '../models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  bool _isLoading = true;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _cargarUsuario();
  }

  Future<void> _cargarUsuario() async {
    final user = await ApiService.getCurrentUser();
    setState(() {
      _user = user;
      _isLoading = false;
    });
  }

  Future<void> _changeProfileImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Tomar foto'),
              onTap: () async {
                Navigator.pop(context);
                final image = await ImageService.takePhoto(context);
                if (image != null) {
                  final savedPath = await ImageService.saveImageLocally(image);
                  setState(() {
                    _profileImage = File(savedPath);
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Seleccionar de galería'),
              onTap: () async {
                Navigator.pop(context);
                final image = await ImageService.pickFromGallery(context);
                if (image != null) {
                  final savedPath = await ImageService.saveImageLocally(image);
                  setState(() {
                    _profileImage = File(savedPath);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_user == null) {
      return const Center(
        child: Text('No se pudo cargar el perfil'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),

          // 🔥 Foto de perfil con opción de cambiar
          GestureDetector(
            onTap: _changeProfileImage,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.blue,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : null,
                  child: _profileImage == null
                      ? Text(
                          _user!.nombre[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Text(
            _user!.fullName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _user!.email,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),

          const SizedBox(height: 40),
          const Divider(),
          const SizedBox(height: 16),

          _buildInfoItem('ID', _user!.id.toString()),
          _buildInfoItem('Nombre', _user!.nombre),
          _buildInfoItem('Apellido', _user!.apellido),
          _buildInfoItem('Email', _user!.email),
          if (_user!.telefono != null)
            _buildInfoItem('Teléfono', _user!.telefono!),

          const SizedBox(height: 32),

          // 🔥 Botón para activar notificaciones
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () async {
                final granted = await NotificationService.requestPermission(context);
                if (granted && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Notificaciones activadas'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.notifications),
              label: const Text('Activar recordatorios de citas'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}