import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design/design_tokens.dart';
import '../../../data/models/detalle_producto_model.dart';
import '../../../data/services/detalle_producto_service.dart';
import '../../widgets/common/search_bar.dart';
import '../../widgets/common/empty_state.dart';

/// Página de control de inventario
class InventoryPage extends ConsumerStatefulWidget {
  const InventoryPage({super.key});

  @override
  ConsumerState<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends ConsumerState<InventoryPage> {
  String _searchQuery = '';
  String _stockFilter = 'Todos'; // Todos, Bajo, Agotado, Disponible
  List<DetalleProducto> _inventory = [];
  List<DetalleProducto> _filteredInventory = [];
  bool _isLoading = true;
  final DetalleProductoService _service = DetalleProductoService();

  @override
  void initState() {
    super.initState();
    _cargarInventario();
  }

  Future<void> _cargarInventario() async {
    setState(() => _isLoading = true);
    try {
      final inventario = await _service.obtenerActivos();
      setState(() {
        _inventory = inventario;
        _aplicarFiltros();
      });
    } catch (e) {
      _mostrarError('Error al cargar inventario: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _aplicarFiltros() async {
    List<DetalleProducto> productos = _inventory;

    // Aplicar filtro de búsqueda
    if (_searchQuery.isNotEmpty) {
      try {
        productos = await _service.buscarPorNombre(_searchQuery);
      } catch (e) {
        _mostrarError('Error al buscar inventario: ${e.toString()}');
        productos = _inventory;
      }
    }

    // Aplicar filtro de stock
    switch (_stockFilter) {
      case 'Bajo':
        productos = productos.where((p) => p.isLowStock && !p.isOutOfStock).toList();
        break;
      case 'Agotado':
        productos = productos.where((p) => p.isOutOfStock).toList();
        break;
      case 'Disponible':
        productos = productos.where((p) => !p.isLowStock && !p.isOutOfStock).toList();
        break;
    }

    setState(() {
      _filteredInventory = productos;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lowStockProducts = _filteredInventory.where((p) => p.isLowStock).toList();
    final outOfStockProducts = _filteredInventory.where((p) => p.isOutOfStock).toList();

    return Scaffold(
      backgroundColor: DesignTokens.backgroundColor,
      body: Column(
        children: [
          // Barra de búsqueda con botones de filtros y alertas
          Padding(
            padding: const EdgeInsets.all(DesignTokens.spacingMd),
            child: Row(
              children: [
                Expanded(
                  child: CustomSearchBar(
                    hintText: 'Buscar productos por nombre...',
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                        _aplicarFiltros();
                      });
                    },
                    onClear: _searchQuery.isNotEmpty
                        ? () {
                            setState(() {
                              _searchQuery = '';
                              _aplicarFiltros();
                            });
                          }
                        : null,
                  ),
                ),
                const SizedBox(width: DesignTokens.spacingSm),
                // Botón de stock bajo
                if (lowStockProducts.isNotEmpty)
                  _buildStockAlertButton(
                    'Stock Bajo',
                    lowStockProducts.length,
                    Icons.warning,
                    DesignTokens.warningColor,
                    () => _filtrarPorStock('Bajo'),
                  ),
                const SizedBox(width: DesignTokens.spacingXs),
                // Botón de productos agotados
                if (outOfStockProducts.isNotEmpty)
                  _buildStockAlertButton(
                    'Agotados',
                    outOfStockProducts.length,
                    Icons.error,
                    DesignTokens.errorColor,
                    () => _filtrarPorStock('Agotado'),
                  ),
                const SizedBox(width: DesignTokens.spacingXs),
                // Botón de filtros
                IconButton(
                  icon: const Icon(Icons.filter_list, color: DesignTokens.textPrimaryColor),
                  onPressed: _showFilterDialog,
                ),
              ],
            ),
          ),

          // Lista de productos
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredInventory.isEmpty
                    ? _buildEmptyState()
                    : _buildProductsList(_filteredInventory),
          ),
        ],
      ),
    );
  }

  Widget _buildStockAlertButton(
    String label,
    int count,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingSm,
          vertical: DesignTokens.spacingXs,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: DesignTokens.spacingXs),
            Text(
              '$count',
              style: TextStyle(
                color: color,
                fontWeight: DesignTokens.fontWeightBold,
                fontSize: DesignTokens.fontSizeSm,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _filtrarPorStock(String tipo) {
    setState(() {
      _stockFilter = tipo;
      _aplicarFiltros();
    });
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: DesignTokens.errorColor),
    );
  }


  Widget _buildProductsList(List<DetalleProducto> products) {
    return ListView.builder(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(DetalleProducto product) {
    return Card(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingMd),
      elevation: DesignTokens.elevationSm,
      child: InkWell(
        onTap: () => context.push('/inventory/${product.detalleProductoId}'),
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con nombre y estado de stock
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.producto,
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeLg,
                            fontWeight: DesignTokens.fontWeightBold,
                            color: DesignTokens.textPrimaryColor,
                          ),
                        ),
                        Text(
                          product.marca,
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeMd,
                            color: DesignTokens.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStockStatusChip(product),
                ],
              ),

              const SizedBox(height: DesignTokens.spacingMd),

              // Información del producto
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Categoría: ${product.categoria}',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeSm,
                            color: DesignTokens.textSecondaryColor,
                          ),
                        ),
                        const SizedBox(height: DesignTokens.spacingXs),
                        Text(
                          'Precio: ₡${_formatCurrency(product.precio)}',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeMd,
                            fontWeight: DesignTokens.fontWeightMedium,
                            color: DesignTokens.primaryColor,
                          ),
                        ),
                        if (product.codigoBarra.isNotEmpty) ...[
                          const SizedBox(height: DesignTokens.spacingXs),
                          Text(
                            'Código: ${product.codigoBarra}',
                            style: TextStyle(
                              fontSize: DesignTokens.fontSizeSm,
                              color: DesignTokens.textSecondaryColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Stock: ${product.stock}',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeLg,
                          fontWeight: DesignTokens.fontWeightBold,
                          color: _getStockColor(product),
                        ),
                      ),
                      Text(
                        'Costo: ₡${_formatCurrency(product.costo)}',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeSm,
                          color: DesignTokens.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStockStatusChip(DetalleProducto product) {
    Color color;
    String text;

    if (product.isOutOfStock) {
      color = DesignTokens.errorColor;
      text = 'Agotado';
    } else if (product.isLowStock) {
      color = DesignTokens.warningColor;
      text = 'Stock Bajo';
    } else {
      color = DesignTokens.successColor;
      text = 'Disponible';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingSm,
        vertical: DesignTokens.spacingXs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: DesignTokens.fontSizeSm,
          fontWeight: DesignTokens.fontWeightMedium,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return EmptyState(
      icon: Icons.inventory,
      title: 'No se encontraron productos',
      subtitle: 'Intenta ajustar los filtros o agregar nuevos productos',
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtrar Inventario'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Filtro por estado de stock
            DropdownButtonFormField<String>(
              initialValue: _stockFilter,
              decoration: const InputDecoration(
                labelText: 'Estado de Stock',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Todos', child: Text('Todos')),
                DropdownMenuItem(
                  value: 'Disponible',
                  child: Text('Disponible'),
                ),
                DropdownMenuItem(value: 'Bajo', child: Text('Stock Bajo')),
                DropdownMenuItem(value: 'Agotado', child: Text('Agotado')),
              ],
              onChanged: (value) {
                setState(() {
                  _stockFilter = value!;
                  _aplicarFiltros();
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _stockFilter = 'Todos';
                _aplicarFiltros();
              });
              Navigator.of(context).pop();
            },
            child: const Text('Restablecer'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );
  }


  Color _getStockColor(DetalleProducto product) {
    if (product.isOutOfStock) return DesignTokens.errorColor;
    if (product.isLowStock) return DesignTokens.warningColor;
    return DesignTokens.successColor;
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0);
  }
}
