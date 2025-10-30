import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design/design_tokens.dart';
import '../../../data/models/venta_model.dart';
import '../../../data/services/venta_service.dart';
import '../../widgets/common/empty_state.dart';

class SalesHistoryPage extends ConsumerStatefulWidget {
  const SalesHistoryPage({super.key});

  @override
  ConsumerState<SalesHistoryPage> createState() => _SalesHistoryPageState();
}

class _SalesHistoryPageState extends ConsumerState<SalesHistoryPage> {
  List<VentaListResponse> _ventas = [];
  bool _isLoading = true;
  final VentaService _service = VentaService();
  final int _usuarioId = 1; // TODO: Obtener del usuario logueado

  @override
  void initState() {
    super.initState();
    _cargarVentas();
  }

  Future<void> _cargarVentas() async {
    setState(() => _isLoading = true);
    try {
      final ventas = await _service.obtenerTodas(_usuarioId);
      // Ordenar por fecha más reciente primero
      ventas.sort((a, b) => b.fechaVenta.compareTo(a.fechaVenta));
      setState(() {
        _ventas = ventas;
      });
    } catch (e) {
      _mostrarError('Error al cargar ventas: ${e.toString()}');
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
          : _ventas.isEmpty
              ? _buildEmptyState()
              : _buildSalesList(),
    );
  }

  Widget _buildEmptyState() {
    return EmptyState(
      icon: Icons.receipt_long,
      title: 'No hay ventas registradas',
      subtitle: 'Las ventas aparecerán aquí una vez que se realicen',
    );
  }

  Widget _buildSalesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      itemCount: _ventas.length,
      itemBuilder: (context, index) {
        final venta = _ventas[index];
        return _buildSaleCard(venta);
      },
    );
  }

  Widget _buildSaleCard(VentaListResponse venta) {
    return Card(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingMd),
      elevation: DesignTokens.elevationSm,
      child: InkWell(
        onTap: () => context.push('/sales/${venta.ventaId}'),
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con número de venta y fecha
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Venta #${venta.ventaId}',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeLg,
                            fontWeight: DesignTokens.fontWeightBold,
                            color: DesignTokens.textPrimaryColor,
                          ),
                        ),
                        Text(
                          venta.clienteNombre,
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeMd,
                            color: DesignTokens.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(venta.estado),
                ],
              ),

              const SizedBox(height: DesignTokens.spacingMd),

              // Información de la venta
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fecha: ${venta.fechaFormateada}',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeSm,
                            color: DesignTokens.textSecondaryColor,
                          ),
                        ),
                        const SizedBox(height: DesignTokens.spacingXs),
                        Text(
                          'Hora: ${venta.horaFormateada}',
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
                        'Total: ₡${_formatCurrency(venta.total)}',
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
