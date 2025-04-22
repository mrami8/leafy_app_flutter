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
      appBar: AppBar(title: Text('Perfil')),
      body: userProfileProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Foto de perfil
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: userProfileProvider.fotoPerfil.isNotEmpty
                        ? NetworkImage(userProfileProvider.fotoPerfil)
                        : null,
                    child: userProfileProvider.fotoPerfil.isEmpty
                        ? Icon(Icons.person, size: 50)
                        : null,
                  ),
                  SizedBox(height: 16),
                  // Nombre del usuario
                  Text(
                    userProfileProvider.username.isNotEmpty
                        ? userProfileProvider.username
                        : "Sin nombre",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  // Email del usuario
                  Text(
                    userProfileProvider.email.isNotEmpty
                        ? userProfileProvider.email
                        : "Sin email",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 30),
                  // Botón para editar perfil
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditProfileScreen(),
                        ),
                      );
                    },
                    icon: Icon(Icons.edit),
                    label: Text('Editar perfil'),
                  ),
                  SizedBox(height: 10),
                  // Botón para cerrar sesión
                  ElevatedButton.icon(
                    onPressed: () async {
                      final authProvider =
                          Provider.of<AuthProvider>(context, listen: false);
                      await authProvider.logout();

                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                        (route) => false,
                      );
                    },
                    icon: Icon(Icons.logout),
                    label: Text('Cerrar sesión'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
