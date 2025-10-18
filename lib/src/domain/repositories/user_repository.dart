import '../entities/user.dart';
import '../../data/models/base_model.dart';

/// Interfaz del repositorio de usuarios
abstract class UserRepository {
  /// Obtiene todos los usuarios con paginación
  Future<PaginatedResponse<User>> getUsers({
    int page = 1,
    int limit = 20,
    String? search,
    UserRole? role,
    bool? isActive,
  });

  /// Obtiene un usuario por ID
  Future<User?> getUserById(String id);

  /// Obtiene un usuario por email
  Future<User?> getUserByEmail(String email);

  /// Crea un nuevo usuario
  Future<User> createUser(User user);

  /// Actualiza un usuario existente
  Future<User> updateUser(String id, User user);

  /// Elimina un usuario
  Future<bool> deleteUser(String id);

  /// Autentica un usuario
  Future<Map<String, dynamic>> authenticate(String email, String password);

  /// Refresca el token de acceso
  Future<Map<String, dynamic>> refreshToken(String refreshToken);

  /// Cierra la sesión del usuario
  Future<bool> logout();

  /// Cambia la contraseña del usuario
  Future<bool> changePassword(String userId, String currentPassword, String newPassword);

  /// Resetea la contraseña del usuario
  Future<bool> resetPassword(String email);

  /// Verifica si el email está disponible
  Future<bool> isEmailAvailable(String email);

  /// Obtiene estadísticas de usuarios
  Future<Map<String, dynamic>> getUserStats();
}



