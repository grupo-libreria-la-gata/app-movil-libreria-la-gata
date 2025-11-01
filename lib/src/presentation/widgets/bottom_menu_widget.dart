import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/design/design_tokens.dart';

class BottomMenuWidget extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomMenuWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<BottomMenuWidget> createState() => _BottomMenuWidgetState();
}

class _BottomMenuWidgetState extends State<BottomMenuWidget> {
  int? _expandedIndex;

  int? _computeActiveIndex(BuildContext context) {
    final location = GoRouter.of(context).routeInformationProvider.value.uri.path;
    if (location.startsWith('/purchases') || location.startsWith('/sales')) return 0; // Transacciones
    if (location.startsWith('/customers') || location.startsWith('/suppliers')) return 1; // Relaciones
    if (location.startsWith('/inventory') || location.startsWith('/reports') || location.startsWith('/warehouse')) return 2; // Resumen
    if (location.startsWith('/admin')) return 3; // Administración
    return null; // Ninguno activo (home, perfil, etc.)
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: DesignTokens.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: DesignTokens.textPrimaryColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Submenu expandible
            if (_expandedIndex != null) _buildSubmenu(),
            
            // Menú principal
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMenuButton(
                    index: 0,
                    icon: Icons.swap_horiz,
                    label: 'Transacciones',
                    isActive: _computeActiveIndex(context) == 0,
                  ),
                  _buildMenuButton(
                    index: 1,
                    icon: Icons.people,
                    label: 'Relaciones',
                    isActive: _computeActiveIndex(context) == 1,
                  ),
                  _buildMenuButton(
                    index: 2,
                    icon: Icons.analytics,
                    label: 'Resumen',
                    isActive: _computeActiveIndex(context) == 2,
                  ),
                  _buildMenuButton(
                    index: 3,
                    icon: Icons.admin_panel_settings,
                    label: 'Administración',
                    isActive: _computeActiveIndex(context) == 3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required int index,
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () {
        if (index == 3) {
          // Administración navega directo
          _expandedIndex = null;
          context.push('/admin');
          setState(() {});
          return;
        }
        if (_expandedIndex == index) {
          setState(() => _expandedIndex = null);
        } else {
          setState(() => _expandedIndex = index);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive ? DesignTokens.primaryColor.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? DesignTokens.primaryColor : DesignTokens.textPrimaryColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? DesignTokens.primaryColor : DesignTokens.textPrimaryColor,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmenu() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: DesignTokens.surfaceColor,
        border: Border(
          top: BorderSide(color: DesignTokens.borderLightColor, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _getSubmenuItems(),
      ),
    );
  }

  List<Widget> _getSubmenuItems() {
    switch (_expandedIndex) {
      case 0: // Transacciones
        return [
          _buildSubmenuItem(
            icon: Icons.shopping_cart,
            label: 'Compras',
            onTap: () => context.push('/purchases'),
          ),
          _buildSubmenuItem(
            icon: Icons.receipt_long,
            label: 'Ventas',
            onTap: () => context.push('/sales'),
          ),
        ];
      case 1: // Relaciones
        return [
          _buildSubmenuItem(
            icon: Icons.people,
            label: 'Clientes',
            onTap: () => context.push('/customers'),
          ),
          _buildSubmenuItem(
            icon: Icons.business_center,
            label: 'Proveedores',
            onTap: () => context.push('/suppliers'),
          ),
        ];
      case 2: // Resumen
        return [
          _buildSubmenuItem(
            icon: Icons.inventory,
            label: 'Inventario',
            onTap: () => context.push('/inventory'),
          ),
          _buildSubmenuItem(
            icon: Icons.warehouse,
            label: 'Almacén',
            onTap: () => context.push('/warehouse'),
          ),
          _buildSubmenuItem(
            icon: Icons.analytics,
            label: 'Reportes',
            onTap: () => context.push('/reports'),
          ),
        ];
      case 3: // Administración
        return [];
      default:
        return [];
    }
  }

  Widget _buildSubmenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _expandedIndex = null;
        });
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: DesignTokens.surfaceColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: DesignTokens.borderMediumColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: DesignTokens.primaryColor,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: DesignTokens.textPrimaryColor,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
