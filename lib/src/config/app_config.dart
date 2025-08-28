class AppConfig {
  // API Configuration
  static const String baseUrl = 'https://api.lagata.com/api/v1';
  static const String apiKey = 'your_api_key_here';
  
  // Database Configuration
  static const String databaseName = 'la_gata_facturacion.db';
  static const int databaseVersion = 1;
  
  // App Information
  static const String appName = 'La Gata';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Sistema de facturación para licorería La Gata';
  
  // Colors (usando Design Tokens)
  static const int primaryColor = 0xFF8B4513; // Brown - TODO: Migrar a DesignTokens
  static const int secondaryColor = 0xFFD2691E; // Chocolate - TODO: Migrar a DesignTokens
  static const int accentColor = 0xFFFFD700; // Gold - TODO: Migrar a DesignTokens
  
  // Map Configuration
  static const String googleMapsApiKey = 'your_google_maps_api_key_here';
  static const double defaultLatitude = 12.8654; // Nicaragua center
  static const double defaultLongitude = -85.2072;
  static const double defaultZoom = 8.0;
  
  // Image Configuration
  static const String defaultImageUrl = 'https://via.placeholder.com/300x200';
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  
  // Pagination
  static const int pageSize = 20;
  
  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  
  // Cache Configuration
  static const int cacheExpirationDays = 7;
  
  // Notification Configuration
  static const String notificationChannelId = 'la_gata_channel';
  static const String notificationChannelName = 'La Gata Notifications';
  static const String notificationChannelDescription = 'Notifications for La Gata billing system';
  
  // Business Configuration
  static const String businessName = 'Licorería La Gata';
  static const String businessAddress = 'Managua, Nicaragua';
  static const String businessPhone = '+505 1234-5678';
  static const String businessEmail = 'info@lagata.com';
  static const String businessRuc = 'J123456789';
  
  // Invoice Configuration
  static const String invoicePrefix = 'LG';
  static const int invoiceNumberLength = 8;
  static const double taxRate = 0.15; // 15% IVA
}
