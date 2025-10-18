class Marca {
  final int marcaId;
  final String nombre;
  final bool activo;

  Marca({
    required this.marcaId,
    required this.nombre,
    required this.activo,
  });

  factory Marca.fromJson(Map<String, dynamic> json) {
    return Marca(
      marcaId: json['marcaId'],
      nombre: json['nombre'],
      activo: json['activo'],
    );
  }
}
