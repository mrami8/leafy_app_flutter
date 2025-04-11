import 'package:flutter/material.dart';
import 'package:leafy_app_flutter/providers/user_profile_provider.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        backgroundColor: Colors.green.shade800,
      ),
      body: const Center(
        child: Text('Pantalla de edición de perfil'),
      ),
    );
  }
}