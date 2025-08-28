class Booking {
  final String bookingId;
  final String userId;
  final String reserveId;
  final String? guideId;
  final DateTime fechaHora;
  final int personas;
  final String estado;
  final double total;
  final DateTime createdAt;

  Booking({
    String? bookingId,
    required this.userId,
    required this.reserveId,
    this.guideId,
    required this.fechaHora,
    this.personas = 1,
    this.estado = 'Pendiente',
    this.total = 0.0,
    DateTime? createdAt,
  }) : 
    bookingId = bookingId ?? DateTime.now().millisecondsSinceEpoch.toString(),
    createdAt = createdAt ?? DateTime.now();

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      bookingId: json['bookingId'],
      userId: json['userId'],
      reserveId: json['reserveId'],
      guideId: json['guideId'],
      fechaHora: DateTime.parse(json['fechaHora']),
      personas: json['personas'] ?? 1,
      estado: json['estado'] ?? 'Pendiente',
      total: (json['total'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'userId': userId,
      'reserveId': reserveId,
      'guideId': guideId,
      'fechaHora': fechaHora.toIso8601String(),
      'personas': personas,
      'estado': estado,
      'total': total,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Booking copyWith({
    String? userId,
    String? reserveId,
    String? guideId,
    DateTime? fechaHora,
    int? personas,
    String? estado,
    double? total,
  }) {
    return Booking(
      bookingId: bookingId,
      userId: userId ?? this.userId,
      reserveId: reserveId ?? this.reserveId,
      guideId: guideId ?? this.guideId,
      fechaHora: fechaHora ?? this.fechaHora,
      personas: personas ?? this.personas,
      estado: estado ?? this.estado,
      total: total ?? this.total,
      createdAt: createdAt,
    );
  }
}
