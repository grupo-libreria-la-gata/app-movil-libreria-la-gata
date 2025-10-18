import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';

/// Provider de autenticación compatible con Provider package
class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  /// Iniciar sesión con email y contraseña
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    _setLoading(true);
    _clearError();
    
    try {
      // TODO: Implementar autenticación real cuando la API esté lista
      await Future.delayed(const Duration(seconds: 2)); // Simulación
      
      // Simular usuario autenticado
      _currentUser = User(
        id: 'user_123',
        name: 'Usuario Demo',
        email: email,
        phone: '+505 8888 8888',
        role: UserRole.seller,
        createdAt: DateTime.now(),
      );
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Registrar nuevo usuario
  Future<void> signUpWithEmailAndPassword(String email, String password, String name) async {
    _setLoading(true);
    _clearError();
    
    try {
      // TODO: Implementar registro real cuando la API esté lista
      await Future.delayed(const Duration(seconds: 2)); // Simulación
      
      // Simular usuario registrado
      _currentUser = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        phone: null,
        role: UserRole.seller,
        createdAt: DateTime.now(),
      );
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Iniciar sesión como invitado
  Future<void> signInAsGuest() async {
    _setLoading(true);
    _clearError();
    
    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulación
      
      // Usuario invitado sin datos completos
      _currentUser = User(
        id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Invitado',
        email: 'guest@lagata.com',
        phone: null,
        role: UserRole.cashier,
        createdAt: DateTime.now(),
      );
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Cerrar sesión
  Future<void> signOut() async {
    _setLoading(true);
    
    try {
      // TODO: Implementar cierre de sesión real cuando la API esté lista
      await Future.delayed(const Duration(seconds: 1)); // Simulación
      
      _currentUser = null;
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Enviar email de recuperación de contraseña
  Future<void> sendPasswordResetEmail(String email) async {
    _setLoading(true);
    _clearError();
    
    try {
      // TODO: Implementar envío de email real cuando la API esté lista
      await Future.delayed(const Duration(seconds: 2)); // Simulación
      
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Verificar token guardado
  Future<void> checkAuthStatus() async {
    _setLoading(true);
    
    try {
      // TODO: Verificar token guardado cuando la API esté lista
      await Future.delayed(const Duration(seconds: 1)); // Simulación
      
      // Por ahora, siempre inicia sin autenticación
      _currentUser = null;
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Limpiar error
  void clearError() {
    _clearError();
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
