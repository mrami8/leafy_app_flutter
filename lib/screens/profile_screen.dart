import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:leafy_app_flutter/providers/user_profile_provider.dart';
import 'package:leafy_app_flutter/providers/auth_provider.dart';
import 'edit_profile_screen.dart';
import 'package:leafy_app_flutter/LoginScreen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProfileProvider = Provider.of<UserProfileProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFEAF4E4), // Fondo verde claro

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: const Color(0xFFD6E8C4),
          centerTitle: true,
          elevation: 0,
          title: const Text(
            "LEAFY",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 20,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),

      body: userProfileProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F7E8),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
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
                        Text(
                          userProfileProvider.email.isNotEmpty
                              ? userProfileProvider.email
                              : "Sin email",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Botón para editar perfil
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => EditProfileScreen()),
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Editar perfil'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD6E8C4),
                        foregroundColor: Colors.black,
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
                        final authProvider = Provider.of<AuthProvider>(context, listen: false);
                        await authProvider.logout();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Cerrar sesión'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Sección de información falsa del perfil
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F7E8),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Información personal",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
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
