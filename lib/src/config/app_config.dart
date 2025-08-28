class AppConfig {
  // API Configuration
  static const String baseUrl = 'https://api.aveturismo.com/api/v1';
  static const String apiKey = 'your_api_key_here';
  
  // Database Configuration
  static const String databaseName = 'ave_turismo.db';
  static const int databaseVersion = 1;
  
  // App Information
  static const String appName = 'AviFy';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Plataforma de aviturismo y reservas naturales de Nicaragua';
  
  // Colors (usando Design Tokens)
  static const int primaryColor = 0xFF2E7D32; // Green - TODO: Migrar a DesignTokens
  static const int secondaryColor = 0xFF4CAF50; // Light Green - TODO: Migrar a DesignTokens
  static const int accentColor = 0xFFFF9800; // Orange - TODO: Migrar a DesignTokens
  
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
  static const String notificationChannelId = 'ave_turismo_channel';
  static const String notificationChannelName = 'AveTurismo Notifications';
  static const String notificationChannelDescription = 'Notifications for AveTurismo app';
}
