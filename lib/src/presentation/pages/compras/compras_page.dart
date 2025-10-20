import 'package:flutter/material.dart';
import 'package:integrador_lagata/src/data/models/base_model.dart';
import 'package:provider/provider.dart';
import '../../../data/models/compra_model.dart';
import '../../../data/services/compra_service.dart';
import '../../providers/auth_provider_legacy.dart';
import 'nueva_compra_page.dart';
import 'compra_detail_page.dart';
import 'compras_filters_page.dart';

class ComprasPage extends StatefulWidget {
  const ComprasPage({super.key});

  @override
  State<ComprasPage> createState() => _ComprasPageState();
}

class _ComprasPageState extends State<ComprasPage> {
  final CompraService _compraService = CompraService();
  List<CompraListModel> _compras = [];
  bool _isLoading = false;
  String _searchQuery = '';
  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  int? _proveedorId;

  @override
  void initState() {
    super.initState();
    _cargarCompras();
  }

  Future<void> _cargarCompras() async {
    setState(() => _isLoading = true);

    try {
      if (!mounted) return;
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final usuarioId = int.tryParse(authProvider.currentUser?.id ?? '0') ?? 0;

      ApiResponse<List<CompraListModel>> response;

      if (_fechaInicio != null && _fechaFin != null) {
        response = await _compraService.listarPorFechas(
          fechaInicio: _fechaInicio!,
          fechaFin: _fechaFin!,
          usuarioId: usuarioId,
        );
      } else if (_proveedorId != null) {
        response = await _compraService.listarPorProveedor(
          proveedorId: _proveedorId!,
          usuarioId: usuarioId,
        );
      } else {
        response = await _compraService.listarCompras(usuarioId);
      }

      if (response.success && response.data != null) {
        setState(() {
          _compras = response.data!;
        });
      } else {
        _mostrarError(response.message ?? 'Error al cargar compras');
      }
    } catch (e) {
      _mostrarError('Error inesperado: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red),
    );
  }

  void _mostrarExito(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.green),
    );
  }

  List<CompraListModel> get _comprasFiltradas {
    if (_searchQuery.isEmpty) return _compras;

    return _compras.where((compra) {
      return compra.proveedorNombre.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          compra.usuarioNombre.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          compra.observaciones?.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ==
              true;
    }).toList();
  }

  Future<void> _anularCompra(CompraListModel compra) async {
    final confirmacion = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Anular Compra'),
        content: Text(
          '¿Está seguro de que desea anular la compra #${compra.compraId}?',
        ),
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
        final usuarioId =
            int.tryParse(authProvider.currentUser?.id ?? '0') ?? 0;

        final request = AnularCompraRequest(
          compraId: compra.compraId,
          usuarioId: usuarioId,
        );

        final response = await _compraService.anularCompra(request);

        if (response.success) {
          _mostrarExito('Compra anulada exitosamente');
          _cargarCompras();
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
        title: const Text('Gestión de Compras'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ComprasFiltersPage(
                    fechaInicio: _fechaInicio,
                    fechaFin: _fechaFin,
                    proveedorId: _proveedorId,
                  ),
                ),
              );

              if (result != null) {
                setState(() {
                  _fechaInicio = result['fechaInicio'];
                  _fechaFin = result['fechaFin'];
                  _proveedorId = result['proveedorId'];
                });
                _cargarCompras();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarCompras,
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar compras...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Indicadores de filtros activos
          if (_fechaInicio != null || _fechaFin != null || _proveedorId != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8.0,
                children: [
                  if (_fechaInicio != null && _fechaFin != null)
                    Chip(
                      label: Text(
                        '${_fechaInicio!.day}/${_fechaInicio!.month} - ${_fechaFin!.day}/${_fechaFin!.month}',
                      ),
                      onDeleted: () {
                        setState(() {
                          _fechaInicio = null;
                          _fechaFin = null;
                        });
                        _cargarCompras();
                      },
                    ),
                  if (_proveedorId != null)
                    Chip(
                      label: Text('Proveedor: $_proveedorId'),
                      onDeleted: () {
                        setState(() {
                          _proveedorId = null;
                        });
                        _cargarCompras();
                      },
                    ),
                ],
              ),
            ),

          // Lista de compras
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _comprasFiltradas.isEmpty
                ? const Center(
                    child: Text(
                      'No hay compras registradas',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _cargarCompras,
                    child: ListView.builder(
                      itemCount: _comprasFiltradas.length,
                      itemBuilder: (context, index) {
                        final compra = _comprasFiltradas[index];
                        return _CompraCard(
                          compra: compra,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CompraDetailPage(compraId: compra.compraId),
                              ),
                            );
                            _cargarCompras(); // Recargar en caso de cambios
                          },
                          onAnular: compra.activo
                              ? () => _anularCompra(compra)
                              : null,
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NuevaCompraPage()),
          );
          _cargarCompras(); // Recargar después de crear una nueva compra
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _CompraCard extends StatelessWidget {
  final CompraListModel compra;
  final VoidCallback onTap;
  final VoidCallback? onAnular;

  const _CompraCard({required this.compra, required this.onTap, this.onAnular});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: compra.activo ? Colors.green : Colors.red,
          child: Icon(
            compra.activo ? Icons.shopping_cart : Icons.cancel,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Compra #${compra.compraId}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Proveedor: ${compra.proveedorNombre}'),
            Text('Usuario: ${compra.usuarioNombre}'),
            Text('Total: \$${compra.total.toStringAsFixed(2)}'),
            Text('Fecha: ${_formatearFecha(compra.fechaCompra)}'),
            Text('Items: ${compra.totalItems}'),
            if (!compra.activo)
              const Text(
                'ANULADA',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        trailing: compra.activo && onAnular != null
            ? PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'anular', child: Text('Anular')),
                ],
                onSelected: (value) {
                  if (value == 'anular') {
                    onAnular!();
                  }
                },
              )
            : null,
        onTap: onTap,
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }
}
