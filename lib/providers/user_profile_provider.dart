import 'package:flutter/material.dart';
import 'auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Ensure this is the correct package for UserAttributes

import 'package:flutter/material.dart';
import 'auth_provider.dart';

class UserProfileProvider extends ChangeNotifier {
  String _username = '';
  String _email = '';
  String _fotoPerfil = '';
  bool _isLoading = false;  // Estado de carga

  String get username => _username;
  String get email => _email;
  String get fotoPerfil => _fotoPerfil;
  bool get isLoading => _isLoading;  // Getter para el estado de carga

  // Cargar perfil desde AuthProvider
  void loadFromAuth(AuthProvider auth) {
    _isLoading = true;  // Iniciar la carga
    notifyListeners();

    final profile = auth.userProfile;
    if (profile != null) {
      _username = profile['nombre'];
      _email = profile['email'];
      _fotoPerfil = profile['foto_perfil'] ?? '';
      _isLoading = false;  // Finalizar la carga
    } else {
      _isLoading = false;
      print("No se pudo cargar el perfil");
    }
    notifyListeners();
  }

  // Actualizar perfil en Supabase
  Future<void> updateProfile({required String username, required String email, required AuthProvider auth}) async {
    final supabase = auth.supabase;
    final result = await supabase.from('usuarios').update({
      'nombre': username,
      'email': email,
    }).eq('id', auth.user!.id);

    // Si el correo ha cambiado, actualizarlo también en Supabase Auth
    if (email != _email) {
      await supabase.auth.updateUser(UserAttributes(email: email));
    }

    _username = username;
    _email = email;
    notifyListeners();
  }
}
