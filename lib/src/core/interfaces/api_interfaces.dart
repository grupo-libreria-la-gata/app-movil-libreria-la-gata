/// Interfaces para servicios de API
/// 
/// Estas interfaces definen los contratos que deben implementar
/// los servicios de API para facilitar la integración con el backend.
/// 
/// TODO: Implementar estas interfaces cuando la API esté lista

import '../../domain/entities/user.dart';
import '../../domain/entities/bird.dart';
import '../../domain/entities/reserve.dart';
import '../../domain/entities/booking.dart';

/// Resultado de una operación de API
class ApiResult<T> {
  final bool success;
  final T? data;
  final String? error;
  final int? statusCode;

  const ApiResult({
    required this.success,
    this.data,
    this.error,
    this.statusCode,
  });

  factory ApiResult.success(T data) => ApiResult(success: true, data: data);
  factory ApiResult.error(String error, {int? statusCode}) => 
      ApiResult(success: false, error: error, statusCode: statusCode);
}

/// Interfaz para el servicio de autenticación
abstract class IAuthService {
  /// Iniciar sesión con email y contraseña
  Future<ApiResult<User>> signInWithEmailAndPassword(String email, String password);
  
  /// Registrar usuario con email y contraseña
  Future<ApiResult<User>> signUpWithEmailAndPassword(String email, String password, String name);
  
  /// Iniciar sesión con Google
  Future<ApiResult<User>> signInWithGoogle();
  
  /// Cerrar sesión
  Future<ApiResult<void>> signOut();
  
  /// Enviar email de recuperación de contraseña
  Future<ApiResult<void>> sendPasswordResetEmail(String email);
  
  /// Verificar email
  Future<ApiResult<void>> sendEmailVerification();
  
  /// Obtener usuario actual
  Future<ApiResult<User?>> getCurrentUser();
  
  /// Actualizar perfil de usuario
  Future<ApiResult<User>> updateUserProfile(User user);
}

/// Interfaz para el servicio de reservas naturales
abstract class IReserveService {
  /// Obtener lista de reservas
  Future<ApiResult<List<Reserve>>> getReserves({
    String? province,
    String? search,
    int? page,
    int? limit,
  });
  
  /// Obtener reserva por ID
  Future<ApiResult<Reserve>> getReserveById(String reserveId);
  
  /// Obtener reservas favoritas del usuario
  Future<ApiResult<List<Reserve>>> getFavoriteReserves(String userId);
  
  /// Agregar/remover reserva de favoritos
  Future<ApiResult<void>> toggleFavoriteReserve(String userId, String reserveId);
}

/// Interfaz para el servicio de aves
abstract class IBirdService {
  /// Obtener lista de aves
  Future<ApiResult<List<Bird>>> getBirds({
    String? family,
    String? search,
    bool? isEndemic,
    bool? isMigratory,
    int? page,
    int? limit,
  });
  
  /// Obtener ave por ID
  Future<ApiResult<Bird>> getBirdById(String birdId);
  
  /// Obtener aves por familia
  Future<ApiResult<List<Bird>>> getBirdsByFamily(String family);
  
  /// Buscar aves por nombre
  Future<ApiResult<List<Bird>>> searchBirds(String query);
}

/// Interfaz para el servicio de reservas de visitas
abstract class IBookingService {
  /// Obtener reservas del usuario
  Future<ApiResult<List<Booking>>> getUserBookings(String userId);
  
  /// Crear nueva reserva
  Future<ApiResult<Booking>> createBooking(Booking booking);
  
  /// Actualizar reserva
  Future<ApiResult<Booking>> updateBooking(String bookingId, Booking booking);
  
  /// Cancelar reserva
  Future<ApiResult<void>> cancelBooking(String bookingId);
  
  /// Obtener reserva por ID
  Future<ApiResult<Booking>> getBookingById(String bookingId);
  
  /// Obtener guías disponibles
  Future<ApiResult<List<Map<String, dynamic>>>> getAvailableGuides({
    String? reserveId,
    DateTime? date,
  });
}

/// Interfaz para el servicio de eventos
abstract class IEventService {
  /// Obtener lista de eventos
  Future<ApiResult<List<Map<String, dynamic>>>> getEvents({
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    int? page,
    int? limit,
  });
  
  /// Obtener evento por ID
  Future<ApiResult<Map<String, dynamic>>> getEventById(String eventId);
  
  /// Inscribirse a un evento
  Future<ApiResult<void>> registerForEvent(String userId, String eventId);
  
  /// Cancelar inscripción a evento
  Future<ApiResult<void>> unregisterFromEvent(String userId, String eventId);
}

/// Interfaz para el servicio de contenido educativo
abstract class IEducationService {
  /// Obtener artículos educativos
  Future<ApiResult<List<Map<String, dynamic>>>> getArticles({
    String? category,
    int? page,
    int? limit,
  });
  
  /// Obtener artículo por ID
  Future<ApiResult<Map<String, dynamic>>> getArticleById(String articleId);
  
  /// Obtener quizzes
  Future<ApiResult<List<Map<String, dynamic>>>> getQuizzes({
    String? difficulty,
    int? page,
    int? limit,
  });
  
  /// Enviar respuestas de quiz
  Future<ApiResult<Map<String, dynamic>>> submitQuizAnswers(
    String quizId, 
    List<Map<String, dynamic>> answers
  );
}

/// Interfaz para el servicio de ciencia ciudadana
abstract class ICitizenScienceService {
  /// Reportar avistamiento de ave
  Future<ApiResult<Map<String, dynamic>>> reportSighting(Map<String, dynamic> sighting);
  
  /// Obtener avistamientos del usuario
  Future<ApiResult<List<Map<String, dynamic>>>> getUserSightings(String userId);
  
  /// Obtener avistamientos por ave
  Future<ApiResult<List<Map<String, dynamic>>>> getSightingsByBird(String birdId);
  
  /// Obtener estadísticas de avistamientos
  Future<ApiResult<Map<String, dynamic>>> getSightingStats();
}

/// Interfaz para el servicio de notificaciones
abstract class INotificationService {
  /// Enviar notificación push
  Future<ApiResult<void>> sendPushNotification({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  });
  
  /// Suscribir a notificaciones
  Future<ApiResult<void>> subscribeToNotifications(String userId, String topic);
  
  /// Desuscribir de notificaciones
  Future<ApiResult<void>> unsubscribeFromNotifications(String userId, String topic);
  
  /// Obtener configuración de notificaciones
  Future<ApiResult<Map<String, bool>>> getNotificationSettings(String userId);
  
  /// Actualizar configuración de notificaciones
  Future<ApiResult<void>> updateNotificationSettings(
    String userId, 
    Map<String, bool> settings
  );
}
