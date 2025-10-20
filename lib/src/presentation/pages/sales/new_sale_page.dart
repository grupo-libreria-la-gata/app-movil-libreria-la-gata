import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design/design_tokens.dart';
import '../../../core/services/business_service.dart';
import '../../../core/services/error_service.dart';
import '../../../core/services/mock_data_service.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/product_card.dart';

/// Página para crear una nueva venta
class NewSalePage extends ConsumerStatefulWidget {
  const NewSalePage({super.key});

  @override
  ConsumerState<NewSalePage> createState() => _NewSalePageState();
}

class _NewSalePageState extends ConsumerState<NewSalePage> with LoadingMixin {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerPhoneController =
      TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  final List<Map<String, dynamic>> _cartItems = [];
  String _selectedPaymentMethod = 'Efectivo';
  DiscountType _selectedDiscountType = DiscountType.none;
  double _discountValue = 0.0;

  // Datos de ejemplo - esto vendría de un provider
  late List<Map<String, dynamic>> _availableProducts;

  List<Map<String, dynamic>> get _filteredProducts {
    if (_searchController.text.isEmpty) {
      return _availableProducts;
    }

    return _availableProducts.where((product) {
      final search = _searchController.text.toLowerCase();
      return product['name'].toLowerCase().contains(search) ||
          product['brand'].toLowerCase().contains(search);
    }).toList();
  }

  double get _subtotal {
    return BusinessService().calculateSubtotal(_cartItems);
  }

  double get _tax {
    return BusinessService().calculateTax(_subtotal);
  }

  double get _discount {
    return BusinessService().calculateDiscount(
      _subtotal,
      _selectedDiscountType,
      _discountValue,
    );
  }

