import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/app_config.dart';
import '../../../core/design/design_tokens.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/app_header.dart';
import '../../widgets/bottom_menu_widget.dart';

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
      appBar: AppHeader(
        title: AppConfig.appName,
        showBackButton: false,
        showUserMenu: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.instance.isSmallMobile(context) ? 12 : 16,
            vertical: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Sección de bienvenida
            _buildWelcomeSection(context, authState),

            SizedBox(
              height: ResponsiveHelper.instance.getResponsiveSpacing(
                context,
                DesignTokens.spacingLg,
              ),
            ),

            // Estadísticas rápidas
            _buildStatsSection(context),

            SizedBox(
              height: ResponsiveHelper.instance.getResponsiveSpacing(
                context,
                DesignTokens.spacingLg,
              ),
            ),

            // Acciones principales
            _buildMainActionsSection(context, authState),

            SizedBox(
              height: ResponsiveHelper.instance.getResponsiveSpacing(
                context,
                DesignTokens.spacingLg,
              ),
            ),

            // Acciones secundarias
            _buildSecondaryActionsSection(context, authState),

            // Espacio adicional para el menú inferior
            SizedBox(height: ResponsiveHelper.instance.isSmallMobile(context) ? 100 : 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomMenuWidget(
        currentIndex: 0,
        onTap: (index) {
          _navigateToPage(context, index);
        },
      ),
    );
  }

  /// Construye la sección de bienvenida (más compacta)
  Widget _buildWelcomeSection(BuildContext context, AuthState authState) {
    final responsiveHelper = ResponsiveHelper.instance;
    final isSmallMobile = responsiveHelper.isSmallMobile(context);

    return Container(
      padding: EdgeInsets.all(
        isSmallMobile ? 16 : 20,
      ),
      decoration: BoxDecoration(
        gradient: DesignTokens.primaryGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
                    fontSize: isSmallMobile ? 20 : 24,
                    fontWeight: DesignTokens.fontWeightBold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  authState.user?.name ?? 'Usuario',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: isSmallMobile ? 16 : 18,
                    fontWeight: DesignTokens.fontWeightMedium,
                  ),
                ),
                if (!isSmallMobile) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Sistema de Facturación La Gata',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (!isSmallMobile)
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.local_bar,
                color: Colors.white,
                size: 24,
              ),
            ),
        ],
      ),
    );
  }

  /// Construye la sección de estadísticas (más compacta)
  Widget _buildStatsSection(BuildContext context) {
    final responsiveHelper = ResponsiveHelper.instance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resumen del Día',
          style: TextStyle(
            fontSize: responsiveHelper.getResponsiveFontSize(
              context,
              DesignTokens.fontSizeLg,
            ),
            fontWeight: DesignTokens.fontWeightBold,
            color: DesignTokens.textPrimaryColor,
          ),
        ),
        SizedBox(
          height: responsiveHelper.getResponsiveSpacing(
            context,
            DesignTokens.spacingSm,
          ),
        ),
        // Estadísticas en una sola fila para pantallas pequeñas
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildCompactStatsCard(
                title: 'Ventas',
                value: '₡125K',
                icon: Icons.sell,
                color: DesignTokens.successColor,
                change: '+12%',
              ),
              const SizedBox(width: 12),
              _buildCompactStatsCard(
                title: 'Compras',
                value: '₡85K',
                icon: Icons.shopping_cart,
                color: DesignTokens.primaryColor,
                change: '+8%',
              ),
              const SizedBox(width: 12),
              _buildCompactStatsCard(
                title: 'Stock Bajo',
                value: '3',
                icon: Icons.warning,
                color: DesignTokens.warningColor,
                change: '-2',
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Construye una tarjeta de estadísticas compacta
  Widget _buildCompactStatsCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String change,
  }) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: DesignTokens.textPrimaryColor,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: DesignTokens.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            change,
            style: TextStyle(
              fontSize: 10,
              color: change.startsWith('+') ? Colors.green : Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Construye la sección de acciones principales (solo 4 opciones)
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
              DesignTokens.fontSizeLg,
            ),
            fontWeight: DesignTokens.fontWeightBold,
            color: DesignTokens.textPrimaryColor,
          ),
        ),
        SizedBox(
          height: responsiveHelper.getResponsiveSpacing(
            context,
            DesignTokens.spacingSm,
          ),
        ),
        // Grid de 2x2 para las 4 acciones principales
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            DashboardCard(
              title: 'Nueva Venta',
              subtitle: 'Crear venta',
              icon: Icons.sell,
              color: DesignTokens.successColor,
              onTap: () => context.push('/sales/new'),
            ),
            DashboardCard(
              title: 'Nueva Compra',
              subtitle: 'Crear compra',
              icon: Icons.add_shopping_cart,
              color: DesignTokens.primaryColor,
              onTap: () => context.push('/purchases/new'),
            ),
            DashboardCard(
              title: 'Inventario',
              subtitle: 'Gestionar inventario',
              icon: Icons.inventory,
              color: DesignTokens.infoColor,
              onTap: () => context.push('/inventory'),
            ),
            DashboardCard(
              title: 'Reportes',
              subtitle: 'Ver reportes',
              icon: Icons.analytics,
              color: DesignTokens.warningColor,
              onTap: () => context.push('/reports'),
            ),
          ],
        ),
      ],
    );
  }

  /// Construye la sección de acciones secundarias (reorganizada)
  Widget _buildSecondaryActionsSection(
    BuildContext context,
    AuthState authState,
  ) {
    final responsiveHelper = ResponsiveHelper.instance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Más Opciones',
          style: TextStyle(
            fontSize: responsiveHelper.getResponsiveFontSize(
              context,
              DesignTokens.fontSizeLg,
            ),
            fontWeight: DesignTokens.fontWeightBold,
            color: DesignTokens.textPrimaryColor,
          ),
        ),
        SizedBox(
          height: responsiveHelper.getResponsiveSpacing(
            context,
            DesignTokens.spacingSm,
          ),
        ),
        // Grid de 2x1 para las opciones secundarias (mismo tamaño que Main Actions)
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2, // Mismo aspect ratio que Main Actions
          children: [
            DashboardCard(
              title: 'Administración',
              subtitle: 'Gestión del sistema',
              icon: Icons.admin_panel_settings,
              color: DesignTokens.textSecondaryColor,
              onTap: () => context.push('/admin'),
            ),
            DashboardCard(
              title: 'Acceso Rápido',
              subtitle: 'Acciones rápidas',
              icon: Icons.flash_on,
              color: DesignTokens.accentColor,
              onTap: () {
                // Mostrar un menú rápido con opciones adicionales
                _showQuickAccessMenu(context);
              },
            ),
          ],
        ),
      ],
    );
  }

  /// Muestra un menú de acceso rápido
  void _showQuickAccessMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Acceso Rápido',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: DesignTokens.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
              children: [
                _buildQuickAccessItem(
                  icon: Icons.people,
                  title: 'Clientes',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/customers');
                  },
                ),
                _buildQuickAccessItem(
                  icon: Icons.business_center,
                  title: 'Proveedores',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/suppliers');
                  },
                ),
                _buildQuickAccessItem(
                  icon: Icons.receipt_long,
                  title: 'Historial de Ventas',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/sales');
                  },
                ),
                _buildQuickAccessItem(
                  icon: Icons.history,
                  title: 'Historial de Compras',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/purchases');
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Construye un elemento del menú de acceso rápido
  Widget _buildQuickAccessItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: DesignTokens.primaryColor, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: DesignTokens.textPrimaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPage(BuildContext context, int index) {
    switch (index) {
      case 0: // Sales
        context.go('/dashboard');
        break;
      case 1: // Manage
        context.go('/dashboard');
        break;
      case 2: // Purchases
        context.go('/dashboard');
        break;
      case 3: // Resume
        context.go('/dashboard');
        break;
    }
  }

}
