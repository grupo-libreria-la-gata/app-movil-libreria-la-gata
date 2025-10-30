import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design/design_tokens.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  bool _isLoading = false;
  bool _codeSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _sendResetCode() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Simular envío de código por email
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _codeSent = true;
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Se ha enviado un código de verificación a su email'),
            backgroundColor: DesignTokens.successColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al enviar el código: $e'),
            backgroundColor: DesignTokens.errorColor,
          ),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _verifyCode() async {
    if (_codeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingrese el código de verificación'),
          backgroundColor: DesignTokens.errorColor,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Simular verificación de código
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Código verificado correctamente. Redirigiendo al login...'),
            backgroundColor: DesignTokens.successColor,
          ),
        );
        
        // Redirigir al login después de 2 segundos
        await Future.delayed(const Duration(seconds: 2));
        context.go('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Código inválido: $e'),
            backgroundColor: DesignTokens.errorColor,
          ),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Parte blanca superior
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: DesignTokens.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.local_bar, // Icono de copita para licorería
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Nombre de la app
                      const Text(
                        'LA GATA',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: DesignTokens.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Parte amarilla inferior
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: DesignTokens.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título
                      Text(
                        _codeSent ? 'Verificar Código' : '¿Olvidaste tu contraseña?',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: DesignTokens.surfaceColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _codeSent 
                          ? 'Ingresa el código de verificación que enviamos a tu email'
                          : 'Ingresa tu email registrado y te enviaremos un código de verificación',
                        style: const TextStyle(
                          fontSize: 13,
                          color: DesignTokens.surfaceColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Formulario
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            if (!_codeSent) ...[
                            // Email
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Correo Electrónico',
                                  style: TextStyle(
                                    color: DesignTokens.surfaceColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 15,
                                    ),
                                  decoration: InputDecoration(
                                      hintText: 'admin@lagata.com',
                                      hintStyle: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 15,
                                      ),
                                    filled: true,
                                    fillColor: DesignTokens.surfaceColor,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                        vertical: 14,
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.email_outlined,
                                        color: Colors.grey,
                                        size: 18,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingrese su email';
                                    }
                                    if (!value.contains('@')) {
                                      return 'Por favor ingrese un email válido';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                            ] else ...[
                              // Código de verificación
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Código de Verificación',
                                    style: TextStyle(
                                      color: DesignTokens.surfaceColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _codeController,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 6,
                                      color: Colors.black87,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: '123456',
                                      hintStyle: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 20,
                                        letterSpacing: 6,
                                      ),
                                      filled: true,
                                      fillColor: DesignTokens.surfaceColor,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 14,
                                      ),
                                    ),
                                    maxLength: 6,
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 20),
                            // Send/Verify Button
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : (_codeSent ? _verifyCode : _sendResetCode),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: DesignTokens.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  elevation: 6,
                                  shadowColor: Colors.black.withValues(alpha: 0.15),
                                ),
                                child: _isLoading
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: DesignTokens.primaryColor,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        _codeSent ? 'VERIFICAR' : 'ENVIAR CÓDIGO',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Back to Login link
                            Center(
                              child: TextButton(
                                    onPressed: () {
                                  context.go('/login');
                                    },
                                    child: const Text(
                                  '¿Recordaste tu contraseña? Iniciar sesión',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            if (_codeSent) ...[
                              const SizedBox(height: 16),
                              // Resend code button
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _codeSent = false;
                                      _codeController.clear();
                                    });
                                  },
                                  child: const Text(
                                    '¿No recibiste el código? Reenviar',
                                    style: TextStyle(
                                      color: DesignTokens.surfaceColor,
                                      fontSize: 12,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
