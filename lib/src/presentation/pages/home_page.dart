import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_config.dart';
import '../../core/design/design_tokens.dart';
import '../providers/auth_provider.dart';

/// Página principal de la aplicación
///
/// Muestra el dashboard con las principales funcionalidades
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final canPerformActions = ref.watch(canPerformActionsProvider);

    // Escuchar cambios en el estado de autenticación
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (!next.isAuthenticated && !next.isLoading) {
        // Si el usuario no está autenticado, redirigir al login
        context.go('/login');
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: DesignTokens.primaryColor,
        elevation: 0,
        title: Row(
          children: [
            // Logo clickeable que lleva al inicio
            GestureDetector(
              onTap: () {
                // Ya estamos en home, pero podríamos refrescar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🏠 Ya estás en el inicio'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                                 child: Icon(
                   Icons.flutter_dash, // TODO: Cambiar por el logo real de AviFy
                  color: DesignTokens.primaryColor,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: DesignTokens.spacingMd),
            // Nombre de la app
            Text(
              AppConfig.appName,
              style: TextStyle(
                color: Colors.white,
                fontSize: DesignTokens.fontSizeLg,
                fontWeight: DesignTokens.fontWeightBold,
              ),
            ),
          ],
        ),
        actions: [
          // Menú hamburguesa
          _buildHamburgerMenu(context, ref, authState),
          const SizedBox(width: DesignTokens.spacingSm),
          // Menú de usuario
          _buildUserMenu(ref, context),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de bienvenida
            _buildWelcomeSection(context, authState),
            
            const SizedBox(height: DesignTokens.spacingXl),
            
            // Sección explorar
            _buildExploreSection(context, canPerformActions),
            
            const SizedBox(height: DesignTokens.spacingXl),
            
            // Sección de estadísticas rápidas
            _buildQuickStatsSection(context),
          ],
        ),
      ),
    );
  }

  /// Construir el menú hamburguesa
  Widget _buildHamburgerMenu(BuildContext context, WidgetRef ref, AuthState authState) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.menu, color: Colors.white),
      onSelected: (value) => _handleMenuSelection(context, ref, value),
      itemBuilder: (context) => [
        // Sección principal
        const PopupMenuItem(
          enabled: false,
          child: Text(
            'MENÚ PRINCIPAL',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ),
        const PopupMenuDivider(),
        
        // Opciones principales
        const PopupMenuItem(
          value: 'home',
          child: Row(
            children: [
              Icon(Icons.home, color: Colors.green),
              SizedBox(width: 8),
              Text('Inicio'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'reserves',
          child: Row(
            children: [
              Icon(Icons.forest, color: Colors.green),
              SizedBox(width: 8),
              Text('Reservas Naturales'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'birds',
          child: Row(
            children: [
              Icon(Icons.flutter_dash, color: Colors.blue),
              SizedBox(width: 8),
              Text('Catálogo de Aves'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'events',
          child: Row(
            children: [
              Icon(Icons.event, color: Colors.orange),
              SizedBox(width: 8),
              Text('Eventos'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'education',
          child: Row(
            children: [
              Icon(Icons.school, color: Colors.purple),
              SizedBox(width: 8),
              Text('Educación'),
            ],
          ),
        ),
        
        const PopupMenuDivider(),
        
        // Sección de usuario
        const PopupMenuItem(
          enabled: false,
          child: Text(
            'MI CUENTA',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ),
        const PopupMenuDivider(),
        
        if (authState.isAuthenticated && !authState.isGuest) ...[
          const PopupMenuItem(
            value: 'bookings',
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.green),
                SizedBox(width: 8),
                Text('Mis Reservas'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'profile',
            child: Row(
              children: [
                Icon(Icons.person, color: Colors.blue),
                SizedBox(width: 8),
                Text('Mi Perfil'),
              ],
            ),
          ),
        ],
        
        const PopupMenuItem(
          value: 'about',
          child: Row(
            children: [
              Icon(Icons.info, color: Colors.grey),
              SizedBox(width: 8),
              Text('Acerca de'),
            ],
          ),
        ),
      ],
    );
  }

  /// Manejar la selección del menú hamburguesa
  void _handleMenuSelection(BuildContext context, WidgetRef ref, String value) {
    switch (value) {
      case 'home':
        // Ya estamos en home
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🏠 Ya estás en el inicio'),
            duration: Duration(seconds: 1),
          ),
        );
        break;
      case 'reserves':
        context.go('/reserves');
        break;
      case 'birds':
        context.go('/birds');
        break;
      case 'events':
        context.go('/events');
        break;
      case 'education':
        context.go('/education');
        break;
      case 'bookings':
        context.go('/bookings');
        break;
      case 'profile':
        context.go('/profile');
        break;
      case 'about':
        _showAboutDialog(context);
        break;
    }
  }

  /// Mostrar diálogo "Acerca de"
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: DesignTokens.primaryColor,
                borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
              ),
              child: const Icon(
                Icons.flutter_dash,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
                         const Text('Acerca de AviFy'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                         Text(
               'AviFy es una plataforma de aviturismo y reservas naturales de Nicaragua.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Versión: 1.0.0',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              'Desarrollado con Flutter',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  /// Construir el menú de usuario
  Widget _buildUserMenu(WidgetRef ref, BuildContext context) {
    final authState = ref.watch(authProvider);
    
    return PopupMenuButton<String>(
      icon: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(
          authState.isGuest ? Icons.person_outline : Icons.person,
          color: DesignTokens.primaryColor,
        ),
      ),
      onSelected: (value) => _handleUserMenuSelection(context, ref, value),
      itemBuilder: (context) => [
        // Información del usuario
        PopupMenuItem(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                authState.isGuest ? 'Modo Invitado' : authState.user?.name ?? 'Usuario',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              if (!authState.isGuest && authState.user?.email != null)
                Text(
                  authState.user!.email!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        
        // Opciones del usuario
        if (authState.isAuthenticated && !authState.isGuest) ...[
          const PopupMenuItem(
            value: 'profile',
            child: Row(
              children: [
                Icon(Icons.person, color: Colors.blue),
                SizedBox(width: 8),
                Text('Mi Perfil'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'settings',
            child: Row(
              children: [
                Icon(Icons.settings, color: Colors.grey),
                SizedBox(width: 8),
                Text('Configuración'),
              ],
            ),
          ),
          const PopupMenuDivider(),
        ],
        
        const PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 8),
              Text('Cerrar Sesión'),
            ],
          ),
        ),
      ],
    );
  }

  /// Manejar la selección del menú de usuario
  void _handleUserMenuSelection(BuildContext context, WidgetRef ref, String value) {
    switch (value) {
      case 'profile':
        context.go('/profile');
        break;
      case 'settings':
        // TODO: Implementar página de configuración
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚙️ Configuración próximamente'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case 'logout':
        _handleLogout(ref, context);
        break;
    }
  }

  /// Manejar el cierre de sesión
  void _handleLogout(WidgetRef ref, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 8),
            Text('Cerrar Sesión'),
          ],
        ),
        content: const Text(
          '¿Estás seguro de que quieres cerrar sesión?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(authProvider.notifier).signOut();
              if (context.mounted) {
                context.go('/login');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }

  /// Construir la sección de bienvenida
  Widget _buildWelcomeSection(BuildContext context, AuthState authState) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DesignTokens.spacingXl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            DesignTokens.primaryColor,
            DesignTokens.primaryColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusLg),
        boxShadow: [
          BoxShadow(
            color: DesignTokens.primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(DesignTokens.borderRadiusLg),
                ),
                child: Icon(
                  Icons.flutter_dash,
                  size: 32,
                  color: DesignTokens.primaryColor,
                ),
              ),
              const SizedBox(width: DesignTokens.spacingLg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                                         Text(
                       '¡Bienvenido a AviFy!',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: DesignTokens.fontWeightBold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      authState.isGuest 
                        ? 'Explora como invitado'
                        : 'Descubre las maravillas naturales de Nicaragua',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construir la sección explorar
  Widget _buildExploreSection(BuildContext context, bool canPerformActions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Explorar',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: DesignTokens.primaryColor,
            fontWeight: DesignTokens.fontWeightBold,
          ),
        ),
        const SizedBox(height: DesignTokens.spacingLg),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: DesignTokens.spacingMd,
          mainAxisSpacing: DesignTokens.spacingMd,
          childAspectRatio: 1.1,
          children: [
            _buildFeatureCard(
              context,
              icon: Icons.forest,
              title: 'Reservas Naturales',
              color: DesignTokens.primaryColor,
              onTap: () => context.go('/reserves'),
            ),
            _buildFeatureCard(
              context,
              icon: Icons.flutter_dash,
              title: 'Catálogo de Aves',
              color: Colors.blue,
              onTap: () => context.go('/birds'),
            ),
            _buildFeatureCard(
              context,
              icon: Icons.calendar_today,
              title: 'Mis Reservas',
              color: Colors.orange,
              onTap: canPerformActions 
                ? () => context.go('/bookings')
                : () => _showGuestRestriction(context),
            ),
            _buildFeatureCard(
              context,
              icon: Icons.event,
              title: 'Eventos',
              color: Colors.purple,
              onTap: () => context.go('/events'),
            ),
          ],
        ),
      ],
    );
  }

  /// Construir una tarjeta de característica
  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusLg),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusLg),
        child: Container(
          padding: const EdgeInsets.all(DesignTokens.spacingLg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DesignTokens.borderRadiusLg),
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.1),
                color.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(DesignTokens.borderRadiusLg),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(height: DesignTokens.spacingMd),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: DesignTokens.fontWeightSemiBold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Mostrar restricción para usuarios invitados
  void _showGuestRestriction(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.lock, color: Colors.orange),
            SizedBox(width: 8),
            Text('Función Restringida'),
          ],
        ),
        content: const Text(
          'Esta función requiere una cuenta registrada. ¿Te gustaría crear una cuenta o iniciar sesión?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/login');
            },
            child: const Text('Iniciar Sesión'),
          ),
        ],
      ),
    );
  }

  /// Construir la sección de estadísticas rápidas
  Widget _buildQuickStatsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estadísticas Rápidas',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: DesignTokens.primaryColor,
            fontWeight: DesignTokens.fontWeightBold,
          ),
        ),
        const SizedBox(height: DesignTokens.spacingLg),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                icon: Icons.forest,
                title: 'Reservas',
                value: '12',
                color: DesignTokens.primaryColor,
              ),
            ),
            const SizedBox(width: DesignTokens.spacingMd),
            Expanded(
              child: _buildStatCard(
                context,
                icon: Icons.flutter_dash,
                title: 'Especies',
                value: '450+',
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: DesignTokens.spacingMd),
            Expanded(
              child: _buildStatCard(
                context,
                icon: Icons.event,
                title: 'Eventos',
                value: '8',
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Construir una tarjeta de estadística
  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingLg),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: DesignTokens.spacingSm),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: DesignTokens.fontWeightBold,
                color: color,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
