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

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailOrPhoneController =
      TextEditingController(); // Un solo controlador para email o teléfono
  final _passwordController = TextEditingController();
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController(); // ✅ Nuevo controlador

  bool isRegistering = false;

  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    _nombreController.dispose();
    _telefonoController.dispose(); // ✅ Liberar también este controlador
    super.dispose();
  }

  Future<void> _handleLogin(BuildContext context) async {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  
  String input = _emailOrPhoneController.text.trim();
  
  bool success = await authProvider.login(input, _passwordController.text.trim());

  if (success) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => MainScreen()),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al iniciar sesión')));
  }
}





  Future<void> _handleRegister(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    bool success = await authProvider.register(
      _emailOrPhoneController.text.trim(),
      _passwordController.text.trim(),
      _nombreController.text.trim(),
      _telefonoController.text.trim(), // ✅ Pasar teléfono
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro exitoso, ahora inicia sesión.')),
      );
      setState(() {
        isRegistering = false;
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error al registrarse')));
    }
  }

  bool _isEmail(String input) {
    // Verificar si es un correo
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    ).hasMatch(input);
  }

  bool _isPhoneNumber(String input) {
    // Verificar si es un teléfono (por ejemplo, números con 10 dígitos)
    return RegExp(r'^\+?[0-9]{10,15}$').hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/FondoPantalla.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.6)),
          Center(
            child: SlideTransition(
              position: _offsetAnimation,
              child: SingleChildScrollView(
                // Aquí envolvemos todo en un SingleChildScrollView
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/LogoLeafy.png', height: 100),
                      const SizedBox(height: 16),
                      Text(
                        isRegistering
                            ? "Crea tu cuenta"
                            : "Bienvenido de nuevo",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),

                      if (isRegistering)
                        _buildTextField("Nombre", _nombreController),
                      if (isRegistering)
                        _buildTextField(
                          "Teléfono",
                          _telefonoController,
                        ), // ✅ Nuevo campo

                      _buildTextField(
                        "Correo o Teléfono",
                        _emailOrPhoneController,
                      ),
                      _buildTextField(
                        "Contraseña",
                        _passwordController,
                        isPassword: true,
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.green.shade600,
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
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white30),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
