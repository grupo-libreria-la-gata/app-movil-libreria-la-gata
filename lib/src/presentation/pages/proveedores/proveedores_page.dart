import 'package:flutter/material.dart';
import '../../../data/services/proveedor_service.dart';
import '../../../data/models/proveedor_model.dart';
import '../../../core/design/design_tokens.dart';
import 'crear_proveedor_page.dart';
import 'editar_proveedor_page.dart';

class ProveedoresPage extends StatefulWidget {
  const ProveedoresPage({super.key});

  @override
  State<ProveedoresPage> createState() => _ProveedoresPageState();
}

class _ProveedoresPageState extends State<ProveedoresPage> {
  final ProveedorService _service = ProveedorService();
  List<Proveedor> _proveedores = [];
  bool _loading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _cargarProveedores();
  }

  Future<void> _cargarProveedores() async {
    setState(() => _loading = true);
    try {
      final proveedores = await _service.obtenerActivos();
      setState(() {
        _proveedores = proveedores;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      _mostrarError('Error al cargar proveedores: ${e.toString()}');
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: DesignTokens.errorColor),
    );
  }

  void _mostrarExito(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: DesignTokens.successColor),
    );
  }

  void _crearProveedor() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CrearProveedorPage()),
    );

    if (result == true) {
      _cargarProveedores();
    }
  }

  void _editarProveedor(Proveedor proveedor) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarProveedorPage(proveedor: proveedor),
      ),
    );

    if (result == true) {
      _cargarProveedores();
    }
  }

  void _eliminarProveedor(Proveedor proveedor) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
          '¿Está seguro de que desea eliminar el proveedor "${proveedor.nombre}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Eliminar', style: TextStyle(color: DesignTokens.errorColor)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      try {
        await _service.desactivarProveedor(proveedor.proveedorId);
        _mostrarExito('Proveedor eliminado exitosamente');
        _cargarProveedores();
      } catch (e) {
        _mostrarError('Error al eliminar proveedor: ${e.toString()}');
      }
    }
  }

  List<Proveedor> get _proveedoresFiltrados {
    if (_searchQuery.isEmpty) return _proveedores;
    return _proveedores
        .where(
          (proveedor) =>
              proveedor.nombre.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              (proveedor.email?.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ??
                  false) ||
              (proveedor.telefono?.contains(_searchQuery) ?? false),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proveedores'),
        backgroundColor: DesignTokens.primaryColor,
        foregroundColor: DesignTokens.textInverseColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProveedorSearchDelegate(_proveedores),
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
                hintText: 'Buscar proveedores...',
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

          // Lista de proveedores
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _proveedoresFiltrados.isEmpty
                ? const Center(
                    child: Text(
                      'No hay proveedores registrados',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _cargarProveedores,
                    child: ListView.builder(
                      itemCount: _proveedoresFiltrados.length,
                      itemBuilder: (context, index) {
                        final proveedor = _proveedoresFiltrados[index];
                        return _ProveedorCard(
                          proveedor: proveedor,
                          onTap: () => _editarProveedor(proveedor),
                          onDelete: () => _eliminarProveedor(proveedor),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _crearProveedor,
        backgroundColor: DesignTokens.primaryColor,
        child: const Icon(Icons.add, color: DesignTokens.textInverseColor),
      ),
    );
  }
}

class _ProveedorCard extends StatelessWidget {
  final Proveedor proveedor;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ProveedorCard({
    required this.proveedor,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: DesignTokens.primaryColor,
          child: Text(
            proveedor.nombre[0].toUpperCase(),
            style: const TextStyle(
              color: DesignTokens.surfaceColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          proveedor.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (proveedor.email != null) Text('Email: ${proveedor.email}'),
            if (proveedor.telefono != null)
              Text('Teléfono: ${proveedor.telefono}'),
            if (proveedor.direccion != null)
              Text('Dirección: ${proveedor.direccion}'),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  const Icon(Icons.edit, size: 16),
                  const SizedBox(width: 8),
                  const Text('Editar'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  const Icon(Icons.delete, size: 16, color: DesignTokens.errorColor),
                  const SizedBox(width: 8),
                  Text('Eliminar', style: TextStyle(color: DesignTokens.errorColor)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'edit') {
              onTap();
            } else if (value == 'delete') {
              onDelete();
            }
          },
        ),
        onTap: onTap,
      ),
    );
  }
}

class ProveedorSearchDelegate extends SearchDelegate {
  final List<Proveedor> proveedores;

  ProveedorSearchDelegate(this.proveedores);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.delete),
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
    final filteredProveedores = proveedores
        .where(
          (proveedor) =>
              proveedor.nombre.toLowerCase().contains(query.toLowerCase()) ||
              (proveedor.email?.toLowerCase().contains(query.toLowerCase()) ??
                  false) ||
              (proveedor.telefono?.contains(query) ?? false),
        )
        .toList();

    return ListView.builder(
      itemCount: filteredProveedores.length,
      itemBuilder: (context, index) {
        final proveedor = filteredProveedores[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: DesignTokens.primaryColor,
            child: Text(
              proveedor.nombre[0].toUpperCase(),
              style: const TextStyle(
                color: DesignTokens.surfaceColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(proveedor.nombre),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (proveedor.email != null) Text('Email: ${proveedor.email}'),
              if (proveedor.telefono != null)
                Text('Teléfono: ${proveedor.telefono}'),
            ],
          ),
          onTap: () {
            close(context, proveedor);
          },
        );
      },
    );
  }
}
