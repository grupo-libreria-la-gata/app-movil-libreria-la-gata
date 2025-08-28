/// Interfaces para servicios de API
/// 
/// Estas interfaces definen los contratos que deben implementar
/// los servicios de API para facilitar la integración con el backend.
/// 
/// TODO: Implementar estas interfaces cuando la API esté lista

import '../../domain/entities/user.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/sale.dart';

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

/// Interfaz para el servicio de productos
abstract class IProductService {
  /// Obtener lista de productos
  Future<ApiResult<List<Product>>> getProducts({
    String? category,
    String? search,
    int? page,
    int? limit,
  });
  
  /// Obtener producto por ID
  Future<ApiResult<Product>> getProductById(String productId);
  
  /// Crear nuevo producto
  Future<ApiResult<Product>> createProduct(Product product);
  
  /// Actualizar producto
  Future<ApiResult<Product>> updateProduct(String productId, Product product);
  
  /// Eliminar producto
  Future<ApiResult<void>> deleteProduct(String productId);
  
  /// Actualizar stock de producto
  Future<ApiResult<Product>> updateProductStock(String productId, int newStock);
  
  /// Obtener productos con stock bajo
  Future<ApiResult<List<Product>>> getLowStockProducts();
}

/// Interfaz para el servicio de ventas
abstract class ISaleService {
  /// Obtener lista de ventas
  Future<ApiResult<List<Sale>>> getSales({
    DateTime? startDate,
    DateTime? endDate,
    String? sellerId,
    int? page,
    int? limit,
  });
  
  /// Obtener venta por ID
  Future<ApiResult<Sale>> getSaleById(String saleId);
  
  /// Crear nueva venta
  Future<ApiResult<Sale>> createSale(Sale sale);
  
  /// Actualizar venta
  Future<ApiResult<Sale>> updateSale(String saleId, Sale sale);
  
  /// Cancelar venta
  Future<ApiResult<void>> cancelSale(String saleId);
  
  /// Obtener estadísticas de ventas
  Future<ApiResult<Map<String, dynamic>>> getSalesStats({
    DateTime? startDate,
    DateTime? endDate,
  });
}

/// Interfaz para el servicio de clientes
abstract class ICustomerService {
  /// Obtener lista de clientes
  Future<ApiResult<List<Map<String, dynamic>>>> getCustomers({
    String? search,
    int? page,
    int? limit,
  });
  
  /// Obtener cliente por ID
  Future<ApiResult<Map<String, dynamic>>> getCustomerById(String customerId);
  
  /// Crear nuevo cliente
  Future<ApiResult<Map<String, dynamic>>> createCustomer(Map<String, dynamic> customer);
  
  /// Actualizar cliente
  Future<ApiResult<Map<String, dynamic>>> updateCustomer(String customerId, Map<String, dynamic> customer);
  
  /// Eliminar cliente
  Future<ApiResult<void>> deleteCustomer(String customerId);
  
  /// Obtener historial de compras del cliente
  Future<ApiResult<List<Sale>>> getCustomerPurchaseHistory(String customerId);
}

/// Interfaz para el servicio de inventario
abstract class IInventoryService {
  /// Obtener estado del inventario
  Future<ApiResult<Map<String, dynamic>>> getInventoryStatus();
  
  /// Realizar ajuste de inventario
  Future<ApiResult<void>> adjustInventory(String productId, int quantity, String reason);
  
  /// Obtener movimientos de inventario
  Future<ApiResult<List<Map<String, dynamic>>>> getInventoryMovements({
    String? productId,
    DateTime? startDate,
    DateTime? endDate,
    int? page,
    int? limit,
  });
  
  /// Generar reporte de inventario
  Future<ApiResult<Map<String, dynamic>>> generateInventoryReport();
}

/// Interfaz para el servicio de reportes
abstract class IReportService {
  /// Obtener reporte de ventas
  Future<ApiResult<Map<String, dynamic>>> getSalesReport({
    DateTime? startDate,
    DateTime? endDate,
    String? format,
  });
  
  /// Obtener reporte de productos más vendidos
  Future<ApiResult<List<Map<String, dynamic>>>> getTopSellingProducts({
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  });
  
  /// Obtener reporte de ganancias
  Future<ApiResult<Map<String, dynamic>>> getProfitReport({
    DateTime? startDate,
    DateTime? endDate,
  });
  
  /// Obtener reporte de inventario
  Future<ApiResult<Map<String, dynamic>>> getInventoryReport();
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
