class DetalleProducto {
  final int detalleProductoId;
  final String producto;
  final String categoria;
  final String marca;
  final String codigoBarra;
  final double costo;
  final double precio;
  final int stock;
  final DateTime fechaCreacion;

  const DetalleProducto({
    required this.detalleProductoId,
    required this.producto,
    required this.categoria,
    required this.marca,
    required this.codigoBarra,
    required this.costo,
    required this.precio,
    required this.stock,
    required this.fechaCreacion,
  });

  factory DetalleProducto.fromJson(Map<String, dynamic> json) {
    return DetalleProducto(
      detalleProductoId: json['detalleProductoId'] ?? 0,
      producto: json['producto'] ?? '',
      categoria: json['categoria'] ?? '',
      marca: json['marca'] ?? '',
      codigoBarra: json['codigoBarra'] ?? '',
      costo: (json['costo'] ?? 0.0).toDouble(),
      precio: (json['precio'] ?? 0.0).toDouble(),
      stock: json['stock'] ?? 0,
      fechaCreacion: DateTime.parse(json['fechaCreacion'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'detalleProductoId': detalleProductoId,
      'producto': producto,
      'categoria': categoria,
      'marca': marca,
      'codigoBarra': codigoBarra,
      'costo': costo,
      'precio': precio,
      'stock': stock,
      'fechaCreacion': fechaCreacion.toIso8601String(),
    };
  }

  // Propiedades calculadas
  bool get isLowStock => stock <= 5; // Consideramos stock bajo si es <= 5
  bool get isOutOfStock => stock == 0;
  bool get isAvailable => stock > 5;

  String get stockStatus {
    if (isOutOfStock) return 'Agotado';
    if (isLowStock) return 'Stock Bajo';
    return 'Disponible';
  }

  DetalleProducto copyWith({
    int? detalleProductoId,
    String? producto,
    String? categoria,
    String? marca,
    String? codigoBarra,
    double? costo,
    double? precio,
    int? stock,
    DateTime? fechaCreacion,
  }) {
    return DetalleProducto(
      detalleProductoId: detalleProductoId ?? this.detalleProductoId,
      producto: producto ?? this.producto,
      categoria: categoria ?? this.categoria,
      marca: marca ?? this.marca,
      codigoBarra: codigoBarra ?? this.codigoBarra,
      costo: costo ?? this.costo,
      precio: precio ?? this.precio,
      stock: stock ?? this.stock,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }
}