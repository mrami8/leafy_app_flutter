import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/user_profile_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nombreController = TextEditingController(); // Solo para registro

  bool isRegistering = false;

  Future<void> _handleLogin(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProfileProvider =
        Provider.of<UserProfileProvider>(context, listen: false);

    // Limpia cualquier sesión anterior (por si acaso)
    await authProvider.logout();

    bool success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success) {
      // Recargar perfil del nuevo usuario
      userProfileProvider.loadFromAuth(authProvider);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al iniciar sesión')),
      );
    }
  }

  Future<void> _handleRegister(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    bool success = await authProvider.register(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      _nombreController.text.trim(),
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro exitoso, ahora inicia sesión.')),
      );
      setState(() {
        isRegistering = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al registrarse')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isRegistering ? "Registro" : "Iniciar Sesión")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isRegistering)
              TextField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: "Nombre"),
              ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Correo"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Contraseña"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (isRegistering) {
                  _handleRegister(context);
                } else {
                  _handleLogin(context);
                }
              },
              child: Text(isRegistering ? "Registrarse" : "Iniciar Sesión"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isRegistering = !isRegistering;
                });
              },
              child: Text(isRegistering
                  ? "¿Ya tienes cuenta? Inicia sesión"
                  : "¿No tienes cuenta? Regístrate"),
            )
          ],
        ),
      ),
    );
  }
}
