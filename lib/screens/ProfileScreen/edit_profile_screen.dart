import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:leafy_app_flutter/providers/Profile/user_profile_provider.dart';
import 'package:leafy_app_flutter/providers/General/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Clave para identificar el formulario y validar los campos
  final _formKey = GlobalKey<FormState>();

  // Controladores para manejar los campos de texto del formulario
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    // Obtener datos iniciales del perfil del usuario desde el provider
    final userProfile = Provider.of<UserProfileProvider>(context, listen: false);
    // Inicializar controladores con valores actuales del usuario
    _usernameController = TextEditingController(text: userProfile.username);
    _emailController = TextEditingController(text: userProfile.email);
    _phoneController = TextEditingController(text: userProfile.telefono);
    _passwordController = TextEditingController(); // Contraseña vacía inicialmente
  }

  @override
  void dispose() {
    // Liberar recursos de los controladores cuando el widget se elimina
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Obtener providers para autenticación y perfil de usuario
    final authProvider = Provider.of<AuthProvider>(context);
    final userProfileProvider = Provider.of<UserProfileProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFEAF4E4), // Color de fondo de la pantalla
      appBar: AppBar(
        title: Text('Editar Perfil'), // Título del app bar
        backgroundColor: const Color(0xFFD6E8C4), // Color de fondo del app bar
        actions: [
          IconButton(
            icon: Icon(Icons.save), // Icono para guardar cambios
            onPressed: () async {
              // Validar el formulario antes de guardar
              if (_formKey.currentState!.validate()) {
                // Actualizar el perfil con los datos introducidos
                await userProfileProvider.updateProfile(
                  username: _usernameController.text,
                  email: _emailController.text,
                  telefono: _phoneController.text,
                  auth: authProvider,
                );

                // Si se ha introducido una nueva contraseña, actualizarla también
                if (_passwordController.text.isNotEmpty) {
                  await userProfileProvider.updatePassword(
                    _passwordController.text,
                    authProvider,
                  );
                }

                // Mostrar mensaje de confirmación y regresar a la pantalla anterior
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Perfil actualizado correctamente')),
                  );
                  Navigator.pop(context);
                }
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Espaciado alrededor del formulario
        child: Form(
          key: _formKey, // Asociar la clave al formulario
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController, // Controlador para el nombre
                decoration: InputDecoration(
                  labelText: 'Nombre', // Etiqueta del campo
                  filled: true,
                  fillColor: const Color(0xFFF4F4F4), // Color de fondo del campo
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), // Bordes redondeados
                    borderSide: BorderSide.none, // Sin borde visible
                  ),
                ),
                validator: (value) {
                  // Validación: campo no vacío
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16), // Separación vertical entre campos
              TextFormField(
                controller: _emailController, // Controlador para email
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  filled: true,
                  fillColor: const Color(0xFFF4F4F4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  // Validación: no vacío y formato válido de email
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un correo';
                  }
                  if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                      .hasMatch(value)) {
                    return 'Por favor ingresa un correo válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _phoneController, // Controlador para teléfono
                decoration: InputDecoration(
                  labelText: 'Teléfono',
                  filled: true,
                  fillColor: const Color(0xFFF4F4F4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  // Validación: campo no vacío
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un teléfono';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController, // Controlador para contraseña
                obscureText: true, // Ocultar texto para la contraseña
                decoration: InputDecoration(
                  labelText: 'Contraseña (opcional)', // Campo opcional
                  filled: true,
                  fillColor: const Color(0xFFF4F4F4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
