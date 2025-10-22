import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/base_model.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

/// Implementación del repositorio de usuarios
class UserRepositoryImpl implements UserRepository {
  final ApiService _apiService;

  UserRepositoryImpl(this._apiService);

  @override
  Future<PaginatedResponse<User>> getUsers({
    int page = 1,
    int limit = 20,
    String? search,
    UserRole? role,
    bool? isActive,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };

    if (search != null) queryParams['search'] = search;
    if (role != null) queryParams['role'] = role.name;
    if (isActive != null) queryParams['isActive'] = isActive;

    final response = await _apiService.get<Map<String, dynamic>>(
      '/users',
      queryParameters: queryParams,
    );

    if (response.success && response.data != null) {
      return PaginatedResponse.fromMap(
        response.data!,
        (map) => UserModel.fromMap(map).toEntity(),
      );
    }

    throw ApiException(
      message: response.message ?? 'Error al obtener usuarios',
      statusCode: response.statusCode,
    );
  }

  @override
  Future<User?> getUserById(String id) async {
    final response = await _apiService.get<Map<String, dynamic>>('/users/$id');

    if (response.success && response.data != null) {
      return UserModel.fromMap(response.data!).toEntity();
    }

    if (response.statusCode == 404) {
      return null;
    }

    throw ApiException(
      message: response.message ?? 'Error al obtener usuario',
      statusCode: response.statusCode,
    );
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    final response = await _apiService.get<Map<String, dynamic>>(
      '/users/email/$email',
    );

    if (response.success && response.data != null) {
      return UserModel.fromMap(response.data!).toEntity();
    }

    if (response.statusCode == 404) {
      return null;
    }

    throw ApiException(
      message: response.message ?? 'Error al obtener usuario',
      statusCode: response.statusCode,
    );
  }

  @override
  Future<User> createUser(User user) async {
    final userModel = UserModel.fromEntity(user);
    final response = await _apiService.post<Map<String, dynamic>>(
      '/users',
      data: userModel.toMap(),
    );

    if (response.success && response.data != null) {
      return UserModel.fromMap(response.data!).toEntity();
    }

    throw ApiException(
      message: response.message ?? 'Error al crear usuario',
      statusCode: response.statusCode,
    );
  }

  @override
  Future<User> updateUser(String id, User user) async {
    final userModel = UserModel.fromEntity(user);
    final response = await _apiService.put<Map<String, dynamic>>(
      '/users/$id',
      data: userModel.toMap(),
    );

    if (response.success && response.data != null) {
      return UserModel.fromMap(response.data!).toEntity();
    }

    throw ApiException(
      message: response.message ?? 'Error al actualizar usuario',
      statusCode: response.statusCode,
    );
  }

  @override
  Future<bool> deleteUser(String id) async {
    final response = await _apiService.delete<Map<String, dynamic>>('/users/$id');

    if (response.success) {
      return true;
    }

    throw ApiException(
      message: response.message ?? 'Error al eliminar usuario',
      statusCode: response.statusCode,
    );
  }

  @override
  Future<Map<String, dynamic>> authenticate(String email, String password) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    if (response.success && response.data != null) {
      final authData = response.data!;
      
      // Configurar tokens en el servicio API
      if (authData['accessToken'] != null) {
        _apiService.setAccessToken(authData['accessToken']);
      }
      if (authData['refreshToken'] != null) {
        _apiService.setRefreshToken(authData['refreshToken']);
      }

      return authData;
    }

    throw ApiException(
      message: response.message ?? 'Error de autenticación',
      statusCode: response.statusCode,
    );
  }

  @override
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      '/auth/refresh',
      data: {
        'refreshToken': refreshToken,
      },
    );

    if (response.success && response.data != null) {
      final authData = response.data!;
      
      // Actualizar tokens en el servicio API
      if (authData['accessToken'] != null) {
        _apiService.setAccessToken(authData['accessToken']);
      }
      if (authData['refreshToken'] != null) {
        _apiService.setRefreshToken(authData['refreshToken']);
      }

      return authData;
    }

    throw ApiException(
      message: response.message ?? 'Error al refrescar token',
      statusCode: response.statusCode,
    );
  }

  @override
  Future<bool> logout() async {
    final response = await _apiService.post<Map<String, dynamic>>('/auth/logout');

    // Limpiar tokens independientemente del resultado
    _apiService.clearTokens();

    return response.success;
  }

  @override
  Future<bool> changePassword(String userId, String currentPassword, String newPassword) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      '/users/$userId/change-password',
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );

    if (response.success) {
      return true;
    }

    throw ApiException(
      message: response.message ?? 'Error al cambiar contraseña',
      statusCode: response.statusCode,
    );
  }

  @override
  Future<bool> resetPassword(String email) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      '/auth/reset-password',
      data: {
        'email': email,
      },
    );

    if (response.success) {
      return true;
    }

    throw ApiException(
      message: response.message ?? 'Error al resetear contraseña',
      statusCode: response.statusCode,
    );
  }

  @override
  Future<bool> isEmailAvailable(String email) async {
    final response = await _apiService.get<Map<String, dynamic>>(
      '/users/check-email',
      queryParameters: {'email': email},
    );

    if (response.success && response.data != null) {
      return response.data!['available'] ?? false;
    }

    throw ApiException(
      message: response.message ?? 'Error al verificar email',
      statusCode: response.statusCode,
    );
  }

  @override
  Future<Map<String, dynamic>> getUserStats() async {
    final response = await _apiService.get<Map<String, dynamic>>('/users/stats');

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw ApiException(
      message: response.message ?? 'Error al obtener estadísticas',
      statusCode: response.statusCode,
    );
  }
}
