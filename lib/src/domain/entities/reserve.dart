class Reserve {
  final String reserveId;
  final String nombre;
  final String? descripcion;
  final double? lat;
  final double? lng;
  final String? direccion;
  final String? provincia;
  final String? horario;
  final String? telefono;
  final String? emailContacto;
  final String estado;
  final DateTime createdAt;

  Reserve({
    String? reserveId,
    required this.nombre,
    this.descripcion,
    this.lat,
    this.lng,
    this.direccion,
    this.provincia,
    this.horario,
    this.telefono,
    this.emailContacto,
    this.estado = 'Abierto',
    DateTime? createdAt,
  }) : 
    reserveId = reserveId ?? DateTime.now().millisecondsSinceEpoch.toString(),
    createdAt = createdAt ?? DateTime.now();

  factory Reserve.fromJson(Map<String, dynamic> json) {
    return Reserve(
      reserveId: json['reserveId'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      lat: json['lat']?.toDouble(),
      lng: json['lng']?.toDouble(),
      direccion: json['direccion'],
      provincia: json['provincia'],
      horario: json['horario'],
      telefono: json['telefono'],
      emailContacto: json['emailContacto'],
      estado: json['estado'] ?? 'Abierto',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reserveId': reserveId,
      'nombre': nombre,
      'descripcion': descripcion,
      'lat': lat,
      'lng': lng,
      'direccion': direccion,
      'provincia': provincia,
      'horario': horario,
      'telefono': telefono,
      'emailContacto': emailContacto,
      'estado': estado,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Reserve copyWith({
    String? nombre,
    String? descripcion,
    double? lat,
    double? lng,
    String? direccion,
    String? provincia,
    String? horario,
    String? telefono,
    String? emailContacto,
    String? estado,
  }) {
    return Reserve(
      reserveId: reserveId,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      direccion: direccion ?? this.direccion,
      provincia: provincia ?? this.provincia,
      horario: horario ?? this.horario,
      telefono: telefono ?? this.telefono,
      emailContacto: emailContacto ?? this.emailContacto,
      estado: estado ?? this.estado,
      createdAt: createdAt,
    );
  }
}
