import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design/design_tokens.dart';
import '../../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final authNotifier = ref.read(authProvider.notifier);
      authNotifier.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  void _handleGoogleLogin() {
    // TODO: Implementar login con Google cuando esté configurado
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Login con Google en desarrollo'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _handleGuestLogin() {
    final authNotifier = ref.read(authProvider.notifier);
    authNotifier.signInAsGuest();
  }

  @override
  Widget build(BuildContext context) {
    // Escuchar cambios en el estado de autenticación
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isAuthenticated && !next.isLoading) {
        // Redirigir al dashboard después del login exitoso
        context.go('/dashboard');
      }
      
      if (next.error != null) {
        // Mostrar error si existe
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
        // Limpiar el error
        ref.read(authProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: DesignTokens.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                
                // Logo y título
                _buildHeader(),
                const SizedBox(height: 48),
                
                // Formulario de login
                _buildLoginForm(),
                const SizedBox(height: 24),
                
                // Botón de login
                _buildLoginButton(),
                const SizedBox(height: 16),
                
                // Divider
                _buildDivider(),
                const SizedBox(height: 16),
                
                // Botón de Google
                _buildGoogleButton(),
                const SizedBox(height: 16),
                
                // Botón continuar como invitado
                _buildGuestButton(),
                const SizedBox(height: 32),
                
                // Enlaces adicionales
                _buildAdditionalLinks(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo placeholder
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: DesignTokens.primaryGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: DesignTokens.elevatedShadow,
          ),
          child: const Icon(
            Icons.local_bar,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '¡Bienvenido a La Gata!',
          style: TextStyle(
            fontSize: DesignTokens.fontSize3xl,
            fontWeight: DesignTokens.fontWeightBold,
            color: DesignTokens.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sistema de Facturación',
          style: TextStyle(
            fontSize: DesignTokens.fontSizeLg,
            color: DesignTokens.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        // Campo de email
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Correo electrónico',
            hintText: 'ejemplo@correo.com',
            prefixIcon: Icon(Icons.email_outlined, color: DesignTokens.textSecondaryColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
              borderSide: BorderSide(color: DesignTokens.dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
              borderSide: BorderSide(color: DesignTokens.dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
              borderSide: BorderSide(color: DesignTokens.primaryColor, width: 2),
            ),
            filled: true,
            fillColor: DesignTokens.cardColor,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa tu correo electrónico';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Por favor ingresa un correo electrónico válido';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Campo de contraseña
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Contraseña',
            hintText: 'Ingresa tu contraseña',
            prefixIcon: Icon(Icons.lock_outlined, color: DesignTokens.textSecondaryColor),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                color: DesignTokens.textSecondaryColor,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
              borderSide: BorderSide(color: DesignTokens.dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
              borderSide: BorderSide(color: DesignTokens.dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
              borderSide: BorderSide(color: DesignTokens.primaryColor, width: 2),
            ),
            filled: true,
            fillColor: DesignTokens.cardColor,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa tu contraseña';
            }
            if (value.length < 6) {
              return 'La contraseña debe tener al menos 6 caracteres';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Recordar contraseña y olvidé contraseña
        Row(
          children: [
            // Checkbox recordar
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                  activeColor: DesignTokens.primaryColor,
                ),
                const Text('Recordarme'),
              ],
            ),
            const Spacer(),
            // Enlace olvidé contraseña
            TextButton(
              onPressed: () => context.go('/forgot-password'),
              child: Text(
                '¿Olvidaste tu contraseña?',
                style: TextStyle(
                  color: DesignTokens.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    final authState = ref.watch(authProvider);
    
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: authState.isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: DesignTokens.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
          ),
        ),
        child: authState.isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Iniciar Sesión',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: DesignTokens.dividerColor,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'o continúa con',
            style: TextStyle(
              color: DesignTokens.textSecondaryColor,
              fontSize: DesignTokens.fontSizeSm,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: DesignTokens.dividerColor,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleButton() {
    final authState = ref.watch(authProvider);
    
    return SizedBox(
      height: 50,
      child: OutlinedButton.icon(
        onPressed: authState.isLoading ? null : _handleGoogleLogin,
        icon: Image.network(
          'https://developers.google.com/identity/images/g-logo.png',
          height: 20,
          width: 20,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.g_mobiledata, size: 20);
          },
        ),
        label: const Text(
          'Continuar con Google',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: DesignTokens.textPrimaryColor,
          side: BorderSide(color: DesignTokens.dividerColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
          ),
        ),
      ),
    );
  }

  Widget _buildGuestButton() {
    final authState = ref.watch(authProvider);
    
    return SizedBox(
      height: 50,
      child: TextButton.icon(
        onPressed: authState.isLoading ? null : _handleGuestLogin,
        icon: const Icon(Icons.person_outline),
        label: const Text('Continuar como invitado'),
        style: TextButton.styleFrom(
          foregroundColor: DesignTokens.textSecondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalLinks() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¿No tienes una cuenta? ',
              style: TextStyle(
                color: DesignTokens.textSecondaryColor,
              ),
            ),
            TextButton(
              onPressed: () => context.go('/register'),
              child: Text(
                'Regístrate aquí',
                style: TextStyle(
                  color: DesignTokens.primaryColor,
                  fontWeight: DesignTokens.fontWeightSemiBold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => context.go('/'),
          child: Text(
            'Continuar como invitado',
            style: TextStyle(
              color: Colors.grey[600],
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
