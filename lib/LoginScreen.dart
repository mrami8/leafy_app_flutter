// Importaciones necesarias
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/user_profile_provider.dart';

// Pantalla de login y registro
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

// Estado de la pantalla de login con animación
class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  // Controladores de texto para los campos de entrada
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nombreController = TextEditingController(); // Solo se usa en el registro

  bool isRegistering = false; // Indica si estamos en modo registro

  // Controlador y animación para el SlideTransition
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    // Inicializa la animación al entrar a la pantalla
    _controller =
        AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _offsetAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward(); // Comienza la animación
  }

  @override
  void dispose() {
    // Limpia los controladores para liberar recursos
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nombreController.dispose();
    super.dispose();
  }

  // Función que maneja el inicio de sesión
  Future<void> _handleLogin(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProfileProvider = Provider.of<UserProfileProvider>(
      context,
      listen: false,
    );

    await authProvider.logout(); // Cierra cualquier sesión anterior

    bool success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success) {
      // Carga el perfil del usuario desde Supabase
      userProfileProvider.loadFromAuth(authProvider);

      // Navega a la pantalla principal
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainScreen()),
      );
    } else {
      // Muestra error si el login falla
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al iniciar sesión')),
      );
    }
  }

  // Función que maneja el registro de un nuevo usuario
  Future<void> _handleRegister(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    bool success = await authProvider.register(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      _nombreController.text.trim(),
    );

    if (success) {
      // Muestra mensaje de éxito y cambia a modo login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro exitoso, ahora inicia sesión.')),
      );
      setState(() {
        isRegistering = false;
      });
    } else {
      // Muestra error si el registro falla
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al registrarse')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand, // El fondo cubre toda la pantalla
        children: [
          // Imagen de fondo
          Image.asset('assets/FondoPantalla.jpg', fit: BoxFit.cover),

          // Capa oscura semitransparente encima de la imagen
          Container(color: Colors.black.withOpacity(0.6)),

          // Contenedor principal centrado con animación
          Center(
            child: SlideTransition(
              position: _offsetAnimation,
              child: Container(
                // Estilo del contenedor blanco translúcido
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
                    // Logo de la app
                    Image.asset('assets/LogoLeafy.png', height: 100),

                    const SizedBox(height: 16),

                    // Título dinámico según el modo
                    Text(
                      isRegistering ? "Crea tu cuenta" : "Bienvenido de nuevo",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Campo de nombre si está en modo registro
                    if (isRegistering)
                      _buildTextField("Nombre", _nombreController),

                    // Campo de correo y contraseña
                    _buildTextField("Correo electrónico", _emailController),
                    _buildTextField("Contraseña", _passwordController, isPassword: true),

                    const SizedBox(height: 20),

                    // Botón principal: iniciar sesión o registrarse
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

                    // Botón para cambiar entre login y registro
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
        ],
      ),
    );
  }

  // Constructor de campos de texto personalizados
  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        obscureText: isPassword, // Oculta texto si es contraseña
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05), // Fondo del campo
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
// Este código define una pantalla de inicio de sesión y registro para una aplicación Flutter.
// Utiliza Provider para manejar el estado de autenticación y la carga del perfil de usuario.