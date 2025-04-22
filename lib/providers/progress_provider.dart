import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ProgressProvider extends ChangeNotifier {
  List<Map<String, dynamic>> fotos = [];
  String? jardinId;

  Future<void> cargarFotos(String idJardin) async {
    jardinId = idJardin;
    final result = await Supabase.instance.client
        .from('imagenes_progreso')
        .select()
        .eq('id_jardin', idJardin)
        .order('fecha_subida', ascending: false);

    fotos = (result as List).cast<Map<String, dynamic>>();
    notifyListeners();
  }

  Future<void> subirFoto(ImageSource source) async {
    if (jardinId == null) return;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 70);
    if (pickedFile == null) return;

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final uuid = const Uuid().v4();
    final file = File(pickedFile.path);
    final path = '${user.id}/$jardinId/$uuid.jpg';

    final storageResponse = await Supabase.instance.client.storage
        .from('progreso_plantas')
        .upload(path, file);

    if (storageResponse.isEmpty) {
      print('Error al subir la imagen');
      return;
    }

    final imageUrl = Supabase.instance.client.storage
        .from('progreso_plantas')
        .getPublicUrl(path);

    await Supabase.instance.client.from('imagenes_progreso').insert({
      'id_jardin': jardinId,
      'imagen_url': imageUrl,
      'fecha_subida': DateTime.now().toIso8601String(),
    });

    await cargarFotos(jardinId!); // refresca
  }
}
