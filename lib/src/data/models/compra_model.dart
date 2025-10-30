class Compra {
  final int compraId;
  final int proveedorId;
  final String proveedorNombre;
  final DateTime fechaCompra;
  final double subtotal;
  final double impuestos;
  final double total;
  final String estado;
  final String? observaciones;
  final List<DetalleCompra> detalles;

  const Compra({
    required this.compraId,
    required this.proveedorId,
    required this.proveedorNombre,
    required this.fechaCompra,
    required this.subtotal,
    required this.impuestos,
    required this.total,
    required this.estado,
    this.observaciones,
    this.detalles = const [],
  });

  factory Compra.fromJson(Map<String, dynamic> json) {
    return Compra(
      compraId: json['compraId'] ?? 0,
      proveedorId: json['proveedorId'] ?? 0,
      proveedorNombre: json['proveedorNombre'] ?? '',
      fechaCompra: DateTime.parse(json['fechaCompra'] ?? DateTime.now().toIso8601String()),
      subtotal: (json['subtotal'] ?? 0.0).toDouble(),
      impuestos: (json['impuestos'] ?? 0.0).toDouble(),
      total: (json['total'] ?? 0.0).toDouble(),
      estado: json['estado'] ?? '',
      observaciones: json['observaciones'],
      detalles: (json['detalles'] as List<dynamic>?)
          ?.map((d) => DetalleCompra.fromJson(d))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'compraId': compraId,
      'proveedorId': proveedorId,
      'proveedorNombre': proveedorNombre,
      'fechaCompra': fechaCompra.toIso8601String(),
      'subtotal': subtotal,
      'impuestos': impuestos,
      'total': total,
      'estado': estado,
      'observaciones': observaciones,
      'detalles': detalles.map((d) => d.toJson()).toList(),
    };
  }

  String get fechaFormateada {
    return '${fechaCompra.day.toString().padLeft(2, '0')}/'
           '${fechaCompra.month.toString().padLeft(2, '0')}/'
           '${fechaCompra.year}';
  }

  String get horaFormateada {
    return '${fechaCompra.hour.toString().padLeft(2, '0')}:'
           '${fechaCompra.minute.toString().padLeft(2, '0')}';
  }
}

class DetalleCompra {
  final int detalleCompraId;
  final int detalleProductoId;
  final String producto;
  final String marca;
  final int cantidad;
  final double costoUnitario;
  final double subtotal;

  const DetalleCompra({
    required this.detalleCompraId,
    required this.detalleProductoId,
    required this.producto,
    required this.marca,
    required this.cantidad,
    required this.costoUnitario,
    required this.subtotal,
  });

  factory DetalleCompra.fromJson(Map<String, dynamic> json) {
    return DetalleCompra(
      detalleCompraId: json['detalleCompraId'] ?? 0,
      detalleProductoId: json['detalleProductoId'] ?? 0,
      producto: json['producto'] ?? '',
      marca: json['marca'] ?? '',
      cantidad: json['cantidad'] ?? 0,
      costoUnitario: (json['costoUnitario'] ?? 0.0).toDouble(),
      subtotal: (json['subtotal'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'detalleCompraId': detalleCompraId,
      'detalleProductoId': detalleProductoId,
      'producto': producto,
      'marca': marca,
      'cantidad': cantidad,
      'costoUnitario': costoUnitario,
      'subtotal': subtotal,
    };
  }
}

class CompraListResponse {
  final int compraId;
  final String proveedorNombre;
  final DateTime fechaCompra;
  final double total;
  final String estado;

  const CompraListResponse({
    required this.compraId,
    required this.proveedorNombre,
    required this.fechaCompra,
    required this.total,
    required this.estado,
  });

  factory CompraListResponse.fromJson(Map<String, dynamic> json) {
    return CompraListResponse(
      compraId: json['compraId'] ?? 0,
      proveedorNombre: json['proveedorNombre'] ?? '',
      fechaCompra: DateTime.parse(json['fechaCompra'] ?? DateTime.now().toIso8601String()),
      total: (json['total'] ?? 0.0).toDouble(),
      estado: json['estado'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'compraId': compraId,
      'proveedorNombre': proveedorNombre,
      'fechaCompra': fechaCompra.toIso8601String(),
      'total': total,
      'estado': estado,
    };
  }

  String get fechaFormateada {
    return '${fechaCompra.day.toString().padLeft(2, '0')}/'
           '${fechaCompra.month.toString().padLeft(2, '0')}/'
           '${fechaCompra.year}';
  }

  String get horaFormateada {
    return '${fechaCompra.hour.toString().padLeft(2, '0')}:'
           '${fechaCompra.minute.toString().padLeft(2, '0')}';
  }
}