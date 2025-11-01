class Venta {
  final int ventaId;
  final int clienteId;
  final String clienteNombre;
  final DateTime fechaVenta;
  final double subtotal;
  final double impuestos;
  final double total;
  final String estado;
  final String? observaciones;
  final List<DetalleVenta> detalles;

  const Venta({
    required this.ventaId,
    required this.clienteId,
    required this.clienteNombre,
    required this.fechaVenta,
    required this.subtotal,
    required this.impuestos,
    required this.total,
    required this.estado,
    this.observaciones,
    this.detalles = const [],
  });

  factory Venta.fromJson(Map<String, dynamic> json) {
    return Venta(
      ventaId: json['ventaId'] ?? 0,
      clienteId: json['clienteId'] ?? 0,
      clienteNombre: json['clienteNombre'] ?? '',
      fechaVenta: DateTime.parse(json['fechaVenta'] ?? DateTime.now().toIso8601String()),
      subtotal: (json['subtotal'] ?? 0.0).toDouble(),
      impuestos: (json['impuestos'] ?? 0.0).toDouble(),
      total: (json['total'] ?? 0.0).toDouble(),
      estado: json['estado'] ?? '',
      observaciones: json['observaciones'],
      detalles: (json['detalles'] as List<dynamic>?)
          ?.map((d) => DetalleVenta.fromJson(d))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ventaId': ventaId,
      'clienteId': clienteId,
      'clienteNombre': clienteNombre,
      'fechaVenta': fechaVenta.toIso8601String(),
      'subtotal': subtotal,
      'impuestos': impuestos,
      'total': total,
      'estado': estado,
      'observaciones': observaciones,
      'detalles': detalles.map((d) => d.toJson()).toList(),
    };
  }

  String get fechaFormateada {
    return '${fechaVenta.day.toString().padLeft(2, '0')}/'
           '${fechaVenta.month.toString().padLeft(2, '0')}/'
           '${fechaVenta.year}';
  }

  String get horaFormateada {
    return '${fechaVenta.hour.toString().padLeft(2, '0')}:'
           '${fechaVenta.minute.toString().padLeft(2, '0')}';
  }
}

class DetalleVenta {
  final int detalleVentaId;
  final int detalleProductoId;
  final String producto;
  final String marca;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;

  const DetalleVenta({
    required this.detalleVentaId,
    required this.detalleProductoId,
    required this.producto,
    required this.marca,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
  });

  factory DetalleVenta.fromJson(Map<String, dynamic> json) {
    return DetalleVenta(
      detalleVentaId: json['detalleVentaId'] ?? 0,
      detalleProductoId: json['detalleProductoId'] ?? 0,
      producto: json['producto'] ?? '',
      marca: json['marca'] ?? '',
      cantidad: json['cantidad'] ?? 0,
      precioUnitario: (json['precioUnitario'] ?? 0.0).toDouble(),
      subtotal: (json['subtotal'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'detalleVentaId': detalleVentaId,
      'detalleProductoId': detalleProductoId,
      'producto': producto,
      'marca': marca,
      'cantidad': cantidad,
      'precioUnitario': precioUnitario,
      'subtotal': subtotal,
    };
  }
}

class VentaListResponse {
  final int ventaId;
  final int clienteId;
  final String clienteNombre;
  final int usuarioId;
  final String usuarioNombre;
  final String metodoPago;
  final DateTime fechaVenta;
  final double total;
  final String? observaciones;
  final bool activo;
  final int totalItems;

  const VentaListResponse({
    required this.ventaId,
    required this.clienteId,
    required this.clienteNombre,
    required this.usuarioId,
    required this.usuarioNombre,
    required this.metodoPago,
    required this.fechaVenta,
    required this.total,
    this.observaciones,
    required this.activo,
    required this.totalItems,
  });

  factory VentaListResponse.fromJson(Map<String, dynamic> json) {
    return VentaListResponse(
      ventaId: json['ventaId'] ?? json['VentaId'] ?? 0,
      clienteId: json['clienteId'] ?? json['ClienteId'] ?? 0,
      clienteNombre: json['clienteNombre'] ?? json['ClienteNombre'] ?? '',
      usuarioId: json['usuarioId'] ?? json['UsuarioId'] ?? 0,
      usuarioNombre: json['usuarioNombre'] ?? json['UsuarioNombre'] ?? '',
      metodoPago: json['metodoPago'] ?? json['MetodoPago'] ?? '',
      fechaVenta: json['fechaVenta'] != null
          ? DateTime.parse(json['fechaVenta'])
          : json['Fecha'] != null
              ? DateTime.parse(json['Fecha'])
              : DateTime.now(),
      total: ((json['total'] ?? json['Total']) ?? 0.0).toDouble(),
      observaciones: json['observaciones'] ?? json['Observaciones'],
      activo: json['activo'] ?? json['Activo'] ?? true,
      totalItems: json['totalItems'] ?? json['TotalItems'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ventaId': ventaId,
      'clienteId': clienteId,
      'clienteNombre': clienteNombre,
      'usuarioId': usuarioId,
      'usuarioNombre': usuarioNombre,
      'metodoPago': metodoPago,
      'fechaVenta': fechaVenta.toIso8601String(),
      'total': total,
      'observaciones': observaciones,
      'activo': activo,
      'totalItems': totalItems,
    };
  }

  String get estado => activo ? 'Activa' : 'Anulada';

  String get fechaFormateada {
    return '${fechaVenta.day.toString().padLeft(2, '0')}/'
           '${fechaVenta.month.toString().padLeft(2, '0')}/'
           '${fechaVenta.year}';
  }

  String get horaFormateada {
    return '${fechaVenta.hour.toString().padLeft(2, '0')}:'
           '${fechaVenta.minute.toString().padLeft(2, '0')}';
  }
}