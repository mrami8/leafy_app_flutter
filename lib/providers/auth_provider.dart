import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Provider para gestionar autenticación y perfil del usuario
class AuthProvider extends ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;

  Session? _session; // Sesión actual del usuario (token, etc.)
  User? _user; // Usuario autenticado (ID, email, etc.)
  Map<String, dynamic>? _userProfile; // Perfil adicional desde tabla 'usuarios'
  bool _isLoading = false; // Indicador de carga general

  // Getters públicos para acceder desde el exterior (por ejemplo, widgets)
  Session? get session => _session;
  User? get user => _user;
  Map<String, dynamic>? get userProfile => _userProfile;
  bool get isLoading => _isLoading;

  // Cargar sesión automáticamente al iniciar la app
  Future<void> loadSession() async {
    _isLoading = true;
    notifyListeners(); // Notifica a los listeners que la app está cargando

    // Obtiene sesión y usuario actuales desde Supabase (si ya ha iniciado sesión)
    _session = supabase.auth.currentSession;
    _user = supabase.auth.currentUser;

    // Si hay usuario, asegurar que está en nuestra tabla y cargar su perfil
    if (_user != null) {
      await _asegurarUsuarioRegistrado();
      await _loadUserProfile();
    }

    _isLoading = false;
    notifyListeners(); // Notifica que ha terminado la carga
  }

  // Función de inicio de sesión con email y contraseña
  // Función de inicio de sesión con correo y contraseña
Future<bool> login(String email, String password) async {
  try {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    // Verificamos si la respuesta contiene una sesión válida
    if (response.user != null) {
      _session = response.session;
      _user = response.user;
      await _asegurarUsuarioRegistrado();
      await _loadUserProfile();
      notifyListeners();
      print('Login con correo exitoso');
      return true;
    } else {
      print('No se pudo iniciar sesión con el correo. Respuesta vacía.');
      return false;
    }
  } catch (e) {
    print('Error durante el inicio de sesión con correo: $e');
    return false;
  }
}

Future<bool> loginWithPhone(String phone, String password) async {
  try {
    // Buscar usuario en la tabla 'usuarios' por teléfono y contraseña
    final result = await supabase
        .from('usuarios')
        .select('email, id')
        .eq('telefono', phone) // Buscar por teléfono
        .eq('password', password) // Comparar la contraseña
        .maybeSingle();

    if (result != null) {
      final email = result['email'];
      print('Usuario encontrado por teléfono: $email');
      // Intentamos login con el correo del usuario
      return login(email, password);
    } else {
      print('No se encontró un usuario con ese teléfono y contraseña');
      return false;
    }
  } catch (e) {
    print('Error al intentar login con teléfono: $e');
    return false;
  }
}




  // Función para registrar un nuevo usuario
  Future<bool> register(
    String email,
    String password,
    String nombre,
    String telefono, { // Agregamos el parámetro de teléfono
    String foto = "", // Parámetro opcional para la foto de perfil
  }) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      // Si el usuario fue creado correctamente
      if (response.user != null) {
        // Insertamos datos extra en la tabla 'usuarios' (incluyendo teléfono)
        await supabase.from('usuarios').insert({
          'id': response.user!.id,
          'email': email,
          'nombre': nombre,
          'telefono': telefono, // Insertamos el teléfono
          'foto_perfil': foto,
        });

        // Guardamos sesión y perfil
        _session = response.session;
        _user = response.user;
        await _loadUserProfile();
        notifyListeners();
        return true;
      }

      return false; // Registro fallido
    } on AuthException catch (_) {
      return false; // Error de Supabase (ej: correo duplicado)
    }
  }

  // Carga los datos del perfil del usuario desde la tabla 'usuarios'
  Future<void> _loadUserProfile() async {
    try {
      if (_user != null && _user!.email != null) {
        print('Cargando perfil para el usuario con email: ${_user!.email}');

        final result =
            await supabase
                .from('usuarios')
                .select()
                .eq('email', _user!.email!) // Busca por email
                .maybeSingle(); // Solo una fila (o null)

        if (result != null) {
          _userProfile = result;
          print('Perfil cargado: $_userProfile');
        } else {
          print('No se encontró el perfil del usuario en la tabla.');
        }
      } else {
        print('El usuario o su correo es nulo.');
      }
    } catch (e) {
      print('Error cargando perfil: $e');
    }
  }

  // Cerrar sesión y limpiar datos locales
  Future<void> logout() async {
    await supabase.auth.signOut(); // Termina la sesión
    _session = null;
    _user = null;
    _userProfile = null;
    notifyListeners(); // Notifica a widgets dependientes
  }

  // Verifica si el usuario está registrado en la tabla 'usuarios'
  Future<void> _asegurarUsuarioRegistrado() async {
    if (_user == null || _user!.email == null) return;

    try {
      // Busca si ya existe un perfil con ese email
      final existing =
          await supabase
              .from('usuarios')
              .select()
              .eq('email', _user!.email!)
              .maybeSingle();

      // Si no existe, lo crea automáticamente
      if (existing == null) {
        await supabase.from('usuarios').insert({
          'id': _user!.id,
          'email': _user!.email,
          'nombre': 'Usuario nuevo',
          'foto_perfil': '',
          'telefono':
              '', // Aseguramos que el teléfono también se registre vacío si no existe
        });
        print('✅ Usuario creado automáticamente en tabla usuarios');
      } else {
        print('🟢 Usuario ya existe en tabla usuarios (por email)');
      }
    } catch (e) {
      print('❌ Error asegurando usuario registrado: $e');
    }
  }
}
