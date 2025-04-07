class Plant {
  final String id;
  final String nombre;
  final String nombreCientifico;
  final String descripcion;
  final String imagenUrl; // Aquí almacenamos la URL de la imagen

  Plant({
    required this.id,
    required this.nombre,
    required this.nombreCientifico,
    required this.descripcion,
    required this.imagenUrl, // Nueva propiedad
  });

  factory Plant.fromMap(Map<String, dynamic> map, String imageUrl) {
    return Plant(
      id: map['id'],
      nombre: map['nombre'],
      nombreCientifico: map['nombre_cientifico'],
      descripcion: map['descripcion'],
      imagenUrl: imageUrl, // Usamos la imagen proporcionada
    );
  }
}
