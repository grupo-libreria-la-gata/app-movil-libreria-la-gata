import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/app_config.dart';
import '../../../core/design/design_tokens.dart';
import '../../../core/utils/responsive_helper.dart';
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
              onTap: () => context.go('/dashboard'),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    DesignTokens.borderRadiusMd,
                  ),
                  boxShadow: DesignTokens.cardShadow,
                ),
                child: Icon(
                  Icons.local_bar, // Icono de licorería
                  color: DesignTokens.primaryColor,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: DesignTokens.spacingSm),
            // Nombre de la app
            Expanded(
              child: Text(
                AppConfig.appName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: DesignTokens.fontSizeLg,
                  fontWeight: DesignTokens.fontWeightBold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          // Notificaciones
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
              size: 22,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('🔔 Notificaciones próximamente')),
              );
            },
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
          // Menú de usuario
          _buildUserMenu(ref, context),
        ],
      ),
      body: SingleChildScrollView(
        padding: ResponsiveHelper.instance.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de bienvenida
            _buildWelcomeSection(context, authState),

            SizedBox(
              height: ResponsiveHelper.instance.getResponsiveSpacing(
                context,
                DesignTokens.spacingXl,
              ),
            ),

            // Estadísticas rápidas
            _buildStatsSection(context),

            SizedBox(
              height: ResponsiveHelper.instance.getResponsiveSpacing(
                context,
                DesignTokens.spacingXl,
              ),
            ),

            // Acciones principales
            _buildMainActionsSection(context, authState),

            SizedBox(
              height: ResponsiveHelper.instance.getResponsiveSpacing(
                context,
                DesignTokens.spacingXl,
              ),
            ),

            // Acciones secundarias
            _buildSecondaryActionsSection(context, authState),
          ],
        ),
      ),
    );
  }

  /// Construye la sección de bienvenida
  Widget _buildWelcomeSection(BuildContext context, AuthState authState) {
    final responsiveHelper = ResponsiveHelper.instance;
    final isSmallMobile = responsiveHelper.isSmallMobile(context);

    return Container(
      padding: EdgeInsets.all(
        responsiveHelper.getResponsiveSpacing(context, DesignTokens.spacingLg),
      ),
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
                    fontSize: responsiveHelper.getResponsiveFontSize(
                      context,
                      DesignTokens.fontSize3xl,
                    ),
                    fontWeight: DesignTokens.fontWeightBold,
                  ),
                ),
                SizedBox(
                  height: responsiveHelper.getResponsiveSpacing(
                    context,
                    DesignTokens.spacingSm,
                  ),
                ),
                Text(
                  authState.user?.name ?? 'Usuario',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: responsiveHelper.getResponsiveFontSize(
                      context,
                      DesignTokens.fontSizeXl,
                    ),
                    fontWeight: DesignTokens.fontWeightMedium,
                  ),
                ),
                SizedBox(
                  height: responsiveHelper.getResponsiveSpacing(
                    context,
                    DesignTokens.spacingSm,
                  ),
                ),
                Text(
                  'Sistema de Facturación La Gata',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: responsiveHelper.getResponsiveFontSize(
                      context,
                      DesignTokens.fontSizeLg,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!isSmallMobile) // Ocultar icono en móviles muy pequeños
            Container(
              width: responsiveHelper.getResponsiveIconSize(context, 60),
              height: responsiveHelper.getResponsiveIconSize(context, 60),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(
                  DesignTokens.borderRadiusFull,
                ),
              ),
              child: Icon(
                Icons.local_bar,
                color: Colors.white,
                size: responsiveHelper.getResponsiveIconSize(context, 30),
              ),
            ),
        ],
      ),
    );
  }

  /// Construye la sección de estadísticas
  Widget _buildStatsSection(BuildContext context) {
    final responsiveHelper = ResponsiveHelper.instance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estadísticas del Día',
          style: TextStyle(
            fontSize: responsiveHelper.getResponsiveFontSize(
              context,
              DesignTokens.fontSizeXl,
            ),
            fontWeight: DesignTokens.fontWeightBold,
            color: DesignTokens.textPrimaryColor,
          ),
        ),
        SizedBox(
          height: responsiveHelper.getResponsiveSpacing(
            context,
            DesignTokens.spacingMd,
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: responsiveHelper.getResponsiveGridCrossAxisCount(
            context,
          ),
          crossAxisSpacing: responsiveHelper.getResponsiveGridSpacing(context),
          mainAxisSpacing: responsiveHelper.getResponsiveGridSpacing(context),
          childAspectRatio: responsiveHelper.getResponsiveGridChildAspectRatio(
            context,
          ),
          children: [
            StatsCard(
              title: 'Compras del dia',
              value: '₡125,000',
              icon: Icons.point_of_sale,
              color: DesignTokens.primaryColor,
              change: '+12%',
              isPositive: true,
            ),
            StatsCard(
              title: 'Productos comprados',
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
              title: 'proveedores atendidos',
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
    final responsiveHelper = ResponsiveHelper.instance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acciones Principales',
          style: TextStyle(
            fontSize: responsiveHelper.getResponsiveFontSize(
              context,
              DesignTokens.fontSizeXl,
            ),
            fontWeight: DesignTokens.fontWeightBold,
            color: DesignTokens.textPrimaryColor,
          ),
        ),
        SizedBox(
          height: responsiveHelper.getResponsiveSpacing(
            context,
            DesignTokens.spacingMd,
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: responsiveHelper.getResponsiveGridCrossAxisCount(
            context,
          ),
          crossAxisSpacing: responsiveHelper.getResponsiveGridSpacing(context),
          mainAxisSpacing: responsiveHelper.getResponsiveGridSpacing(context),
          childAspectRatio: responsiveHelper.getResponsiveGridChildAspectRatio(
            context,
          ),
          children: [
            DashboardCard(
              title: 'Nueva Compra',
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
              title: 'Compras',
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
  Widget _buildSecondaryActionsSection(
    BuildContext context,
    AuthState authState,
  ) {
    final user = authState.user;
    final isAdmin = user?.isAdmin ?? false;
    final canManageInventory = user?.canManageInventory ?? false;
    final responsiveHelper = ResponsiveHelper.instance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Más Opciones',
          style: TextStyle(
            fontSize: responsiveHelper.getResponsiveFontSize(
              context,
              DesignTokens.fontSizeXl,
            ),
            fontWeight: DesignTokens.fontWeightBold,
            color: DesignTokens.textPrimaryColor,
          ),
        ),
        SizedBox(
          height: responsiveHelper.getResponsiveSpacing(
            context,
            DesignTokens.spacingMd,
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: responsiveHelper.getResponsiveGridCrossAxisCount(
            context,
          ),
          crossAxisSpacing: responsiveHelper.getResponsiveGridSpacing(context),
          mainAxisSpacing: responsiveHelper.getResponsiveGridSpacing(context),
          childAspectRatio: responsiveHelper.getResponsiveGridChildAspectRatio(
            context,
          ),
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
              title: 'Proveedores',
              subtitle: 'Gestionar proveedores',
              icon: Icons.people_outline,
              color: DesignTokens.warningColor,
              onTap: () => context.push('/customers'),
            ),
            if (isAdmin)
              DashboardCard(
                title: 'Empleados',
                subtitle: 'Gestionar empleados',
                icon: Icons.manage_accounts,
                color: DesignTokens.accentDarkColor,
                onTap: () => context.push('/users'),
              ),
            DashboardCard(
              title: 'Administracion',
              subtitle: 'Gestión del sistema',
              icon: Icons.admin_panel_settings,
              color: DesignTokens.textSecondaryColor,
              onTap: () => context.push('/admin'),
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
        radius: 16,
        child: Text(
          user?.name.substring(0, 1).toUpperCase() ?? 'U',
          style: TextStyle(
            color: DesignTokens.primaryColor,
            fontWeight: DesignTokens.fontWeightBold,
            fontSize: DesignTokens.fontSizeSm,
          ),
        ),
      ),
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      onSelected: (value) {
        switch (value) {
          case 'profile':
            context.push('/profile');
            break;
          case 'admin':
            context.push('/admin');
            break;
          case 'logout':
            _showLogoutDialog(context, ref);
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
          value: 'admin',
          child: Row(
            children: [
              const Icon(Icons.admin_panel_settings),
              const SizedBox(width: DesignTokens.spacingSm),
              const Text('Administración'),
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

  /// Muestra el diálogo de confirmación para cerrar sesión
  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(authProvider.notifier).signOut();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}
