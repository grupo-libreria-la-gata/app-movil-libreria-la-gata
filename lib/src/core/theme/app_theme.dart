import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../design/design_tokens.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: DesignTokens.primaryColor,
        brightness: Brightness.light,
        primary: DesignTokens.primaryColor,
        secondary: DesignTokens.secondaryColor,
        surface: DesignTokens.surfaceColor,
        // background: DesignTokens.backgroundColor, // Deprecated
        error: DesignTokens.errorColor,
      ),
      // En web, usar Google Fonts (ya incluidas en index.html)
      // En móvil/desktop, usar fuente local
      fontFamily: kIsWeb ? 'Roboto' : null, // En web usa Google Fonts, en móvil usa fuente del sistema
      // Icon Theme - Asegurar que los iconos se muestren correctamente
      iconTheme: const IconThemeData(
        color: DesignTokens.primaryColor,
        size: 24,
      ),

      // Material Icons Theme
      primaryIconTheme: const IconThemeData(
        color: DesignTokens.primaryColor,
        size: 24,
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: DesignTokens.primaryColor,
        foregroundColor: DesignTokens.textInverseColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: DesignTokens.textInverseColor,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: DesignTokens.primaryColor.withValues(alpha: 0.1),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: DesignTokens.cardColor,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DesignTokens.primaryColor,
          foregroundColor: DesignTokens.textInverseColor,
          elevation: 2,
          shadowColor: DesignTokens.primaryColor.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: DesignTokens.borderMediumColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: DesignTokens.borderMediumColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: DesignTokens.primaryColor,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: DesignTokens.backgroundColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),

      // Text Theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: DesignTokens.textPrimaryColor, // Marrón Oscuro
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: DesignTokens.textPrimaryColor, // Marrón Oscuro
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: DesignTokens.textPrimaryColor, // Marrón Oscuro
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: DesignTokens.textPrimaryColor, // Marrón Oscuro
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: DesignTokens.textSecondaryColor, // Marrón Medio
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: DesignTokens.textPrimaryColor, // Marrón Oscuro
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: DesignTokens.textSecondaryColor, // Marrón Medio
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: DesignTokens.textMutedColor, // Marrón Muted
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: DesignTokens.accentColor,
        foregroundColor: DesignTokens.textInverseColor,
        elevation: 4,
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: DesignTokens.surfaceColor,
        selectedItemColor: DesignTokens.primaryColor,
        unselectedItemColor: DesignTokens.textMutedColor,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  // Tema oscuro eliminado - Solo usamos tema claro minimalista
}
