import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  // 🔥 Solicitar permiso de cámara EN EL MOMENTO DE USO
  static Future<bool> requestCameraPermission(BuildContext context) async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      if (context.mounted) {
        _showPermanentDenialDialog(context, 'cámara');
      }
      return false;
    } else {
      return false;
    }
  }

  // 🔥 Solicitar permiso de galería (NO necesario en Android 13+ con selector del sistema)
  static Future<bool> requestGalleryPermission(BuildContext context) async {
    // Android 13+ no requiere permiso para leer imágenes con el selector del sistema
    if (Platform.isAndroid) {
      return true;
    }

    final status = await Permission.photos.request();

    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      if (context.mounted) {
        _showPermanentDenialDialog(context, 'galería');
      }
      return false;
    } else {
      return false;
    }
  }

  // 🔥 Tomar foto con la cámara
  static Future<File?> takePhoto(BuildContext context) async {
    final shouldProceed = await _showExplanationDialog(
      context,
      'Tomar foto',
      'SaludApp necesita acceso a la cámara para tomar tu foto de perfil.',
    );

    if (!shouldProceed) return null;

    final hasPermission = await requestCameraPermission(context);
    if (!hasPermission) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permiso de cámara denegado'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    }

    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 800,
      );

      if (photo == null) return null;
      return File(photo.path);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al tomar foto: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    }
  }

  // 🔥 Seleccionar imagen de la galería
  static Future<File?> pickFromGallery(BuildContext context) async {
    final shouldProceed = await _showExplanationDialog(
      context,
      'Seleccionar foto',
      'SaludApp necesita acceso a tus fotos para que puedas elegir una imagen de perfil.',
    );

    if (!shouldProceed) return null;

    final hasPermission = await requestGalleryPermission(context);
    if (!hasPermission) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permiso de galería denegado'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
      );

      if (image == null) return null;
      return File(image.path);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al seleccionar imagen: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    }
  }

  // 🔥 Diálogo de explicación previa
  static Future<bool> _showExplanationDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // 🔥 Diálogo para denegación permanente
  static void _showPermanentDenialDialog(
      BuildContext context, String permissionName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permiso denegado permanentemente'),
        content: Text(
          'Has denegado el permiso de $permissionName permanentemente. '
          'Para activarlo, ve a los ajustes del sistema.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text('Abrir ajustes'),
          ),
        ],
      ),
    );
  }

  // 🔥 Guardar imagen localmente
  static Future<String> saveImageLocally(File image) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await image.copy('${directory.path}/$fileName');
      return savedImage.path;
    } catch (e) {
      print('Error al guardar imagen: $e');
      return image.path;
    }
  }
}