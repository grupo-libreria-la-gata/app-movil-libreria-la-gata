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
      // Validar credenciales ficticias
      final email = _emailController.text.trim().toLowerCase();
      final password = _passwordController.text;
      
      // Credenciales válidas: cualquier email y contraseña "usuario"
      if (password == 'usuario') {
        final authNotifier = ref.read(authProvider.notifier);
        authNotifier.signInWithEmailAndPassword(email, password);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Credenciales incorrectas. Usa cualquier email y contraseña "usuario"'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
          style: TextStyle(color: DesignTokens.textPrimaryColor),
          decoration: InputDecoration(
            labelText: 'Correo electrónico',
            labelStyle: TextStyle(color: DesignTokens.textPrimaryColor),
            hintText: 'ejemplo@correo.com',
            hintStyle: TextStyle(color: DesignTokens.textSecondaryColor),
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
          style: TextStyle(color: DesignTokens.textPrimaryColor),
          decoration: InputDecoration(
            labelText: 'Contraseña',
            labelStyle: TextStyle(color: DesignTokens.textPrimaryColor),
            hintText: 'Ingresa tu contraseña',
            hintStyle: TextStyle(color: DesignTokens.textSecondaryColor),
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
        
        // Recordar contraseña
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

  Widget _buildAdditionalLinks() {
    return Column(
      children: [
        TextButton(
          onPressed: () => context.go('/forgot-password'),
          child: Text(
            '¿Olvidaste tu contraseña?',
            style: TextStyle(
              color: DesignTokens.primaryColor,
              fontWeight: DesignTokens.fontWeightMedium,
            ),
          ),
        ),
      ],
    );
  }
}
