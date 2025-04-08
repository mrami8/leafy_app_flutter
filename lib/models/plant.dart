class Plant {
  final String id;
  final String nombre;
  final String nombreCientifico;
  final String descripcion;
  final List<String> imagenes;
  final String imagenPrincipal;
  final String cuidados;
  final String riego;
  final String luz;
  final String temperatura;
  final String sustrato;

  Plant({
    required this.id,
    required this.nombre,
    required this.nombreCientifico,
    required this.descripcion,
    required this.imagenes,
    required this.imagenPrincipal,
    required this.cuidados,
    required this.riego,
    required this.luz,
    required this.temperatura,
    required this.sustrato,
  });

  // Método existente para mapear todos los campos
  factory Plant.fromMap(Map<String, dynamic> map) {
    return Plant(
      id: map['id'],
      nombre: map['nombre'],
      nombreCientifico: map['nombre_cientifico'],
      descripcion: map['descripcion'],
      imagenes: List<String>.from(map['imagenes'] ?? []),
      imagenPrincipal: map['imagen_principal'] ?? '',
      cuidados: map['cuidados'] ?? '',
      riego: map['riego'] ?? '',
      luz: map['luz'] ?? '',
      temperatura: map['temperatura'] ?? '',
      sustrato: map['sustrato'] ?? '',
    );
  }

  // Nuevo método para mapear solo los campos necesarios para la búsqueda
  factory Plant.fromSearchMap(Map<String, dynamic> map) {
    return Plant(
      id: map['id'],
      nombre: map['nombre'],
      nombreCientifico: map['nombre_cientifico'],
      descripcion: '',
      imagenes: [],
      imagenPrincipal: map['imagen_principal'] ?? '',
      cuidados: '',
      riego: '',
      luz: '',
      temperatura: '',
      sustrato: '',
    );
  }
}
