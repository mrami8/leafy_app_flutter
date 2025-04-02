import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://pxrtpyuvhfjfhvlmdbdb.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB4cnRweXV2aGZqZmh2bG1kYmRiIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0MzYwNDkzNCwiZXhwIjoyMDU5MTgwOTM0fQ.wWBZBMIXntAcx8BY3KKHLN7K-yXv035-s3d1bWZruXU';

  static Future<void> init() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static Future<List<Map<String, dynamic>>> getUsuarios() async {
    final client = Supabase.instance.client;
    final response = await client.from('usuarios').select();
    return response;
  }
}
