import 'package:uuid/uuid.dart';

class User {
  final String userId;
  final String nombre;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final int roleId;
  final bool isVerified;
  final DateTime createdAt;

  User({
    String? userId,
    required this.nombre,
    required this.email,
    this.phone,
    this.avatarUrl,
    required this.roleId,
    this.isVerified = false,
    DateTime? createdAt,
  }) : 
    userId = userId ?? const Uuid().v4(),
    createdAt = createdAt ?? DateTime.now();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      nombre: json['nombre'],
      email: json['email'],
      phone: json['phone'],
      avatarUrl: json['avatarUrl'],
      roleId: json['roleId'],
      isVerified: json['isVerified'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'nombre': nombre,
      'email': email,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'roleId': roleId,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  User copyWith({
    String? nombre,
    String? email,
    String? phone,
    String? avatarUrl,
    int? roleId,
    bool? isVerified,
  }) {
    return User(
      userId: userId,
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      roleId: roleId ?? this.roleId,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt,
    );
  }
}
