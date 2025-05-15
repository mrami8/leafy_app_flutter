// Clase que representa a un usuario registrado en la aplicación
class Usuario {
  // Atributos del usuario
  final String id;           // ID único del usuario (UUID de Supabase)
  final String nombre;       // Nombre completo del usuario
  final String email;        // Correo electrónico
  final String fotoPerfil;   // URL de la imagen de perfil
  final String telefono;     // Número de teléfono (opcional)

  // Constructor principal con todos los campos requeridos
  Usuario({
    required this.id,
    required this.nombre,
    required this.email,
    required this.fotoPerfil,
    required this.telefono,
  });

  // Crea un objeto Usuario a partir de un Map (ej. obtenido desde Supabase)
  factory Usuario.fromMap(Map<String, dynamic> data) {
    return Usuario(
      id: data['id'],                                 // ID del usuario
      nombre: data['nombre'],                         // Nombre
      email: data['email'],                           // Email
      fotoPerfil: data['foto_perfil'] ?? '',          // Imagen de perfil (por defecto vacío)
      telefono: data['telefono'] ?? '',               // Teléfono (por defecto vacío)
    );
  }

  // Convierte un objeto Usuario a un Map para enviarlo a Supabase o guardar localmente
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'foto_perfil': fotoPerfil,
      'telefono': telefono,
    };
  }
}
