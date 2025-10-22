import 'base_model.dart';

/// Modelo para representar una venta
class VentaModel extends BaseModel {
  final int ventaId;
  final int clienteId;
  final String clienteNombre;
  final String? clienteTelefono;
  final String? clienteEmail;
  final String? clienteDireccion;
  final int usuarioId;
  final String usuarioNombre;
  final String metodoPago;
  final double total;
  final String? observaciones;
  final DateTime fecha;
  final bool activo;
  final List<VentaDetalleModel> detalles;

  VentaModel({
    required this.ventaId,
    required this.clienteId,
    required this.clienteNombre,
    this.clienteTelefono,
    this.clienteEmail,
    this.clienteDireccion,
    required this.usuarioId,
    required this.usuarioNombre,
    required this.metodoPago,
    required this.total,
    this.observaciones,
    required this.fecha,
    required this.activo,
    this.detalles = const [],
  });

  @override
  String get id => ventaId.toString();

  @override
  DateTime get createdAt => fecha;

  @override
  DateTime? get updatedAt => null;

  @override
  bool get isValid =>
      ventaId > 0 && clienteId > 0 && usuarioId > 0 && total > 0;

  @override
  Map<String, dynamic> toMap() {
    return {
      'ventaId': ventaId,
      'clienteId': clienteId,
      'clienteNombre': clienteNombre,
      'clienteTelefono': clienteTelefono,
      'clienteEmail': clienteEmail,
      'clienteDireccion': clienteDireccion,
      'usuarioId': usuarioId,
      'usuarioNombre': usuarioNombre,
      'metodoPago': metodoPago,
      'total': total,
      'observaciones': observaciones,
      'fecha': fecha.toIso8601String(),
      'activo': activo,
      'detalles': detalles.map((detalle) => detalle.toMap()).toList(),
    };
  }

