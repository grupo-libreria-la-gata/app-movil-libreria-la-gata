import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/app_config.dart';
import '../../../core/design/design_tokens.dart';
import '../../../core/services/error_service.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/loading_widgets.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> with LoadingMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  bool _acceptNewsletter = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate() && _acceptTerms) {
      await executeWithErrorHandling(() async {
        // Simular proceso de registro
        await Future.delayed(const Duration(seconds: 2));
        
        // TODO: Implementar lógica de registro real
        ErrorService().showWarningSnackBar(
          context, 
          'Funcionalidad de registro en desarrollo'
        );
      });
    } else if (!_acceptTerms) {
      ErrorService().showErrorSnackBar(
        context, 
        'Debes aceptar los términos y condiciones'
      );
    }
  }

  void _handleGoogleRegister() async {
    await executeWithErrorHandling(() async {
      // Simular registro con Google
      await Future.delayed(const Duration(seconds: 2));
      
      // TODO: Implementar registro con Google
      ErrorService().showWarningSnackBar(
        context, 
        'Registro con Google en desarrollo'
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Escuchar cambios en el estado de autenticación
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isAuthenticated && !next.isLoading) {
        // Redirigir al dashboard después del registro exitoso
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
      appBar: AppBar(
        title: Text('Crear Cuenta', style: TextStyle(color: DesignTokens.textPrimaryColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: DesignTokens.primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                _buildHeader(),
                const SizedBox(height: 32),
                
                // Formulario de registro
                _buildRegisterForm(),
                const SizedBox(height: 24),
                
                // Términos y condiciones
                _buildTermsSection(),
                const SizedBox(height: 24),
                
                // Botón de registro
                _buildRegisterButton(),
                const SizedBox(height: 16),
                
                // Divider
                _buildDivider(),
                const SizedBox(height: 16),
                
                // Botón de Google
                _buildGoogleButton(),
                const SizedBox(height: 32),
                
                // Enlace a login
                _buildLoginLink(),
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
          'Únete a La Gata',
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
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      children: [
        // Campo de nombre
        TextFormField(
          controller: _nameController,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: 'Nombre completo',
            hintText: 'Juan Pérez',
            prefixIcon: const Icon(Icons.person_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          validator: (value) {
            return ErrorService().getFieldError('name', value ?? '');
          },
        ),
        const SizedBox(height: 16),
        
        // Campo de email
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Correo electrónico',
            hintText: 'juan@ejemplo.com',
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          validator: (value) {
            return ErrorService().getFieldError('email', value ?? '');
          },
        ),
        const SizedBox(height: 16),
        
        // Campo de teléfono
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Teléfono (opcional)',
            hintText: '+505 8888-8888',
            prefixIcon: const Icon(Icons.phone_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
        const SizedBox(height: 16),
        
        // Campo de contraseña
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Contraseña',
            hintText: 'Mínimo 8 caracteres',
            prefixIcon: const Icon(Icons.lock_outlined),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          validator: (value) {
            return ErrorService().getFieldError('password', value ?? '');
          },
        ),
        const SizedBox(height: 16),
        
        // Campo de confirmar contraseña
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          decoration: InputDecoration(
            labelText: 'Confirmar contraseña',
            hintText: 'Repite tu contraseña',
            prefixIcon: const Icon(Icons.lock_outlined),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor confirma tu contraseña';
            }
            if (value != _passwordController.text) {
              return 'Las contraseñas no coinciden';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTermsSection() {
    return Column(
      children: [
        // Términos y condiciones
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: _acceptTerms,
              onChanged: (value) {
                setState(() {
                  _acceptTerms = value ?? false;
                });
              },
              activeColor: const Color(AppConfig.primaryColor),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                      children: [
                        const TextSpan(text: 'Acepto los '),
                        TextSpan(
                          text: 'Términos y Condiciones',
                          style: const TextStyle(
                            color: Color(AppConfig.primaryColor),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(text: ' y la '),
                        TextSpan(
                          text: 'Política de Privacidad',
                          style: const TextStyle(
                            color: Color(AppConfig.primaryColor),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Newsletter
        Row(
          children: [
            Checkbox(
              value: _acceptNewsletter,
              onChanged: (value) {
                setState(() {
                  _acceptNewsletter = value ?? false;
                });
              },
              activeColor: const Color(AppConfig.primaryColor),
            ),
            Expanded(
              child: Text(
                'Recibir notificaciones sobre eventos y ofertas especiales',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return LoadingButton(
      onPressed: _handleRegister,
      isLoading: loadingState.isLoading,
      text: 'Crear Cuenta',
      backgroundColor: DesignTokens.primaryColor,
      textColor: Colors.white,
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey[300],
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'o regístrate con',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey[300],
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return SizedBox(
      height: 50,
      child: OutlinedButton.icon(
        onPressed: loadingState.isLoading ? null : _handleGoogleRegister,
        icon: Image.network(
          'https://developers.google.com/identity/images/g-logo.png',
          height: 20,
          width: 20,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.g_mobiledata, size: 20);
          },
        ),
        label: const Text(
          'Registrarse con Google',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.grey[800],
          side: BorderSide(color: Colors.grey[300]!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿Ya tienes una cuenta? ',
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        TextButton(
          onPressed: () => context.go('/login'),
          child: const Text(
            'Inicia sesión aquí',
            style: TextStyle(
              color: Color(AppConfig.primaryColor),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
