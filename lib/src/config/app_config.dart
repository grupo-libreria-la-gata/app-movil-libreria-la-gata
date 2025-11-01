import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  // API Configuration
  // Para desarrollo local, usar la IP de tu máquina en lugar de localhost
  // Encuentra tu IP con: ipconfig (Windows) o ifconfig (Mac/Linux)
  // Opciones comunes: 192.168.1.100, 192.168.0.100, 10.0.2.2 (para emulador Android)
  // Configura la URL en el archivo .env
  // Si dotenv no está cargado (error al cargar el .env), usar valores por defecto
  static String get baseUrl {
    try {
      return dotenv.env['API_BASE_URL'] ?? 'http://localhost:5044';
    } catch (e) {
      return 'http://localhost:5044';
    }
  }
  
  static String get apiKey {
    try {
      return dotenv.env['API_KEY'] ?? 'your_api_key_here';
    } catch (e) {
      return 'your_api_key_here';
    }
  }

  // Database Configuration
  static String get databaseName => dotenv.env['DATABASE_NAME'] ?? 'la_gata_facturacion.db';
  static int get databaseVersion => int.tryParse(dotenv.env['DATABASE_VERSION'] ?? '1') ?? 1;

  // App Information
  static String get appName => dotenv.env['APP_NAME'] ?? 'La Gata';
  static String get appVersion => dotenv.env['APP_VERSION'] ?? '1.0.0';
  static const String appDescription =
      'Sistema de facturación para licorería La Gata';

  // Colors (usando Design Tokens)
  static const int primaryColor = 0xFF8B4513; // Brown
  static const int secondaryColor = 0xFFD2691E; // Chocolate
  static const int accentColor = 0xFFFFD700; // Gold

  // Map Configuration
  static const String googleMapsApiKey = 'your_google_maps_api_key_here';
  static const double defaultLatitude = 12.8654; // Nicaragua center
  static const double defaultLongitude = -85.2072;
  static const double defaultZoom = 8.0;

  // Image Configuration
  static const String defaultImageUrl = 'https://via.placeholder.com/300x200';
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB

  // Pagination
  static int get pageSize => int.tryParse(dotenv.env['PAGE_SIZE'] ?? '20') ?? 20;

  // Timeouts
  static int get connectionTimeout => int.tryParse(dotenv.env['CONNECTION_TIMEOUT'] ?? '30000') ?? 30000;
  static int get receiveTimeout => int.tryParse(dotenv.env['RECEIVE_TIMEOUT'] ?? '30000') ?? 30000;

  // Cache Configuration
  static int get cacheExpirationDays => int.tryParse(dotenv.env['CACHE_EXPIRATION_DAYS'] ?? '7') ?? 7;

  // Notification Configuration
  static const String notificationChannelId = 'la_gata_channel';
  static const String notificationChannelName = 'La Gata Notifications';
  static const String notificationChannelDescription =
      'Notifications for La Gata billing system';

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
