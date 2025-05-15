// Importaciones necesarias
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_screen.dart'; // Pantalla principal después del login
import 'providers/General/auth_provider.dart'; // Lógica de autenticación
// Pantalla de Login/Registro
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  // Controladores de texto para campos de entrada
  final _emailOrPhoneController = TextEditingController(); // Correo o teléfono
  final _passwordController = TextEditingController(); // Contraseña
  final _nombreController = TextEditingController(); // Nombre (solo para registro)
  final _telefonoController = TextEditingController(); // Teléfono (solo para registro)

  bool isRegistering = false; // Indica si el usuario está registrándose o iniciando sesión

  late AnimationController _controller; // Controlador para animaciones
  late Animation<Offset> _offsetAnimation; // Animación de desplazamiento vertical

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3), // Inicia ligeramente abajo
      end: Offset.zero, // Termina en su lugar original
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward(); // Iniciar animación al cargar
  }

  @override
  void dispose() {
    // Liberar recursos de los controladores y animaciones
    _controller.dispose();
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    _nombreController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  // Maneja el inicio de sesión
  Future<void> _handleLogin(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String input = _emailOrPhoneController.text.trim();

    // Llamar a la función login del AuthProvider
    bool success = await authProvider.login(input, _passwordController.text.trim());

    if (success) {
      // Navegar a la pantalla principal si el login fue exitoso
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainScreen()),
      );
    } else {
      // Mostrar error en un SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al iniciar sesión')),
      );
    }
  }

  // Maneja el registro de usuarios nuevos
  Future<void> _handleRegister(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Llamar a la función register del AuthProvider
    bool success = await authProvider.register(
      _emailOrPhoneController.text.trim(),
      _passwordController.text.trim(),
      _nombreController.text.trim(),
      _telefonoController.text.trim(),
    );

    if (success) {
      // Mostrar mensaje de éxito y cambiar a modo login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro exitoso, ahora inicia sesión.')),
      );
      setState(() {
        isRegistering = false;
      });
    } else {
      // Mostrar error en un SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al registrarse')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Imagen de fondo
          Image.asset('assets/FondoPantalla.jpg', fit: BoxFit.cover),

          // Capa oscura encima del fondo para mejorar contraste
          Container(color: Colors.black.withOpacity(0.6)),

          // Contenido principal centrado con animación
          Center(
            child: SlideTransition(
              position: _offsetAnimation,
              child: SingleChildScrollView(
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
                      // Logo principal
                      Image.asset('assets/LogoLeafy.png', height: 100),
                      const SizedBox(height: 16),

                      // Título según modo actual
                      Text(
                        isRegistering ? "Crea tu cuenta" : "Bienvenido de nuevo",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Campos de registro adicionales
                      if (isRegistering)
                        _buildTextField("Nombre", _nombreController),

                      if (isRegistering)
                        _buildTextField("Teléfono", _telefonoController),

                      // Campo compartido (email o teléfono)
                      _buildTextField("Correo o Teléfono", _emailOrPhoneController),

                      // Campo de contraseña
                      _buildTextField("Contraseña", _passwordController, isPassword: true),

                      const SizedBox(height: 20),

                      // Botón de acción (login o registro)
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
          ),
        ],
      ),
    );
  }

  // Método auxiliar para crear campos de texto con estilo
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
