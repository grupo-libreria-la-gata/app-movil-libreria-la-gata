/// Entidad que representa un usuario del sistema de facturación
class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final UserRole role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastLogin;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    this.isActive = true,
    required this.createdAt,
    this.lastLogin,
  });

  /// Verifica si el usuario tiene permisos de administrador
  bool get isAdmin => role == UserRole.admin;

  /// Verifica si el usuario tiene permisos de vendedor
  bool get isSeller => role == UserRole.seller || role == UserRole.admin;

  /// Verifica si el usuario tiene permisos de inventario
  bool get canManageInventory => role == UserRole.inventory || role == UserRole.admin;

  /// Verifica si el usuario puede ver reportes
  bool get canViewReports => role == UserRole.seller || role == UserRole.inventory || role == UserRole.admin;

  /// Copia el usuario con nuevos valores
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  /// Convierte la entidad a un Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role.name,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }

  /// Crea una entidad desde un Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
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
      lastLogin: map['lastLogin'] != null ? DateTime.parse(map['lastLogin']) : null,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Roles de usuario en el sistema
enum UserRole {
  admin,      // Administrador - acceso completo
  seller,     // Vendedor - puede hacer ventas y ver reportes básicos
  inventory,  // Inventario - puede gestionar productos y stock
  cashier,    // Cajero - solo puede hacer ventas
}
