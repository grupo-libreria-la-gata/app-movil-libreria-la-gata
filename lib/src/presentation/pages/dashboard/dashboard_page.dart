import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/app_config.dart';
import '../../../core/design/design_tokens.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/stats_card.dart';

/// Página principal del dashboard del sistema de facturación
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // Escuchar cambios en el estado de autenticación
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (!next.isAuthenticated && !next.isLoading) {
        context.go('/login');
      }
    });

    return Scaffold(
      backgroundColor: DesignTokens.backgroundColor,
      appBar: AppBar(
        backgroundColor: DesignTokens.primaryColor,
        elevation: 0,
        title: Row(
          children: [
            // Logo clickeable
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🏠 Dashboard de La Gata'),
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
                  boxShadow: DesignTokens.cardShadow,
                ),
                child: Icon(
                  Icons.local_bar, // Icono de licorería
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
          // Notificaciones
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('🔔 Notificaciones próximamente')),
              );
            },
          ),
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
            
            // Estadísticas rápidas
            _buildStatsSection(context),
            
            const SizedBox(height: DesignTokens.spacingXl),
            
            // Acciones principales
            _buildMainActionsSection(context, authState),
            
            const SizedBox(height: DesignTokens.spacingXl),
            
            // Acciones secundarias
            _buildSecondaryActionsSection(context, authState),
          ],
        ),
      ),
    );
  }

  /// Construye la sección de bienvenida
  Widget _buildWelcomeSection(BuildContext context, AuthState authState) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingLg),
      decoration: BoxDecoration(
        gradient: DesignTokens.primaryGradient,
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusLg),
        boxShadow: DesignTokens.elevatedShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Bienvenido!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: DesignTokens.fontSize2xl,
                    fontWeight: DesignTokens.fontWeightBold,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingSm),
                Text(
                  authState.user?.name ?? 'Usuario',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: DesignTokens.fontSizeLg,
                    fontWeight: DesignTokens.fontWeightMedium,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingSm),
                Text(
                  'Sistema de Facturación La Gata',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: DesignTokens.fontSizeMd,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(DesignTokens.borderRadiusFull),
            ),
            child: Icon(
              Icons.local_bar,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  /// Construye la sección de estadísticas
  Widget _buildStatsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estadísticas del Día',
          style: TextStyle(
            fontSize: DesignTokens.fontSizeXl,
            fontWeight: DesignTokens.fontWeightBold,
            color: DesignTokens.textPrimaryColor,
          ),
        ),
        const SizedBox(height: DesignTokens.spacingMd),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: DesignTokens.spacingMd,
          mainAxisSpacing: DesignTokens.spacingMd,
          childAspectRatio: 1.5,
          children: [
            StatsCard(
              title: 'Ventas Hoy',
              value: '₡125,000',
              icon: Icons.point_of_sale,
              color: DesignTokens.primaryColor,
              change: '+12%',
              isPositive: true,
            ),
            StatsCard(
              title: 'Productos Vendidos',
              value: '45',
              icon: Icons.inventory,
              color: DesignTokens.successColor,
              change: '+8%',
              isPositive: true,
            ),
            StatsCard(
              title: 'Stock Bajo',
              value: '3',
              icon: Icons.warning,
              color: DesignTokens.warningColor,
              change: '-2',
              isPositive: false,
            ),
            StatsCard(
              title: 'Clientes Atendidos',
              value: '12',
              icon: Icons.people,
              color: DesignTokens.accentColor,
              change: '+3',
              isPositive: true,
            ),
          ],
        ),
      ],
    );
  }

  /// Construye la sección de acciones principales
  Widget _buildMainActionsSection(BuildContext context, AuthState authState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acciones Principales',
          style: TextStyle(
            fontSize: DesignTokens.fontSizeXl,
            fontWeight: DesignTokens.fontWeightBold,
            color: DesignTokens.textPrimaryColor,
          ),
        ),
        const SizedBox(height: DesignTokens.spacingMd),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: DesignTokens.spacingMd,
          mainAxisSpacing: DesignTokens.spacingMd,
          childAspectRatio: 1.2,
          children: [
            DashboardCard(
              title: 'Nueva Venta',
              subtitle: 'Crear factura',
              icon: Icons.add_shopping_cart,
              color: DesignTokens.successColor,
              onTap: () => context.push('/sales/new'),
            ),
            DashboardCard(
              title: 'Productos',
              subtitle: 'Gestionar inventario',
              icon: Icons.inventory_2,
              color: DesignTokens.infoColor,
              onTap: () => context.push('/products'),
            ),
            DashboardCard(
              title: 'Ventas',
              subtitle: 'Ver historial',
              icon: Icons.receipt_long,
              color: DesignTokens.primaryColor,
              onTap: () => context.push('/sales'),
            ),
            DashboardCard(
              title: 'Reportes',
              subtitle: 'Estadísticas',
              icon: Icons.analytics,
              color: DesignTokens.accentColor,
              onTap: () => context.push('/reports'),
            ),
          ],
        ),
      ],
    );
  }

  /// Construye la sección de acciones secundarias
  Widget _buildSecondaryActionsSection(BuildContext context, AuthState authState) {
    final user = authState.user;
    final isAdmin = user?.isAdmin ?? false;
    final canManageInventory = user?.canManageInventory ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Más Opciones',
          style: TextStyle(
            fontSize: DesignTokens.fontSizeXl,
            fontWeight: DesignTokens.fontWeightBold,
            color: DesignTokens.textPrimaryColor,
          ),
        ),
        const SizedBox(height: DesignTokens.spacingMd),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: DesignTokens.spacingMd,
          mainAxisSpacing: DesignTokens.spacingMd,
          childAspectRatio: 1.2,
          children: [
            if (canManageInventory)
              DashboardCard(
                title: 'Stock',
                subtitle: 'Control de inventario',
                icon: Icons.assessment,
                color: DesignTokens.warningColor,
                onTap: () => context.push('/inventory'),
              ),
            DashboardCard(
              title: 'Clientes',
              subtitle: 'Gestionar clientes',
              icon: Icons.people_outline,
              color: DesignTokens.warningColor,
              onTap: () => context.push('/customers'),
            ),
            if (isAdmin)
              DashboardCard(
                title: 'Usuarios',
                subtitle: 'Gestionar empleados',
                icon: Icons.manage_accounts,
                color: DesignTokens.accentDarkColor,
                onTap: () => context.push('/users'),
              ),
            DashboardCard(
              title: 'Configuración',
              subtitle: 'Ajustes del sistema',
              icon: Icons.settings,
              color: DesignTokens.textSecondaryColor,
              onTap: () => context.push('/settings'),
            ),
          ],
        ),
      ],
    );
  }

  /// Construye el menú de usuario
  Widget _buildUserMenu(WidgetRef ref, BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return PopupMenuButton<String>(
      icon: CircleAvatar(
        backgroundColor: Colors.white,
        child: Text(
          user?.name.substring(0, 1).toUpperCase() ?? 'U',
          style: TextStyle(
            color: DesignTokens.primaryColor,
            fontWeight: DesignTokens.fontWeightBold,
          ),
        ),
      ),
      onSelected: (value) {
        switch (value) {
          case 'profile':
            context.push('/profile');
            break;
          case 'settings':
            context.push('/settings');
            break;
          case 'logout':
            ref.read(authProvider.notifier).signOut();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              const Icon(Icons.person),
              const SizedBox(width: DesignTokens.spacingSm),
              const Text('Perfil'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              const Icon(Icons.settings),
              const SizedBox(width: DesignTokens.spacingSm),
              const Text('Configuración'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              const Icon(Icons.logout, color: Colors.red),
              const SizedBox(width: DesignTokens.spacingSm),
              const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }
}
