import 'package:flutter/material.dart';

/// Design Tokens para La Gata - Sistema de Facturación
///
/// Este archivo centraliza todos los elementos de diseño para facilitar
/// la adaptación al diseño final de la diseñadora gráfica.
///
class DesignTokens {
  // ===== COLORS =====
  // 🎨 PALETA DE COLORES MINIMALISTA - La Gata App

  /// 🔸 COLORES PRIMARIOS
  static const Color primaryColor = Color(
    0xFFFFC107,
  ); // Amarillo primario (botones)
  static const Color primaryLightColor = Color(0xFFFFF350); // Amarillo claro
  static const Color primaryDarkColor = Color(0xFFC49000); // Amarillo oscuro

  /// 🔸 COLORES SECUNDARIOS
  static const Color secondaryColor = Color(
    0xFF2196F3,
  ); // Azul acento (UI educativa)
  static const Color secondaryLightColor = Color(0xFF64B5F6); // Azul claro
  static const Color secondaryDarkColor = Color(0xFF1976D2); // Azul oscuro

  /// 🔸 COLORES DE ACENTO
  static const Color accentColor = Color(
    0xFF4CAF50,
  ); // Verde acento (pantalla reset password)
  static const Color accentLightColor = Color(0xFF81C784); // Verde claro
  static const Color accentDarkColor = Color(0xFF388E3C); // Verde oscuro

  /// 🔸 COLORES DE ESTADO
  static const Color successColor = Color(0xFF4CAF50); // Verde acento
  static const Color warningColor = Color(0xFFFFC107); // Amarillo primario
  static const Color errorColor = Color(
    0xFFF44336,
  ); // Rojo alerta (errores/avisos)
  static const Color infoColor = Color(0xFF2196F3); // Azul acento

  /// 🔸 COLORES DE FONDO
  static const Color backgroundColor = Color(0xFFF5F5F5); // Gris claro fondo
  static const Color surfaceColor = Color(0xFFFFFFFF); // Blanco base
  static const Color cardColor = Color(0xFFFFFFFF); // Blanco base
  static const Color tertiaryBackgroundColor = Color(
    0xFFF5F5F5,
  ); // Gris claro fondo

  /// 🔸 COLORES DE TEXTO
  static const Color textPrimaryColor = Color(0xFF000000); // Negro texto
  static const Color textSecondaryColor = Color(
    0xFF9E9E9E,
  ); // Gris medio texto secundario
  static const Color textTertiaryColor = Color(0xFF757575); // Gris medio
  static const Color textMutedColor = Color(
    0xFF9E9E9E,
  ); // Gris medio texto secundario
  static const Color textInverseColor = Color(0xFFFFFFFF); // Blanco base

  /// 🔸 COLORES DE BORDE
  static const Color borderLightColor = Color(0xFFE0E0E0); // Gris muy claro
  static const Color borderMediumColor = Color(0xFFBDBDBD); // Gris medio
  static const Color borderDarkColor = Color(0xFF757575); // Gris medio
  static const Color dividerColor = Color(
    0xFFE0E0E0,
  ); // Gris muy claro para divisores

  /// 🔸 COLORES DE GRADIENTES
  static const Color gradientStartColor = Color(
    0xFFFFC107,
  ); // Amarillo primario
  static const Color gradientEndColor = Color(0xFFFFF350); // Amarillo claro

  /// 🔸 GRADIENTES MINIMALISTAS
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFC107),
      Color(0xFFFFF350),
    ], // Amarillo primario a amarillo claro
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2196F3), Color(0xFF64B5F6)], // Azul acento a azul claro
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF4CAF50),
      Color(0xFF81C784),
    ], // Verde acento a verde claro
  );

  /// 🔸 SOMBRAS MINIMALISTAS
  static const List<BoxShadow> shadowSmall = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.1),
      offset: Offset(0, 1),
      blurRadius: 3,
    ),
  ];

  static const List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.1),
      offset: Offset(0, 4),
      blurRadius: 6,
    ),
  ];

  static const List<BoxShadow> shadowLarge = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.1),
      offset: Offset(0, 10),
      blurRadius: 15,
    ),
  ];

  // ===== TYPOGRAPHY =====

  /// Familia de fuentes principal
  static const String fontFamily = 'Poppins';

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

  static const double breakpointMobile =
      480.0; // New mobile breakpoint for screens < 480px
  static const double breakpointSm = 600.0;
  static const double breakpointMd = 900.0;
  static const double breakpointLg = 1200.0;
  static const double breakpointXl = 1536.0;

  // ===== RESPONSIVE SPACING =====

  /// Espaciado responsivo para móviles pequeños
  static double get responsiveSpacingXs => 2.0;
  static double get responsiveSpacingSm => 4.0;
  static double get responsiveSpacingMd => 8.0;
  static double get responsiveSpacingLg => 12.0;
  static double get responsiveSpacingXl => 16.0;
  static double get responsiveSpacing2xl => 24.0;

  // ===== RESPONSIVE FONT SIZES =====

  /// Tamaños de fuente responsivos para móviles pequeños
  static double get responsiveFontSizeXs => 8.0;
  static double get responsiveFontSizeSm => 10.0;
  static double get responsiveFontSizeMd => 12.0;
  static double get responsiveFontSizeLg => 14.0;
  static double get responsiveFontSizeXl => 16.0;
  static double get responsiveFontSize2xl => 18.0;
  static double get responsiveFontSize3xl => 20.0;

  // ===== RESPONSIVE CARD HEIGHTS =====

  /// Alturas de tarjetas responsivas para móviles pequeños
  static double get responsiveInvoiceCardHeight => 100.0;
  static double get responsiveProductCardHeight => 160.0;
  static double get responsiveDashboardCardHeight => 120.0;

  // ===== RESPONSIVE GRID SETTINGS =====

  /// Configuraciones de grid responsivas
  static int get responsiveGridCrossAxisCount =>
      1; // 1 columna en móviles pequeños
  static double get responsiveGridChildAspectRatio =>
      1.5; // Aspecto más alto para móviles
  static double get responsiveGridSpacing => 8.0; // Espaciado reducido

  // ===== RESPONSIVE ICON SIZES =====

  /// Tamaños de iconos responsivos
  static double get responsiveIconSizeXs => 12.0;
  static double get responsiveIconSizeSm => 16.0;
  static double get responsiveIconSizeMd => 20.0;
  static double get responsiveIconSizeLg => 24.0;
  static double get responsiveIconSizeXl => 28.0;

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

  /// Gradientes personalizados (métodos para evitar duplicados)
  static LinearGradient get primaryGradientMethod => const LinearGradient(
    colors: [gradientStartColor, gradientEndColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get accentGradientMethod => const LinearGradient(
    colors: [accentColor, accentDarkColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get secondaryGradientMethod => const LinearGradient(
    colors: [secondaryColor, secondaryLightColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
