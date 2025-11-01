import 'package:flutter/material.dart';
import '../../../data/services/producto_service.dart';
import '../../../data/models/producto_model.dart';
import '../../../core/design/design_tokens.dart';
import '../../widgets/common/confirmation_dialog.dart';
import '../../widgets/common/input_dialog.dart';
import '../../widgets/common/crud_card.dart';
import '../../widgets/common/search_bar.dart';
import '../../widgets/common/empty_state.dart';

class ProductManagementPage extends StatefulWidget {
  const ProductManagementPage({super.key});

  @override
  State<ProductManagementPage> createState() => _ProductManagementPageState();
}

class _ProductManagementPageState extends State<ProductManagementPage> {
  final ProductoService _service = ProductoService();
  List<Producto> _productos = [];
  List<Producto> _productosFiltrados = [];
  bool _loading = true;
  String _searchQuery = '';
  bool _mostrarInactivos = false;

  @override
  void initState() {
    super.initState();
    _loadProductos();
  }

  Future<void> _loadProductos() async {
    setState(() => _loading = true);
    try {
      final productos = _mostrarInactivos
          ? await _service.obtenerInactivos()
          : await _service.obtenerActivos();
      setState(() {
        _productos = productos;
        _aplicarFiltros();
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      _showError('Error al cargar productos');
    }
  }

  void _toggleMostrarInactivos(bool value) {
    setState(() => _mostrarInactivos = value);
    _loadProductos();
  }

  void _aplicarFiltros() async {
    if (_searchQuery.isEmpty) {
      setState(() {
        _productosFiltrados = _productos;
      });
      return;
    }

    try {
      final productosBuscados = await _service.buscarPorNombre(_searchQuery);
      setState(() {
        _productosFiltrados = productosBuscados;
      });
    } catch (e) {
      _showError('Error al buscar productos: ${e.toString()}');
      setState(() {
        _productosFiltrados = _productos;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: DesignTokens.errorColor),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: DesignTokens.successColor),
    );
  }

  void _crearProducto() async {
    final nombre = await InputDialog.show(
      context,
      title: 'Nuevo Producto',
      labelText: 'Nombre del producto',
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'El nombre es requerido';
        }
        return null;
      },
    );
    if (nombre != null && nombre.isNotEmpty) {
      try {
        await _service.crearProducto(nombre);
        _showSuccess('Producto creado exitosamente');
        await _loadProductos();
      } catch (e) {
        _showError('Error al crear producto');
      }
    }
  }

  void _editarProducto(Producto producto) async {
    final nuevoNombre = await InputDialog.show(
      context,
      title: 'Editar Producto',
      labelText: 'Nombre del producto',
      initialValue: producto.nombre,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'El nombre es requerido';
        }
        return null;
      },
    );
    if (nuevoNombre != null && nuevoNombre.isNotEmpty) {
      try {
        await _service.editarProducto(producto.productoId, nuevoNombre);
        _showSuccess('Producto actualizado exitosamente');
        await _loadProductos();
      } catch (e) {
        _showError('Error al editar producto');
      }
    }
  }

  void _desactivarProducto(Producto producto) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Desactivar Producto',
      message: '¿Está seguro de desactivar el producto "${producto.nombre}"?',
      confirmText: 'Desactivar',
      icon: Icons.warning,
      confirmColor: DesignTokens.errorColor,
    );

    if (confirmed == true) {
      try {
        await _service.desactivarProducto(producto.productoId);
        _showSuccess('Producto desactivado exitosamente');
        await _loadProductos();
      } catch (e) {
        _showError('Error al desactivar producto');
      }
    }
  }

  void _activarProducto(Producto producto) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Activar Producto',
      message: '¿Está seguro de activar el producto "${producto.nombre}"?',
      confirmText: 'Activar',
      icon: Icons.check_circle,
      confirmColor: DesignTokens.successColor,
    );

    if (confirmed == true) {
      try {
        await _service.activarProducto(producto.productoId);
        _showSuccess('Producto activado exitosamente');
        await _loadProductos();
      } catch (e) {
        _showError('Error al activar producto');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.backgroundColor,
      body: Column(
        children: [
          // Toggle para mostrar inactivos
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingMd,
              vertical: DesignTokens.spacingSm,
            ),
            color: DesignTokens.surfaceColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  _mostrarInactivos ? 'Mostrando Inactivos' : 'Mostrando Activos',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeSm,
                    color: DesignTokens.textSecondaryColor,
                  ),
                ),
                const SizedBox(width: DesignTokens.spacingSm),
                Switch(
                  value: _mostrarInactivos,
                  onChanged: _toggleMostrarInactivos,
                  activeTrackColor: DesignTokens.primaryColor.withValues(alpha: 0.5),
                  activeThumbColor: DesignTokens.primaryColor,
                ),
              ],
            ),
          ),
          // Barra de búsqueda con botón agregar
          Padding(
            padding: const EdgeInsets.all(DesignTokens.spacingMd),
            child: Row(
              children: [
                Expanded(
                  child: CustomSearchBar(
                    hintText: 'Buscar productos...',
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                        _aplicarFiltros();
                      });
                    },
                    onClear: _searchQuery.isNotEmpty
                        ? () {
                            setState(() {
                              _searchQuery = '';
                              _aplicarFiltros();
                            });
                          }
                        : null,
                  ),
                ),
                const SizedBox(width: DesignTokens.spacingSm),
                FloatingActionButton.small(
                  onPressed: _crearProducto,
                  backgroundColor: DesignTokens.primaryColor,
                  foregroundColor: DesignTokens.textInverseColor,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          // Lista de productos
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _productosFiltrados.isEmpty
                    ? EmptyState(
                        icon: Icons.inventory_outlined,
                        title: _mostrarInactivos
                            ? (_searchQuery.isNotEmpty
                                ? 'No se encontraron productos inactivos'
                                : 'No hay productos inactivos')
                            : (_searchQuery.isNotEmpty
                                ? 'No se encontraron productos'
                                : 'No hay productos registrados'),
                        subtitle: _mostrarInactivos
                            ? 'Todos los productos están activos'
                            : (_searchQuery.isNotEmpty
                                ? 'Intenta con otro término de búsqueda'
                                : 'Agrega tu primer producto'),
                        action: ElevatedButton.icon(
                          onPressed: _crearProducto,
                          icon: const Icon(Icons.add),
                          label: const Text('Agregar Producto'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: DesignTokens.primaryColor,
                            foregroundColor: DesignTokens.textInverseColor,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _productosFiltrados.length,
                        itemBuilder: (context, index) {
                          final producto = _productosFiltrados[index];
                          return CrudCard(
                            title: producto.nombre,
                            subtitle: 'ID: ${producto.productoId}',
                            leadingIcon: Icons.inventory,
                            leadingColor: DesignTokens.successColor,
                            actions: _mostrarInactivos
                                ? [
                                    CrudAction(
                                      label: 'Activar',
                                      icon: Icons.check_circle,
                                      onPressed: () => _activarProducto(producto),
                                      color: DesignTokens.successColor,
                                    ),
                                  ]
                                : [
                                    CrudAction(
                                      label: 'Editar',
                                      icon: Icons.edit,
                                      onPressed: () => _editarProducto(producto),
                                      color: DesignTokens.primaryColor,
                                    ),
                                    CrudAction(
                                      label: 'Desactivar',
                                      icon: Icons.delete_outline,
                                      onPressed: () => _desactivarProducto(producto),
                                      color: DesignTokens.errorColor,
                                    ),
                                  ],
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}