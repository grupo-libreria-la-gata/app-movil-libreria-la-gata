import 'package:flutter/material.dart';

/// Design Tokens para AveTurismo App
/// 
/// Este archivo centraliza todos los elementos de diseño para facilitar
/// la adaptación al diseño final de la diseñadora gráfica.
/// 
/// TODO: Actualizar estos valores según el diseño final del equipo de UX
class DesignTokens {
  // ===== COLORS =====
  
  /// Colores primarios de la marca
  static const Color primaryColor = Color(0xFF2E7D32); // Verde principal
  static const Color primaryLightColor = Color(0xFF4CAF50);
  static const Color primaryDarkColor = Color(0xFF1B5E20);
  
  /// Colores secundarios/accent
  static const Color accentColor = Color(0xFFFF9800); // Naranja
  static const Color accentLightColor = Color(0xFFFFB74D);
  static const Color accentDarkColor = Color(0xFFF57C00);
  
  /// Colores de estado
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFF44336);
  static const Color infoColor = Color(0xFF2196F3);
  
  /// Colores neutros
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color dividerColor = Color(0xFFE0E0E0);
  
  /// Colores de texto
  static const Color textPrimaryColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color textDisabledColor = Color(0xFFBDBDBD);
  static const Color textOnPrimaryColor = Color(0xFFFFFFFF);
  
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
  
  // ===== COMPONENT SPECIFIC =====
  
  /// AppBar
  static const double appBarHeight = 56.0;
  static const double appBarElevation = 0.0;
  
  /// Buttons
  static const double buttonHeight = 48.0;
  static const double buttonMinWidth = 120.0;
  
  /// Input Fields
  static const double inputHeight = 48.0;
  static const double inputBorderWidth = 1.0;
  static const double inputFocusedBorderWidth = 2.0;
  
  /// Cards
  static const double cardElevation = elevationSm;
  static const EdgeInsets cardPadding = EdgeInsets.all(spacingMd);
  
  /// Navigation
  static const double bottomNavHeight = 56.0;
  static const double drawerWidth = 280.0;
  
  // ===== UTILITY METHODS =====
  
  /// Obtener color con opacidad
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: (opacity * 255).round().toDouble());
  }
  
  /// Obtener color de estado según el tipo
  static Color getStateColor(String state) {
    switch (state.toLowerCase()) {
      case 'success':
      case 'active':
      case 'completed':
        return successColor;
      case 'warning':
      case 'pending':
        return warningColor;
      case 'error':
      case 'failed':
      case 'cancelled':
        return errorColor;
      case 'info':
      case 'processing':
        return infoColor;
      default:
        return textSecondaryColor;
    }
  }
  
  /// Obtener breakpoint actual basado en el ancho de pantalla
  static String getBreakpoint(double width) {
    if (width >= breakpointXl) return 'xl';
    if (width >= breakpointLg) return 'lg';
    if (width >= breakpointMd) return 'md';
    if (width >= breakpointSm) return 'sm';
    return 'xs';
  }
}
