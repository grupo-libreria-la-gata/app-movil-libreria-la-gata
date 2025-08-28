import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Servicio para manejo de errores y conectividad
class ErrorService {
  static final ErrorService _instance = ErrorService._internal();
  factory ErrorService() => _instance;
  ErrorService._internal();

  /// Verifica si hay conexión a internet
  Future<bool> isConnected() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      return false;
    }
  }

  /// Escucha cambios en la conectividad
  Stream<ConnectivityResult> get connectivityStream {
    return Connectivity().onConnectivityChanged;
  }

  /// Maneja errores de red
  String handleNetworkError(dynamic error) {
    if (error.toString().contains('SocketException') ||
        error.toString().contains('NetworkException')) {
      return 'Error de conexión. Verifica tu conexión a internet.';
    }
    
    if (error.toString().contains('TimeoutException')) {
      return 'Tiempo de espera agotado. Intenta nuevamente.';
    }
    
    if (error.toString().contains('HttpException')) {
      return 'Error del servidor. Intenta más tarde.';
    }
    
    return 'Error inesperado. Intenta nuevamente.';
  }

  /// Maneja errores de validación
  String handleValidationError(String field, String error) {
    switch (field.toLowerCase()) {
      case 'email':
        if (error.contains('empty')) return 'El email es requerido';
        if (error.contains('invalid')) return 'Ingresa un email válido';
        break;
      case 'password':
        if (error.contains('empty')) return 'La contraseña es requerida';
        if (error.contains('short')) return 'La contraseña debe tener al menos 6 caracteres';
        break;
      case 'name':
        if (error.contains('empty')) return 'El nombre es requerido';
        if (error.contains('short')) return 'El nombre debe tener al menos 2 caracteres';
        break;
      case 'phone':
        if (error.contains('empty')) return 'El teléfono es requerido';
        if (error.contains('invalid')) return 'Ingresa un teléfono válido';
        break;
      case 'price':
        if (error.contains('empty')) return 'El precio es requerido';
        if (error.contains('invalid')) return 'Ingresa un precio válido';
        if (error.contains('negative')) return 'El precio debe ser mayor a 0';
        break;
      case 'stock':
        if (error.contains('empty')) return 'El stock es requerido';
        if (error.contains('invalid')) return 'Ingresa un número válido';
        if (error.contains('negative')) return 'El stock no puede ser negativo';
        break;
      case 'quantity':
        if (error.contains('empty')) return 'La cantidad es requerida';
        if (error.contains('invalid')) return 'Ingresa un número válido';
        if (error.contains('zero')) return 'La cantidad debe ser mayor a 0';
        break;
    }
    return error;
  }

  /// Muestra un snackbar de error
  void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: SnackBarAction(
          label: 'Cerrar',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Muestra un snackbar de éxito
  void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: SnackBarAction(
          label: 'Cerrar',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Muestra un snackbar de advertencia
  void showWarningSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_outlined, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: SnackBarAction(
          label: 'Cerrar',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Muestra un snackbar de información
  void showInfoSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: SnackBarAction(
          label: 'Cerrar',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Valida email
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Valida teléfono
  bool isValidPhone(String phone) {
    // Acepta formatos: +505 8888 8888, 8888 8888, 88888888
    return RegExp(r'^(\+505\s?)?[0-9]{4}\s?[0-9]{4}$').hasMatch(phone);
  }

  /// Valida precio
  bool isValidPrice(String price) {
    final value = double.tryParse(price);
    return value != null && value > 0;
  }

  /// Valida cantidad
  bool isValidQuantity(String quantity) {
    final value = int.tryParse(quantity);
    return value != null && value > 0;
  }

  /// Valida stock
  bool isValidStock(String stock) {
    final value = int.tryParse(stock);
    return value != null && value >= 0;
  }

  /// Formatea teléfono
  String formatPhone(String phone) {
    // Remueve todos los caracteres no numéricos
    final numbers = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    if (numbers.length == 8) {
      return '+505 ${numbers.substring(0, 4)} ${numbers.substring(4)}';
    }
    
    return phone;
  }

  /// Formatea precio
  String formatPrice(double price) {
    return '₡${price.toStringAsFixed(0)}';
  }

  /// Formatea cantidad
  String formatQuantity(int quantity) {
    return quantity.toString();
  }

  /// Obtiene el mensaje de error para un campo específico
  String? getFieldError(String field, String value) {
    switch (field.toLowerCase()) {
      case 'email':
        if (value.isEmpty) return 'El email es requerido';
        if (!isValidEmail(value)) return 'Ingresa un email válido';
        break;
      case 'password':
        if (value.isEmpty) return 'La contraseña es requerida';
        if (value.length < 6) return 'La contraseña debe tener al menos 6 caracteres';
        break;
      case 'name':
        if (value.isEmpty) return 'El nombre es requerido';
        if (value.length < 2) return 'El nombre debe tener al menos 2 caracteres';
        break;
      case 'phone':
        if (value.isEmpty) return 'El teléfono es requerido';
        if (!isValidPhone(value)) return 'Ingresa un teléfono válido';
        break;
      case 'price':
        if (value.isEmpty) return 'El precio es requerido';
        if (!isValidPrice(value)) return 'Ingresa un precio válido';
        break;
      case 'stock':
        if (value.isEmpty) return 'El stock es requerido';
        if (!isValidStock(value)) return 'Ingresa un número válido';
        break;
      case 'quantity':
        if (value.isEmpty) return 'La cantidad es requerida';
        if (!isValidQuantity(value)) return 'Ingresa un número válido';
        break;
    }
    return null;
  }
}

/// Clase para manejar estados de carga y error
class LoadingState {
  final bool isLoading;
  final String? error;
  final bool isOffline;

  const LoadingState({
    this.isLoading = false,
    this.error,
    this.isOffline = false,
  });

  LoadingState copyWith({
    bool? isLoading,
    String? error,
    bool? isOffline,
  }) {
    return LoadingState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isOffline: isOffline ?? this.isOffline,
    );
  }

  bool get hasError => error != null;
  bool get isOnline => !isOffline;
}

/// Mixin para manejar estados de carga
mixin LoadingMixin<T extends StatefulWidget> on State<T> {
  LoadingState _loadingState = const LoadingState();

  LoadingState get loadingState => _loadingState;

  void setLoading(bool isLoading) {
    setState(() {
      _loadingState = _loadingState.copyWith(isLoading: isLoading);
    });
  }

  void setError(String? error) {
    setState(() {
      _loadingState = _loadingState.copyWith(error: error, isLoading: false);
    });
  }

  void setOffline(bool isOffline) {
    setState(() {
      _loadingState = _loadingState.copyWith(isOffline: isOffline);
    });
  }

  void clearError() {
    setState(() {
      _loadingState = _loadingState.copyWith(error: null);
    });
  }

  void resetState() {
    setState(() {
      _loadingState = const LoadingState();
    });
  }

  /// Ejecuta una función con manejo de errores
  Future<void> executeWithErrorHandling(Future<void> Function() action) async {
    try {
      setLoading(true);
      clearError();
      
      // Verificar conectividad
      final isConnected = await ErrorService().isConnected();
      if (!isConnected) {
        setOffline(true);
        setError('No hay conexión a internet');
        return;
      }
      
      setOffline(false);
      await action();
    } catch (e) {
      final errorMessage = ErrorService().handleNetworkError(e);
      setError(errorMessage);
    } finally {
      setLoading(false);
    }
  }
}
