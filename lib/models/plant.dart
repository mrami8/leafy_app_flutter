class Plant {
  final String id; // ID de tipo String (UUID)
  final String nombre;
  final String nombreCientifico;
  final String descripcion;
  final List<String> imagenes;

  Plant({
    required this.id,
    required this.nombre,
    required this.nombreCientifico,
    required this.descripcion,
    required this.imagenes,
  });

  factory Plant.fromMap(Map<String, dynamic> map) {
    return Plant(
      id: map['id'], // Aquí tomamos el UUID como String
      nombre: map['nombre'],
      nombreCientifico: map['nombre_cientifico'],
      descripcion: map['descripcion'],
      imagenes: List<String>.from(map['imagenes'] ?? []), // Aseguramos que sea una lista
    );
  }
}
