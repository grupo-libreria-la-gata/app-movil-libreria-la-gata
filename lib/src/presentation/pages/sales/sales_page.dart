import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/design_tokens.dart';
import '../../../data/services/venta_service.dart';
import '../../../data/models/venta_model.dart';
import 'new_sale_page.dart';
import 'sale_detail_page.dart';

class SalesPage extends ConsumerStatefulWidget {
  const SalesPage({super.key});

  @override
  ConsumerState<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends ConsumerState<SalesPage> {
  final VentaService _ventaService = VentaService();
  List<VentaListResponse> _ventas = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cargarVentas();
  }

  Future<void> _cargarVentas() async {
    setState(() => _isLoading = true);
    try {
      final ventas = await _ventaService.obtenerTodas(1); // TODO: Obtener usuarioId del usuario logueado
      setState(() {
        _ventas = ventas;
      });
    } catch (e) {
      _mostrarError('Error al cargar ventas: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales History'),
        backgroundColor: DesignTokens.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (context) => const NewSalePage()),
              );
              if (result == true) {
                _cargarVentas();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search sales...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  // Filter logic will be implemented here
                });
              },
            ),
          ),
          // Lista de ventas
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _ventas.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No sales registered',
                          style: TextStyle(fontSize: 18, color: DesignTokens.textSecondaryColor),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _ventas.length,
                    itemBuilder: (context, index) {
                      final venta = _ventas[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.green,
                            child: const Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            venta.clienteNombre,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Cliente: ${venta.clienteNombre}'),
                              Text(
                                'Fecha: ${venta.fechaFormateada}',
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${venta.total.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                venta.estado,
                                style: TextStyle(
                                  color: venta.estado.toLowerCase() == 'completada' 
                                      ? Colors.green
                                      : Colors.orange,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          onTap: () async {
                            final result = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SaleDetailPage(ventaId: venta.ventaId),
                              ),
                            );
                            if (result == true) {
                              _cargarVentas();
                            }
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
