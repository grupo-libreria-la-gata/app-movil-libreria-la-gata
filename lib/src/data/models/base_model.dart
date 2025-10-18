/// Modelo base que proporciona funcionalidad común para todos los modelos
abstract class BaseModel {
  /// ID único del modelo
  String get id;
  
  /// Fecha de creación
  DateTime get createdAt;
  
  /// Fecha de última actualización
  DateTime? get updatedAt;
  
  /// Convierte el modelo a un Map para serialización
  Map<String, dynamic> toMap();
  
  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() => toMap();
  
  /// Crea una instancia del modelo desde un Map
  static T fromMap<T extends BaseModel>(Map<String, dynamic> map) {
    throw UnimplementedError('fromMap must be implemented by subclasses');
  }
  
  /// Crea una instancia del modelo desde JSON
  static T fromJson<T extends BaseModel>(Map<String, dynamic> json) {
    return fromMap<T>(json);
  }
  
  /// Valida que el modelo tenga los datos requeridos
  bool get isValid;
  
  /// Obtiene una representación en string del modelo
  @override
  String toString();
  
  /// Compara dos modelos por su ID
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BaseModel && other.id == id;
  }
  
  /// Hash code basado en el ID
  @override
  int get hashCode => id.hashCode;
}

/// Clase base para respuestas de API
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final List<String>? errors;
  final int? statusCode;
  final Map<String, dynamic>? metadata;

  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.errors,
    this.statusCode,
    this.metadata,
  });

  /// Crea una respuesta exitosa
  factory ApiResponse.success({
    required T data,
    String? message,
    Map<String, dynamic>? metadata,
  }) {
    return ApiResponse<T>(
      success: true,
      data: data,
      message: message,
      metadata: metadata,
    );
  }

  /// Crea una respuesta de error
  factory ApiResponse.error({
    required String message,
    List<String>? errors,
    int? statusCode,
    Map<String, dynamic>? metadata,
  }) {
    return ApiResponse<T>(
      success: false,
      message: message,
      errors: errors,
      statusCode: statusCode,
      metadata: metadata,
    );
  }

  /// Convierte la respuesta a Map
  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'message': message,
      'data': data,
      'errors': errors,
      'statusCode': statusCode,
      'metadata': metadata,
    };
  }

  /// Crea una respuesta desde un Map
  factory ApiResponse.fromMap(Map<String, dynamic> map) {
    return ApiResponse<T>(
      success: map['success'] ?? false,
      message: map['message'],
      data: map['data'],
      errors: map['errors']?.cast<String>(),
      statusCode: map['statusCode'],
      metadata: map['metadata'],
    );
  }
}

/// Clase base para paginación
class PaginatedResponse<T> {
  final List<T> data;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const PaginatedResponse({
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  /// Crea una respuesta paginada desde un Map
  factory PaginatedResponse.fromMap(
    Map<String, dynamic> map,
    T Function(Map<String, dynamic>) fromMapT,
  ) {
    final dataList = (map['data'] as List<dynamic>?)
        ?.map((item) => fromMapT(item as Map<String, dynamic>))
        .toList() ?? [];

    return PaginatedResponse<T>(
      data: dataList,
      currentPage: map['currentPage'] ?? 1,
      totalPages: map['totalPages'] ?? 1,
      totalItems: map['totalItems'] ?? 0,
      itemsPerPage: map['itemsPerPage'] ?? 10,
      hasNextPage: map['hasNextPage'] ?? false,
      hasPreviousPage: map['hasPreviousPage'] ?? false,
    );
  }

  /// Convierte la respuesta paginada a Map
  Map<String, dynamic> toMap() {
    return {
      'data': data,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalItems': totalItems,
      'itemsPerPage': itemsPerPage,
      'hasNextPage': hasNextPage,
      'hasPreviousPage': hasPreviousPage,
    };
  }
}

/// Enumeración para estados de operaciones
enum OperationStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
}

/// Clase para manejar errores de API
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;
  final Map<String, dynamic>? details;

  const ApiException({
    required this.message,
    this.statusCode,
    this.errorCode,
    this.details,
  });

  @override
  String toString() {
    return 'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
  }
}



