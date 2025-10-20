import 'package:flutter/material.dart';
import '../../../data/services/detalle_producto_service.dart';
import '../../../data/models/detalle_producto_model.dart';
import '../../../core/design/design_tokens.dart';

class DetalleProductosPage extends StatefulWidget {
  const DetalleProductosPage({super.key});

  @override
  State<DetalleProductosPage> createState() => _DetalleProductosPageState();
}

class _DetalleProductosPageState extends State<DetalleProductosPage> {
  final DetalleProductoService _service = DetalleProductoService();
  List<DetalleProducto> _detalleProductos = [];
  bool _loading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _cargarDetalleProductos();
  }

  Future<void> _cargarDetalleProductos() async {
    setState(() => _loading = true);
    try {
      final detalleProductos = await _service.obtenerActivos();
      setState(() {
        _detalleProductos = detalleProductos;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      _mostrarError('Error al cargar productos: ${e.toString()}');
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red),
    );
  }

  List<DetalleProducto> get _detalleProductosFiltrados {
    if (_searchQuery.isEmpty) return _detalleProductos;
    return _detalleProductos
        .where(
          (detalle) =>
              detalle.producto.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              detalle.categoria.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              detalle.marca.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              detalle.codigoBarra.contains(_searchQuery),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Productos'),
        backgroundColor: DesignTokens.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DetalleProductoSearchDelegate(_detalleProductos),
              );
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
                hintText: 'Buscar productos...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    DesignTokens.borderRadiusMd,
                  ),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Lista de productos
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _detalleProductosFiltrados.isEmpty
                ? const Center(
                    child: Text(
                      'No hay productos registrados',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _cargarDetalleProductos,
                    child: ListView.builder(
                      itemCount: _detalleProductosFiltrados.length,
                      itemBuilder: (context, index) {
                        final detalle = _detalleProductosFiltrados[index];
                        return _DetalleProductoCard(detalle: detalle);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _DetalleProductoCard extends StatelessWidget {
  final DetalleProducto detalle;

  const _DetalleProductoCard({required this.detalle});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    detalle.producto,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: detalle.stock > 10
                        ? Colors.green.withValues(alpha: 0.1)
                        : detalle.stock > 0
                        ? Colors.orange.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Stock: ${detalle.stock}',
                    style: TextStyle(
                      color: detalle.stock > 10
                          ? Colors.green[700]
                          : detalle.stock > 0
                          ? Colors.orange[700]
                          : Colors.red[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${detalle.marca} - ${detalle.categoria}',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Código: ${detalle.codigoBarra}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Costo: \$${detalle.costo.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 12, color: Colors.red),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Precio: \$${detalle.precio.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ganancia: \$${(detalle.precio - detalle.costo).toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DetalleProductoSearchDelegate extends SearchDelegate {
  final List<DetalleProducto> detalleProductos;

  DetalleProductoSearchDelegate(this.detalleProductos);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final filteredDetalleProductos = detalleProductos
        .where(
          (detalle) =>
              detalle.producto.toLowerCase().contains(query.toLowerCase()) ||
              detalle.categoria.toLowerCase().contains(query.toLowerCase()) ||
              detalle.marca.toLowerCase().contains(query.toLowerCase()) ||
              detalle.codigoBarra.contains(query),
        )
        .toList();

    return ListView.builder(
      itemCount: filteredDetalleProductos.length,
      itemBuilder: (context, index) {
        final detalle = filteredDetalleProductos[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: DesignTokens.primaryColor,
            child: Text(
              detalle.producto[0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(detalle.producto),
          subtitle: Text('${detalle.marca} - ${detalle.categoria}'),
          trailing: Text(
            'Stock: ${detalle.stock}',
            style: TextStyle(
              color: detalle.stock > 10
                  ? Colors.green[700]
                  : detalle.stock > 0
                  ? Colors.orange[700]
                  : Colors.red[700],
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            close(context, detalle);
          },
        );
      },
    );
  }
}
