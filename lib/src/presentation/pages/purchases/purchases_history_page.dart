import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design/design_tokens.dart';
import '../../../data/models/compra_model.dart';
import '../../../data/services/compra_service.dart';
import '../../widgets/common/empty_state.dart';

class PurchasesHistoryPage extends ConsumerStatefulWidget {
  const PurchasesHistoryPage({super.key});

  @override
  ConsumerState<PurchasesHistoryPage> createState() => _PurchasesHistoryPageState();
}

class _PurchasesHistoryPageState extends ConsumerState<PurchasesHistoryPage> {
  List<CompraListResponse> _compras = [];
  bool _isLoading = true;
  final CompraService _service = CompraService();
  final int _usuarioId = 1; // TODO: Obtener del usuario logueado

  @override
  void initState() {
    super.initState();
    _cargarCompras();
  }

  Future<void> _cargarCompras() async {
    setState(() => _isLoading = true);
    try {
      final compras = await _service.obtenerTodas(_usuarioId);
      // Ordenar por fecha más reciente primero
      compras.sort((a, b) => b.fechaCompra.compareTo(a.fechaCompra));
      setState(() {
        _compras = compras;
      });
    } catch (e) {
      _mostrarError('Error al cargar compras: ${e.toString()}');
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
          : _compras.isEmpty
              ? _buildEmptyState()
              : _buildPurchasesList(),
    );
  }

  Widget _buildEmptyState() {
    return EmptyState(
      icon: Icons.shopping_cart,
      title: 'No hay compras registradas',
      subtitle: 'Las compras aparecerán aquí una vez que se realicen',
    );
  }

  Widget _buildPurchasesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      itemCount: _compras.length,
      itemBuilder: (context, index) {
        final compra = _compras[index];
        return _buildPurchaseCard(compra);
      },
    );
  }

  Widget _buildPurchaseCard(CompraListResponse compra) {
    return Card(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingMd),
      elevation: DesignTokens.elevationSm,
      child: InkWell(
        onTap: () => context.push('/purchases/${compra.compraId}'),
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con número de compra y fecha
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Compra #${compra.compraId}',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeLg,
                            fontWeight: DesignTokens.fontWeightBold,
                            color: DesignTokens.textPrimaryColor,
                          ),
                        ),
                        Text(
                          compra.proveedorNombre,
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeMd,
                            color: DesignTokens.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(compra.estado),
                ],
              ),

              const SizedBox(height: DesignTokens.spacingMd),

              // Información de la compra
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fecha: ${compra.fechaFormateada}',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeSm,
                            color: DesignTokens.textSecondaryColor,
                          ),
                        ),
                        const SizedBox(height: DesignTokens.spacingXs),
                        Text(
                          'Hora: ${compra.horaFormateada}',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeSm,
                            color: DesignTokens.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total: ₡${_formatCurrency(compra.total)}',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeLg,
                          fontWeight: DesignTokens.fontWeightBold,
                          color: DesignTokens.primaryColor,
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spacingXs),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: DesignTokens.textSecondaryColor,
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

  Widget _buildStatusChip(String estado) {
    Color color;
    String text;

    switch (estado.toLowerCase()) {
      case 'completada':
      case 'completa':
        color = DesignTokens.successColor;
        text = 'Completada';
        break;
      case 'pendiente':
        color = DesignTokens.warningColor;
        text = 'Pendiente';
        break;
      case 'cancelada':
      case 'anulada':
        color = DesignTokens.errorColor;
        text = 'Cancelada';
        break;
      default:
        color = DesignTokens.textSecondaryColor;
        text = estado;
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

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0);
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red),
    );
  }
}