  factory VentaModel.fromMap(Map<String, dynamic> map) {
    return VentaModel(
      ventaId: map['ventaId']?.toInt() ?? 0,
      clienteId: map['clienteId']?.toInt() ?? 0,
      clienteNombre: map['clienteNombre'] ?? '',
      clienteTelefono: map['clienteTelefono'],
      clienteEmail: map['clienteEmail'],
      clienteDireccion: map['clienteDireccion'],
      usuarioId: map['usuarioId']?.toInt() ?? 0,
      usuarioNombre: map['usuarioNombre'] ?? '',
      metodoPago: map['metodoPago'] ?? 'Efectivo',
      total: (map['total'] ?? 0.0).toDouble(),
      observaciones: map['observaciones'],
      fecha: DateTime.parse(map['fecha'] ?? DateTime.now().toIso8601String()),
      activo: map['activo'] ?? true,
      detalles:
          (map['detalles'] as List<dynamic>?)
              ?.map(
                (detalle) =>
                    VentaDetalleModel.fromMap(detalle as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  factory VentaModel.fromJson(Map<String, dynamic> json) =>
      VentaModel.fromMap(json);

  VentaModel copyWith({
    int? ventaId,
    int? clienteId,
    String? clienteNombre,
    String? clienteTelefono,
    String? clienteEmail,
    String? clienteDireccion,
    int? usuarioId,
    String? usuarioNombre,
    String? metodoPago,
    double? total,
    String? observaciones,
    DateTime? fecha,
    bool? activo,
    List<VentaDetalleModel>? detalles,
  }) {
    return VentaModel(
      ventaId: ventaId ?? this.ventaId,
      clienteId: clienteId ?? this.clienteId,
      clienteNombre: clienteNombre ?? this.clienteNombre,
      clienteTelefono: clienteTelefono ?? this.clienteTelefono,
      clienteEmail: clienteEmail ?? this.clienteEmail,
      clienteDireccion: clienteDireccion ?? this.clienteDireccion,
      usuarioId: usuarioId ?? this.usuarioId,
      usuarioNombre: usuarioNombre ?? this.usuarioNombre,
      metodoPago: metodoPago ?? this.metodoPago,
      total: total ?? this.total,
      observaciones: observaciones ?? this.observaciones,
      fecha: fecha ?? this.fecha,
      activo: activo ?? this.activo,
      detalles: detalles ?? this.detalles,
    );
  }

  @override
  String toString() {
    return 'VentaModel(ventaId: $ventaId, clienteNombre: $clienteNombre, total: $total, fecha: $fecha)';
  }
}

/// Modelo para representar el detalle de una venta
class VentaDetalleModel extends BaseModel {
  final int ventaDetalleId;
  final int detalleProductoId;
  final String productoNombre;
  final String categoriaNombre;
  final String marcaNombre;
  final String? codigoBarra;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;

  VentaDetalleModel({
    required this.ventaDetalleId,
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
  String get id => ventaDetalleId.toString();

  @override
  DateTime get createdAt => DateTime.now();

  @override
  DateTime? get updatedAt => null;

  @override
  bool get isValid =>
      ventaDetalleId > 0 &&
      detalleProductoId > 0 &&
      cantidad > 0 &&
      precioUnitario > 0;

  @override
  Map<String, dynamic> toMap() {
    return {
      'ventaDetalleId': ventaDetalleId,
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

  factory VentaDetalleModel.fromMap(Map<String, dynamic> map) {
    return VentaDetalleModel(
      ventaDetalleId: map['ventaDetalleId']?.toInt() ?? 0,
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

  factory VentaDetalleModel.fromJson(Map<String, dynamic> json) =>
      VentaDetalleModel.fromMap(json);

  VentaDetalleModel copyWith({
    int? ventaDetalleId,
    int? detalleProductoId,
    String? productoNombre,
    String? categoriaNombre,
    String? marcaNombre,
    String? codigoBarra,
    int? cantidad,
    double? precioUnitario,
    double? subtotal,
  }) {
    return VentaDetalleModel(
      ventaDetalleId: ventaDetalleId ?? this.ventaDetalleId,
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
    return 'VentaDetalleModel(ventaDetalleId: $ventaDetalleId, productoNombre: $productoNombre, cantidad: $cantidad, subtotal: $subtotal)';
  }
}

/// Modelo para crear una nueva venta
class CrearVentaRequest {
  final int clienteId;
  final int usuarioId;
  final String metodoPago;
  final double total;
  final String? observaciones;
  final List<CrearVentaDetalleRequest> detalles;

  const CrearVentaRequest({
    required this.clienteId,
    required this.usuarioId,
    required this.metodoPago,
    required this.total,
    this.observaciones,
    required this.detalles,
  });

  Map<String, dynamic> toMap() {
    return {
      'clienteId': clienteId,
      'usuarioId': usuarioId,
      'metodoPago': metodoPago,
      'total': total,
      'observaciones': observaciones,
      'detalles': detalles.map((detalle) => detalle.toMap()).toList(),
    };
  }

  factory CrearVentaRequest.fromMap(Map<String, dynamic> map) {
    return CrearVentaRequest(
      clienteId: map['clienteId']?.toInt() ?? 0,
      usuarioId: map['usuarioId']?.toInt() ?? 0,
      metodoPago: map['metodoPago'] ?? 'Efectivo',
      total: (map['total'] ?? 0.0).toDouble(),
      observaciones: map['observaciones'],
      detalles:
          (map['detalles'] as List<dynamic>?)
              ?.map(
                (detalle) => CrearVentaDetalleRequest.fromMap(
                  detalle as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }

  factory CrearVentaRequest.fromJson(Map<String, dynamic> json) =>
      CrearVentaRequest.fromMap(json);
}

/// Modelo para crear detalle de venta
class CrearVentaDetalleRequest {
  final int detalleProductoId;
  final int cantidad;
  final double precioUnitario;
  final String? codigoBarra;

  const CrearVentaDetalleRequest({
    required this.detalleProductoId,
    required this.cantidad,
    required this.precioUnitario,
    this.codigoBarra,
  });

  Map<String, dynamic> toMap() {
    return {
      'detalleProductoId': detalleProductoId,
      'cantidad': cantidad,
      'precioUnitario': precioUnitario,
      'codigoBarra': codigoBarra,
    };
  }

  factory CrearVentaDetalleRequest.fromMap(Map<String, dynamic> map) {
    return CrearVentaDetalleRequest(
      detalleProductoId: map['detalleProductoId']?.toInt() ?? 0,
      cantidad: map['cantidad']?.toInt() ?? 0,
      precioUnitario: (map['precioUnitario'] ?? 0.0).toDouble(),
      codigoBarra: map['codigoBarra'],
    );
  }

  factory CrearVentaDetalleRequest.fromJson(Map<String, dynamic> json) =>
      CrearVentaDetalleRequest.fromMap(json);
}

/// Modelo para listar ventas
class VentaListModel {
  final int ventaId;
  final int clienteId;
  final String clienteNombre;
  final int usuarioId;
  final String usuarioNombre;
  final String metodoPago;
  final double total;
  final String? observaciones;
  final DateTime fecha;
  final bool activo;
  final int totalItems;

  const VentaListModel({
    required this.ventaId,
    required this.clienteId,
    required this.clienteNombre,
    required this.usuarioId,
    required this.usuarioNombre,
    required this.metodoPago,
    required this.total,
    this.observaciones,
    required this.fecha,
    required this.activo,
    required this.totalItems,
  });

  Map<String, dynamic> toMap() {
    return {
      'ventaId': ventaId,
      'clienteId': clienteId,
      'clienteNombre': clienteNombre,
      'usuarioId': usuarioId,
      'usuarioNombre': usuarioNombre,
      'metodoPago': metodoPago,
      'total': total,
      'observaciones': observaciones,
      'fecha': fecha.toIso8601String(),
      'activo': activo,
      'totalItems': totalItems,
    };
  }

  factory VentaListModel.fromMap(Map<String, dynamic> map) {
    return VentaListModel(
      ventaId: map['ventaId']?.toInt() ?? 0,
      clienteId: map['clienteId']?.toInt() ?? 0,
      clienteNombre: map['clienteNombre'] ?? '',
      usuarioId: map['usuarioId']?.toInt() ?? 0,
      usuarioNombre: map['usuarioNombre'] ?? '',
      metodoPago: map['metodoPago'] ?? 'Efectivo',
      total: (map['total'] ?? 0.0).toDouble(),
      observaciones: map['observaciones'],
      fecha: DateTime.parse(map['fecha'] ?? DateTime.now().toIso8601String()),
      activo: map['activo'] ?? true,
      totalItems: map['totalItems']?.toInt() ?? 0,
    );
  }

  factory VentaListModel.fromJson(Map<String, dynamic> json) =>
      VentaListModel.fromMap(json);
}

/// Modelo para filtros de ventas
class VentaFiltrosRequest {
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final int? clienteId;
  final int? usuarioId;
  final bool? activo;

  const VentaFiltrosRequest({
    this.fechaInicio,
    this.fechaFin,
    this.clienteId,
    this.usuarioId,
    this.activo,
  });

  Map<String, dynamic> toMap() {
    return {
      'fechaInicio': fechaInicio?.toIso8601String(),
      'fechaFin': fechaFin?.toIso8601String(),
      'clienteId': clienteId,
      'usuarioId': usuarioId,
      'activo': activo,
    };
  }

  factory VentaFiltrosRequest.fromMap(Map<String, dynamic> map) {
    return VentaFiltrosRequest(
      fechaInicio: map['fechaInicio'] != null
          ? DateTime.parse(map['fechaInicio'])
          : null,
      fechaFin: map['fechaFin'] != null
          ? DateTime.parse(map['fechaFin'])
          : null,
      clienteId: map['clienteId']?.toInt(),
      usuarioId: map['usuarioId']?.toInt(),
      activo: map['activo'],
    );
  }

  factory VentaFiltrosRequest.fromJson(Map<String, dynamic> json) =>
      VentaFiltrosRequest.fromMap(json);
}

/// Modelo para resumen de ventas
class VentaResumenModel {
  final int totalVentas;
  final double totalMonto;
  final double promedioVenta;
  final double ventaMinima;
  final double ventaMaxima;

  const VentaResumenModel({
    required this.totalVentas,
    required this.totalMonto,
    required this.promedioVenta,
    required this.ventaMinima,
    required this.ventaMaxima,
  });

  Map<String, dynamic> toMap() {
    return {
      'totalVentas': totalVentas,
      'totalMonto': totalMonto,
      'promedioVenta': promedioVenta,
      'ventaMinima': ventaMinima,
      'ventaMaxima': ventaMaxima,
    };
  }

  factory VentaResumenModel.fromMap(Map<String, dynamic> map) {
    return VentaResumenModel(
      totalVentas: map['totalVentas']?.toInt() ?? 0,
      totalMonto: (map['totalMonto'] ?? 0.0).toDouble(),
      promedioVenta: (map['promedioVenta'] ?? 0.0).toDouble(),
      ventaMinima: (map['ventaMinima'] ?? 0.0).toDouble(),
      ventaMaxima: (map['ventaMaxima'] ?? 0.0).toDouble(),
    );
  }

  factory VentaResumenModel.fromJson(Map<String, dynamic> json) =>
      VentaResumenModel.fromMap(json);
}

/// Modelo para top productos vendidos
class TopProductoVendidoModel {
  final String productoNombre;
  final String marcaNombre;
  final String categoriaNombre;
  final int totalCantidad;
  final double totalMonto;
  final int vecesVendido;

  const TopProductoVendidoModel({
    required this.productoNombre,
    required this.marcaNombre,
    required this.categoriaNombre,
    required this.totalCantidad,
    required this.totalMonto,
    required this.vecesVendido,
  });

  Map<String, dynamic> toMap() {
    return {
      'productoNombre': productoNombre,
      'marcaNombre': marcaNombre,
      'categoriaNombre': categoriaNombre,
      'totalCantidad': totalCantidad,
      'totalMonto': totalMonto,
      'vecesVendido': vecesVendido,
    };
  }

  factory TopProductoVendidoModel.fromMap(Map<String, dynamic> map) {
    return TopProductoVendidoModel(
      productoNombre: map['productoNombre'] ?? '',
      marcaNombre: map['marcaNombre'] ?? '',
      categoriaNombre: map['categoriaNombre'] ?? '',
      totalCantidad: map['totalCantidad']?.toInt() ?? 0,
      totalMonto: (map['totalMonto'] ?? 0.0).toDouble(),
      vecesVendido: map['vecesVendido']?.toInt() ?? 0,
    );
  }

  factory TopProductoVendidoModel.fromJson(Map<String, dynamic> json) =>
      TopProductoVendidoModel.fromMap(json);
}

/// Modelo para anular venta
class AnularVentaRequest {
  final int ventaId;
  final int usuarioId;

  const AnularVentaRequest({required this.ventaId, required this.usuarioId});

  Map<String, dynamic> toMap() {
    return {'ventaId': ventaId, 'usuarioId': usuarioId};
  }

  factory AnularVentaRequest.fromMap(Map<String, dynamic> map) {
    return AnularVentaRequest(
      ventaId: map['ventaId']?.toInt() ?? 0,
      usuarioId: map['usuarioId']?.toInt() ?? 0,
    );
  }

  factory AnularVentaRequest.fromJson(Map<String, dynamic> json) =>
      AnularVentaRequest.fromMap(json);
}
