import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design/design_tokens.dart';
import '../../../domain/entities/product.dart';

/// Página de control de inventario
class InventoryPage extends ConsumerStatefulWidget {
  const InventoryPage({super.key});

  @override
  ConsumerState<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends ConsumerState<InventoryPage> {
  String _searchQuery = '';
  String _selectedCategory = 'Todas';
  String _stockFilter = 'Todos'; // Todos, Bajo, Agotado, Disponible

  @override
  Widget build(BuildContext context) {
    final products = _getFilteredProducts();
    final lowStockProducts = products.where((p) => p.lowStock).toList();
    final outOfStockProducts = products.where((p) => p.outOfStock).toList();

    return Scaffold(
      backgroundColor: DesignTokens.backgroundColor,
      appBar: AppBar(
        backgroundColor: DesignTokens.primaryColor,
        elevation: 0,
        title: const Text(
          'Control de Inventario',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          _buildSearchBar(),

          // Filtros activos
          if (_searchQuery.isNotEmpty ||
              _selectedCategory != 'Todas' ||
              _stockFilter != 'Todos')
            _buildActiveFilters(),

          // Alertas de stock
          if (lowStockProducts.isNotEmpty || outOfStockProducts.isNotEmpty)
            _buildStockAlerts(lowStockProducts, outOfStockProducts),

          // Lista de productos
          Expanded(child: _buildProductsList(products)),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: DesignTokens.cardColor,
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
        boxShadow: DesignTokens.cardShadow,
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Buscar productos por nombre, código...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingMd,
            vertical: DesignTokens.spacingSm,
          ),
        ),
      ),
    );
  }

