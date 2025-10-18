import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/compra_model.dart';
import '../../../data/services/compra_service.dart';
import '../../providers/auth_provider_legacy.dart';
import '../../widgets/loading_widgets.dart';

class CompraDetailPage extends StatefulWidget {
  final int compraId;

  const CompraDetailPage({
    super.key,
    required this.compraId,
  });

  @override
  State<CompraDetailPage> createState() => _CompraDetailPageState();
}

class _CompraDetailPageState extends State<CompraDetailPage> {
  final CompraService _compraService = CompraService();
  CompraModel? _compra;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cargarCompra();
  }

  Future<void> _cargarCompra() async {
    setState(() => _isLoading = true);
    
    try {
      final response = await _compraService.obtenerCompra(widget.compraId);
      
      if (response.success && response.data != null) {
        setState(() {
          _compra = response.data!;
        });
      } else {
        _mostrarError(response.message ?? 'Error al cargar la compra');
      }
    } catch (e) {
      _mostrarError('Error inesperado: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _anularCompra() async {
    if (_compra == null) return;

    final confirmacion = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Anular Compra'),
        content: Text('¿Está seguro de que desea anular la compra #${_compra!.compraId}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Anular'),
          ),
        ],
      ),
    );

    if (confirmacion == true) {
      setState(() => _isLoading = true);
      
      try {
        if (!mounted) return;
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final usuarioId = int.tryParse(authProvider.currentUser?.id ?? '0') ?? 0;
        
        final request = AnularCompraRequest(
          compraId: _compra!.compraId,
          usuarioId: usuarioId,
        );
        
        final response = await _compraService.anularCompra(request);
        
        if (response.success) {
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Compra anulada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
          _cargarCompra(); // Recargar para actualizar el estado
        } else {
          _mostrarError(response.message ?? 'Error al anular la compra');
        }
      } catch (e) {
        _mostrarError('Error inesperado: ${e.toString()}');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Compra #${widget.compraId}'),
        actions: [
          if (_compra?.activo == true)
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'anular',
                  child: Text('Anular Compra'),
                ),
              ],
              onSelected: (value) {
                if (value == 'anular') {
                  _anularCompra();
                }
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _compra == null
              ? const Center(
                  child: Text(
                    'No se pudo cargar la compra',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _cargarCompra,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Información general
                        _InformacionGeneralCard(compra: _compra!),
                        
                        const SizedBox(height: 16),
                        
                        // Información del proveedor
                        _ProveedorCard(compra: _compra!),
                        
                        const SizedBox(height: 16),
                        
                        // Detalles de productos
                        _DetallesProductosCard(compra: _compra!),
                        
                        const SizedBox(height: 16),
                        
                        // Resumen
                        _ResumenCard(compra: _compra!),
                      ],
                    ),
                  ),
                ),
    );
  }
}

class _InformacionGeneralCard extends StatelessWidget {
  final CompraModel compra;

  const _InformacionGeneralCard({required this.compra});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Información General',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: compra.activo ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    compra.activo ? 'ACTIVA' : 'ANULADA',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _infoRow('ID de Compra', compra.compraId.toString()),
            _infoRow('Fecha', _formatearFecha(compra.fechaCompra)),
            _infoRow('Usuario', compra.usuarioNombre),
            if (compra.observaciones != null && compra.observaciones!.isNotEmpty)
              _infoRow('Observaciones', compra.observaciones!),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year} ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}';
  }
}

class _ProveedorCard extends StatelessWidget {
  final CompraModel compra;

  const _ProveedorCard({required this.compra});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información del Proveedor',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _infoRow('Nombre', compra.proveedorNombre),
            if (compra.proveedorTelefono != null)
              _infoRow('Teléfono', compra.proveedorTelefono!),
            if (compra.proveedorEmail != null)
              _infoRow('Email', compra.proveedorEmail!),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

class _DetallesProductosCard extends StatelessWidget {
  final CompraModel compra;

  const _DetallesProductosCard({required this.compra});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Productos Comprados',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            if (compra.detalles.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text(
                    'No hay productos en esta compra',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: compra.detalles.length,
                itemBuilder: (context, index) {
                  final detalle = compra.detalles[index];
                  return _DetalleProductoItem(detalle: detalle);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _DetalleProductoItem extends StatelessWidget {
  final DetalleCompraModel detalle;

  const _DetalleProductoItem({required this.detalle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            detalle.productoNombre,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text('${detalle.marcaNombre} - ${detalle.categoriaNombre}'),
          if (detalle.codigoBarra != null)
            Text('Código: ${detalle.codigoBarra}'),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Cantidad: ${detalle.cantidad}'),
              Text('Precio: \$${detalle.precioUnitario.toStringAsFixed(2)}'),
              Text(
                'Subtotal: \$${detalle.subtotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResumenCard extends StatelessWidget {
  final CompraModel compra;

  const _ResumenCard({required this.compra});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total de productos:',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  compra.detalles.length.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total de la compra:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${compra.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
