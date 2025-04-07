import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'supabase_config.dart';
import 'LoginScreen.dart';
import 'main_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/plant_search_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.init();

  final supabaseClient = Supabase.instance.client;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..loadSession()),
        ChangeNotifierProvider(create: (_) => PlantSearchProvider(supabaseClient)),
      ],
      child: MaterialApp(
        home: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            return auth.session != null ? MainScreen() : LoginScreen();
          },
        ),
      ),
    ),
  );
}
