import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';

/// Estado de autenticación
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final bool isGuest;
  final User? user;
  final String? error;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.isGuest = false,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    bool? isGuest,
    User? user,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      isGuest: isGuest ?? this.isGuest,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}

/// Provider para el estado de autenticación
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

/// Notifier para manejar la autenticación
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  /// Iniciar sesión con email y contraseña
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Simular usuario autenticado con datos reales
      final user = User(
        id: '1', // ID numérico como string para compatibilidad
        name: 'Juan López', // Nombre real del usuario
        email: email,
        phone: '+505 8888 8888',
        role: UserRole.seller,
        createdAt: DateTime.now(),
      );

      state = state.copyWith(
        isAuthenticated: true,
        isGuest: false,
        user: user,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Registrar nuevo usuario
  Future<void> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Simulación de registro - implementar cuando la API esté lista
      await Future.delayed(const Duration(seconds: 2)); // Simulación

      // Simular usuario registrado
      final user = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        phone: null,
        role: UserRole.seller,
        createdAt: DateTime.now(),
      );

      state = state.copyWith(
        isAuthenticated: true,
        isGuest: false,
        user: user,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Iniciar sesión como invitado
  Future<void> signInAsGuest() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulación

      // Usuario invitado sin datos completos
      final guestUser = User(
        id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Invitado',
        email: 'guest@lagata.com',
        phone: null,
        role: UserRole.cashier,
        createdAt: DateTime.now(),
      );

      state = state.copyWith(
        isAuthenticated: true,
        isGuest: true,
        user: guestUser,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Cerrar sesión
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);

    try {
      // Simulación de cierre de sesión - implementar cuando la API esté lista
      await Future.delayed(const Duration(seconds: 1)); // Simulación

      state = const AuthState();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Enviar email de recuperación de contraseña
  Future<void> sendPasswordResetEmail(String email) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Simulación de envío de email - implementar cuando la API esté lista
      await Future.delayed(const Duration(seconds: 2)); // Simulación

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Limpiar error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Verificar token guardado
  Future<void> checkAuthStatus() async {
    state = state.copyWith(isLoading: true);

    try {
      // Simulación de verificación de token - implementar cuando la API esté lista
      await Future.delayed(const Duration(seconds: 1)); // Simulación

      // Por ahora, siempre inicia sin autenticación
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

/// Provider para verificar si el usuario puede realizar acciones
final canPerformActionsProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.isAuthenticated && !authState.isLoading;
});
