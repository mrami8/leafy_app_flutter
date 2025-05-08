class Usuario {
  final String id;
  final String nombre;
  final String email;
  final String fotoPerfil;
  final String telefono;

  Usuario({
    required this.id,
    required this.nombre,
    required this.email,
    required this.fotoPerfil,
    required this.telefono,
  });

  factory Usuario.fromMap(Map<String, dynamic> data) {
    return Usuario(
      id: data['id'],
      nombre: data['nombre'],
      email: data['email'],
      fotoPerfil: data['foto_perfil'] ?? '',
      telefono: data['telefono'] ?? '',
    );
  }

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
