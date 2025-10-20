class Proveedor {
  final int proveedorId;
  final String nombre;
  final String? telefono;
  final String? email;
  final String? direccion;
  final bool activo;
  final DateTime fechaCreacion;

  const Proveedor({
    required this.proveedorId,
    required this.nombre,
    this.telefono,
    this.email,
    this.direccion,
    required this.activo,
    required this.fechaCreacion,
  });

  factory Proveedor.fromJson(Map<String, dynamic> json) {
    return Proveedor(
      proveedorId: json['proveedorId'] ?? 0,
      nombre: json['nombre'] ?? '',
      telefono: json['telefono'],
      email: json['email'],
      direccion: json['direccion'],
      activo: json['activo'] ?? true,
      fechaCreacion: DateTime.parse(
        json['fechaCreacion'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'proveedorId': proveedorId,
      'nombre': nombre,
      'telefono': telefono,
      'email': email,
      'direccion': direccion,
      'activo': activo,
      'fechaCreacion': fechaCreacion.toIso8601String(),
    };
  }

  Proveedor copyWith({
    int? proveedorId,
    String? nombre,
    String? telefono,
    String? email,
    String? direccion,
    bool? activo,
    DateTime? fechaCreacion,
  }) {
    return Proveedor(
      proveedorId: proveedorId ?? this.proveedorId,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      direccion: direccion ?? this.direccion,
      activo: activo ?? this.activo,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }
}

class CrearProveedorRequest {
  final String nombre;
  final String? telefono;
  final String? email;
  final String? direccion;

  const CrearProveedorRequest({
    required this.nombre,
    this.telefono,
    this.email,
    this.direccion,
  });

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'telefono': telefono,
      'email': email,
      'direccion': direccion,
    };
  }

  factory CrearProveedorRequest.fromJson(Map<String, dynamic> json) {
    return CrearProveedorRequest(
      nombre: json['nombre'] ?? '',
      telefono: json['telefono'],
      email: json['email'],
      direccion: json['direccion'],
    );
  }
}

class ActualizarProveedorRequest {
  final String? nombre;
  final String? telefono;
  final String? email;
  final String? direccion;

  const ActualizarProveedorRequest({
    this.nombre,
    this.telefono,
    this.email,
    this.direccion,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (nombre != null) data['nombre'] = nombre;
    if (telefono != null) data['telefono'] = telefono;
    if (email != null) data['email'] = email;
    if (direccion != null) data['direccion'] = direccion;
    return data;
  }

  factory ActualizarProveedorRequest.fromJson(Map<String, dynamic> json) {
    return ActualizarProveedorRequest(
      nombre: json['nombre'],
      telefono: json['telefono'],
      email: json['email'],
      direccion: json['direccion'],
    );
  }
}