  Widget _buildActiveFilters() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingMd),
      child: Wrap(
        spacing: DesignTokens.spacingSm,
        children: [
          if (_searchQuery.isNotEmpty)
            Chip(
              label: Text('Búsqueda: $_searchQuery'),
              onDeleted: () {
                setState(() {
                  _searchQuery = '';
                });
              },
              backgroundColor: DesignTokens.primaryColor.withValues(alpha: 0.1),
            ),
          if (_selectedCategory != 'Todas')
            Chip(
              label: Text('Categoría: $_selectedCategory'),
              onDeleted: () {
                setState(() {
                  _selectedCategory = 'Todas';
                });
              },
              backgroundColor: DesignTokens.accentColor.withValues(alpha: 0.1),
            ),
          if (_stockFilter != 'Todos')
            Chip(
              label: Text('Stock: $_stockFilter'),
              onDeleted: () {
                setState(() {
                  _stockFilter = 'Todos';
                });
              },
              backgroundColor: DesignTokens.warningColor.withValues(alpha: 0.1),
            ),
        ],
      ),
    );
  }

  Widget _buildStockAlerts(
    List<Product> lowStockProducts,
    List<Product> outOfStockProducts,
  ) {
    return Container(
      margin: const EdgeInsets.all(DesignTokens.spacingMd),
      child: Column(
        children: [
          if (outOfStockProducts.isNotEmpty)
            _buildAlertCard(
              'Productos Agotados',
              '${outOfStockProducts.length} productos sin stock',
              Icons.error,
              DesignTokens.errorColor,
              () => _showProductsList(outOfStockProducts, 'Productos Agotados'),
            ),
          if (lowStockProducts.isNotEmpty) ...[
            const SizedBox(height: DesignTokens.spacingSm),
            _buildAlertCard(
              'Stock Bajo',
              '${lowStockProducts.length} productos con stock bajo',
              Icons.warning,
              DesignTokens.warningColor,
              () => _showProductsList(
                lowStockProducts,
                'Productos con Stock Bajo',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAlertCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: DesignTokens.elevationSm,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
        child: Container(
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
          decoration: BoxDecoration(
            border: Border.all(color: color.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacingSm),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    DesignTokens.borderRadiusSm,
                  ),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: DesignTokens.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeLg,
                        fontWeight: DesignTokens.fontWeightBold,
                        color: DesignTokens.textPrimaryColor,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeMd,
                        color: DesignTokens.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductsList(List<Product> products) {
    if (products.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingMd),
      elevation: DesignTokens.elevationSm,
      child: InkWell(
        onTap: () => context.push('/products/${product.id}'),
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
                          product.name,
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeLg,
                            fontWeight: DesignTokens.fontWeightBold,
                            color: DesignTokens.textPrimaryColor,
                          ),
                        ),
                        Text(
                          product.brand,
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
                          'Categoría: ${product.category}',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeSm,
                            color: DesignTokens.textSecondaryColor,
                          ),
                        ),
                        const SizedBox(height: DesignTokens.spacingXs),
                        Text(
                          'Precio: ₡${_formatCurrency(product.price)}',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeMd,
                            fontWeight: DesignTokens.fontWeightMedium,
                            color: DesignTokens.primaryColor,
                          ),
                        ),
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
                        'Mínimo: ${product.minStock}',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeSm,
                          color: DesignTokens.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: DesignTokens.spacingMd),

              // Acciones
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showAdjustStockDialog(product),
                      icon: const Icon(Icons.edit),
                      label: const Text('Ajustar Stock'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: DesignTokens.primaryColor,
                        side: BorderSide(color: DesignTokens.primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spacingSm),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showRestockDialog(product),
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text('Reabastecer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DesignTokens.successColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStockStatusChip(Product product) {
    Color color;
    String text;

    if (product.outOfStock) {
      color = DesignTokens.errorColor;
      text = 'Agotado';
    } else if (product.lowStock) {
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory,
            size: 64,
            color: DesignTokens.textSecondaryColor,
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          Text(
            'No se encontraron productos',
            style: TextStyle(
              fontSize: DesignTokens.fontSizeLg,
              fontWeight: DesignTokens.fontWeightMedium,
              color: DesignTokens.textSecondaryColor,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          Text(
            'Intenta ajustar los filtros',
            style: TextStyle(
              fontSize: DesignTokens.fontSizeMd,
              color: DesignTokens.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
            // Filtro por categoría
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Categoría',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem(
                  value: 'Todas',
                  child: Text('Todas las categorías'),
                ),
                const DropdownMenuItem(
                  value: 'Whiskey',
                  child: Text('Whiskey'),
                ),
                const DropdownMenuItem(value: 'Vodka', child: Text('Vodka')),
                const DropdownMenuItem(value: 'Ron', child: Text('Ron')),
                const DropdownMenuItem(
                  value: 'Tequila',
                  child: Text('Tequila'),
                ),
                const DropdownMenuItem(value: 'Gin', child: Text('Gin')),
                const DropdownMenuItem(value: 'Vino', child: Text('Vino')),
                const DropdownMenuItem(
                  value: 'Cerveza',
                  child: Text('Cerveza'),
                ),
                const DropdownMenuItem(value: 'Licor', child: Text('Licor')),
                const DropdownMenuItem(value: 'Otros', child: Text('Otros')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),

            const SizedBox(height: DesignTokens.spacingMd),

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
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedCategory = 'Todas';
                _stockFilter = 'Todos';
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

  void _showProductsList(List<Product> products, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text(
                  'Stock: ${product.stock} | Mínimo: ${product.minStock}',
                ),
                trailing: Text('₡${_formatCurrency(product.price)}'),
                onTap: () {
                  Navigator.of(context).pop();
                  context.push('/products/${product.id}');
                },
              );
            },
          ),
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

  void _showAdjustStockDialog(Product product) {
    final stockController = TextEditingController(
      text: product.stock.toString(),
    );
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ajustar Stock - ${product.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: stockController,
              decoration: const InputDecoration(
                labelText: 'Nuevo stock',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El stock es requerido';
                }
                if (int.tryParse(value) == null) {
                  return 'Ingrese un número válido';
                }
                if (int.parse(value) < 0) {
                  return 'El stock no puede ser negativo';
                }
                return null;
              },
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            TextFormField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Motivo del ajuste (opcional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // Aquí se guardaría el ajuste en la API
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Stock ajustado exitosamente'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Ajustar'),
          ),
        ],
      ),
    );
  }

  void _showRestockDialog(Product product) {
    final quantityController = TextEditingController();
    final costController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reabastecer - ${product.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: quantityController,
              decoration: const InputDecoration(
                labelText: 'Cantidad a agregar',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'La cantidad es requerida';
                }
                if (int.tryParse(value) == null) {
                  return 'Ingrese un número válido';
                }
                if (int.parse(value) <= 0) {
                  return 'La cantidad debe ser mayor a 0';
                }
                return null;
              },
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            TextFormField(
              controller: costController,
              decoration: const InputDecoration(
                labelText: 'Costo por unidad (₡)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El costo es requerido';
                }
                if (double.tryParse(value) == null) {
                  return 'Ingrese un número válido';
                }
                if (double.parse(value) <= 0) {
                  return 'El costo debe ser mayor a 0';
                }
                return null;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // Aquí se guardaría el reabastecimiento en la API
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Producto reabastecido exitosamente'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Reabastecer'),
          ),
        ],
      ),
    );
  }

  // Datos mock para los productos
  List<Product> _getMockProducts() {
    return [
      Product(
        id: '1',
        name: 'Ron Flor de Caña 7 años',
        description: 'Ron premium añejado por 7 años',
        category: 'Ron',
        brand: 'Flor de Caña',
        price: 8500.0,
        stock: 5,
        minStock: 10,
        barcode: '7891234567890',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      Product(
        id: '2',
        name: 'Vodka Absolut',
        description: 'Vodka premium sueco',
        category: 'Vodka',
        brand: 'Absolut',
        price: 12000.0,
        stock: 0,
        minStock: 5,
        barcode: '7891234567891',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
      ),
      Product(
        id: '3',
        name: 'Whisky Jack Daniel\'s',
        description: 'Whisky americano clásico',
        category: 'Whiskey',
        brand: 'Jack Daniel\'s',
        price: 15000.0,
        stock: 25,
        minStock: 10,
        barcode: '7891234567892',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      Product(
        id: '4',
        name: 'Tequila José Cuervo',
        description: 'Tequila mexicano tradicional',
        category: 'Tequila',
        brand: 'José Cuervo',
        price: 9500.0,
        stock: 8,
        minStock: 10,
        barcode: '7891234567893',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      Product(
        id: '5',
        name: 'Gin Bombay Sapphire',
        description: 'Gin premium inglés',
        category: 'Gin',
        brand: 'Bombay Sapphire',
        price: 18000.0,
        stock: 15,
        minStock: 8,
        barcode: '7891234567894',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];
  }

  List<Product> _getFilteredProducts() {
    List<Product> products = _getMockProducts();

    // Filtro por búsqueda
    if (_searchQuery.isNotEmpty) {
      products = products
          .where(
            (product) =>
                product.name.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                product.brand.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                (product.barcode?.contains(_searchQuery) ?? false),
          )
          .toList();
    }

    // Filtro por categoría
    if (_selectedCategory != 'Todas') {
      products = products
          .where((product) => product.category == _selectedCategory)
          .toList();
    }

    // Filtro por estado de stock
    switch (_stockFilter) {
      case 'Disponible':
        products = products
            .where((product) => !product.lowStock && !product.outOfStock)
            .toList();
        break;
      case 'Bajo':
        products = products
            .where((product) => product.lowStock && !product.outOfStock)
            .toList();
        break;
      case 'Agotado':
        products = products.where((product) => product.outOfStock).toList();
        break;
    }

    return products;
  }

  Color _getStockColor(Product product) {
    if (product.outOfStock) return DesignTokens.errorColor;
    if (product.lowStock) return DesignTokens.warningColor;
    return DesignTokens.successColor;
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0);
  }
}
