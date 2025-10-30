import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design/design_tokens.dart';
import '../../../data/models/venta_model.dart';
import '../../../data/services/venta_service.dart';

class SaleDetailPage extends ConsumerStatefulWidget {
  final int ventaId;

  const SaleDetailPage({
    super.key,
    required this.ventaId,
  });

  @override
  ConsumerState<SaleDetailPage> createState() => _SaleDetailPageState();
}

class _SaleDetailPageState extends ConsumerState<SaleDetailPage> {
  Venta? _venta;
  bool _isLoading = true;
  final VentaService _service = VentaService();

  @override
  void initState() {
    super.initState();
    _cargarVenta();
  }

  Future<void> _cargarVenta() async {
    setState(() => _isLoading = true);
    try {
      final venta = await _service.obtenerPorId(widget.ventaId);
      setState(() {
        _venta = venta;
      });
    } catch (e) {
      _mostrarError('Error al cargar venta: ${e.toString()}');
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
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Venta #${widget.ventaId}',
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
          : _venta == null
              ? _buildErrorState()
              : _buildSaleDetail(),
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
            'Venta no encontrada',
            style: TextStyle(
              fontSize: DesignTokens.fontSizeLg,
              fontWeight: DesignTokens.fontWeightBold,
              color: DesignTokens.textPrimaryColor,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          Text(
            'La venta solicitada no existe o fue eliminada',
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

  Widget _buildSaleDetail() {
    final venta = _venta!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Información General
          _buildInfoCard(
            'Información General',
            [
              _buildInfoRow('ID de Venta:', venta.ventaId.toString()),
              _buildInfoRow('Fecha:', '${venta.fechaFormateada} ${venta.horaFormateada}'),
              _buildInfoRow('Usuario:', 'Administrador General'), // TODO: Obtener del usuario logueado
              _buildInfoRow('Observaciones:', venta.observaciones ?? 'Sin observaciones'),
            ],
            statusChip: _buildStatusChip(venta.estado),
          ),

          const SizedBox(height: DesignTokens.spacingMd),

          // Información del Cliente
          _buildInfoCard(
            'Información del Cliente',
            [
              _buildInfoRow('Nombre:', venta.clienteNombre),
              _buildInfoRow('Teléfono:', '22223333'), // TODO: Obtener del cliente
              _buildInfoRow('Email:', 'cliente@email.com'), // TODO: Obtener del cliente
            ],
          ),

          const SizedBox(height: DesignTokens.spacingMd),

          // Productos Vendidos
          _buildProductsCard(venta.detalles),

          const SizedBox(height: DesignTokens.spacingMd),

          // Resumen
          _buildSummaryCard(venta),
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
          color: Colors.white,
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

  Widget _buildProductsCard(List<DetalleVenta> detalles) {
    return Card(
      elevation: DesignTokens.elevationSm,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
        ),
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Productos Vendidos',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeLg,
                  fontWeight: DesignTokens.fontWeightBold,
                  color: DesignTokens.textPrimaryColor,
                ),
              ),
              const SizedBox(height: DesignTokens.spacingSm),
              if (detalles.isEmpty)
                Text(
                  'No hay productos en esta venta',
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

  Widget _buildProductItem(DetalleVenta detalle) {
    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingSm),
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
                        '\$${_formatCurrency(detalle.precioUnitario)}',
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

  Widget _buildSummaryCard(Venta venta) {
    return Card(
      elevation: DesignTokens.elevationSm,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
              _buildSummaryRow('Total de productos:', venta.detalles.length.toString()),
              _buildSummaryRow('Total de la venta:', '\$${_formatCurrency(venta.total)}', isTotal: true),
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
          color: Colors.white,
          fontSize: DesignTokens.fontSizeSm,
          fontWeight: DesignTokens.fontWeightBold,
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0);
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red),
    );
  }
}