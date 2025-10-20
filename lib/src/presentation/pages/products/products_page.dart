import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design/design_tokens.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/services/error_service.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/services/filter_service.dart';
import '../../widgets/product_card.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/advanced_filters_widget.dart';
import '../../widgets/filter_chips_widget.dart';
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
  bool _sortAscending = true;
  Map<String, dynamic> _advancedFilters = {};

  // Datos de ejemplo - esto vendría de un provider
  late List<Map<String, dynamic>> _products;

  List<Map<String, dynamic>> get _filteredProducts {
    final filterService = FilterService();

    // Combinar filtros básicos con avanzados
    final allFilters = <String, dynamic>{
      'search': _searchController.text,
      'category': _selectedCategory,
      ..._advancedFilters,
    };

    // Aplicar filtros combinados
    var filtered = filterService.applyProductFilters(_products, allFilters);

    // Aplicar ordenamiento
    filtered = filterService.sortProducts(filtered, _sortBy, _sortAscending);

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
        title: const Text('Productos', style: TextStyle(color: Colors.white)),
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
          Expanded(child: _buildMainContent()),
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
    final responsiveHelper = ResponsiveHelper.instance;

    return Container(
      padding: EdgeInsets.all(
        responsiveHelper.getResponsiveSpacing(context, DesignTokens.spacingMd),
      ),
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

          SizedBox(
            height: responsiveHelper.getResponsiveSpacing(
              context,
              DesignTokens.spacingMd,
            ),
          ),

          // Filtros básicos - Cambiar a columna en móviles pequeños
          ResponsiveHelper.instance.isSmallMobile(context)
              ? Column(
                  children: [
                    _buildCategoryFilter(),
                    SizedBox(
                      height: responsiveHelper.getResponsiveSpacing(
                        context,
                        DesignTokens.spacingMd,
                      ),
                    ),
                    _buildSortFilter(),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: _buildCategoryFilter()),
                    SizedBox(
                      width: responsiveHelper.getResponsiveSpacing(
                        context,
                        DesignTokens.spacingMd,
                      ),
                    ),
                    Expanded(child: _buildSortFilter()),
                  ],
                ),

          SizedBox(
            height: responsiveHelper.getResponsiveSpacing(
              context,
              DesignTokens.spacingMd,
            ),
          ),

          // Filtros avanzados
          AdvancedFiltersWidget(
            filters: _advancedFilters,
            onFiltersChanged: (filters) {
              setState(() {
                _advancedFilters = filters;
              });
            },
            onClearFilters: () {
              setState(() {
                _advancedFilters = {};
              });
            },
          ),

          // Chips de filtros activos
          if (FilterService().getActiveFiltersCount(_advancedFilters) > 0) ...[
            SizedBox(
              height: responsiveHelper.getResponsiveSpacing(
                context,
                DesignTokens.spacingSm,
              ),
            ),
            FilterChipsWidget(
              filters: _advancedFilters,
              onRemoveFilter: (key) {
                setState(() {
                  _advancedFilters.remove(key);
                });
              },
              onClearAll: () {
                setState(() {
                  _advancedFilters = {};
                });
              },
            ),
            SizedBox(
              height: responsiveHelper.getResponsiveSpacing(
                context,
                DesignTokens.spacingSm,
              ),
            ),
            _buildFilterStats(),
          ],
        ],
      ),
    );
  }

  /// Construye el filtro de categorías
  Widget _buildCategoryFilter() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedCategory,
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
      items:
          [
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
            return DropdownMenuItem(value: category, child: Text(category));
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
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            initialValue: _sortBy,
            decoration: InputDecoration(
              labelText: 'Ordenar por',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  DesignTokens.borderRadiusMd,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingMd,
                vertical: DesignTokens.spacingSm,
              ),
            ),
            items: [
              DropdownMenuItem(value: 'name', child: const Text('Nombre')),
              DropdownMenuItem(value: 'brand', child: const Text('Marca')),
              DropdownMenuItem(
                value: 'category',
                child: const Text('Categoría'),
              ),
              DropdownMenuItem(value: 'price', child: const Text('Precio')),
              DropdownMenuItem(value: 'stock', child: const Text('Stock')),
              DropdownMenuItem(value: 'createdAt', child: const Text('Fecha')),
            ],
            onChanged: (value) {
              setState(() {
                _sortBy = value!;
              });
            },
          ),
        ),
        const SizedBox(width: DesignTokens.spacingSm),
        IconButton(
          onPressed: () {
            setState(() {
              _sortAscending = !_sortAscending;
            });
          },
          icon: Icon(
            _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
            size: 20,
          ),
          tooltip: _sortAscending ? 'Ascendente' : 'Descendente',
          style: IconButton.styleFrom(
            backgroundColor: DesignTokens.primaryColor.withValues(alpha: 0.1),
            foregroundColor: DesignTokens.primaryColor,
          ),
        ),
      ],
    );
  }

  /// Construye las estadísticas de filtros
  Widget _buildFilterStats() {
    final filterService = FilterService();
    final stats = filterService.getFilterStats(_products, _filteredProducts);
    final activeFiltersCount = filterService.getActiveFiltersCount(
      _advancedFilters,
    );

    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingSm),
      decoration: BoxDecoration(
        color: DesignTokens.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
        border: Border.all(
          color: DesignTokens.primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.filter_list, size: 16, color: DesignTokens.primaryColor),
          const SizedBox(width: DesignTokens.spacingXs),
          Expanded(
            child: Text(
              '$activeFiltersCount filtros activos • ${stats['filtered']} de ${stats['total']} productos (${stats['percentage']}%)',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeSm,
                color: DesignTokens.primaryColor,
                fontWeight: DesignTokens.fontWeightMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construye la lista de productos
  Widget _buildProductsList() {
    final responsiveHelper = ResponsiveHelper.instance;

    return ListView.builder(
      padding: EdgeInsets.all(
        responsiveHelper.getResponsiveSpacing(context, DesignTokens.spacingMd),
      ),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return Padding(
          padding: EdgeInsets.only(
            bottom: responsiveHelper.getResponsiveSpacing(
              context,
              DesignTokens.spacingMd,
            ),
          ),
          child: ProductCard(
            product: product,
            onTap: () => context.push('/products/${product['id']}'),
            onEdit: () => context.push('/products/${product['id']}/edit'),
          ),
        );
      },
    );
  }
}
