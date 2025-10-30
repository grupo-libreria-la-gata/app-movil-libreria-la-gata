import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design/design_tokens.dart';
import '../../../data/models/detalle_producto_model.dart';
import '../../../data/services/detalle_producto_service.dart';

class InventoryDetailPage extends ConsumerStatefulWidget {
  final int detalleProductoId;

  const InventoryDetailPage({
    super.key,
    required this.detalleProductoId,
  });

  @override
  ConsumerState<InventoryDetailPage> createState() => _InventoryDetailPageState();
}

class _InventoryDetailPageState extends ConsumerState<InventoryDetailPage> {
  DetalleProducto? _producto;
  bool _isLoading = true;
  final DetalleProductoService _service = DetalleProductoService();

  @override
  void initState() {
    super.initState();
    _cargarProducto();
  }

  Future<void> _cargarProducto() async {
    setState(() => _isLoading = true);
    try {
      final producto = await _service.obtenerPorId(widget.detalleProductoId);
      setState(() {
        _producto = producto;
      });
    } catch (e) {
      _mostrarError('Error al cargar producto: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.backgroundColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _producto == null
              ? _buildErrorState()
              : _buildProductDetail(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: DesignTokens.errorColor,
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          Text(
            'Producto no encontrado',
            style: TextStyle(
              fontSize: DesignTokens.fontSizeLg,
              fontWeight: DesignTokens.fontWeightBold,
              color: DesignTokens.textPrimaryColor,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          Text(
            'El producto solicitado no existe o fue eliminado',
            style: TextStyle(
              fontSize: DesignTokens.fontSizeMd,
              color: DesignTokens.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignTokens.spacingLg),
          ElevatedButton(
            onPressed: () => context.pop(),
            child: const Text('Volver'),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetail() {
    final producto = _producto!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con nombre y estado
          Card(
            elevation: DesignTokens.elevationSm,
            child: Padding(
              padding: const EdgeInsets.all(DesignTokens.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              producto.producto,
                              style: TextStyle(
                                fontSize: DesignTokens.fontSizeXl,
                                fontWeight: DesignTokens.fontWeightBold,
                                color: DesignTokens.textPrimaryColor,
                              ),
                            ),
                            const SizedBox(height: DesignTokens.spacingXs),
                            Text(
                              producto.marca,
                              style: TextStyle(
                                fontSize: DesignTokens.fontSizeLg,
                                color: DesignTokens.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildStockStatusChip(producto),
                    ],
                  ),
                  const SizedBox(height: DesignTokens.spacingMd),
                  Text(
                    'Categoría: ${producto.categoria}',
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeMd,
                      color: DesignTokens.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: DesignTokens.spacingMd),

          // Información de stock
          Card(
            elevation: DesignTokens.elevationSm,
            child: Padding(
              padding: const EdgeInsets.all(DesignTokens.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Información de Stock',
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
                        child: _buildInfoItem(
                          'Stock Actual',
                          '${producto.stock}',
                          Icons.inventory,
                          _getStockColor(producto),
                        ),
                      ),
                      const SizedBox(width: DesignTokens.spacingMd),
                      Expanded(
                        child: _buildInfoItem(
                          'Estado',
                          producto.stockStatus,
                          Icons.info,
                          _getStockColor(producto),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: DesignTokens.spacingMd),

          // Información de precios
          Card(
            elevation: DesignTokens.elevationSm,
            child: Padding(
              padding: const EdgeInsets.all(DesignTokens.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Información de Precios',
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
                        child: _buildInfoItem(
                          'Precio de Venta',
                          '₡${_formatCurrency(producto.precio)}',
                          Icons.sell,
                          DesignTokens.primaryColor,
                        ),
                      ),
                      const SizedBox(width: DesignTokens.spacingMd),
                      Expanded(
                        child: _buildInfoItem(
                          'Costo',
                          '₡${_formatCurrency(producto.costo)}',
                          Icons.monetization_on,
                          DesignTokens.successColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: DesignTokens.spacingMd),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          'Margen',
                          '₡${_formatCurrency(producto.precio - producto.costo)}',
                          Icons.trending_up,
                          DesignTokens.accentColor,
                        ),
                      ),
                      const SizedBox(width: DesignTokens.spacingMd),
                      Expanded(
                        child: _buildInfoItem(
                          'Margen %',
                          '${_calculateMarginPercentage(producto.costo, producto.precio)}%',
                          Icons.percent,
                          DesignTokens.accentColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: DesignTokens.spacingMd),

          // Información adicional
          Card(
            elevation: DesignTokens.elevationSm,
            child: Padding(
              padding: const EdgeInsets.all(DesignTokens.spacingMd),
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
                  if (producto.codigoBarra.isNotEmpty)
                    _buildInfoItem(
                      'Código de Barras',
                      producto.codigoBarra,
                      Icons.qr_code,
                      DesignTokens.textSecondaryColor,
                    ),
                  const SizedBox(height: DesignTokens.spacingSm),
                  _buildInfoItem(
                    'Fecha de Creación',
                    _formatDate(producto.fechaCreacion),
                    Icons.calendar_today,
                    DesignTokens.textSecondaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: DesignTokens.spacingXs),
            Text(
              label,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeSm,
                color: DesignTokens.textSecondaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: DesignTokens.spacingXs),
        Text(
          value,
          style: TextStyle(
            fontSize: DesignTokens.fontSizeLg,
            fontWeight: DesignTokens.fontWeightBold,
            color: color,
          ),
        ),
      ],
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
        horizontal: DesignTokens.spacingMd,
        vertical: DesignTokens.spacingSm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: DesignTokens.fontSizeMd,
          fontWeight: DesignTokens.fontWeightBold,
        ),
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
           '${date.month.toString().padLeft(2, '0')}/'
           '${date.year}';
  }

  String _calculateMarginPercentage(double costo, double precio) {
    if (costo == 0) return '0';
    final margin = ((precio - costo) / costo) * 100;
    return margin.toStringAsFixed(1);
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red),
    );
  }
}
