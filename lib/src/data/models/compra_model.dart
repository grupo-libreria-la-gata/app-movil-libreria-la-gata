import 'base_model.dart';

/// Modelo para representar una compra
class CompraModel extends BaseModel {
  final int compraId;
  final int proveedorId;
  final String proveedorNombre;
  final String? proveedorTelefono;
  final String? proveedorEmail;
  final int usuarioId;
  final String usuarioNombre;
  final double total;
  final String? observaciones;
  final DateTime fechaCompra;
  final bool activo;
  final List<DetalleCompraModel> detalles;

  CompraModel({
    required this.compraId,
    required this.proveedorId,
    required this.proveedorNombre,
    this.proveedorTelefono,
    this.proveedorEmail,
    required this.usuarioId,
    required this.usuarioNombre,
    required this.total,
    this.observaciones,
    required this.fechaCompra,
    required this.activo,
    this.detalles = const [],
  });

  @override
  String get id => compraId.toString();

  @override
  DateTime get createdAt => fechaCompra;

  @override
  DateTime? get updatedAt => null;

  @override
  bool get isValid => compraId > 0 && proveedorId > 0 && usuarioId > 0 && total > 0;

  @override
  Map<String, dynamic> toMap() {
    return {
      'compraId': compraId,
      'proveedorId': proveedorId,
      'proveedorNombre': proveedorNombre,
      'proveedorTelefono': proveedorTelefono,
      'proveedorEmail': proveedorEmail,
      'usuarioId': usuarioId,
      'usuarioNombre': usuarioNombre,
      'total': total,
      'observaciones': observaciones,
      'fechaCompra': fechaCompra.toIso8601String(),
      'activo': activo,
      'detalles': detalles.map((detalle) => detalle.toMap()).toList(),
    };
  }

