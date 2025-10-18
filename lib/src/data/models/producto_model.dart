class Producto {
  final int productoId;
  final String nombre;
  final bool activo;

  Producto({
    required this.productoId,
    required this.nombre,
    required this.activo,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      productoId: json['productoId'],
      nombre: json['nombre'],
      activo: json['activo'],
    );
  }
}
