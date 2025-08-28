import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design/design_tokens.dart';
import '../../../core/services/error_service.dart';
import '../../../core/services/mock_data_service.dart';
import '../../widgets/product_card.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/loading_widgets.dart' as loading_widgets;

/// Página para gestionar productos (licores)
class ProductsPage extends ConsumerStatefulWidget {
  const ProductsPage({super.key});

  @override
  ConsumerState<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> with LoadingMixin {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Todas';
  String _sortBy = 'name';

  // Datos de ejemplo - esto vendría de un provider
  late List<Map<String, dynamic>> _products;

  List<Map<String, dynamic>> get _filteredProducts {
    var filtered = List<Map<String, dynamic>>.from(_products);

    // Filtrar por búsqueda
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((product) {
        final search = _searchController.text.toLowerCase();
        return product['name'].toLowerCase().contains(search) ||
               product['brand'].toLowerCase().contains(search);
      }).toList();
    }

    // Filtrar por categoría
    if (_selectedCategory != 'Todas') {
      filtered = filtered.where((product) {
        return product['category'] == _selectedCategory;
      }).toList();
    }

    // Ordenar
    filtered.sort((a, b) {
      switch (_sortBy) {
        case 'name':
          return a['name'].compareTo(b['name']);
        case 'price':
          return a['price'].compareTo(b['price']);
        case 'stock':
          return a['stock'].compareTo(b['stock']);
        default:
          return a['name'].compareTo(b['name']);
      }
    });

    return filtered;
  }

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Carga los productos con manejo de errores
  Future<void> _loadProducts() async {
    await executeWithErrorHandling(() async {
      // Simular carga de productos desde API
      await Future.delayed(const Duration(seconds: 1));
      
      // Cargar productos desde el servicio mock
      _products = MockDataService().mockProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.backgroundColor,
      appBar: AppBar(
        backgroundColor: DesignTokens.primaryColor,
        elevation: 0,
        title: const Text(
          'Productos',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => context.push('/products/new'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda y filtros
          _buildSearchAndFilters(),
          
          // Contenido principal
          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
    );
  }

  /// Construye el contenido principal con manejo de estados
  Widget _buildMainContent() {
    if (loadingState.isLoading) {
      return const Center(
        child: loading_widgets.LoadingSpinner(message: 'Cargando productos...'),
      );
    }

    if (loadingState.hasError) {
      return loading_widgets.ErrorWidget(
        message: loadingState.error!,
        onRetry: _loadProducts,
      );
    }

    if (loadingState.isOffline) {
      return loading_widgets.ErrorWidget(
        message: 'No hay conexión a internet',
        onRetry: _loadProducts,
        icon: Icons.wifi_off,
      );
    }

    if (_filteredProducts.isEmpty) {
      return loading_widgets.EmptyStateWidget(
        title: 'No se encontraron productos',
        subtitle: 'Intenta ajustar los filtros de búsqueda',
        icon: Icons.inventory_2_outlined,
        actionText: 'Recargar',
        onAction: _loadProducts,
      );
    }

    return _buildProductsList();
  }

  /// Construye la barra de búsqueda y filtros
  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Barra de búsqueda
          SearchBarWidget(
            controller: _searchController,
            hintText: 'Buscar productos...',
            onChanged: (value) => setState(() {}),
          ),
          
          const SizedBox(height: DesignTokens.spacingMd),
          
          // Filtros
          Row(
            children: [
              // Filtro por categoría
              Expanded(
                child: _buildCategoryFilter(),
              ),
              const SizedBox(width: DesignTokens.spacingMd),
              // Ordenar por
              Expanded(
                child: _buildSortFilter(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construye el filtro de categorías
  Widget _buildCategoryFilter() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: InputDecoration(
        labelText: 'Categoría',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingMd,
          vertical: DesignTokens.spacingSm,
        ),
      ),
      items: [
        'Todas',
        'Whiskey',
        'Ron',
        'Vodka',
        'Tequila',
        'Gin',
        'Vino',
        'Cerveza',
        'Licor',
      ].map((category) {
        return DropdownMenuItem(
          value: category,
          child: Text(category),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCategory = value!;
        });
      },
    );
  }

  /// Construye el filtro de ordenamiento
  Widget _buildSortFilter() {
    return DropdownButtonFormField<String>(
      value: _sortBy,
      decoration: InputDecoration(
        labelText: 'Ordenar por',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingMd,
          vertical: DesignTokens.spacingSm,
        ),
      ),
      items: [
        DropdownMenuItem(value: 'name', child: const Text('Nombre')),
        DropdownMenuItem(value: 'price', child: const Text('Precio')),
        DropdownMenuItem(value: 'stock', child: const Text('Stock')),
      ],
      onChanged: (value) {
        setState(() {
          _sortBy = value!;
        });
      },
    );
  }

  /// Construye la lista de productos
  Widget _buildProductsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: DesignTokens.spacingMd),
          child: ProductCard(
            product: product,
            onTap: () => context.push('/products/${product['id']}'),
            onEdit: () => context.push('/products/${product['id']}/edit'),
          ),
        );
      },
    );
  }

  /// Construye el estado vacío
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: DesignTokens.textSecondaryColor,
          ),
          const SizedBox(height: DesignTokens.spacingLg),
          Text(
            'No se encontraron productos',
            style: TextStyle(
              fontSize: DesignTokens.fontSizeLg,
              fontWeight: DesignTokens.fontWeightMedium,
              color: DesignTokens.textSecondaryColor,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          Text(
            'Intenta ajustar los filtros o agregar nuevos productos',
            style: TextStyle(
              fontSize: DesignTokens.fontSizeMd,
              color: DesignTokens.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignTokens.spacingLg),
          ElevatedButton.icon(
            onPressed: () => context.push('/products/new'),
            icon: const Icon(Icons.add),
            label: const Text('Agregar Producto'),
            style: ElevatedButton.styleFrom(
              backgroundColor: DesignTokens.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingLg,
                vertical: DesignTokens.spacingMd,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
