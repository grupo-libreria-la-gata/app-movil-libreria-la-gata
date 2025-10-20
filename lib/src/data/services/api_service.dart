import 'dart:io';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/base_model.dart';
import '../../config/app_config.dart';

/// Servicio base para comunicación con API
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  Dio? _dio;
  String? _accessToken;
  String? _refreshToken;

  /// Obtiene el token de acceso (para testing)
  String? get accessToken => _accessToken;

  /// Inicializa el servicio de API
  void initialize() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: Duration(milliseconds: AppConfig.connectionTimeout),
        receiveTimeout: Duration(milliseconds: AppConfig.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Interceptor para manejo de autenticación
    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_accessToken != null) {
            options.headers['Authorization'] = 'Bearer $_accessToken';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            // Token expirado, intentar refrescar
            if (await _refreshAccessToken()) {
              // Reintentar la petición original
              final options = error.requestOptions;
              options.headers['Authorization'] = 'Bearer $_accessToken';
              final response = await _dio!.fetch(options);
              handler.resolve(response);
              return;
            }
          }
          handler.next(error);
        },
      ),
    );

    // Interceptor para logging en desarrollo
    if (AppConfig.appVersion.contains('debug')) {
      _dio!.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (object) => {}, // Removed print for production
        ),
      );
    }
  }

  /// Establece el token de acceso
  void setAccessToken(String token) {
    _accessToken = token;
  }

  /// Establece el token de refresh
  void setRefreshToken(String token) {
    _refreshToken = token;
  }

  /// Limpia los tokens
  void clearTokens() {
    _accessToken = null;
    _refreshToken = null;
  }

  /// Verifica la conectividad
  Future<bool> hasInternetConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      return false;
    }
  }

  /// Refresca el token de acceso
  Future<bool> _refreshAccessToken() async {
    if (_refreshToken == null) return false;
    if (_dio == null) return false;

    try {
      final response = await _dio!.post(
        '/auth/refresh',
        data: {'refreshToken': _refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        _accessToken = data['accessToken'];
        _refreshToken = data['refreshToken'];
        return true;
      }
    } catch (e) {
      clearTokens();
    }
    return false;
  }

  /// Realiza una petición GET
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      if (_dio == null) {
        initialize();
      }

      if (!await hasInternetConnection()) {
        return ApiResponse.error(
          message: 'Sin conexión a internet',
          statusCode: 0,
        );
      }

      final response = await _dio!.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return _handleResponse<T>(response);
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    } catch (e) {
      return ApiResponse.error(
        message: 'Error inesperado: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Realiza una petición POST
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      print('🔍 [DEBUG] ApiService: Iniciando POST a $endpoint');
      print('🔍 [DEBUG] ApiService: URL base: ${AppConfig.baseUrl}');
      print(
        '🔍 [DEBUG] ApiService: URL completa: ${AppConfig.baseUrl}$endpoint',
      );

      if (_dio == null) {
        print('🔍 [DEBUG] ApiService: Inicializando Dio...');
        initialize();
      }

      print('🔍 [DEBUG] ApiService: Verificando conexión a internet...');
      if (!await hasInternetConnection()) {
        print('❌ [DEBUG] ApiService: Sin conexión a internet');
        return ApiResponse.error(
          message: 'Sin conexión a internet',
          statusCode: 0,
        );
      }

      print('🔍 [DEBUG] ApiService: Enviando petición POST...');
      final response = await _dio!.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      print(
        '🔍 [DEBUG] ApiService: Respuesta recibida - Status: ${response.statusCode}',
      );
      return _handleResponse<T>(response);
    } on DioException catch (e) {
      print('❌ [DEBUG] ApiService: DioException capturada: ${e.toString()}');
      print('❌ [DEBUG] ApiService: Error type: ${e.type}');
      print('❌ [DEBUG] ApiService: Error message: ${e.message}');
      print('❌ [DEBUG] ApiService: Response data: ${e.response?.data}');
      return _handleDioError<T>(e);
    } catch (e) {
      return ApiResponse.error(
        message: 'Error inesperado: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Realiza una petición PUT
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      if (_dio == null) {
        initialize();
      }

      if (!await hasInternetConnection()) {
        return ApiResponse.error(
          message: 'Sin conexión a internet',
          statusCode: 0,
        );
      }

      final response = await _dio!.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return _handleResponse<T>(response);
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    } catch (e) {
      return ApiResponse.error(
        message: 'Error inesperado: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Realiza una petición PATCH
  Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      if (_dio == null) {
        initialize();
      }

      if (!await hasInternetConnection()) {
        return ApiResponse.error(
          message: 'Sin conexión a internet',
          statusCode: 0,
        );
      }

      final response = await _dio!.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return _handleResponse<T>(response);
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    } catch (e) {
      return ApiResponse.error(
        message: 'Error inesperado: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Realiza una petición DELETE
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      if (_dio == null) {
        initialize();
      }

      if (!await hasInternetConnection()) {
        return ApiResponse.error(
          message: 'Sin conexión a internet',
          statusCode: 0,
        );
      }

      final response = await _dio!.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return _handleResponse<T>(response);
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    } catch (e) {
      return ApiResponse.error(
        message: 'Error inesperado: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Maneja la respuesta exitosa
  ApiResponse<T> _handleResponse<T>(Response response) {
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return ApiResponse.success(
        data: response.data as T,
        message: response.data['message'],
        metadata: response.data['metadata'],
      );
    } else {
      return ApiResponse.error(
        message: response.data['message'] ?? 'Error en la respuesta',
        statusCode: response.statusCode,
        metadata: response.data['metadata'],
      );
    }
  }

  /// Maneja errores de Dio
  ApiResponse<T> _handleDioError<T>(DioException error) {
    String message;
    int? statusCode;
    List<String>? errors;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Tiempo de espera agotado';
        statusCode = 408;
        break;
      case DioExceptionType.badResponse:
        statusCode = error.response?.statusCode;
        final responseData = error.response?.data;
        if (responseData is Map<String, dynamic>) {
          message = responseData['message'] ?? 'Error del servidor';
          errors = responseData['errors']?.cast<String>();
        } else {
          message = 'Error del servidor';
        }
        break;
      case DioExceptionType.cancel:
        message = 'Petición cancelada';
        statusCode = 499;
        break;
      case DioExceptionType.connectionError:
        message = 'Error de conexión';
        statusCode = 0;
        break;
      case DioExceptionType.badCertificate:
        message = 'Error de certificado';
        statusCode = 495;
        break;
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          message = 'Sin conexión a internet';
          statusCode = 0;
        } else {
          message = 'Error desconocido: ${error.message}';
          statusCode = 500;
        }
        break;
    }

    return ApiResponse.error(
      message: message,
      errors: errors,
      statusCode: statusCode,
    );
  }

  /// Sube un archivo
  Future<ApiResponse<T>> uploadFile<T>(
    String endpoint,
    String filePath, {
    String fieldName = 'file',
    Map<String, dynamic>? additionalData,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      if (_dio == null) {
        initialize();
      }

      if (!await hasInternetConnection()) {
        return ApiResponse.error(
          message: 'Sin conexión a internet',
          statusCode: 0,
        );
      }

      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        ...?additionalData,
      });

      final response = await _dio!.post(
        endpoint,
        data: formData,
        onSendProgress: onSendProgress,
      );

      return _handleResponse<T>(response);
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    } catch (e) {
      return ApiResponse.error(
        message: 'Error al subir archivo: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Descarga un archivo
  Future<ApiResponse<String>> downloadFile(
    String endpoint,
    String savePath, {
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      if (_dio == null) {
        initialize();
      }

      if (!await hasInternetConnection()) {
        return ApiResponse.error(
          message: 'Sin conexión a internet',
          statusCode: 0,
        );
      }

      final response = await _dio!.download(
        endpoint,
        savePath,
        onReceiveProgress: onReceiveProgress,
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(
          data: savePath,
          message: 'Archivo descargado exitosamente',
        );
      } else {
        return ApiResponse.error(
          message: 'Error al descargar archivo',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return _handleDioError<String>(e);
    } catch (e) {
      return ApiResponse.error(
        message: 'Error al descargar archivo: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}
