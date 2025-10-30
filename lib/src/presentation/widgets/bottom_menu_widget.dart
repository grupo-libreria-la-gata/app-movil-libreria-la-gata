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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
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
                    icon: Icons.sell,
                    label: 'Ventas',
                    isActive: widget.currentIndex == 0,
                  ),
                  _buildMenuButton(
                    index: 1,
                    icon: Icons.people,
                    label: 'Gestionar',
                    isActive: widget.currentIndex == 1,
                  ),
                  _buildMenuButton(
                    index: 2,
                    icon: Icons.shopping_cart,
                    label: 'Compras',
                    isActive: widget.currentIndex == 2,
                  ),
                  _buildMenuButton(
                    index: 3,
                    icon: Icons.analytics,
                    label: 'Resumen',
                    isActive: widget.currentIndex == 3,
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
        if (_expandedIndex == index) {
          setState(() {
            _expandedIndex = null;
          });
        } else {
          setState(() {
            _expandedIndex = index;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.yellow : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.orange[800] : Colors.black87,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.orange[800] : Colors.black87,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
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
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!, width: 1),
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
      case 0: // Sales
        return [
          _buildSubmenuItem(
            icon: Icons.add,
            label: 'Nueva Venta',
            onTap: () => context.push('/sales/new'),
          ),
          _buildSubmenuItem(
            icon: Icons.receipt_long,
            label: 'Ventas',
            onTap: () => context.push('/sales'),
          ),
        ];
      case 1: // Manage
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
      case 2: // Purchases
        return [
          _buildSubmenuItem(
            icon: Icons.add_shopping_cart,
            label: 'Nueva Compra',
            onTap: () => context.push('/purchases/new'),
          ),
          _buildSubmenuItem(
            icon: Icons.history,
            label: 'Compras',
            onTap: () => context.push('/purchases'),
          ),
        ];
      case 3: // Resume
        return [
          _buildSubmenuItem(
            icon: Icons.inventory,
            label: 'Inventario',
            onTap: () => context.push('/inventory'),
          ),
          _buildSubmenuItem(
            icon: Icons.analytics,
            label: 'Reportes',
            onTap: () => context.push('/reports'),
          ),
        ];
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[400]!),
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
