import 'api_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiService _apiService = ApiService();

  /// Inicia sesión con email y contraseña
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('🔍 [DEBUG] AuthService: Iniciando login para $email');
      
      final response = await _apiService.post<Map<String, dynamic>>(
        '/api/auth/login',
        data: {
          'email': email,
          'passwordHash': password, // El backend espera passwordHash
        },
      );

      print('🔍 [DEBUG] AuthService: Respuesta del servidor: ${response.data}');
      print('🔍 [DEBUG] AuthService: Status code: ${response.statusCode}');
      print('🔍 [DEBUG] AuthService: Mensaje: ${response.message}');

      if (response.success && response.data != null) {
        return response.data!;
      } else {
        throw Exception(response.message ?? 'Error al iniciar sesión');
      }
    } catch (e) {
      print('❌ [DEBUG] AuthService: Error en login: $e');
      rethrow;
    }
  }

  /// Registra un nuevo usuario
  Future<Map<String, dynamic>> register({
    required String username,
    required String nombre,
    required String email,
    required String password,
    required String telefono,
    required int rolId,
    required int usuarioCreadorId,
  }) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/api/auth/register',
        data: {
          'username': username,
          'nombre': nombre,
          'email': email,
          'passwordHash': password,
          'telefono': telefono,
          'rolId': rolId,
          'usuarioCreadorId': usuarioCreadorId,
        },
      );

      if (response.success) {
        return response.data ?? {};
      } else {
        throw Exception(response.message ?? 'Error al registrar usuario');
      }
    } catch (e) {
      print('❌ [DEBUG] AuthService: Error en registro: $e');
      rethrow;
    }
  }

  /// Cierra sesión
  Future<void> logout() async {
    try {
      // Limpiar tokens del ApiService
      _apiService.clearTokens();
    } catch (e) {
      print('❌ [DEBUG] AuthService: Error en logout: $e');
      rethrow;
    }
  }

  /// Verifica el estado de autenticación
  Future<bool> checkAuthStatus() async {
    try {
      // Por ahora, simplemente verificar si hay un token
      return _apiService.accessToken != null;
    } catch (e) {
      print('❌ [DEBUG] AuthService: Error verificando estado: $e');
      return false;
    }
  }
}
