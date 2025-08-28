import 'package:flutter/material.dart';
import '../design/design_tokens.dart';

/// Utilidad para manejar el diseño responsivo
class ResponsiveHelper {
  static ResponsiveHelper? _instance;
  static ResponsiveHelper get instance => _instance ??= ResponsiveHelper._();
  
  ResponsiveHelper._();

  /// Obtiene el ancho de la pantalla
  double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Obtiene la altura de la pantalla
  double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Verifica si es una pantalla móvil pequeña (< 480px)
  bool isSmallMobile(BuildContext context) {
    return getScreenWidth(context) < DesignTokens.breakpointMobile;
  }

  /// Verifica si es una pantalla móvil (480px - 600px)
  bool isMobile(BuildContext context) {
    final width = getScreenWidth(context);
    return width >= DesignTokens.breakpointMobile && width < DesignTokens.breakpointSm;
  }

  /// Verifica si es una pantalla tablet (600px - 900px)
  bool isTablet(BuildContext context) {
    final width = getScreenWidth(context);
    return width >= DesignTokens.breakpointSm && width < DesignTokens.breakpointMd;
  }

  /// Verifica si es una pantalla desktop (> 900px)
  bool isDesktop(BuildContext context) {
    return getScreenWidth(context) >= DesignTokens.breakpointMd;
  }

  /// Obtiene el espaciado responsivo
  double getResponsiveSpacing(BuildContext context, double defaultSpacing) {
    if (isSmallMobile(context)) {
      return defaultSpacing * 0.5; // Reducir espaciado en móviles pequeños
    } else if (isMobile(context)) {
      return defaultSpacing * 0.75; // Reducir espaciado en móviles
    }
    return defaultSpacing;
  }

  /// Obtiene el tamaño de fuente responsivo
  double getResponsiveFontSize(BuildContext context, double defaultSize) {
    if (isSmallMobile(context)) {
      return defaultSize * 0.8; // Reducir tamaño de fuente en móviles pequeños
    } else if (isMobile(context)) {
      return defaultSize * 0.9; // Reducir tamaño de fuente en móviles
    }
    return defaultSize;
  }

  /// Obtiene el número de columnas para grid responsivo
  int getResponsiveGridCrossAxisCount(BuildContext context) {
    if (isSmallMobile(context)) {
      return 1; // 1 columna en móviles pequeños
    } else if (isMobile(context)) {
      return 2; // 2 columnas en móviles
    } else if (isTablet(context)) {
      return 3; // 3 columnas en tablets
    }
    return 4; // 4 columnas en desktop
  }

  /// Obtiene el aspect ratio responsivo para grid
  double getResponsiveGridChildAspectRatio(BuildContext context) {
    if (isSmallMobile(context)) {
      return 1.5; // Aspecto más alto para móviles pequeños
    } else if (isMobile(context)) {
      return 1.3; // Aspecto alto para móviles
    }
    return 1.2; // Aspecto normal para tablets y desktop
  }

  /// Obtiene el espaciado del grid responsivo
  double getResponsiveGridSpacing(BuildContext context) {
    if (isSmallMobile(context)) {
      return DesignTokens.responsiveGridSpacing;
    } else if (isMobile(context)) {
      return DesignTokens.spacingSm;
    }
    return DesignTokens.spacingMd;
  }

  /// Obtiene el padding responsivo
  EdgeInsets getResponsivePadding(BuildContext context) {
    if (isSmallMobile(context)) {
      return EdgeInsets.all(DesignTokens.responsiveSpacingMd);
    } else if (isMobile(context)) {
      return EdgeInsets.all(DesignTokens.spacingMd);
    }
    return EdgeInsets.all(DesignTokens.spacingLg);
  }

  /// Obtiene el tamaño de icono responsivo
  double getResponsiveIconSize(BuildContext context, double defaultSize) {
    if (isSmallMobile(context)) {
      return defaultSize * 0.8; // Reducir tamaño de icono en móviles pequeños
    } else if (isMobile(context)) {
      return defaultSize * 0.9; // Reducir tamaño de icono en móviles
    }
    return defaultSize;
  }

  /// Obtiene la altura de tarjeta responsiva
  double getResponsiveCardHeight(BuildContext context, double defaultHeight) {
    if (isSmallMobile(context)) {
      return defaultHeight * 0.8; // Reducir altura en móviles pequeños
    } else if (isMobile(context)) {
      return defaultHeight * 0.9; // Reducir altura en móviles
    }
    return defaultHeight;
  }

  /// Obtiene el ancho mínimo para botones responsivos
  double getResponsiveButtonMinWidth(BuildContext context) {
    if (isSmallMobile(context)) {
      return 80.0; // Botones más pequeños en móviles pequeños
    } else if (isMobile(context)) {
      return 100.0; // Botones medianos en móviles
    }
    return 120.0; // Botones normales en tablets y desktop
  }

  /// Obtiene la altura mínima para botones responsivos
  double getResponsiveButtonMinHeight(BuildContext context) {
    if (isSmallMobile(context)) {
      return 36.0; // Botones más bajos en móviles pequeños
    } else if (isMobile(context)) {
      return 40.0; // Botones medianos en móviles
    }
    return 48.0; // Botones normales en tablets y desktop
  }
}
