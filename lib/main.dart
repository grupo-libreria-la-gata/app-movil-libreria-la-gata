import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/config/app_config.dart';
import 'src/core/theme/app_theme.dart';
import 'src/routes/app_routes.dart';

void main() {
  runApp(
    const ProviderScope(
      child: LaGataApp(),
    ),
  );
}

class LaGataApp extends StatelessWidget {
  const LaGataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConfig.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRoutes.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
