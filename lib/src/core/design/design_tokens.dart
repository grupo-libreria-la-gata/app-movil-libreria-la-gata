import 'package:flutter/material.dart';

/// Design Tokens para La Gata - Sistema de Facturación
/// 
/// Este archivo centraliza todos los elementos de diseño para facilitar
/// la adaptación al diseño final de la diseñadora gráfica.
/// 
/// TODO: Actualizar estos valores según el diseño final del equipo de UX
class DesignTokens {
  // ===== COLORS =====
  
  /// Colores primarios de la marca - Tema licorería mejorado
  static const Color primaryColor = Color(0xFFD4AF37); // Dorado elegante
  static const Color primaryLightColor = Color(0xFFF4E4BC); // Dorado claro suave
  static const Color primaryDarkColor = Color(0xFFB8860B); // Dorado oscuro
  
  /// Colores secundarios/accent
  static const Color accentColor = Color(0xFF8B4513); // Marrón chocolate
  static const Color accentLightColor = Color(0xFFD2691E); // Marrón claro
  static const Color accentDarkColor = Color(0xFF654321); // Marrón oscuro
  
  /// Colores de estado
  static const Color successColor = Color(0xFF2E7D32); // Verde más elegante
  static const Color warningColor = Color(0xFFF57C00); // Naranja vibrante
  static const Color errorColor = Color(0xFFD32F2F); // Rojo más suave
  static const Color infoColor = Color(0xFF1976D2); // Azul profesional
  
  /// Colores neutros - Fondo blanco para páginas principales
  static const Color backgroundColor = Color(0xFFFFFFFF); // Blanco puro
  static const Color surfaceColor = Color(0xFFFFFFFF); // Blanco puro
  static const Color cardColor = Color(0xFFFFFFFF); // Blanco puro
  static const Color dividerColor = Color(0xFFE8E8E8); // Gris muy claro
  
  /// Colores de texto
  static const Color textPrimaryColor = Color(0xFF1A1A1A); // Negro suave
  static const Color textSecondaryColor = Color(0xFF666666); // Gris medio
  static const Color textDisabledColor = Color(0xFFBDBDBD); // Gris claro
  static const Color textOnPrimaryColor = Color(0xFFFFFFFF); // Blanco
  static const Color textOnAccentColor = Color(0xFFFFFFFF); // Blanco
  
  /// Colores de gradientes
  static const Color gradientStartColor = Color(0xFFD4AF37);
  static const Color gradientEndColor = Color(0xFFB8860B);
  
  // ===== TYPOGRAPHY =====
  
  /// Familia de fuentes principal
  static const String fontFamily = 'Poppins'; // TODO: Confirmar con diseñadora
  
  /// Tamaños de fuente
  static const double fontSizeXs = 10.0;
  static const double fontSizeSm = 12.0;
  static const double fontSizeMd = 14.0;
  static const double fontSizeLg = 16.0;
  static const double fontSizeXl = 18.0;
  static const double fontSize2xl = 20.0;
  static const double fontSize3xl = 24.0;
  static const double fontSize4xl = 32.0;
  static const double fontSize5xl = 48.0;
  
  /// Pesos de fuente
  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightNormal = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;
  
  // ===== SPACING =====
  
  /// Espaciado base (4px)
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacing2xl = 48.0;
  static const double spacing3xl = 64.0;
  
  // ===== BORDER RADIUS =====
  
  static const double borderRadiusXs = 4.0;
  static const double borderRadiusSm = 8.0;
  static const double borderRadiusMd = 12.0;
  static const double borderRadiusLg = 16.0;
  static const double borderRadiusXl = 24.0;
  static const double borderRadiusFull = 999.0;
  
  // ===== ELEVATION =====
  
  static const double elevationXs = 1.0;
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;
  static const double elevationXl = 16.0;
  
  // ===== ANIMATION DURATIONS =====
  
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  
  // ===== BREAKPOINTS =====
  
  static const double breakpointSm = 600.0;
  static const double breakpointMd = 900.0;
  static const double breakpointLg = 1200.0;
  static const double breakpointXl = 1536.0;
  
  // ===== CUSTOM VALUES =====
  
  /// Valores específicos para el sistema de facturación
  static const double invoiceCardHeight = 120.0;
  static const double productCardHeight = 200.0;
  static const double dashboardCardHeight = 150.0;
  
  /// Sombras personalizadas mejoradas
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];
  
  /// Gradientes personalizados
  static LinearGradient get primaryGradient => const LinearGradient(
    colors: [gradientStartColor, gradientEndColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static LinearGradient get accentGradient => const LinearGradient(
    colors: [accentColor, accentDarkColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
