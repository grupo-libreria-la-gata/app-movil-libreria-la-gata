import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/compra_model.dart';
import '../../../data/models/base_model.dart';
import '../../../data/services/compra_service.dart';
import '../../providers/auth_provider_legacy.dart';

class ComprasReportsPage extends StatefulWidget {
  const ComprasReportsPage({super.key});

  @override
  State<ComprasReportsPage> createState() => _ComprasReportsPageState();
}

class _ComprasReportsPageState extends State<ComprasReportsPage> {
  final CompraService _compraService = CompraService();
  CompraResumenModel? _resumen;
  List<TopProductoCompradoModel> _topProductos = [];
  bool _isLoading = false;
  DateTime _fechaInicio = DateTime.now().subtract(const Duration(days: 30));
  DateTime _fechaFin = DateTime.now();

  @override
  void initState() {
    super.initState();
    _cargarReportes();
  }

  Future<void> _cargarReportes() async {
    setState(() => _isLoading = true);

    try {
      if (!mounted) return;
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final usuarioId = int.tryParse(authProvider.currentUser?.id ?? '0') ?? 0;

      // Cargar resumen y top productos en paralelo
      final futures = await Future.wait([
        _compraService.obtenerResumen(
          fechaInicio: _fechaInicio,
          fechaFin: _fechaFin,
          usuarioId: usuarioId,
        ),
        _compraService.obtenerTopProductos(
          fechaInicio: _fechaInicio,
          fechaFin: _fechaFin,
          usuarioId: usuarioId,
        ),
      ]);

      final resumenResponse = futures[0] as ApiResponse<CompraResumenModel>;
      final topProductosResponse =
          futures[1] as ApiResponse<List<TopProductoCompradoModel>>;

      if (resumenResponse.success && resumenResponse.data != null) {
        setState(() {
          _resumen = resumenResponse.data!;
        });
      }

      if (topProductosResponse.success && topProductosResponse.data != null) {
        setState(() {
          _topProductos = topProductosResponse.data!;
        });
      }
    } catch (e) {
      _mostrarError('Error al cargar reportes: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red),
    );
  }

  Future<void> _seleccionarFechas() async {
    final fechas = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _fechaInicio, end: _fechaFin),
    );

    if (fechas != null) {
      setState(() {
        _fechaInicio = fechas.start;
        _fechaFin = fechas.end;
      });
      _cargarReportes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes de Compras'),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: _seleccionarFechas,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarReportes,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _cargarReportes,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Selector de fechas
                    _SelectorFechas(
                      fechaInicio: _fechaInicio,
                      fechaFin: _fechaFin,
                      onTap: _seleccionarFechas,
                    ),
                    const SizedBox(height: 16),

                    // Resumen de compras
                    if (_resumen != null) _ResumenCard(resumen: _resumen!),

                    const SizedBox(height: 16),

                    // Top productos
                    if (_topProductos.isNotEmpty)
                      _TopProductosCard(productos: _topProductos),
                  ],
                ),
              ),
            ),
    );
  }
}

class _SelectorFechas extends StatelessWidget {
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final VoidCallback onTap;

  const _SelectorFechas({
    required this.fechaInicio,
    required this.fechaFin,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.date_range, color: Colors.blue),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Período de Reporte',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${_formatearFecha(fechaInicio)} - ${_formatearFecha(fechaFin)}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }
}

class _ResumenCard extends StatelessWidget {
  final CompraResumenModel resumen;

  const _ResumenCard({required this.resumen});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen del Período',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _ResumenItem(
              icon: Icons.shopping_cart,
              label: 'Total de Compras',
              value: resumen.totalCompras.toString(),
              color: Colors.blue,
            ),
            _ResumenItem(
              icon: Icons.attach_money,
              label: 'Monto Total',
              value: '\$${resumen.totalMonto.toStringAsFixed(2)}',
              color: Colors.green,
            ),
            _ResumenItem(
              icon: Icons.trending_up,
              label: 'Promedio por Compra',
              value: '\$${resumen.promedioCompra.toStringAsFixed(2)}',
              color: Colors.orange,
            ),
            _ResumenItem(
              icon: Icons.keyboard_arrow_down,
              label: 'Compra Mínima',
              value: '\$${resumen.compraMinima.toStringAsFixed(2)}',
              color: Colors.red,
            ),
            _ResumenItem(
              icon: Icons.keyboard_arrow_up,
              label: 'Compra Máxima',
              value: '\$${resumen.compraMaxima.toStringAsFixed(2)}',
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }
}

class _ResumenItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ResumenItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopProductosCard extends StatelessWidget {
  final List<TopProductoCompradoModel> productos;

  const _TopProductosCard({required this.productos});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Productos Comprados',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final producto = productos[index];
                return _TopProductoItem(
                  producto: producto,
                  position: index + 1,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TopProductoItem extends StatelessWidget {
  final TopProductoCompradoModel producto;
  final int position;

  const _TopProductoItem({required this.producto, required this.position});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Posición
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _getPositionColor(position),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                position.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Información del producto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producto.productoNombre,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${producto.marcaNombre} - ${producto.categoriaNombre}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _InfoChip(
                      icon: Icons.shopping_bag,
                      label: '${producto.totalCantidad} unidades',
                    ),
                    const SizedBox(width: 8),
                    _InfoChip(
                      icon: Icons.attach_money,
                      label: '\$${producto.totalMonto.toStringAsFixed(2)}',
                    ),
                    const SizedBox(width: 8),
                    _InfoChip(
                      icon: Icons.repeat,
                      label: '${producto.vecesComprado} veces',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getPositionColor(int position) {
    switch (position) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey[400]!;
      case 3:
        return Colors.brown[400]!;
      default:
        return Colors.blue;
    }
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
