import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'supabase_config.dart';
import 'LoginScreen.dart';
import 'home_screen.dart';
import 'providers/auth_provider.dart';
import 'calendar_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..loadSession()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        home: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            return auth.session != null ? HomeScreen() : LoginScreen();
          },
        ),
      ),
    ),
  );
}
