// Importación de los paquetes necesarios para Flutter, Provider y navegación entre pantallas
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importación del provider del perfil de usuario y autenticación
import 'package:leafy_app_flutter/providers/Profile/user_profile_provider.dart';
import 'package:leafy_app_flutter/providers/General/auth_provider.dart';

// Importación de pantallas externas
import 'edit_profile_screen.dart';
import 'package:leafy_app_flutter/LoginScreen.dart';

// Widget principal de la pantalla de perfil
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key}); // Constructor constante sin lógica extra

  @override
  Widget build(BuildContext context) {
    // Obtenemos el provider con los datos del usuario (nombre, email, foto, etc.)
    final userProfileProvider = Provider.of<UserProfileProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFEAF4E4), // Establece un color de fondo verde claro

      // AppBar personalizado con un título centrado e ícono de hoja
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), // Altura del AppBar
        child: AppBar(
          backgroundColor: const Color(0xFFD6E8C4), // Fondo verde suave
          centerTitle: true, // Centrar título e ícono
          elevation: 0, // Sin sombra
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "LEAFY", // Nombre/logo de la app
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: 8), // Espacio entre texto e ícono
              const Icon(
                Icons.energy_savings_leaf, // Ícono representativo
                color: Colors.green,
                size: 30,
              ),
            ],
          ),
        ),
      ),

      // Cuerpo principal de la pantalla
      body: userProfileProvider.isLoading
          // Si se está cargando el perfil, mostrar spinner de carga
          ? const Center(child: CircularProgressIndicator())
          // Si ya está cargado, mostrar la información
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0), // Espaciado alrededor del contenido
              child: Column(
                children: [
                  // Contenedor principal con datos del usuario
                  Container(
                    width: double.infinity, // Ocupa todo el ancho
                    padding: const EdgeInsets.all(20), // Espaciado interior
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F7E8), // Fondo del contenedor
                      borderRadius: BorderRadius.circular(16), // Bordes redondeados
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12, // Sombra sutil
                          blurRadius: 4,
                          offset: const Offset(0, 2), // Posición de la sombra
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Avatar redondo con imagen del usuario o ícono por defecto
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: userProfileProvider.fotoPerfil.isNotEmpty
                              ? NetworkImage(userProfileProvider.fotoPerfil)
                              : null,
                          backgroundColor: const Color(0xFFD6E8C4),
                          child: userProfileProvider.fotoPerfil.isEmpty
                              ? Icon(Icons.person, size: 60, color: Colors.grey[700])
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // Nombre del usuario (si está disponible)
                        Text(
                          userProfileProvider.username.isNotEmpty
                              ? userProfileProvider.username
                              : "Sin nombre",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        // Email del usuario (si está disponible)
                        Text(
                          userProfileProvider.email.isNotEmpty
                              ? userProfileProvider.email
                              : "Sin email",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30), // Espacio entre secciones

                  // Botón para ir a la pantalla de edición del perfil
                  SizedBox(
                    width: double.infinity, // Ocupa todo el ancho
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Navega a la pantalla de edición
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => EditProfileScreen()),
                        );
                      },
                      icon: const Icon(Icons.edit), // Ícono de lápiz
                      label: const Text('Editar perfil'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD6E8C4), // Color de fondo del botón
                        foregroundColor: Colors.black, // Color del texto
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Botón para cerrar sesión
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        // Obtener el AuthProvider sin escuchar cambios
                        final authProvider = Provider.of<AuthProvider>(context, listen: false);
                        // Ejecutar logout (cerrar sesión)
                        await authProvider.logout();
                        // Navegar a la pantalla de login eliminando el historial de navegación
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.logout), // Ícono de salida
                      label: const Text('Cerrar sesión'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Fondo rojo para advertencia
                        foregroundColor: Colors.white, // Texto blanco
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Sección de información complementaria ficticia
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F7E8), // Mismo fondo que el bloque de perfil
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        // Título de sección
                        Text(
                          "Información personal",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),

                        // Detalles ficticios del usuario (pueden reemplazarse por datos reales)
                        Text("📍 Ubicación: Sevilla, España"),
                        Text("🎂 Fecha de nacimiento: 22 de octubre de 1989"),
                        Text("🧬 Intereses: Ecología urbana, botánica exótica, acuaponía doméstica"),
                        Text("📚 Profesión: Arquitecta paisajista"),
                        Text(
                          "💬 Biografía: Entusiasta de los ecosistemas urbanos. "
                          "Creo espacios verdes sostenibles que mezclan diseño moderno y naturaleza viva.",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
