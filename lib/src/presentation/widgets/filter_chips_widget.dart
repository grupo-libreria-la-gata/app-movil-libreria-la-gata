import 'package:flutter/material.dart';
import '../../core/design/design_tokens.dart';

/// Widget para mostrar chips de filtros activos
class FilterChipsWidget extends StatelessWidget {
  final Map<String, dynamic> filters;
  final Function(String) onRemoveFilter;
  final VoidCallback? onClearAll;

  const FilterChipsWidget({
    super.key,
    required this.filters,
    required this.onRemoveFilter,
    this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final activeFilters = _getActiveFilters();
    
    if (activeFilters.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingSm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Filtros activos:',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeSm,
                  fontWeight: DesignTokens.fontWeightMedium,
                  color: DesignTokens.textSecondaryColor,
                ),
              ),
              const Spacer(),
              if (onClearAll != null)
                TextButton(
                  onPressed: onClearAll,
                  child: Text(
                    'Limpiar todos',
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeSm,
                      color: DesignTokens.errorColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          Wrap(
            spacing: DesignTokens.spacingXs,
            runSpacing: DesignTokens.spacingXs,
            children: activeFilters.map((filter) {
              return _buildFilterChip(filter);
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Construye un chip de filtro
  Widget _buildFilterChip(Map<String, dynamic> filter) {
    return Chip(
      label: Text(
        filter['label'],
        style: TextStyle(
          fontSize: DesignTokens.fontSizeXs,
          color: Colors.white,
        ),
      ),
      backgroundColor: DesignTokens.primaryColor,
      deleteIcon: const Icon(
        Icons.close,
        size: 16,
        color: Colors.white,
      ),
      onDeleted: () => onRemoveFilter(filter['key']),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  /// Obtiene los filtros activos
  List<Map<String, dynamic>> _getActiveFilters() {
    final activeFilters = <Map<String, dynamic>>[];

    // Filtros de precio
    if (filters['minPrice'] != null) {
      activeFilters.add({
        'key': 'minPrice',
        'label': 'Precio ≥ ₡${filters['minPrice']}',
      });
    }
    if (filters['maxPrice'] != null) {
      activeFilters.add({
        'key': 'maxPrice',
        'label': 'Precio ≤ ₡${filters['maxPrice']}',
      });
    }

    // Filtros de stock
    if (filters['minStock'] != null) {
      activeFilters.add({
        'key': 'minStock',
        'label': 'Stock ≥ ${filters['minStock']}',
      });
    }
    if (filters['maxStock'] != null) {
      activeFilters.add({
        'key': 'maxStock',
        'label': 'Stock ≤ ${filters['maxStock']}',
      });
    }

    // Filtros de fecha
    if (filters['startDate'] != null) {
      final date = filters['startDate'] as DateTime;
      activeFilters.add({
        'key': 'startDate',
        'label': 'Desde ${date.day}/${date.month}/${date.year}',
      });
    }
    if (filters['endDate'] != null) {
      final date = filters['endDate'] as DateTime;
      activeFilters.add({
        'key': 'endDate',
        'label': 'Hasta ${date.day}/${date.month}/${date.year}',
      });
    }

    // Filtro de código de barras
    if (filters['barcode'] != null && filters['barcode'].toString().isNotEmpty) {
      activeFilters.add({
        'key': 'barcode',
        'label': 'Código: ${filters['barcode']}',
      });
    }

    // Filtros de estado
    if (filters['isActive'] != null) {
      activeFilters.add({
        'key': 'isActive',
        'label': filters['isActive'] ? 'Activos' : 'Inactivos',
      });
    }

    // Filtros especiales
    if (filters['lowStock'] == true) {
      activeFilters.add({
        'key': 'lowStock',
        'label': 'Stock bajo',
      });
    }
    if (filters['outOfStock'] == true) {
      activeFilters.add({
        'key': 'outOfStock',
        'label': 'Agotados',
      });
    }

    return activeFilters;
  }
}
