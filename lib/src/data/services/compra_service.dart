import '../models/base_model.dart';
import '../models/compra_model.dart';
import 'api_service.dart';

/// Servicio para manejo de compras
class CompraService {
  static final CompraService _instance = CompraService._internal();
  factory CompraService() => _instance;
  CompraService._internal();

  final ApiService _apiService = ApiService();

  /// Crea una nueva compra
  Future<ApiResponse<CompraModel>> crearCompra(CrearCompraRequest request) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/api/compras',
        data: request.toMap(),
      );

      if (response.success && response.data != null) {
        final compra = CompraModel.fromMap(response.data!);
        return ApiResponse.success(
          data: compra,
          message: 'Compra creada exitosamente',
        );
      } else {
        return ApiResponse.error(
          message: response.message ?? 'Error al crear la compra',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error(
        message: 'Error inesperado al crear compra: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Obtiene una compra completa por ID
  Future<ApiResponse<CompraModel>> obtenerCompra(int compraId) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        '/api/compras/$compraId',
      );

      if (response.success && response.data != null) {
        final compra = CompraModel.fromMap(response.data!);
        return ApiResponse.success(
          data: compra,
          message: 'Compra obtenida exitosamente',
        );
      } else {
        return ApiResponse.error(
          message: response.message ?? 'Error al obtener la compra',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error(
        message: 'Error inesperado al obtener compra: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Lista todas las compras
  Future<ApiResponse<List<CompraListModel>>> listarCompras(int usuarioId) async {
    try {
      final response = await _apiService.get<List<dynamic>>(
        '/api/compras',
        queryParameters: {'usuarioId': usuarioId},
      );

      if (response.success && response.data != null) {
        final compras = (response.data as List)
            .map((item) => CompraListModel.fromMap(item as Map<String, dynamic>))
            .toList();
        
        return ApiResponse.success(
          data: compras,
          message: 'Compras obtenidas exitosamente',
        );
      } else {
        return ApiResponse.error(
          message: response.message ?? 'Error al obtener las compras',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error(
        message: 'Error inesperado al obtener compras: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Lista compras por rango de fechas
  Future<ApiResponse<List<CompraListModel>>> listarPorFechas({
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required int usuarioId,
  }) async {
    try {
      final response = await _apiService.get<List<dynamic>>(
        '/api/compras/por-fechas',
        queryParameters: {
          'fechaInicio': fechaInicio.toIso8601String(),
          'fechaFin': fechaFin.toIso8601String(),
          'usuarioId': usuarioId,
        },
      );

      if (response.success && response.data != null) {
        final compras = (response.data as List)
            .map((item) => CompraListModel.fromMap(item as Map<String, dynamic>))
            .toList();
        
        return ApiResponse.success(
          data: compras,
          message: 'Compras obtenidas exitosamente',
        );
      } else {
        return ApiResponse.error(
          message: response.message ?? 'Error al obtener las compras',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error(
        message: 'Error inesperado al obtener compras: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Lista compras por proveedor
  Future<ApiResponse<List<CompraListModel>>> listarPorProveedor({
    required int proveedorId,
    required int usuarioId,
  }) async {
    try {
      final response = await _apiService.get<List<dynamic>>(
        '/api/compras/por-proveedor/$proveedorId',
        queryParameters: {'usuarioId': usuarioId},
      );

      if (response.success && response.data != null) {
        final compras = (response.data as List)
            .map((item) => CompraListModel.fromMap(item as Map<String, dynamic>))
            .toList();
        
        return ApiResponse.success(
          data: compras,
          message: 'Compras obtenidas exitosamente',
        );
      } else {
        return ApiResponse.error(
          message: response.message ?? 'Error al obtener las compras',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error(
        message: 'Error inesperado al obtener compras: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Lista compras con filtros
  Future<ApiResponse<List<CompraListModel>>> listarConFiltros({
    required CompraFiltrosRequest filtros,
    required int usuarioId,
  }) async {
    try {
      final response = await _apiService.post<List<dynamic>>(
        '/api/compras/filtrar',
        data: filtros.toMap(),
        queryParameters: {'usuarioId': usuarioId},
      );

      if (response.success && response.data != null) {
        final compras = (response.data as List)
            .map((item) => CompraListModel.fromMap(item as Map<String, dynamic>))
            .toList();
        
        return ApiResponse.success(
          data: compras,
          message: 'Compras obtenidas exitosamente',
        );
      } else {
        return ApiResponse.error(
          message: response.message ?? 'Error al obtener las compras',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error(
        message: 'Error inesperado al obtener compras: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Anula una compra
  Future<ApiResponse<bool>> anularCompra(AnularCompraRequest request) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/api/compras/anular',
        data: request.toMap(),
      );

      if (response.success) {
        return ApiResponse.success(
          data: true,
          message: 'Compra anulada exitosamente',
        );
      } else {
        return ApiResponse.error(
          message: response.message ?? 'Error al anular la compra',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error(
        message: 'Error inesperado al anular compra: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Obtiene resumen de compras por período
  Future<ApiResponse<CompraResumenModel>> obtenerResumen({
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required int usuarioId,
  }) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        '/api/compras/resumen',
        queryParameters: {
          'fechaInicio': fechaInicio.toIso8601String(),
          'fechaFin': fechaFin.toIso8601String(),
          'usuarioId': usuarioId,
        },
      );

      if (response.success && response.data != null) {
        final resumen = CompraResumenModel.fromMap(response.data!);
        return ApiResponse.success(
          data: resumen,
          message: 'Resumen obtenido exitosamente',
        );
      } else {
        return ApiResponse.error(
          message: response.message ?? 'Error al obtener el resumen',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error(
        message: 'Error inesperado al obtener resumen: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Obtiene top productos comprados
  Future<ApiResponse<List<TopProductoCompradoModel>>> obtenerTopProductos({
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required int usuarioId,
  }) async {
    try {
      final response = await _apiService.get<List<dynamic>>(
        '/api/compras/top-productos',
        queryParameters: {
          'fechaInicio': fechaInicio.toIso8601String(),
          'fechaFin': fechaFin.toIso8601String(),
          'usuarioId': usuarioId,
        },
      );

      if (response.success && response.data != null) {
        final productos = (response.data as List)
            .map((item) => TopProductoCompradoModel.fromMap(item as Map<String, dynamic>))
            .toList();
        
        return ApiResponse.success(
          data: productos,
          message: 'Top productos obtenidos exitosamente',
        );
      } else {
        return ApiResponse.error(
          message: response.message ?? 'Error al obtener los top productos',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error(
        message: 'Error inesperado al obtener top productos: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Valida permisos del usuario
  Future<ApiResponse<bool>> validarPermisos(int usuarioId) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        '/api/compras/validar-permisos/$usuarioId',
      );

      if (response.success && response.data != null) {
        final tienePermisos = response.data!['tienePermisos'] ?? false;
        return ApiResponse.success(
          data: tienePermisos,
          message: 'Permisos validados exitosamente',
        );
      } else {
        return ApiResponse.error(
          message: response.message ?? 'Error al validar permisos',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error(
        message: 'Error inesperado al validar permisos: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Calcula el total de una compra basado en los detalles
  double calcularTotal(List<CrearDetalleCompraRequest> detalles) {
    return detalles.fold(0.0, (total, detalle) => total + detalle.subtotal);
  }

  /// Valida que una compra tenga al menos un detalle
  bool validarDetalles(List<CrearDetalleCompraRequest> detalles) {
    return detalles.isNotEmpty && detalles.every((detalle) => detalle.cantidad > 0 && detalle.precioUnitario > 0);
  }

  /// Crea un detalle de compra
  CrearDetalleCompraRequest crearDetalle({
    required int detalleProductoId,
    required int cantidad,
    required double precioUnitario,
  }) {
    return CrearDetalleCompraRequest(
      detalleProductoId: detalleProductoId,
      cantidad: cantidad,
      precioUnitario: precioUnitario,
      subtotal: cantidad * precioUnitario,
    );
  }
}
