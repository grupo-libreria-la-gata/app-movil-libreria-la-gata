/// Feature Flags para AveTurismo App
/// 
/// Este archivo permite activar/desactivar funcionalidades
/// según el estado de desarrollo y disponibilidad de la API.
/// 
/// TODO: Actualizar estos flags según el progreso del desarrollo

class FeatureFlags {
  // ===== API INTEGRATION FLAGS =====
  
  /// Habilitar integración con API real
  /// Cambiar a true cuando la API esté lista
  static const bool enableRealApi = false;
  
  /// Habilitar autenticación real (Firebase/API)
  /// Cambiar a true cuando la autenticación esté configurada
  static const bool enableRealAuth = false;
  
  /// Habilitar notificaciones push
  /// Cambiar a true cuando las notificaciones estén configuradas
  static const bool enablePushNotifications = false;
  
  /// Habilitar mapas reales (Google Maps)
  /// Cambiar a true cuando las API keys estén configuradas
  static const bool enableRealMaps = false;
  
  /// Habilitar carga de imágenes reales
  /// Cambiar a true cuando el CDN esté configurado
  static const bool enableRealImages = false;
  
  // ===== FEATURE FLAGS =====
  
  /// Habilitar módulo de ciencia ciudadana
  static const bool enableCitizenScience = true;
  
  /// Habilitar sistema de reseñas y valoraciones
  static const bool enableReviews = true;
  
  /// Habilitar chat entre turista y guía
  static const bool enableChat = false;
  
  /// Habilitar modo offline
  static const bool enableOfflineMode = true;
  
  /// Habilitar sincronización de datos
  static const bool enableDataSync = false;
  
  /// Habilitar analytics y tracking
  static const bool enableAnalytics = false;
  
  /// Habilitar modo debug
  static const bool enableDebugMode = true;
  
  /// Habilitar logs detallados
  static const bool enableVerboseLogging = true;
  
  // ===== UI/UX FLAGS =====
  
  /// Habilitar animaciones avanzadas
  static const bool enableAdvancedAnimations = true;
  
  /// Habilitar modo oscuro
  static const bool enableDarkMode = true;
  
  /// Habilitar soporte multi-idioma
  static const bool enableMultiLanguage = false;
  
  /// Habilitar accesibilidad avanzada
  static const bool enableAdvancedAccessibility = true;
  
  // ===== DEVELOPMENT FLAGS =====
  
  /// Mostrar información de debug en la UI
  static const bool showDebugInfo = true;
  
  /// Habilitar herramientas de desarrollo
  static const bool enableDevTools = true;
  
  /// Mostrar errores detallados al usuario
  static const bool showDetailedErrors = true;
  
  /// Habilitar modo de prueba con datos mock
  static const bool enableMockData = true;
  
  // ===== PERFORMANCE FLAGS =====
  
  /// Habilitar cache de imágenes
  static const bool enableImageCache = true;
  
  /// Habilitar cache de datos
  static const bool enableDataCache = true;
  
  /// Habilitar compresión de imágenes
  static const bool enableImageCompression = true;
  
  /// Habilitar lazy loading
  static const bool enableLazyLoading = true;
  
  // ===== SECURITY FLAGS =====
  
  /// Habilitar validación estricta de datos
  static const bool enableStrictValidation = true;
  
  /// Habilitar encriptación de datos sensibles
  static const bool enableDataEncryption = false;
  
  /// Habilitar certificados SSL pinning
  static const bool enableSSLPinning = false;
  
  // ===== UTILITY METHODS =====
  
  /// Verificar si una funcionalidad está habilitada
  static bool isEnabled(String feature) {
    switch (feature.toLowerCase()) {
      case 'real_api':
        return enableRealApi;
      case 'real_auth':
        return enableRealAuth;
      case 'push_notifications':
        return enablePushNotifications;
      case 'real_maps':
        return enableRealMaps;
      case 'real_images':
        return enableRealImages;
      case 'citizen_science':
        return enableCitizenScience;
      case 'reviews':
        return enableReviews;
      case 'chat':
        return enableChat;
      case 'offline_mode':
        return enableOfflineMode;
      case 'data_sync':
        return enableDataSync;
      case 'analytics':
        return enableAnalytics;
      case 'debug_mode':
        return enableDebugMode;
      case 'verbose_logging':
        return enableVerboseLogging;
      case 'advanced_animations':
        return enableAdvancedAnimations;
      case 'dark_mode':
        return enableDarkMode;
      case 'multi_language':
        return enableMultiLanguage;
      case 'advanced_accessibility':
        return enableAdvancedAccessibility;
      case 'show_debug_info':
        return showDebugInfo;
      case 'dev_tools':
        return enableDevTools;
      case 'show_detailed_errors':
        return showDetailedErrors;
      case 'mock_data':
        return enableMockData;
      case 'image_cache':
        return enableImageCache;
      case 'data_cache':
        return enableDataCache;
      case 'image_compression':
        return enableImageCompression;
      case 'lazy_loading':
        return enableLazyLoading;
      case 'strict_validation':
        return enableStrictValidation;
      case 'data_encryption':
        return enableDataEncryption;
      case 'ssl_pinning':
        return enableSSLPinning;
      default:
        return false;
    }
  }
  
  /// Obtener configuración de desarrollo
  static Map<String, bool> getDevelopmentConfig() {
    return {
      'real_api': enableRealApi,
      'real_auth': enableRealAuth,
      'push_notifications': enablePushNotifications,
      'real_maps': enableRealMaps,
      'real_images': enableRealImages,
      'citizen_science': enableCitizenScience,
      'reviews': enableReviews,
      'chat': enableChat,
      'offline_mode': enableOfflineMode,
      'data_sync': enableDataSync,
      'analytics': enableAnalytics,
      'debug_mode': enableDebugMode,
      'verbose_logging': enableVerboseLogging,
      'advanced_animations': enableAdvancedAnimations,
      'dark_mode': enableDarkMode,
      'multi_language': enableMultiLanguage,
      'advanced_accessibility': enableAdvancedAccessibility,
      'show_debug_info': showDebugInfo,
      'dev_tools': enableDevTools,
      'show_detailed_errors': showDetailedErrors,
      'mock_data': enableMockData,
      'image_cache': enableImageCache,
      'data_cache': enableDataCache,
      'image_compression': enableImageCompression,
      'lazy_loading': enableLazyLoading,
      'strict_validation': enableStrictValidation,
      'data_encryption': enableDataEncryption,
      'ssl_pinning': enableSSLPinning,
    };
  }
  
  /// Verificar si estamos en modo desarrollo
  static bool get isDevelopmentMode => enableDebugMode || enableMockData;
  
  /// Verificar si estamos en modo producción
  static bool get isProductionMode => !enableDebugMode && !enableMockData;
  
  /// Verificar si la API está disponible
  static bool get isApiAvailable => enableRealApi;
  
  /// Verificar si la autenticación real está disponible
  static bool get isRealAuthAvailable => enableRealAuth;
}
