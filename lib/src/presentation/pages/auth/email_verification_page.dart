import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/app_config.dart';
import '../../../core/design/design_tokens.dart';

class EmailVerificationPage extends StatefulWidget {
  final String email;

  const EmailVerificationPage({super.key, required this.email});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  bool _isLoading = false;
  bool _emailVerified = false;
  int _resendCountdown = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendCountdown();
  }

  void _startResendCountdown() {
    _resendCountdown = 60;
    _canResend = false;
    _updateCountdown();
  }

  void _updateCountdown() {
    if (_resendCountdown > 0) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _resendCountdown--;
          });
          _updateCountdown();
        }
      });
    } else {
      setState(() {
        _canResend = true;
      });
    }
  }

  void _handleResendEmail() {
    setState(() {
      _isLoading = true;
    });

    // Simular reenvío
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      _startResendCountdown();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email de verificación reenviado'),
            backgroundColor: DesignTokens.successColor,
          ),
        );
      }
    });
  }

  void _handleVerifyEmail() {
    setState(() {
      _isLoading = true;
    });

    // Simular verificación
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        _emailVerified = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Email verificado correctamente!'),
            backgroundColor: DesignTokens.successColor,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Verificar Email',
          style: TextStyle(color: DesignTokens.textPrimaryColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: DesignTokens.primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // Header
              _buildHeader(),
              const SizedBox(height: 32),

              // Contenido principal
              _emailVerified
                  ? _buildVerifiedContent()
                  : _buildVerificationContent(),
              const SizedBox(height: 32),

              // Enlaces adicionales
              _buildAdditionalLinks(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Icono
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: _emailVerified
                ? DesignTokens.successColor.withValues(alpha: 0.2)
                : const Color(AppConfig.primaryColor).withAlpha(25),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            _emailVerified ? Icons.verified : Icons.mark_email_unread,
            size: 40,
            color: _emailVerified
                ? DesignTokens.successColor
                : const Color(AppConfig.primaryColor),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _emailVerified ? '¡Email Verificado!' : 'Verifica tu Email',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: _emailVerified
                ? DesignTokens.successColor
                : const Color(AppConfig.primaryColor),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _emailVerified
              ? 'Tu cuenta ha sido verificada correctamente'
              : 'Hemos enviado un enlace de verificación a tu correo',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: DesignTokens.textSecondaryColor),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildVerificationContent() {
    return Column(
      children: [
        // Email mostrado
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: DesignTokens.infoColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: DesignTokens.infoColor.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.email_outlined, color: DesignTokens.infoColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email enviado a:',
                      style: TextStyle(
                        color: DesignTokens.infoColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      widget.email,
                      style: TextStyle(
                        color: DesignTokens.infoColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Instrucciones
        _buildInstructionsCard(),
        const SizedBox(height: 24),

        // Botones de acción
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleVerifyEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(AppConfig.primaryColor),
                    foregroundColor: DesignTokens.textInverseColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              DesignTokens.textInverseColor,
                            ),
                          ),
                        )
                      : const Text(
                          'Ya verifiqué',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 50,
                child: OutlinedButton(
                  onPressed: (_isLoading || !_canResend)
                      ? null
                      : _handleResendEmail,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(AppConfig.primaryColor),
                    side: const BorderSide(
                      color: Color(AppConfig.primaryColor),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(AppConfig.primaryColor),
                            ),
                          ),
                        )
                      : Text(
                          _canResend
                              ? 'Reenviar'
                              : 'Reenviar ($_resendCountdown)',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVerifiedContent() {
    return Column(
      children: [
        // Mensaje de confirmación
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: DesignTokens.successColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: DesignTokens.successColor.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: DesignTokens.successColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '¡Verificación exitosa!',
                      style: TextStyle(
                        color: DesignTokens.successColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Tu cuenta ha sido verificada correctamente. Ya puedes acceder a todas las funcionalidades de AveTurismo.',
                style: TextStyle(color: DesignTokens.successColor, fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Botón para continuar
        SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () => context.go('/'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(AppConfig.primaryColor),
              foregroundColor: DesignTokens.textInverseColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Continuar',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DesignTokens.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DesignTokens.borderLightColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pasos para verificar tu email:',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: DesignTokens.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 12),
          _buildInstructionItem(
            '1. Revisa tu bandeja de entrada',
            Icons.inbox_outlined,
          ),
          _buildInstructionItem(
            '2. Busca el email de AveTurismo',
            Icons.search_outlined,
          ),
          _buildInstructionItem(
            '3. Haz clic en el enlace de verificación',
            Icons.link_outlined,
          ),
          _buildInstructionItem(
            '4. Regresa a la app y presiona "Ya verifiqué"',
            Icons.check_circle_outline,
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionItem(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: DesignTokens.textSecondaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: DesignTokens.textSecondaryColor, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalLinks() {
    return Column(
      children: [
        TextButton(
          onPressed: () => context.go('/login'),
          child: const Text(
            'Volver al inicio de sesión',
            style: TextStyle(
              color: Color(AppConfig.primaryColor),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => context.go('/forgot-password'),
          child: Text(
            '¿Problemas con la verificación?',
            style: TextStyle(
              color: DesignTokens.textSecondaryColor,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
