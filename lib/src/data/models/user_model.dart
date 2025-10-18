import 'base_model.dart';
import '../../domain/entities/user.dart';

/// Modelo de datos para Usuario con serialización JSON
class UserModel extends BaseModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final UserRole role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLogin;
  final String? avatarUrl;
  final Map<String, dynamic>? preferences;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
    this.lastLogin,
    this.avatarUrl,
    this.preferences,
  });

  @override
  bool get isValid => 
      id.isNotEmpty && 
      name.isNotEmpty && 
      email.isNotEmpty && 
      email.contains('@');

  /// Convierte el modelo a una entidad de dominio
  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      phone: phone,
      role: role,
      isActive: isActive,
      createdAt: createdAt,
      lastLogin: lastLogin,
    );
  }

  /// Crea un modelo desde una entidad de dominio
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      role: user.role,
      isActive: user.isActive,
      createdAt: user.createdAt,
      lastLogin: user.lastLogin,
    );
  }

  /// Copia el modelo con nuevos valores
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLogin,
    String? avatarUrl,
    Map<String, dynamic>? preferences,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLogin: lastLogin ?? this.lastLogin,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role.name,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
      'avatarUrl': avatarUrl,
      'preferences': preferences,
    };
  }

  /// Crea un modelo desde un Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'],
      role: UserRole.values.firstWhere(
        (e) => e.name == map['role'],
        orElse: () => UserRole.seller,
      ),
      isActive: map['isActive'] ?? true,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      lastLogin: map['lastLogin'] != null ? DateTime.parse(map['lastLogin']) : null,
      avatarUrl: map['avatarUrl'],
      preferences: map['preferences'] != null 
          ? Map<String, dynamic>.from(map['preferences']) 
          : null,
    );
  }

  /// Crea un modelo desde JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel.fromMap(json);
  }

  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() => toMap();

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, role: $role)';
  }
}

/// DTO para crear un nuevo usuario
class CreateUserDto {
  final String name;
  final String email;
  final String? phone;
  final UserRole role;
  final String? password;
  final Map<String, dynamic>? preferences;

  const CreateUserDto({
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    this.password,
    this.preferences,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role.name,
      'password': password,
      'preferences': preferences,
    };
  }

  factory CreateUserDto.fromMap(Map<String, dynamic> map) {
    return CreateUserDto(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'],
      role: UserRole.values.firstWhere(
        (e) => e.name == map['role'],
        orElse: () => UserRole.seller,
      ),
      password: map['password'],
      preferences: map['preferences'] != null 
          ? Map<String, dynamic>.from(map['preferences']) 
          : null,
    );
  }
}

/// DTO para actualizar un usuario
class UpdateUserDto {
  final String? name;
  final String? email;
  final String? phone;
  final UserRole? role;
  final bool? isActive;
  final String? avatarUrl;
  final Map<String, dynamic>? preferences;

  const UpdateUserDto({
    this.name,
    this.email,
    this.phone,
    this.role,
    this.isActive,
    this.avatarUrl,
    this.preferences,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (name != null) map['name'] = name;
    if (email != null) map['email'] = email;
    if (phone != null) map['phone'] = phone;
    if (role != null) map['role'] = role!.name;
    if (isActive != null) map['isActive'] = isActive;
    if (avatarUrl != null) map['avatarUrl'] = avatarUrl;
    if (preferences != null) map['preferences'] = preferences;
    return map;
  }

  factory UpdateUserDto.fromMap(Map<String, dynamic> map) {
    return UpdateUserDto(
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      role: map['role'] != null 
          ? UserRole.values.firstWhere(
              (e) => e.name == map['role'],
              orElse: () => UserRole.seller,
            )
          : null,
      isActive: map['isActive'],
      avatarUrl: map['avatarUrl'],
      preferences: map['preferences'] != null 
          ? Map<String, dynamic>.from(map['preferences']) 
          : null,
    );
  }
}

/// DTO para autenticación
class LoginDto {
  final String email;
  final String password;
  final bool rememberMe;

  const LoginDto({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'rememberMe': rememberMe,
    };
  }

  factory LoginDto.fromMap(Map<String, dynamic> map) {
    return LoginDto(
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      rememberMe: map['rememberMe'] ?? false,
    );
  }
}

/// DTO para respuesta de autenticación
class AuthResponseDto {
  final UserModel user;
  final String accessToken;
  final String? refreshToken;
  final DateTime expiresAt;

  const AuthResponseDto({
    required this.user,
    required this.accessToken,
    this.refreshToken,
    required this.expiresAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'user': user.toMap(),
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  factory AuthResponseDto.fromMap(Map<String, dynamic> map) {
    return AuthResponseDto(
      user: UserModel.fromMap(map['user']),
      accessToken: map['accessToken'] ?? '',
      refreshToken: map['refreshToken'],
      expiresAt: DateTime.parse(map['expiresAt']),
    );
  }
}
