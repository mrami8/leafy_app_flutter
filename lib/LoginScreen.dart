import 'package:flutter/material.dart';
import 'package:leafy_app_flutter/supabase_config.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool isLoading = false;
  bool isRegistering = false;

  Future<void> _login() async {
    setState(() => isLoading = true);
    try {
      final response = await SupabaseConfig.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      if (response.session != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('¡Inicio de sesión exitoso!')),
        );
        // TODO: Navegar a Home
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al iniciar sesión')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
    setState(() => isLoading = false);
  }

  Future<void> _register() async {
    setState(() => isLoading = true);
    try {
      final response = await SupabaseConfig.signUp(
        emailController.text.trim(),
        passwordController.text.trim(),
        nameController.text.trim(),
        'https://via.placeholder.com/150', // Puedes reemplazarlo con un selector de imagen luego
      );
      if (response.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('¡Registro exitoso! Ahora puedes iniciar sesión.')),
        );
        setState(() {
          isRegistering = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
    setState(() => isLoading = false);
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
                controller: nameController,
                decoration: InputDecoration(labelText: "Nombre"),
              ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Correo electrónico"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Contraseña"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : isRegistering
                      ? _register
                      : _login,
              child: isLoading
                  ? CircularProgressIndicator()
                  : Text(isRegistering ? "Registrarse" : "Iniciar Sesión"),
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
            ),
          ],
        ),
      ),
    );
  }
}
