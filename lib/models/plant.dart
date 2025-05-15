// Clase que representa una planta con todos sus atributos detallados
class Plant {
  // Atributos principales de la planta
  final String id;                     // Identificador único
  final String nombre;                // Nombre común de la planta
  final String nombreCientifico;     // Nombre científico
  final String descripcion;          // Descripción general

  // Imagen principal y lista de imágenes adicionales
  final List<String> imagenes;       // Lista de URLs de imágenes
  final String imagenPrincipal;      // URL de la imagen destacada

  // Requisitos de cuidado
  final String riego;                // Frecuencia y tipo de riego
  final String luz;                  // Requerimiento de luz
  final String temperatura;          // Temperatura ideal
  final String humedad;              // Nivel de humedad requerido
  final String tipoSustrato;         // Tipo de sustrato recomendado
  final String frecuenciaAbono;      // Frecuencia de abonado

  // Posibles problemas y cuidados
  final String plagasComunes;        // Plagas comunes que puede sufrir
  final String cuidadosEspeciales;   // Cuidados adicionales o especiales
  final String toxicidad;            // Nivel de toxicidad para humanos o mascotas

  // Información adicional
  final String floracion;            // Época de floración
  final String usoRecomendado;       // Uso decorativo, medicinal, etc.

  // Constructor principal con todos los campos requeridos
  Plant({
    required this.id,
    required this.nombre,
    required this.nombreCientifico,
    required this.descripcion,
    required this.imagenes,
    required this.imagenPrincipal,
    required this.riego,
    required this.luz,
    required this.temperatura,
    required this.humedad,
    required this.tipoSustrato,
    required this.frecuenciaAbono,
    required this.plagasComunes,
    required this.cuidadosEspeciales,
    required this.toxicidad,
    required this.floracion,
    required this.usoRecomendado,
  });

  // Constructor para crear una planta a partir de un Map (por ejemplo, desde Supabase)
  factory Plant.fromMap(Map<String, dynamic> map) {
    return Plant(
      id: map['id'],
      nombre: map['nombre'],
      nombreCientifico: map['nombre_cientifico'],
      descripcion: map['descripcion'] ?? 'Descripción no disponible',
      imagenes: List<String>.from(map['imagenes'] ?? []),
      imagenPrincipal: map['imagen_principal'] ?? '',
      riego: map['riego'] ?? 'Riego no disponible',
      luz: map['luz'] ?? 'Luz no disponible',
      temperatura: map['temperatura'] ?? 'Temperatura no disponible',
      humedad: map['humedad'] ?? 'Humedad no disponible',
      tipoSustrato: map['tipo_sustrato'] ?? 'Tipo de sustrato no disponible',
      frecuenciaAbono: map['frecuencia_abono'] ?? 'Frecuencia de abono no disponible',
      plagasComunes: map['plagas_comunes'] ?? 'Plagas comunes no disponibles',
      cuidadosEspeciales: map['cuidados_especiales'] ?? 'Cuidados especiales no disponibles',
      toxicidad: map['toxicidad'] ?? 'Toxicidad no disponible',
      floracion: map['floracion'] ?? 'Floración no disponible',
      usoRecomendado: map['uso_recomendado'] ?? 'Uso recomendado no disponible',
    );
  }

  // Constructor alternativo para búsquedas o cargas parciales (idéntico aquí, pero puedes personalizarlo)
  factory Plant.fromSearchMap(Map<String, dynamic> map) {
    return Plant(
      id: map['id'],
      nombre: map['nombre'],
      nombreCientifico: map['nombre_cientifico'],
      descripcion: map['descripcion'] ?? 'Descripción no disponible',
      imagenes: List<String>.from(map['imagenes'] ?? []),
      imagenPrincipal: map['imagen_principal'] ?? '',
      riego: map['riego'] ?? 'Riego no disponible',
      luz: map['luz'] ?? 'Luz no disponible',
      temperatura: map['temperatura'] ?? 'Temperatura no disponible',
      humedad: map['humedad'] ?? 'Humedad no disponible',
      tipoSustrato: map['tipo_sustrato'] ?? 'Tipo de sustrato no disponible',
      frecuenciaAbono: map['frecuencia_abono'] ?? 'Frecuencia de abono no disponible',
      plagasComunes: map['plagas_comunes'] ?? 'Plagas comunes no disponibles',
      cuidadosEspeciales: map['cuidados_especiales'] ?? 'Cuidados especiales no disponibles',
      toxicidad: map['toxicidad'] ?? 'Toxicidad no disponible',
      floracion: map['floracion'] ?? 'Floración no disponible',
      usoRecomendado: map['uso_recomendado'] ?? 'Uso recomendado no disponible',
    );
  }
}
