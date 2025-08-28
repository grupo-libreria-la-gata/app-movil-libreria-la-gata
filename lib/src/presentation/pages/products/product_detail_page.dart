import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design/design_tokens.dart';
import '../../../domain/entities/product.dart';

/// Página que muestra el detalle completo de un producto
class ProductDetailPage extends ConsumerStatefulWidget {
  final String productId;
  
  const ProductDetailPage({
    super.key,
    required this.productId,
  });

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  bool _isEditing = false;
  late Product _product;
  final _formKey = GlobalKey<FormState>();
  
  // Controllers para edición
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _minStockController;
  late TextEditingController _barcodeController;

  @override
  void initState() {
    super.initState();
    _product = _getMockProduct();
    _initializeControllers();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _minStockController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: _product.name);
    _descriptionController = TextEditingController(text: _product.description);
    _priceController = TextEditingController(text: _product.price.toString());
    _stockController = TextEditingController(text: _product.stock.toString());
    _minStockController = TextEditingController(text: _product.minStock.toString());
    _barcodeController = TextEditingController(text: _product.barcode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.backgroundColor,
      appBar: AppBar(
        backgroundColor: DesignTokens.primaryColor,
        elevation: 0,
        title: Text(
          _isEditing ? 'Editar Producto' : 'Detalle del Producto',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (!_isEditing) ...[
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: _startEditing,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: _showDeleteDialog,
            ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.save, color: Colors.white),
              onPressed: _saveChanges,
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: _cancelEditing,
            ),
          ],
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Imagen del producto
            _buildProductImage(),
            
            // Información del producto
            Padding(
              padding: const EdgeInsets.all(DesignTokens.spacingLg),
              child: _isEditing ? _buildEditForm() : _buildProductInfo(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        color: DesignTokens.cardColor,
        boxShadow: DesignTokens.cardShadow,
      ),
      child: _product.imageUrl != null && _product.imageUrl!.isNotEmpty
          ? ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(DesignTokens.borderRadiusLg),
                bottomRight: Radius.circular(DesignTokens.borderRadiusLg),
              ),
              child: Image.network(
                _product.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
              ),
            )
          : _buildPlaceholderImage(),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        gradient: DesignTokens.primaryGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(DesignTokens.borderRadiusLg),
          bottomRight: Radius.circular(DesignTokens.borderRadiusLg),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_bar,
              size: 64,
              color: Colors.white.withValues(alpha: 0.8),
            ),
            const SizedBox(height: DesignTokens.spacingSm),
            Text(
              'Sin imagen',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: DesignTokens.fontSizeMd,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nombre y precio
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _product.name,
                    style: TextStyle(
                      fontSize: DesignTokens.fontSize2xl,
                      fontWeight: DesignTokens.fontWeightBold,
                      color: DesignTokens.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spacingXs),
                  Text(
                    _product.brand,
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeLg,
                      color: DesignTokens.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingMd,
                vertical: DesignTokens.spacingSm,
              ),
              decoration: BoxDecoration(
                color: DesignTokens.primaryColor,
                borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
              ),
              child: Text(
                '₡${_formatCurrency(_product.price)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: DesignTokens.fontSizeLg,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: DesignTokens.spacingLg),
        
        // Categoría y código de barras
        _buildInfoRow('Categoría', _product.category, Icons.category),
        _buildInfoRow('Código de Barras', _product.barcode ?? 'No especificado', Icons.qr_code),
        
        const SizedBox(height: DesignTokens.spacingLg),
        
        // Descripción
        if (_product.description.isNotEmpty) ...[
          Text(
            'Descripción',
            style: TextStyle(
              fontSize: DesignTokens.fontSizeLg,
              fontWeight: DesignTokens.fontWeightBold,
              color: DesignTokens.textPrimaryColor,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          Text(
            _product.description,
            style: TextStyle(
              fontSize: DesignTokens.fontSizeMd,
              color: DesignTokens.textSecondaryColor,
              height: 1.5,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingLg),
        ],
        
        // Stock y estado
        _buildStockSection(),
        
        const SizedBox(height: DesignTokens.spacingLg),
        
        // Información adicional
        _buildAdditionalInfo(),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacingMd),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: DesignTokens.textSecondaryColor,
          ),
          const SizedBox(width: DesignTokens.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeSm,
                    color: DesignTokens.textSecondaryColor,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeMd,
                    fontWeight: DesignTokens.fontWeightMedium,
                    color: DesignTokens.textPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockSection() {
    final isLowStock = _product.stock <= _product.minStock;
    final stockColor = isLowStock ? DesignTokens.errorColor : DesignTokens.successColor;
    
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingLg),
      decoration: BoxDecoration(
        color: DesignTokens.cardColor,
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
        boxShadow: DesignTokens.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.inventory,
                color: stockColor,
                size: 24,
              ),
              const SizedBox(width: DesignTokens.spacingSm),
              Text(
                'Stock',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeLg,
                  fontWeight: DesignTokens.fontWeightBold,
                  color: DesignTokens.textPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          Row(
            children: [
              Expanded(
                child: _buildStockInfo('Disponible', '${_product.stock}', stockColor),
              ),
              Expanded(
                child: _buildStockInfo('Mínimo', '${_product.minStock}', DesignTokens.warningColor),
              ),
            ],
          ),
          if (isLowStock) ...[
            const SizedBox(height: DesignTokens.spacingMd),
            Container(
              padding: const EdgeInsets.all(DesignTokens.spacingSm),
              decoration: BoxDecoration(
                color: DesignTokens.errorColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                border: Border.all(color: DesignTokens.errorColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: DesignTokens.errorColor,
                    size: 16,
                  ),
                  const SizedBox(width: DesignTokens.spacingSm),
                  Expanded(
                    child: Text(
                      'Stock bajo - Reabastecer pronto',
                      style: TextStyle(
                        color: DesignTokens.errorColor,
                        fontSize: DesignTokens.fontSizeSm,
                        fontWeight: DesignTokens.fontWeightMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStockInfo(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: DesignTokens.fontSizeSm,
            color: DesignTokens.textSecondaryColor,
          ),
        ),
        const SizedBox(height: DesignTokens.spacingXs),
        Text(
          value,
          style: TextStyle(
            fontSize: DesignTokens.fontSizeXl,
            fontWeight: DesignTokens.fontWeightBold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo() {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingLg),
      decoration: BoxDecoration(
        color: DesignTokens.cardColor,
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
        boxShadow: DesignTokens.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información Adicional',
            style: TextStyle(
              fontSize: DesignTokens.fontSizeLg,
              fontWeight: DesignTokens.fontWeightBold,
              color: DesignTokens.textPrimaryColor,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          _buildInfoRow('Estado', _product.isActive ? 'Activo' : 'Inactivo', Icons.circle),
          _buildInfoRow('Creado', _formatDate(_product.createdAt), Icons.calendar_today),
          if (_product.updatedAt != null)
            _buildInfoRow('Actualizado', _formatDate(_product.updatedAt!), Icons.update),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información del Producto',
            style: TextStyle(
              fontSize: DesignTokens.fontSizeXl,
              fontWeight: DesignTokens.fontWeightBold,
              color: DesignTokens.textPrimaryColor,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingLg),
          
          // Nombre
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nombre del Producto',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.local_bar),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El nombre es requerido';
              }
              return null;
            },
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          
          // Descripción
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Descripción',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.description),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          
          // Precio
          TextFormField(
            controller: _priceController,
            decoration: const InputDecoration(
              labelText: 'Precio (₡)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.attach_money),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El precio es requerido';
              }
              if (double.tryParse(value) == null) {
                return 'Ingrese un precio válido';
              }
              if (double.parse(value) <= 0) {
                return 'El precio debe ser mayor a 0';
              }
              return null;
            },
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          
          // Stock
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _stockController,
                  decoration: const InputDecoration(
                    labelText: 'Stock Actual',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.inventory),
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
              ),
              const SizedBox(width: DesignTokens.spacingMd),
              Expanded(
                child: TextFormField(
                  controller: _minStockController,
                  decoration: const InputDecoration(
                    labelText: 'Stock Mínimo',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.warning),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El stock mínimo es requerido';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Ingrese un número válido';
                    }
                    if (int.parse(value) < 0) {
                      return 'El stock mínimo no puede ser negativo';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          
          // Código de barras
          TextFormField(
            controller: _barcodeController,
            decoration: const InputDecoration(
              labelText: 'Código de Barras',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.qr_code),
            ),
          ),
        ],
      ),
    );
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _initializeControllers(); // Restaurar valores originales
    });
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      // Aquí se guardarían los cambios en la API
      setState(() {
        _product = _product.copyWith(
          name: _nameController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          stock: int.parse(_stockController.text),
          minStock: int.parse(_minStockController.text),
          barcode: _barcodeController.text,
          updatedAt: DateTime.now(),
        );
        _isEditing = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Producto actualizado exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Producto'),
        content: Text('¿Estás seguro de que quieres eliminar "${_product.name}"? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Aquí se eliminaría el producto en la API
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Producto eliminado'),
                  backgroundColor: Colors.red,
                ),
              );
              context.pop(); // Regresar a la lista
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  // Datos mock para el producto
  Product _getMockProduct() {
    return Product(
      id: widget.productId,
      name: 'Ron Flor de Caña 7 años',
      description: 'Ron premium añejado por 7 años en barriles de roble blanco americano. Con un sabor suave y equilibrado, notas de vainilla y caramelo.',
      category: 'Ron',
      brand: 'Flor de Caña',
      price: 8500.0,
      stock: 15,
      minStock: 10,
      imageUrl: null, // Sin imagen por ahora
      barcode: '7891234567890',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    );
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
