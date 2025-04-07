import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;

  Session? _session;
  User? _user;
  Map<String, dynamic>? _userProfile;

  Session? get session => _session;
  User? get user => _user;
  Map<String, dynamic>? get userProfile => _userProfile;

  // Cargar sesión al iniciar la app
  Future<void> loadSession() async {
    _session = supabase.auth.currentSession;
    _user = supabase.auth.currentUser;

    if (_user != null) {
      await _loadUserProfile();
    }

    notifyListeners();
  }

  // Login
  Future<bool> login(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session != null) {
        _session = response.session;
        _user = response.user;
        await _loadUserProfile();
        notifyListeners();
        return true;
      }
      return false;
    } on AuthException catch (_) {
      return false;
    }
  }

  // Registro con nombre y foto (puede ser vacía)
  Future<bool> register(String email, String password, String nombre, {String foto = ""}) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await supabase.from('usuarios').insert({
          'id': response.user!.id,
          'email': email,
          'nombre': nombre,
          'foto_perfil': foto,
        });

        _session = response.session;
        _user = response.user;
        await _loadUserProfile();
        notifyListeners();
        return true;
      }

      return false;
    } on AuthException catch (_) {
      return false;
    }
  }

  // Cargar perfil del usuario desde tabla "usuarios"
  Future<void> _loadUserProfile() async {
    final result = await supabase
        .from('usuarios')
        .select()
        .eq('id', _user!.id)
        .single();

    _userProfile = result;
  }

  // Logout
  Future<void> logout() async {
    await supabase.auth.signOut();
    _session = null;
    _user = null;
    _userProfile = null;
    notifyListeners();
  }
}
