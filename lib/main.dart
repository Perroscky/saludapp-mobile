import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const SaludApp());
}

class SaludApp extends StatelessWidget {
  const SaludApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SaludApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRoutes.generateRoute,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  String? _redirectRoute;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: ApiService.isAuthenticated(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == true) {
          if (_redirectRoute != null) {
            final route = _redirectRoute!;
            _redirectRoute = null;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, route);
            });
          }
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }

  void setRedirectRoute(String route) {
    _redirectRoute = route;
  }
}