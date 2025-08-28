import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';

/// Estado de autenticación de la aplicación
class AuthState {
  final bool isAuthenticated;
  final bool isGuest;
  final User? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.isAuthenticated = false,
    this.isGuest = false,
    this.user,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isGuest,
    User? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isGuest: isGuest ?? this.isGuest,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  /// Verificar si el usuario puede realizar acciones completas
  bool get canPerformActions => isAuthenticated && !isGuest;
  
  /// Verificar si el usuario puede solo ver contenido
  bool get canViewContent => isAuthenticated || isGuest;
}

/// Provider para manejar la autenticación
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  /// Iniciar sesión con email y contraseña
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // TODO: Implementar autenticación real cuando la API esté lista
      await Future.delayed(const Duration(seconds: 2)); // Simulación
      
      // Simular usuario autenticado
      final user = User(
        userId: 'user_123',
        nombre: 'Usuario Demo',
        email: email,
        phone: '+505 8888 8888',
        roleId: 1,
        isVerified: true,
        createdAt: DateTime.now(),
      );
      
      state = state.copyWith(
        isAuthenticated: true,
        isGuest: false,
        user: user,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Registrar nuevo usuario
  Future<void> signUpWithEmailAndPassword(String email, String password, String name) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // TODO: Implementar registro real cuando la API esté lista
      await Future.delayed(const Duration(seconds: 2)); // Simulación
      
      // Simular usuario registrado
      final user = User(
        userId: 'user_${DateTime.now().millisecondsSinceEpoch}',
        nombre: name,
        email: email,
        phone: null,
        roleId: 1,
        isVerified: false,
        createdAt: DateTime.now(),
      );
      
      state = state.copyWith(
        isAuthenticated: true,
        isGuest: false,
        user: user,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Iniciar sesión como invitado
  Future<void> signInAsGuest() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulación
      
      // Usuario invitado sin datos completos
      final guestUser = User(
        userId: 'guest_${DateTime.now().millisecondsSinceEpoch}',
        nombre: 'Invitado',
        email: 'guest@aveturismo.com',
        phone: null,
        roleId: 2,
        isVerified: false,
        createdAt: DateTime.now(),
      );
      
      state = state.copyWith(
        isAuthenticated: true,
        isGuest: true,
        user: guestUser,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Cerrar sesión
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // TODO: Implementar cierre de sesión real cuando la API esté lista
      await Future.delayed(const Duration(seconds: 1)); // Simulación
      
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Enviar email de recuperación de contraseña
  Future<void> sendPasswordResetEmail(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // TODO: Implementar envío de email real cuando la API esté lista
      await Future.delayed(const Duration(seconds: 2)); // Simulación
      
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Limpiar error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Verificar si el usuario está autenticado al iniciar la app
  Future<void> checkAuthStatus() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // TODO: Verificar token guardado cuando la API esté lista
      await Future.delayed(const Duration(seconds: 1)); // Simulación
      
      // Por ahora, siempre redirigir al login
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

/// Provider de autenticación
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

/// Provider para verificar si el usuario puede realizar acciones
final canPerformActionsProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.canPerformActions;
});

/// Provider para verificar si el usuario puede ver contenido
final canViewContentProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.canViewContent;
});
