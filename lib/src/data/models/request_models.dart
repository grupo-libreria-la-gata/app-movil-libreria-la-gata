// Modelos para requests de ventas
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

  Map<String, dynamic> toJson() {
    return {
      'clienteId': clienteId,
      'usuarioId': usuarioId,
      'metodoPago': metodoPago,
      'total': total,
      'observaciones': observaciones,
      'detalles': detalles.map((d) => d.toJson()).toList(),
    };
  }
}

class CrearVentaDetalleRequest {
  final int detalleProductoId;
  final int cantidad;
  final double precioUnitario;
  final String codigoBarra;

  const CrearVentaDetalleRequest({
    required this.detalleProductoId,
    required this.cantidad,
    required this.precioUnitario,
    required this.codigoBarra,
  });

  Map<String, dynamic> toJson() {
    return {
      'detalleProductoId': detalleProductoId,
      'cantidad': cantidad,
      'precioUnitario': precioUnitario,
      'codigoBarra': codigoBarra,
    };
  }
}

// Modelos para requests de compras
class CrearCompraRequest {
  final int proveedorId;
  final int usuarioId;
  final double subtotal;
  final double impuestos;
  final double total;
  final String? observaciones;
  final List<CrearCompraDetalleRequest> detalles;

  const CrearCompraRequest({
    required this.proveedorId,
    required this.usuarioId,
    required this.subtotal,
    required this.impuestos,
    required this.total,
    this.observaciones,
    required this.detalles,
  });

  Map<String, dynamic> toJson() {
    return {
      'proveedorId': proveedorId,
      'usuarioId': usuarioId,
      'subtotal': subtotal,
      'impuestos': impuestos,
      'total': total,
      'observaciones': observaciones,
      'detalles': detalles.map((d) => d.toJson()).toList(),
    };
  }
}

class CrearCompraDetalleRequest {
  final int detalleProductoId;
  final String codigoBarra;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;

  const CrearCompraDetalleRequest({
    required this.detalleProductoId,
    required this.codigoBarra,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
  });

  Map<String, dynamic> toJson() {
    return {
      'detalleProductoId': detalleProductoId,
      'codigoBarra': codigoBarra,
      'cantidad': cantidad,
      'precioUnitario': precioUnitario,
      'subtotal': subtotal,
    };
  }
}
