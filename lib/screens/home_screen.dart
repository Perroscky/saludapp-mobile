import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../screens/appointments_screen.dart';
import '../screens/create_appointment_screen.dart';
import '../screens/profile_screen.dart';
import '../routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  // 🔥 Key para forzar la reconstrucción de la lista de citas
  Key _appointmentsKey = UniqueKey();

  void goToTab(int index) {
    setState(() {
      _currentIndex = index;
      // 🔥 Si volvemos a "Citas", forzamos la reconstrucción
      if (index == 0) {
        _appointmentsKey = UniqueKey();
      }
    });
  }

  List<Widget> get _screens => [
    AppointmentsScreen(key: _appointmentsKey),
    // 🔥 Pasar el callback goToTab al CreateAppointmentScreen
    CreateAppointmentScreen(onAppointmentCreated: goToTab),
    const ProfileScreen(),
  ];

  Future<void> _logout() async {
    await ApiService.logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SaludApp'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
            // 🔥 Si el usuario toca "Citas", forzamos recarga
            if (index == 0) {
              _appointmentsKey = UniqueKey();
            }
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calendar_today),
            label: 'Citas',
          ),
          NavigationDestination(
            icon: Icon(Icons.add),
            label: 'Crear',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}