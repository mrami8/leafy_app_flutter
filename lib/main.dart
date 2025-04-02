import 'package:flutter/material.dart';
import 'supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const UsuariosScreen(),
    );
  }
}

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});

  @override
  _UsuariosScreenState createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  List<Map<String, dynamic>> usuarios = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsuarios();
  }

  Future<void> _fetchUsuarios() async {
    final data = await SupabaseConfig.getUsuarios();
    setState(() {
      usuarios = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuarios Registrados')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                final usuario = usuarios[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(usuario['foto_perfil'] ?? ''),
                  ),
                  title: Text(usuario['nombre']),
                  subtitle: Text(usuario['email']),
                );
              },
            ),
    );
  }
}
