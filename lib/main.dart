import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'supabase_config.dart';
import 'LoginScreen.dart';
import 'main_screen.dart';
import 'providers/auth_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..loadSession()),
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
