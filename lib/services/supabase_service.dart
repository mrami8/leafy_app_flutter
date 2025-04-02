import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient supabase = Supabase.instance.client;

  // Obtener todas las plantas de la wiki
  Future<List<Map<String, dynamic>>> getPlantas() async {
    final response = await supabase.from('plantas').select();
    return response;
  }
}
