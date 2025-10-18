class Categoria {
  final int categoriaId;
  final String nombre;
  final bool activo;

  Categoria({
    required this.categoriaId,
    required this.nombre,
    required this.activo,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      categoriaId: json['categoriaId'],
      nombre: json['nombre'],
      activo: json['activo'],
    );
  }
}
