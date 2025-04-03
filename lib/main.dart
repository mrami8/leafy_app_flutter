import 'package:flutter/material.dart';
import 'supabase_config.dart';
import 'LoginScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.init();

  runApp(MaterialApp(
    home: LoginScreen(),
  ));
}