  factory CompraModel.fromMap(Map<String, dynamic> map) {
    return CompraModel(
      compraId: map['compraId']?.toInt() ?? 0,
      proveedorId: map['proveedorId']?.toInt() ?? 0,
      proveedorNombre: map['proveedorNombre'] ?? '',
      proveedorTelefono: map['proveedorTelefono'],
      proveedorEmail: map['proveedorEmail'],
      usuarioId: map['usuarioId']?.toInt() ?? 0,
      usuarioNombre: map['usuarioNombre'] ?? '',
      total: (map['total'] ?? 0.0).toDouble(),
      observaciones: map['observaciones'],
      fechaCompra: DateTime.parse(map['fechaCompra'] ?? DateTime.now().toIso8601String()),
      activo: map['activo'] ?? true,
      detalles: (map['detalles'] as List<dynamic>?)
          ?.map((detalle) => DetalleCompraModel.fromMap(detalle as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  factory CompraModel.fromJson(Map<String, dynamic> json) => CompraModel.fromMap(json);

  CompraModel copyWith({
    int? compraId,
    int? proveedorId,
    String? proveedorNombre,
    String? proveedorTelefono,
    String? proveedorEmail,
    int? usuarioId,
    String? usuarioNombre,
    double? total,
    String? observaciones,
    DateTime? fechaCompra,
    bool? activo,
    List<DetalleCompraModel>? detalles,
  }) {
    return CompraModel(
      compraId: compraId ?? this.compraId,
      proveedorId: proveedorId ?? this.proveedorId,
      proveedorNombre: proveedorNombre ?? this.proveedorNombre,
      proveedorTelefono: proveedorTelefono ?? this.proveedorTelefono,
      proveedorEmail: proveedorEmail ?? this.proveedorEmail,
      usuarioId: usuarioId ?? this.usuarioId,
      usuarioNombre: usuarioNombre ?? this.usuarioNombre,
      total: total ?? this.total,
      observaciones: observaciones ?? this.observaciones,
      fechaCompra: fechaCompra ?? this.fechaCompra,
      activo: activo ?? this.activo,
      detalles: detalles ?? this.detalles,
    );
  }

  @override
  String toString() {
    return 'CompraModel(compraId: $compraId, proveedorNombre: $proveedorNombre, total: $total, fechaCompra: $fechaCompra)';
  }
}

/// Modelo para representar el detalle de una compra
class DetalleCompraModel extends BaseModel {
  final int detalleCompraId;
  final int detalleProductoId;
  final String productoNombre;
  final String categoriaNombre;
  final String marcaNombre;
  final String? codigoBarra;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;

  DetalleCompraModel({
    required this.detalleCompraId,
    required this.detalleProductoId,
    required this.productoNombre,
    required this.categoriaNombre,
    required this.marcaNombre,
    this.codigoBarra,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
  });

  @override
  String get id => detalleCompraId.toString();

  @override
  DateTime get createdAt => DateTime.now();

  @override
  DateTime? get updatedAt => null;

  @override
  bool get isValid => detalleCompraId > 0 && detalleProductoId > 0 && cantidad > 0 && precioUnitario > 0;

  @override
  Map<String, dynamic> toMap() {
    return {
      'detalleCompraId': detalleCompraId,
      'detalleProductoId': detalleProductoId,
      'productoNombre': productoNombre,
      'categoriaNombre': categoriaNombre,
      'marcaNombre': marcaNombre,
      'codigoBarra': codigoBarra,
      'cantidad': cantidad,
      'precioUnitario': precioUnitario,
      'subtotal': subtotal,
    };
  }

  factory DetalleCompraModel.fromMap(Map<String, dynamic> map) {
    return DetalleCompraModel(
      detalleCompraId: map['detalleCompraId']?.toInt() ?? 0,
      detalleProductoId: map['detalleProductoId']?.toInt() ?? 0,
      productoNombre: map['productoNombre'] ?? '',
      categoriaNombre: map['categoriaNombre'] ?? '',
      marcaNombre: map['marcaNombre'] ?? '',
      codigoBarra: map['codigoBarra'],
      cantidad: map['cantidad']?.toInt() ?? 0,
      precioUnitario: (map['precioUnitario'] ?? 0.0).toDouble(),
      subtotal: (map['subtotal'] ?? 0.0).toDouble(),
    );
  }

  factory DetalleCompraModel.fromJson(Map<String, dynamic> json) => DetalleCompraModel.fromMap(json);

  DetalleCompraModel copyWith({
    int? detalleCompraId,
    int? detalleProductoId,
    String? productoNombre,
    String? categoriaNombre,
    String? marcaNombre,
    String? codigoBarra,
    int? cantidad,
    double? precioUnitario,
    double? subtotal,
  }) {
    return DetalleCompraModel(
      detalleCompraId: detalleCompraId ?? this.detalleCompraId,
      detalleProductoId: detalleProductoId ?? this.detalleProductoId,
      productoNombre: productoNombre ?? this.productoNombre,
      categoriaNombre: categoriaNombre ?? this.categoriaNombre,
      marcaNombre: marcaNombre ?? this.marcaNombre,
      codigoBarra: codigoBarra ?? this.codigoBarra,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      subtotal: subtotal ?? this.subtotal,
    );
  }

  @override
  String toString() {
    return 'DetalleCompraModel(detalleCompraId: $detalleCompraId, productoNombre: $productoNombre, cantidad: $cantidad, subtotal: $subtotal)';
  }
}

/// Modelo para crear una nueva compra
class CrearCompraRequest {
  final int proveedorId;
  final int usuarioId;
  final double total;
  final String? observaciones;
  final List<CrearDetalleCompraRequest> detalles;

  const CrearCompraRequest({
    required this.proveedorId,
    required this.usuarioId,
    required this.total,
    this.observaciones,
    required this.detalles,
  });

  Map<String, dynamic> toMap() {
    return {
      'proveedorId': proveedorId,
      'usuarioId': usuarioId,
      'total': total,
      'observaciones': observaciones,
      'detalles': detalles.map((detalle) => detalle.toMap()).toList(),
    };
  }

  factory CrearCompraRequest.fromMap(Map<String, dynamic> map) {
    return CrearCompraRequest(
      proveedorId: map['proveedorId']?.toInt() ?? 0,
      usuarioId: map['usuarioId']?.toInt() ?? 0,
      total: (map['total'] ?? 0.0).toDouble(),
      observaciones: map['observaciones'],
      detalles: (map['detalles'] as List<dynamic>?)
          ?.map((detalle) => CrearDetalleCompraRequest.fromMap(detalle as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  factory CrearCompraRequest.fromJson(Map<String, dynamic> json) => CrearCompraRequest.fromMap(json);
}

/// Modelo para crear detalle de compra
class CrearDetalleCompraRequest {
  final int detalleProductoId;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;

  const CrearDetalleCompraRequest({
    required this.detalleProductoId,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
  });

  Map<String, dynamic> toMap() {
    return {
      'detalleProductoId': detalleProductoId,
      'cantidad': cantidad,
      'precioUnitario': precioUnitario,
      'subtotal': subtotal,
    };
  }

  factory CrearDetalleCompraRequest.fromMap(Map<String, dynamic> map) {
    return CrearDetalleCompraRequest(
      detalleProductoId: map['detalleProductoId']?.toInt() ?? 0,
      cantidad: map['cantidad']?.toInt() ?? 0,
      precioUnitario: (map['precioUnitario'] ?? 0.0).toDouble(),
      subtotal: (map['subtotal'] ?? 0.0).toDouble(),
    );
  }

  factory CrearDetalleCompraRequest.fromJson(Map<String, dynamic> json) => CrearDetalleCompraRequest.fromMap(json);
}

/// Modelo para listar compras
class CompraListModel {
  final int compraId;
  final int proveedorId;
  final String proveedorNombre;
  final int usuarioId;
  final String usuarioNombre;
  final double total;
  final String? observaciones;
  final DateTime fechaCompra;
  final bool activo;
  final int totalItems;

  const CompraListModel({
    required this.compraId,
    required this.proveedorId,
    required this.proveedorNombre,
    required this.usuarioId,
    required this.usuarioNombre,
    required this.total,
    this.observaciones,
    required this.fechaCompra,
    required this.activo,
    required this.totalItems,
  });

  Map<String, dynamic> toMap() {
    return {
      'compraId': compraId,
      'proveedorId': proveedorId,
      'proveedorNombre': proveedorNombre,
      'usuarioId': usuarioId,
      'usuarioNombre': usuarioNombre,
      'total': total,
      'observaciones': observaciones,
      'fechaCompra': fechaCompra.toIso8601String(),
      'activo': activo,
      'totalItems': totalItems,
    };
  }

  factory CompraListModel.fromMap(Map<String, dynamic> map) {
    return CompraListModel(
      compraId: map['compraId']?.toInt() ?? 0,
      proveedorId: map['proveedorId']?.toInt() ?? 0,
      proveedorNombre: map['proveedorNombre'] ?? '',
      usuarioId: map['usuarioId']?.toInt() ?? 0,
      usuarioNombre: map['usuarioNombre'] ?? '',
      total: (map['total'] ?? 0.0).toDouble(),
      observaciones: map['observaciones'],
      fechaCompra: DateTime.parse(map['fechaCompra'] ?? DateTime.now().toIso8601String()),
      activo: map['activo'] ?? true,
      totalItems: map['totalItems']?.toInt() ?? 0,
    );
  }

  factory CompraListModel.fromJson(Map<String, dynamic> json) => CompraListModel.fromMap(json);
}

/// Modelo para filtros de compras
class CompraFiltrosRequest {
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final int? proveedorId;
  final int? usuarioId;
  final bool? activo;

  const CompraFiltrosRequest({
    this.fechaInicio,
    this.fechaFin,
    this.proveedorId,
    this.usuarioId,
    this.activo,
  });

  Map<String, dynamic> toMap() {
    return {
      'fechaInicio': fechaInicio?.toIso8601String(),
      'fechaFin': fechaFin?.toIso8601String(),
      'proveedorId': proveedorId,
      'usuarioId': usuarioId,
      'activo': activo,
    };
  }

  factory CompraFiltrosRequest.fromMap(Map<String, dynamic> map) {
    return CompraFiltrosRequest(
      fechaInicio: map['fechaInicio'] != null ? DateTime.parse(map['fechaInicio']) : null,
      fechaFin: map['fechaFin'] != null ? DateTime.parse(map['fechaFin']) : null,
      proveedorId: map['proveedorId']?.toInt(),
      usuarioId: map['usuarioId']?.toInt(),
      activo: map['activo'],
    );
  }

  factory CompraFiltrosRequest.fromJson(Map<String, dynamic> json) => CompraFiltrosRequest.fromMap(json);
}

/// Modelo para resumen de compras
class CompraResumenModel {
  final int totalCompras;
  final double totalMonto;
  final double promedioCompra;
  final double compraMinima;
  final double compraMaxima;

  const CompraResumenModel({
    required this.totalCompras,
    required this.totalMonto,
    required this.promedioCompra,
    required this.compraMinima,
    required this.compraMaxima,
  });

  Map<String, dynamic> toMap() {
    return {
      'totalCompras': totalCompras,
      'totalMonto': totalMonto,
      'promedioCompra': promedioCompra,
      'compraMinima': compraMinima,
      'compraMaxima': compraMaxima,
    };
  }

  factory CompraResumenModel.fromMap(Map<String, dynamic> map) {
    return CompraResumenModel(
      totalCompras: map['totalCompras']?.toInt() ?? 0,
      totalMonto: (map['totalMonto'] ?? 0.0).toDouble(),
      promedioCompra: (map['promedioCompra'] ?? 0.0).toDouble(),
      compraMinima: (map['compraMinima'] ?? 0.0).toDouble(),
      compraMaxima: (map['compraMaxima'] ?? 0.0).toDouble(),
    );
  }

  factory CompraResumenModel.fromJson(Map<String, dynamic> json) => CompraResumenModel.fromMap(json);
}

/// Modelo para top productos comprados
class TopProductoCompradoModel {
  final String productoNombre;
  final String marcaNombre;
  final String categoriaNombre;
  final int totalCantidad;
  final double totalMonto;
  final int vecesComprado;

  const TopProductoCompradoModel({
    required this.productoNombre,
    required this.marcaNombre,
    required this.categoriaNombre,
    required this.totalCantidad,
    required this.totalMonto,
    required this.vecesComprado,
  });

  Map<String, dynamic> toMap() {
    return {
      'productoNombre': productoNombre,
      'marcaNombre': marcaNombre,
      'categoriaNombre': categoriaNombre,
      'totalCantidad': totalCantidad,
      'totalMonto': totalMonto,
      'vecesComprado': vecesComprado,
    };
  }

  factory TopProductoCompradoModel.fromMap(Map<String, dynamic> map) {
    return TopProductoCompradoModel(
      productoNombre: map['productoNombre'] ?? '',
      marcaNombre: map['marcaNombre'] ?? '',
      categoriaNombre: map['categoriaNombre'] ?? '',
      totalCantidad: map['totalCantidad']?.toInt() ?? 0,
      totalMonto: (map['totalMonto'] ?? 0.0).toDouble(),
      vecesComprado: map['vecesComprado']?.toInt() ?? 0,
    );
  }

  factory TopProductoCompradoModel.fromJson(Map<String, dynamic> json) => TopProductoCompradoModel.fromMap(json);
}

/// Modelo para anular compra
class AnularCompraRequest {
  final int compraId;
  final int usuarioId;

  const AnularCompraRequest({
    required this.compraId,
    required this.usuarioId,
  });

  Map<String, dynamic> toMap() {
    return {
      'compraId': compraId,
      'usuarioId': usuarioId,
    };
  }

  factory AnularCompraRequest.fromMap(Map<String, dynamic> map) {
    return AnularCompraRequest(
      compraId: map['compraId']?.toInt() ?? 0,
      usuarioId: map['usuarioId']?.toInt() ?? 0,
    );
  }

  factory AnularCompraRequest.fromJson(Map<String, dynamic> json) => AnularCompraRequest.fromMap(json);
}
