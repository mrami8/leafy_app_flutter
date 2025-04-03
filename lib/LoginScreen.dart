import 'package:flutter/material.dart';
import 'package:leafy_app_flutter/supabase_config.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _login() async {
    setState(() => isLoading = true);
    
    try {
      final response = await SupabaseConfig.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (response.session != null) {
        // Inicio de sesión exitoso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('¡Inicio de sesión exitoso!')),
        );
        // Aquí puedes navegar a la pantalla principal de la app
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Iniciar Sesión")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Correo electrónico"),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Contraseña"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : _login,
              child: isLoading ? CircularProgressIndicator() : Text("Iniciar Sesión"),
            ),
          ],
        ),
      ),
    );
  }
}
