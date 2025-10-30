class Cliente {
  final int clienteId;
  final String nombre;
  final String telefono;
  final String email;
  final String direccion;
  final bool activo;

  const Cliente({
    required this.clienteId,
    required this.nombre,
    required this.telefono,
    required this.email,
    required this.direccion,
    required this.activo,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      clienteId: json['clienteId'] ?? 0,
      nombre: json['nombre'] ?? '',
      telefono: json['telefono'] ?? '',
      email: json['email'] ?? '',
      direccion: json['direccion'] ?? '',
      activo: json['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clienteId': clienteId,
      'nombre': nombre,
      'telefono': telefono,
      'email': email,
      'direccion': direccion,
      'activo': activo,
    };
  }

  Cliente copyWith({
    int? clienteId,
    String? nombre,
    String? telefono,
    String? email,
    String? direccion,
    bool? activo,
  }) {
    return Cliente(
      clienteId: clienteId ?? this.clienteId,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      direccion: direccion ?? this.direccion,
      activo: activo ?? this.activo,
    );
  }
}

class CrearClienteRequest {
  final String nombre;
  final String telefono;
  final String email;
  final String direccion;

  const CrearClienteRequest({
    required this.nombre,
    required this.telefono,
    required this.email,
    required this.direccion,
  });

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'telefono': telefono,
      'email': email,
      'direccion': direccion,
    };
  }
}

class ActualizarClienteRequest {
  final int clienteId;
  final String nombre;
  final String telefono;
  final String email;
  final String direccion;
  final bool activo;

  const ActualizarClienteRequest({
    required this.clienteId,
    required this.nombre,
    required this.telefono,
    required this.email,
    required this.direccion,
    required this.activo,
  });

  Map<String, dynamic> toJson() {
    return {
      'clienteId': clienteId,
      'nombre': nombre,
      'telefono': telefono,
      'email': email,
      'direccion': direccion,
      'activo': activo,
    };
  }
}
