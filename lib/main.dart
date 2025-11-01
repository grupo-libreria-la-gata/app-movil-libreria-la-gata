import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'src/config/app_config.dart';
import 'src/core/theme/app_theme.dart';
import 'src/routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Cargar variables de entorno
  // En Flutter web, el archivo .env debe estar en la carpeta web/assets/
  try {
    // Intentar cargar desde web/assets/ primero (para web)
    await dotenv.load(fileName: "web/assets/.env", mergeWith: {});
  } catch (e) {
    try {
      // Si falla, intentar desde la raíz (para móvil/desktop)
      await dotenv.load(fileName: ".env", mergeWith: {});
    } catch (e2) {
      // Si ambos fallan, usar valores por defecto
      debugPrint('⚠️ Advertencia: No se pudo cargar el archivo .env');
      debugPrint('⚠️ Usando valores por defecto de AppConfig');
    }
  }
  
  runApp(const ProviderScope(child: LaGataApp()));
}

class LaGataApp extends StatelessWidget {
  const LaGataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConfig.appName,
      theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme, // Removed dark theme
      themeMode: ThemeMode.system,
      routerConfig: AppRoutes.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
