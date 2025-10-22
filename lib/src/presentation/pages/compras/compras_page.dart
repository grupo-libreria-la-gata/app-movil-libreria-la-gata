import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/compra_model.dart';
import '../../../data/models/base_model.dart';
import '../../../data/services/compra_service.dart';
import '../../providers/auth_provider.dart';
import 'nueva_compra_page.dart';
import 'compra_detail_page.dart';
import 'compras_filters_page.dart';

class ComprasPage extends ConsumerStatefulWidget {
  const ComprasPage({super.key});

  @override
  ConsumerState<ComprasPage> createState() => _ComprasPageState();
}

class _ComprasPageState extends ConsumerState<ComprasPage> {
  final CompraService _compraService = CompraService();
  List<CompraListModel> _compras = [];
  bool _isLoading = false;
  String _searchQuery = '';
  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  int? _proveedorId;
  String _sortBy = 'fecha'; // fecha, total, proveedor
  bool _sortAscending = false;

  @override
  void initState() {
    super.initState();
    _cargarCompras();
  }

  Future<void> _cargarCompras() async {
    setState(() => _isLoading = true);

    try {
      if (!mounted) return;
      final authState = ref.read(authProvider);
      final usuarioId = int.tryParse(authState.user?.id ?? '0') ?? 0;

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

  void _mostrarOpcionesOrdenamiento() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Ordenar por',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _OpcionOrdenamiento(
              titulo: 'Fecha',
              valor: 'fecha',
              actual: _sortBy,
              ascendente: _sortAscending,
              onTap: () {
                setState(() {
                  if (_sortBy == 'fecha') {
                    _sortAscending = !_sortAscending;
                  } else {
                    _sortBy = 'fecha';
                    _sortAscending = false;
                  }
                });
                Navigator.pop(context);
              },
            ),
            _OpcionOrdenamiento(
              titulo: 'Total',
              valor: 'total',
              actual: _sortBy,
              ascendente: _sortAscending,
              onTap: () {
                setState(() {
                  if (_sortBy == 'total') {
                    _sortAscending = !_sortAscending;
                  } else {
                    _sortBy = 'total';
                    _sortAscending = false;
                  }
                });
                Navigator.pop(context);
              },
            ),
            _OpcionOrdenamiento(
              titulo: 'Proveedor',
              valor: 'proveedor',
              actual: _sortBy,
              ascendente: _sortAscending,
              onTap: () {
                setState(() {
                  if (_sortBy == 'proveedor') {
                    _sortAscending = !_sortAscending;
                  } else {
                    _sortBy = 'proveedor';
                    _sortAscending = true;
                  }
                });
                Navigator.pop(context);
              },
            ),
            _OpcionOrdenamiento(
              titulo: 'Cantidad de Items',
              valor: 'items',
              actual: _sortBy,
              ascendente: _sortAscending,
              onTap: () {
                setState(() {
                  if (_sortBy == 'items') {
                    _sortAscending = !_sortAscending;
                  } else {
                    _sortBy = 'items';
                    _sortAscending = false;
                  }
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  List<CompraListModel> get _comprasFiltradas {
    List<CompraListModel> compras = _compras;

    // Aplicar filtro de búsqueda
    if (_searchQuery.isNotEmpty) {
      compras = compras.where((compra) {
        return compra.proveedorNombre.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            compra.usuarioNombre.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            compra.observaciones?.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ==
                true ||
            compra.compraId.toString().contains(_searchQuery);
      }).toList();
    }

    // Aplicar ordenamiento
    compras.sort((a, b) {
      int comparison = 0;
      switch (_sortBy) {
        case 'fecha':
          comparison = a.fechaCompra.compareTo(b.fechaCompra);
          break;
        case 'total':
          comparison = a.total.compareTo(b.total);
          break;
        case 'proveedor':
          comparison = a.proveedorNombre.compareTo(b.proveedorNombre);
          break;
        case 'items':
          comparison = a.totalItems.compareTo(b.totalItems);
          break;
      }
      return _sortAscending ? comparison : -comparison;
    });

    return compras;
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
        final authState = ref.read(authProvider);
        final usuarioId = int.tryParse(authState.user?.id ?? '0') ?? 0;

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
            icon: const Icon(Icons.analytics),
            onPressed: () {
              Navigator.pushNamed(context, '/compras/reportes');
            },
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _mostrarOpcionesOrdenamiento,
          ),
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
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con ID y estado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Compra #${compra.compraId}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
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
              const SizedBox(height: 12),

              // Información principal
              Row(
                children: [
                  Icon(Icons.business, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      compra.proveedorNombre,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      compra.usuarioNombre,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Icon(Icons.shopping_bag, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    '${compra.totalItems} productos',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Footer con total y fecha
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatearFecha(compra.fechaCompra),
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  Text(
                    '\$${compra.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year} ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}';
  }
}

class _OpcionOrdenamiento extends StatelessWidget {
  final String titulo;
  final String valor;
  final String actual;
  final bool ascendente;
  final VoidCallback onTap;

  const _OpcionOrdenamiento({
    required this.titulo,
    required this.valor,
    required this.actual,
    required this.ascendente,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = actual == valor;

    return ListTile(
      title: Text(titulo),
      trailing: isSelected
          ? Icon(
              ascendente ? Icons.arrow_upward : Icons.arrow_downward,
              color: Theme.of(context).primaryColor,
            )
          : null,
      selected: isSelected,
      onTap: onTap,
    );
  }
}
