import '../../config/app_config.dart';
import '../../domain/entities/user.dart';
import 'api_service.dart';

/// Servicio para gestionar usuarios
class UsuarioService {
  final ApiService _apiService = ApiService();
  String get baseUrl => '${AppConfig.baseUrl}/api/Usuarios';

  /// Obtener lista de usuarios activos
  Future<List<User>> obtenerUsuariosActivos(int usuarioAdminId) async {
    try {
      final response = await _apiService.get<List<dynamic>>(
        '/api/Usuarios/activos',
        queryParameters: {'usuarioAdminId': usuarioAdminId},
      );

      if (response.success && response.data != null) {
        return (response.data as List).map((json) {
          // Convertir el DTO del backend a User
          return _mapDtoToUser(json as Map<String, dynamic>);
        }).toList();
      }

      throw Exception('Error al obtener usuarios activos: ${response.message}');
    } catch (e) {
      print('❌ Error en obtenerUsuariosActivos: $e');
      rethrow;
    }
  }

  /// Obtener lista de usuarios inactivos
  Future<List<User>> obtenerUsuariosInactivos(int usuarioAdminId) async {
    try {
      final response = await _apiService.get<List<dynamic>>(
        '/api/Usuarios/inactivos',
        queryParameters: {'usuarioAdminId': usuarioAdminId},
      );

      if (response.success && response.data != null) {
        return (response.data as List).map((json) {
          return _mapDtoToUser(json as Map<String, dynamic>);
        }).toList();
      }

      throw Exception('Error al obtener usuarios inactivos: ${response.message}');
    } catch (e) {
      print('❌ Error en obtenerUsuariosInactivos: $e');
      rethrow;
    }
  }

  /// Desactivar un usuario
  Future<void> desactivarUsuario(int usuarioId, int usuarioAdminId) async {
    try {
      final response = await _apiService.post<dynamic>(
        '/api/Usuarios/desactivar',
        queryParameters: {
          'usuarioId': usuarioId,
          'usuarioAdminId': usuarioAdminId,
        },
      );

      if (!response.success) {
        throw Exception('Error al desactivar usuario: ${response.message}');
      }
    } catch (e) {
      print('❌ Error en desactivarUsuario: $e');
      rethrow;
    }
  }

  /// Activar un usuario
  Future<void> activarUsuario(int usuarioId, int usuarioAdminId) async {
    try {
      final response = await _apiService.post<dynamic>(
        '/api/Usuarios/activar',
        queryParameters: {
          'usuarioId': usuarioId,
          'usuarioAdminId': usuarioAdminId,
        },
      );

      if (!response.success) {
        throw Exception('Error al activar usuario: ${response.message}');
      }
    } catch (e) {
      print('❌ Error en activarUsuario: $e');
      rethrow;
    }
  }

  /// Asignar un rol a un usuario
  Future<void> asignarRol({
    required int usuarioId,
    required int nuevoRolId,
    required int usuarioAdminId,
  }) async {
    try {
      final response = await _apiService.post<dynamic>(
        '/api/Usuarios/asignar-rol',
        queryParameters: {
          'usuarioId': usuarioId,
          'nuevoRolId': nuevoRolId,
          'usuarioAdminId': usuarioAdminId,
        },
      );

      if (!response.success) {
        throw Exception('Error al asignar rol: ${response.message}');
      }
    } catch (e) {
      print('❌ Error en asignarRol: $e');
      rethrow;
    }
  }

  /// Mapea el DTO del backend a la entidad User
  User _mapDtoToUser(Map<String, dynamic> json) {
    // El backend devuelve UsuarioAdminListadoDto o UsuarioResumenDto
    // Mapeamos según los campos disponibles
    final usuarioId = json['UsuarioId'] ?? json['usuarioId'] ?? 0;
    final nombre = json['Nombre'] ?? json['nombre'] ?? '';
    final email = json['Email'] ?? json['email'] ?? '';
    final telefono = json['Telefono'] ?? json['telefono'];
    final rolId = json['RolId'] ?? json['rolId'] ?? 2; // Default seller
    final activo = json['Activo'] ?? json['activo'] ?? true;
    final fechaCreacion = json['FechaCreacion'] ?? json['fechaCreacion'];

    // Mapear rolId a UserRole
    UserRole role;
    switch (rolId) {
      case 1:
        role = UserRole.admin;
        break;
      case 2:
        role = UserRole.seller;
        break;
      case 3:
        role = UserRole.cashier;
        break;
      case 4:
        role = UserRole.inventory;
        break;
      default:
        role = UserRole.seller;
    }

    return User(
      id: usuarioId.toString(),
      name: nombre,
      email: email,
      phone: telefono,
      role: role,
      isActive: activo,
      createdAt: fechaCreacion != null 
          ? DateTime.parse(fechaCreacion.toString())
          : DateTime.now(),
    );
  }
}