  double get _total {
    return BusinessService().calculateTotal(_subtotal, _tax, _discount);
  }

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  /// Carga los productos disponibles
  Future<void> _loadProducts() async {
    await executeWithErrorHandling(() async {
      // Simular carga de productos
      await Future.delayed(const Duration(seconds: 1));

      // Cargar productos desde el servicio mock
      _availableProducts = MockDataService().mockProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.backgroundColor,
      appBar: AppBar(
        backgroundColor: DesignTokens.primaryColor,
        elevation: 0,
        title: const Text('Nueva Venta', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Información del cliente
          _buildCustomerInfo(),

          // Productos disponibles
          Expanded(child: _buildProductsSection()),

          // Carrito y total
          _buildCartSection(),
        ],
      ),
    );
  }

  /// Construye la sección de información del cliente
  Widget _buildCustomerInfo() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información del Cliente',
            style: TextStyle(
              fontSize: DesignTokens.fontSizeLg,
              fontWeight: DesignTokens.fontWeightBold,
              color: DesignTokens.textPrimaryColor,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _customerNameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre del Cliente',
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
                ),
              ),
              const SizedBox(width: DesignTokens.spacingMd),
              Expanded(
                child: TextField(
                  controller: _customerPhoneController,
                  decoration: InputDecoration(
                    labelText: 'Teléfono (opcional)',
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construye la sección de productos
  Widget _buildProductsSection() {
    return Column(
      children: [
        // Barra de búsqueda
        Container(
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
          child: SearchBarWidget(
            controller: _searchController,
            hintText: 'Buscar productos...',
            onChanged: (value) => setState(() {}),
          ),
        ),

        // Lista de productos
        Expanded(
          child: _filteredProducts.isEmpty
              ? _buildEmptyProductsState()
              : _buildProductsList(),
        ),
      ],
    );
  }

  /// Construye la lista de productos
  Widget _buildProductsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingMd),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: DesignTokens.spacingMd),
          child: ProductCard(
            product: product,
            onTap: () => _addToCart(product),
          ),
        );
      },
    );
  }

  /// Construye el estado vacío de productos
  Widget _buildEmptyProductsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
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
        ],
      ),
    );
  }

  /// Construye la sección del carrito
  Widget _buildCartSection() {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Items del carrito
          if (_cartItems.isNotEmpty) ...[_buildCartItems(), const Divider()],

          // Totales
          _buildTotals(),

          const SizedBox(height: DesignTokens.spacingMd),

          // Método de pago
          _buildPaymentMethod(),

          const SizedBox(height: DesignTokens.spacingMd),

          // Configuración de descuentos
          _buildDiscountSection(),

          const SizedBox(height: DesignTokens.spacingMd),

          // Botón de finalizar venta
          _buildFinishSaleButton(),
        ],
      ),
    );
  }

  /// Construye los items del carrito
  Widget _buildCartItems() {
    return Column(
      children: _cartItems.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: DesignTokens.spacingSm),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${item['name']} x${item['quantity']}',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeMd,
                    color: DesignTokens.textPrimaryColor,
                  ),
                ),
              ),
              Text(
                '₡${item['total'].toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeMd,
                  fontWeight: DesignTokens.fontWeightMedium,
                  color: DesignTokens.textPrimaryColor,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.remove_circle_outline,
                  color: Colors.red,
                ),
                onPressed: () => _removeFromCart(item['id']),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// Construye los totales
  Widget _buildTotals() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Subtotal:',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeMd,
                color: DesignTokens.textSecondaryColor,
              ),
            ),
            Text(
              '₡${_subtotal.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeMd,
                color: DesignTokens.textPrimaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: DesignTokens.spacingXs),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'IVA (15%):',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeMd,
                color: DesignTokens.textSecondaryColor,
              ),
            ),
            Text(
              '₡${_tax.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeMd,
                color: DesignTokens.textPrimaryColor,
              ),
            ),
          ],
        ),
        if (_selectedDiscountType != DiscountType.none) ...[
          const SizedBox(height: DesignTokens.spacingXs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Descuento:',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeMd,
                  color: DesignTokens.textSecondaryColor,
                ),
              ),
              Text(
                '-₡${_discount.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeMd,
                  color: DesignTokens.errorColor,
                ),
              ),
            ],
          ),
        ],
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total:',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeLg,
                fontWeight: DesignTokens.fontWeightBold,
                color: DesignTokens.textPrimaryColor,
              ),
            ),
            Text(
              '₡${_total.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeLg,
                fontWeight: DesignTokens.fontWeightBold,
                color: DesignTokens.primaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Construye la sección de descuentos
  Widget _buildDiscountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descuento:',
          style: TextStyle(
            fontSize: DesignTokens.fontSizeMd,
            color: DesignTokens.textSecondaryColor,
          ),
        ),
        const SizedBox(height: DesignTokens.spacingSm),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<DiscountType>(
                initialValue: _selectedDiscountType,
                decoration: InputDecoration(
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
                items: DiscountType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.displayName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDiscountType = value!;
                    _discountValue = 0.0;
                    _discountController.clear();
                  });
                },
              ),
            ),
            if (_selectedDiscountType != DiscountType.none) ...[
              const SizedBox(width: DesignTokens.spacingMd),
              Expanded(
                child: TextFormField(
                  controller: _discountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: _selectedDiscountType == DiscountType.percentage
                        ? '15%'
                        : '₡1000',
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
                  onChanged: (value) {
                    setState(() {
                      _discountValue = double.tryParse(value) ?? 0.0;
                    });
                  },
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  /// Construye el método de pago
  Widget _buildPaymentMethod() {
    return Row(
      children: [
        Text(
          'Método de pago:',
          style: TextStyle(
            fontSize: DesignTokens.fontSizeMd,
            color: DesignTokens.textSecondaryColor,
          ),
        ),
        const SizedBox(width: DesignTokens.spacingMd),
        Expanded(
          child: DropdownButtonFormField<String>(
            initialValue: _selectedPaymentMethod,
            decoration: InputDecoration(
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
            items: ['Efectivo', 'Tarjeta', 'Transferencia', 'Móvil'].map((
              method,
            ) {
              return DropdownMenuItem(value: method, child: Text(method));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  /// Construye el botón de finalizar venta
  Widget _buildFinishSaleButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _cartItems.isEmpty || loadingState.isLoading
            ? null
            : _finishSale,
        style: ElevatedButton.styleFrom(
          backgroundColor: DesignTokens.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingMd),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
          ),
        ),
        child: loadingState.isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                'Finalizar Venta - ₡${_total.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeLg,
                  fontWeight: DesignTokens.fontWeightBold,
                ),
              ),
      ),
    );
  }

  /// Agrega un producto al carrito
  void _addToCart(Map<String, dynamic> product) {
    final existingIndex = _cartItems.indexWhere(
      (item) => item['id'] == product['id'],
    );

    setState(() {
      if (existingIndex != -1) {
        // Incrementar cantidad
        _cartItems[existingIndex]['quantity']++;
        _cartItems[existingIndex]['total'] =
            _cartItems[existingIndex]['quantity'] *
            _cartItems[existingIndex]['price'];
      } else {
        // Agregar nuevo item
        _cartItems.add({
          'id': product['id'],
          'name': product['name'],
          'price': product['price'],
          'quantity': 1,
          'total': product['price'],
        });
      }
    });
  }

  /// Remueve un producto del carrito
  void _removeFromCart(String productId) {
    setState(() {
      _cartItems.removeWhere((item) => item['id'] == productId);
    });
  }

  /// Finaliza la venta
  void _finishSale() async {
    if (_customerNameController.text.trim().isEmpty) {
      ErrorService().showErrorSnackBar(
        context,
        'Por favor ingresa el nombre del cliente',
      );
      return;
    }

    await executeWithErrorHandling(() async {
      // Simular procesamiento
      await Future.delayed(const Duration(seconds: 2));

      // Mostrar confirmación
      if (mounted) {
        ErrorService().showSuccessSnackBar(
          context,
          'Venta completada - Total: ₡${_total.toStringAsFixed(0)}',
        );

        // Regresar al dashboard
        context.go('/dashboard');
      }
    });
  }
}
