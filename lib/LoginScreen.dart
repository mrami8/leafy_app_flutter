import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_screen.dart';
import 'providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nombreController = TextEditingController();

  bool isRegistering = false;

  Future<void> _handleLogin(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    bool success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión')),
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
        SnackBar(content: Text('Registro exitoso, ahora inicia sesión.')),
      );
      setState(() {
        isRegistering = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrarse')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/FondoPantalla.jpg', // Usa la imagen que subiste
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.5), // Capa para contraste
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/LogoLeafy.png',
                    height: 120,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    isRegistering ? "Crea tu cuenta" : "Bienvenido de nuevo",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (isRegistering)
                    _buildTextField("Nombre", _nombreController),
                  _buildTextField("Correo electrónico", _emailController),
                  _buildTextField("Contraseña", _passwordController, isPassword: true),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48, vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (isRegistering) {
                        _handleRegister(context);
                      } else {
                        _handleLogin(context);
                      }
                    },
                    child: Text(
                      isRegistering ? "REGISTRARSE" : "INICIAR SESIÓN",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isRegistering = !isRegistering;
                      });
                    },
                    child: Text(
                      isRegistering
                          ? "¿Ya tienes cuenta? Inicia sesión"
                          : "¿No tienes cuenta? Regístrate",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white54),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
