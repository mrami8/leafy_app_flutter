class Plant {
  final String id;
  final String nombre;
  final String nombreCientifico;
  final String descripcion;
  final String imagenPrincipal; // Puede ser la primera imagen de `imagenes` o la imagen principal de la base de datos.

  Plant({
    required this.id,
    required this.nombre,
    required this.nombreCientifico,
    required this.descripcion,
    required this.imagenPrincipal,
  });

  // Convierte un mapa a un objeto Plant
  factory Plant.fromMap(Map<String, dynamic> map) {
    return Plant(
      id: map['id'],
      nombre: map['nombre'],
      nombreCientifico: map['nombre_cientifico'],
      descripcion: map['descripcion'],
      imagenPrincipal: map['imagen_principal'] ?? map['imagenes'][0], // Toma la primera imagen si no hay imagen principal
    );
  }
}
