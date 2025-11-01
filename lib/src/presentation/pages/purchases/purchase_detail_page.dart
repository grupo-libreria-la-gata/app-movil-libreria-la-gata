import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design/design_tokens.dart';
import '../../../data/models/compra_model.dart';
import '../../../data/services/compra_service.dart';

class PurchaseDetailPage extends ConsumerStatefulWidget {
  final int compraId;

  const PurchaseDetailPage({
    super.key,
    required this.compraId,
  });

  @override
  ConsumerState<PurchaseDetailPage> createState() => _PurchaseDetailPageState();
}

class _PurchaseDetailPageState extends ConsumerState<PurchaseDetailPage> {
  Compra? _compra;
  bool _isLoading = true;
  final CompraService _service = CompraService();

  @override
  void initState() {
    super.initState();
    _cargarCompra();
  }

  Future<void> _cargarCompra() async {
    setState(() => _isLoading = true);
    try {
      final compra = await _service.obtenerPorId(widget.compraId);
      setState(() {
        _compra = compra;
      });
    } catch (e) {
      _mostrarError('Error al cargar compra: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.backgroundColor,
      appBar: AppBar(
        backgroundColor: DesignTokens.primaryColor,
        foregroundColor: DesignTokens.textInverseColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Compra #${widget.compraId}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Implementar menú de opciones
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _compra == null
              ? _buildErrorState()
              : _buildPurchaseDetail(),
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
            'Compra no encontrada',
            style: TextStyle(
              fontSize: DesignTokens.fontSizeLg,
              fontWeight: DesignTokens.fontWeightBold,
              color: DesignTokens.textPrimaryColor,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          Text(
            'La compra solicitada no existe o fue eliminada',
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

  Widget _buildPurchaseDetail() {
    final compra = _compra!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Información General
          _buildInfoCard(
            'Información General',
            [
              _buildInfoRow('ID de Compra:', compra.compraId.toString()),
              _buildInfoRow('Fecha:', '${compra.fechaFormateada} ${compra.horaFormateada}'),
              _buildInfoRow('Usuario:', 'Administrador General'), // TODO: Obtener del usuario logueado
              _buildInfoRow('Observaciones:', compra.observaciones ?? 'Sin observaciones'),
            ],
            statusChip: _buildStatusChip(compra.estado),
          ),

          const SizedBox(height: 16),

          // Información del Proveedor
          _buildInfoCard(
            'Información del Proveedor',
            [
              _buildInfoRow('Nombre:', compra.proveedorNombre),
              _buildInfoRow('Teléfono:', '22223333'), // TODO: Obtener del proveedor
              _buildInfoRow('Email:', 'ventas@licorera.com'), // TODO: Obtener del proveedor
            ],
          ),

          const SizedBox(height: 16),

          // Productos Comprados
          _buildProductsCard(compra.detalles),

          const SizedBox(height: 16),

          // Resumen
          _buildSummaryCard(compra),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> infoRows, {Widget? statusChip}) {
    return Card(
      elevation: DesignTokens.elevationSm,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd)),
      child: Container(
        decoration: BoxDecoration(
          color: DesignTokens.surfaceColor,
          borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
        ),
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeLg,
                        fontWeight: DesignTokens.fontWeightBold,
                        color: DesignTokens.textPrimaryColor,
                      ),
                    ),
                  ),
                  if (statusChip != null) statusChip,
                ],
              ),
              const SizedBox(height: DesignTokens.spacingSm),
              ...infoRows,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingXs),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeMd,
                fontWeight: DesignTokens.fontWeightMedium,
                color: DesignTokens.textPrimaryColor,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: DesignTokens.fontSizeMd,
              color: DesignTokens.textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsCard(List<DetalleCompra> detalles) {
    return Card(
      elevation: DesignTokens.elevationSm,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd)),
      child: Container(
        decoration: BoxDecoration(
          color: DesignTokens.surfaceColor,
          borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
        ),
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Productos Comprados',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeLg,
                  fontWeight: DesignTokens.fontWeightBold,
                  color: DesignTokens.textPrimaryColor,
                ),
              ),
              const SizedBox(height: DesignTokens.spacingSm),
              if (detalles.isEmpty)
                Text(
                  'No hay productos en esta compra',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeMd,
                    color: DesignTokens.textSecondaryColor,
                  ),
                )
              else
                ...detalles.map((detalle) => _buildProductItem(detalle)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductItem(DetalleCompra detalle) {
    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingSm),
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: DesignTokens.surfaceColor,
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
        border: Border.all(color: DesignTokens.borderLightColor),
        boxShadow: [
          BoxShadow(
            color: DesignTokens.borderLightColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nombre del producto y marca
          Row(
            children: [
              Expanded(
                child: Text(
                  detalle.producto,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeLg,
                    fontWeight: DesignTokens.fontWeightBold,
                    color: DesignTokens.textPrimaryColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingSm, vertical: DesignTokens.spacingXs),
                decoration: BoxDecoration(
                  color: DesignTokens.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                ),
                child: Text(
                  'Código: ${detalle.detalleProductoId}',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeSm,
                    fontWeight: DesignTokens.fontWeightMedium,
                    color: DesignTokens.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingXs),
          // Marca
          Text(
            'Marca: ${detalle.marca}',
            style: TextStyle(
              fontSize: DesignTokens.fontSizeMd,
              color: DesignTokens.textSecondaryColor,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          // Información de cantidad, precio y subtotal
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacingSm),
            decoration: BoxDecoration(
              color: DesignTokens.backgroundColor,
              borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cantidad',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeSm,
                          color: DesignTokens.textSecondaryColor,
                        ),
                      ),
                      Text(
                        '${detalle.cantidad}',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeMd,
                          fontWeight: DesignTokens.fontWeightBold,
                          color: DesignTokens.textPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Precio Unit.',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeSm,
                          color: DesignTokens.textSecondaryColor,
                        ),
                      ),
                      Text(
                        '\$${_formatCurrency(detalle.costoUnitario)}',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeMd,
                          fontWeight: DesignTokens.fontWeightBold,
                          color: DesignTokens.textPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Subtotal',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeSm,
                          color: DesignTokens.textSecondaryColor,
                        ),
                      ),
                      Text(
                        '\$${_formatCurrency(detalle.subtotal)}',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeLg,
                          fontWeight: DesignTokens.fontWeightBold,
                          color: DesignTokens.successColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(Compra compra) {
    return Card(
      elevation: DesignTokens.elevationSm,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd)),
      child: Container(
        decoration: BoxDecoration(
          color: DesignTokens.surfaceColor,
          borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
        ),
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Resumen',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeLg,
                  fontWeight: DesignTokens.fontWeightBold,
                  color: DesignTokens.textPrimaryColor,
                ),
              ),
              const SizedBox(height: DesignTokens.spacingSm),
              _buildSummaryRow('Total de productos:', compra.detalles.length.toString()),
              _buildSummaryRow('Total de la compra:', '\$${_formatCurrency(compra.total)}', isTotal: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingXs),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: isTotal ? DesignTokens.fontSizeMd : DesignTokens.fontSizeMd,
                fontWeight: isTotal ? DesignTokens.fontWeightBold : DesignTokens.fontWeightMedium,
                color: DesignTokens.textPrimaryColor,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? DesignTokens.fontSizeMd : DesignTokens.fontSizeMd,
              fontWeight: DesignTokens.fontWeightBold,
              color: isTotal ? DesignTokens.successColor : DesignTokens.textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String estado) {
    Color color;
    String text;

    switch (estado.toLowerCase()) {
      case 'completada':
      case 'completa':
        color = DesignTokens.successColor;
        text = 'ACTIVA';
        break;
      case 'pendiente':
        color = DesignTokens.warningColor;
        text = 'PENDIENTE';
        break;
      case 'cancelada':
      case 'anulada':
        color = DesignTokens.errorColor;
        text = 'CANCELADA';
        break;
      default:
        color = DesignTokens.textSecondaryColor;
        text = estado.toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingSm, vertical: DesignTokens.spacingXs),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: DesignTokens.surfaceColor,
          fontSize: DesignTokens.fontSizeSm,
          fontWeight: DesignTokens.fontWeightBold,
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(2);
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: DesignTokens.errorColor),
    );
  }
}