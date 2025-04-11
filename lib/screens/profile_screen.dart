import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:leafy_app_flutter/providers/user_profile_provider.dart';
import 'edit_profile_screen.dart'; // Asegúrate de importar tu pantalla de edición

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProfileProvider = Provider.of<UserProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.green.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 12),

            Text(
              userProfileProvider.username.isNotEmpty
                  ? userProfileProvider.username
                  : "Cargando...",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            Text(
              userProfileProvider.email.isNotEmpty
                  ? userProfileProvider.email
                  : "Cargando...",
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            _buildButton(context, 'Modificar perfil', Icons.edit, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
            }),
            const SizedBox(height: 10),

            _buildButton(context, 'Cambiar contraseña', Icons.lock, () {
              // Acción para cambiar contraseña
            }),
            const SizedBox(height: 10),

            _buildButton(context, 'Ver mis plantas', Icons.local_florist, () {
              // Acción para ir a "mis plantas"
            }),
            const SizedBox(height: 10),

            _buildButton(context, 'Cerrar sesión', Icons.logout, () {
              // Acción para cerrar sesión
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(text),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
