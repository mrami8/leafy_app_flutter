import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'supabase_config.dart';
import 'LoginScreen.dart';
import 'main_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/plant_search_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/user_profile_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.init(); // Inicializamos Supabase con la configuración

  final supabaseClient = Supabase.instance.client; // Obtenemos el cliente de Supabase

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..loadSession()), // Proveedor para autenticación
        ChangeNotifierProvider(create: (_) => PlantSearchProvider(supabaseClient)), // Proveedor para búsqueda de plantas
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()), // Proveedor para perfil del usuario
      ],
      child: MaterialApp(
        home: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            // Dependiendo de si hay sesión, mostramos la pantalla principal o la de login
            return auth.session != null ? MainScreen() : LoginScreen();
          },
        ),
      ),
    ),
  );
}
