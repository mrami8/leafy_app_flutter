class Plant {
  final String id;
  final String nombre;
  final String nombreCientifico;
  final String descripcion;
  final List<String> imagenes;
  final String imagenPrincipal;

  Plant({
    required this.id,
    required this.nombre,
    required this.nombreCientifico,
    required this.descripcion,
    required this.imagenes,
    required this.imagenPrincipal,
  });

  factory Plant.fromMap(Map<String, dynamic> map) {
    return Plant(
      id: map['id'],
      nombre: map['nombre'],
      nombreCientifico: map['nombre_cientifico'],
      descripcion: map['descripcion'],
      imagenes: List<String>.from(map['imagenes'] ?? []),
      imagenPrincipal: map['imagen_principal'] ?? '', // o podrías usar el primero de imagenes
    );
  }

  String get imagenUrl {
    return imagenPrincipal.isNotEmpty ? imagenPrincipal : (imagenes.isNotEmpty ? imagenes.first : '');
  }
}
