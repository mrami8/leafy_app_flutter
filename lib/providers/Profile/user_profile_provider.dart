import 'package:flutter/material.dart';
import '../General/auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provider que gestiona la información del perfil de usuario en la app
class UserProfileProvider extends ChangeNotifier {
  // Atributos privados del perfil
  String _username = '';         // Nombre del usuario
  String _email = '';            // Correo electrónico
  String _telefono = '';         // Teléfono del usuario
  String _fotoPerfil = '';       // URL de la imagen de perfil
  bool _isLoading = false;       // Estado de carga para mostrar spinners, etc.

  // Getters públicos para acceder a los datos desde la UI
  String get username => _username;
  String get email => _email;
  String get telefono => _telefono;
  String get fotoPerfil => _fotoPerfil;
  bool get isLoading => _isLoading;

  /// Carga los datos del usuario desde el `AuthProvider`
  void loadFromAuth(AuthProvider auth) {
    _isLoading = true;
    notifyListeners(); // Notifica a los widgets para mostrar loading

    final profile = auth.userProfile; // Mapa con los datos del usuario

    if (profile != null) {
      _username = profile['nombre'] ?? 'Sin nombre';
      _email = profile['email'] ?? 'Sin email';
      _telefono = profile['telefono'] ?? '';
      _fotoPerfil = profile['foto_perfil'] ?? '';
    } else {
      print("No se pudo cargar el perfil del usuario.");
    }

    _isLoading = false;
    notifyListeners(); // Notifica para refrescar la UI con los nuevos datos
  }

  /// Actualiza el perfil del usuario en Supabase y localmente en el provider
  Future<void> updateProfile({
    required String username,
    required String email,
    required String telefono,
    required AuthProvider auth,
  }) async {
    final supabase = auth.supabase;

    // Actualiza los campos en la tabla 'usuarios' en Supabase
    await supabase
        .from('usuarios')
        .update({
          'nombre': username,
          'email': email,
          'telefono': telefono,
        })
        .eq('id', auth.user!.id); // Asegura que se actualice solo el usuario actual

    // Si el email cambió, actualiza también en el sistema de autenticación
    if (email != _email) {
      await supabase.auth.updateUser(UserAttributes(email: email));
    }

    // Actualiza los valores locales
    _username = username;
    _email = email;
    _telefono = telefono;

    notifyListeners(); // Refresca la UI
  }

  /// Cambia la contraseña del usuario en Supabase
  Future<void> updatePassword(String newPassword, AuthProvider auth) async {
    final supabase = auth.supabase;

    if (auth.user != null) {
      // Supabase maneja el cambio de contraseña con el método updateUser
      await supabase.auth.updateUser(UserAttributes(password: newPassword));
    }
  }
}
