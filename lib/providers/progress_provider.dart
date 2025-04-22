import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ProgressProvider extends ChangeNotifier {
  List<Map<String, dynamic>> fotos = [];
  String? jardinId;

  Future<void> cargarFotos(String idJardin) async {
    try {
      jardinId = idJardin;
      final result = await Supabase.instance.client
          .from('imagenes_progreso')
          .select()
          .eq('id_jardin', idJardin)
          .order('fecha_subida', ascending: false);

      final storage = Supabase.instance.client.storage.from('progresoplantas');

      fotos = (await Future.wait((result as List).map((item) async {
        final path = item['imagen_url'];

        try {
          final signedUrl = await storage.createSignedUrl(path, 60 * 60);
          return {
            'imagen_url': signedUrl,
            'path': path,
            'fecha_subida': item['fecha_subida'],
          };
        } catch (e) {
          debugPrint('No se pudo generar signedUrl para $path: $e');
          return null; // Ignorar este archivo si falla
        }
      }))).whereType<Map<String, dynamic>>().toList();

      notifyListeners();
    } catch (e) {
      debugPrint('Error al cargar fotos: $e');
    }
  }

  Future<void> subirFoto(ImageSource source) async {
    try {
      if (jardinId == null) {
        debugPrint('Error: jardinId es null');
        return;
      }

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source, imageQuality: 70);
      if (pickedFile == null) {
        debugPrint('No se seleccionó ninguna imagen');
        return;
      }

      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        debugPrint('Usuario no autenticado');
        return;
      }

      final uuid = const Uuid().v4();
      final path = '${user.id}/$jardinId/$uuid.jpg';

      final storage = Supabase.instance.client.storage.from('progresoplantas');

      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        await storage.uploadBinary(path, bytes);
      } else {
        final file = File(pickedFile.path);
        await storage.upload(path, file);
      }

      await Supabase.instance.client.from('imagenes_progreso').insert({
        'id_jardin': jardinId,
        'imagen_url': path,
        'fecha_subida': DateTime.now().toIso8601String(),
      });

      // 👇 Esperamos 1 segundo antes de recargar para evitar "Object not found"
      await Future.delayed(const Duration(seconds: 1));
      await cargarFotos(jardinId!);
    } catch (e) {
      debugPrint('Error al subir imagen: $e');
    }
  }

  Future<bool> eliminarFoto(String path) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return false;

      final storage = Supabase.instance.client.storage.from('progresoplantas');
      await storage.remove([path]);

      await Supabase.instance.client
          .from('imagenes_progreso')
          .delete()
          .eq('imagen_url', path);

      await cargarFotos(jardinId!);
      return true;
    } catch (e) {
      debugPrint('Error al eliminar imagen: $e');
      return false;
    }
  }
}
