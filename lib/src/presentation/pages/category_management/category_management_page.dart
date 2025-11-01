import 'package:flutter/material.dart';
import '../../../data/services/categoria_service.dart';
import '../../../data/models/categoria_model.dart';
import '../../../core/design/design_tokens.dart';
import '../../widgets/common/confirmation_dialog.dart';
import '../../widgets/common/input_dialog.dart';
import '../../widgets/common/crud_card.dart';
import '../../widgets/common/search_bar.dart';
import '../../widgets/common/empty_state.dart';

class CategoryManagementPage extends StatefulWidget {
  const CategoryManagementPage({super.key});

  @override
  State<CategoryManagementPage> createState() => _CategoryManagementPageState();
}

class _CategoryManagementPageState extends State<CategoryManagementPage> {
  final CategoriaService _service = CategoriaService();
  List<Categoria> _categorias = [];
  List<Categoria> _categoriasFiltradas = [];
  bool _loading = true;
  String _searchQuery = '';
  bool _mostrarInactivos = false;

  @override
  void initState() {
    super.initState();
    _loadCategorias();
  }

  Future<void> _loadCategorias() async {
    setState(() => _loading = true);
    try {
      final categorias = _mostrarInactivos
          ? await _service.obtenerInactivos()
          : await _service.obtenerActivos();
      setState(() {
        _categorias = categorias;
        _aplicarFiltros();
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      _showError('Error al cargar categorías');
    }
  }

  void _toggleMostrarInactivos(bool value) {
    setState(() => _mostrarInactivos = value);
    _loadCategorias();
  }

  void _aplicarFiltros() async {
    if (_searchQuery.isEmpty) {
      setState(() {
        _categoriasFiltradas = _categorias;
      });
      return;
    }

    try {
      final categoriasBuscadas = await _service.buscarPorNombre(_searchQuery);
      setState(() {
        _categoriasFiltradas = categoriasBuscadas;
      });
    } catch (e) {
      _showError('Error al buscar categorías: ${e.toString()}');
      setState(() {
        _categoriasFiltradas = _categorias;
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

  void _crearCategoria() async {
    final nombre = await InputDialog.show(
      context,
      title: 'Nueva Categoría',
      labelText: 'Nombre de la categoría',
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'El nombre es requerido';
        }
        return null;
      },
    );
    if (nombre != null && nombre.isNotEmpty) {
      try {
        await _service.crearCategoria(nombre);
        _showSuccess('Categoría creada exitosamente');
        await _loadCategorias();
      } catch (e) {
        _showError('Error al crear categoría');
      }
    }
  }

  void _editarCategoria(Categoria categoria) async {
    final nuevoNombre = await InputDialog.show(
      context,
      title: 'Editar Categoría',
      labelText: 'Nombre de la categoría',
      initialValue: categoria.nombre,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'El nombre es requerido';
        }
        return null;
      },
    );
    if (nuevoNombre != null && nuevoNombre.isNotEmpty) {
      try {
        await _service.editarCategoria(categoria.categoriaId, nuevoNombre);
        _showSuccess('Categoría actualizada exitosamente');
        await _loadCategorias();
      } catch (e) {
        _showError('Error al editar categoría');
      }
    }
  }

  void _desactivarCategoria(Categoria categoria) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Desactivar Categoría',
      message: '¿Está seguro de desactivar la categoría "${categoria.nombre}"?',
      confirmText: 'Desactivar',
      icon: Icons.warning,
      confirmColor: DesignTokens.errorColor,
    );

    if (confirmed == true) {
      try {
        await _service.desactivarCategoria(categoria.categoriaId);
        _showSuccess('Categoría desactivada exitosamente');
        await _loadCategorias();
      } catch (e) {
        _showError('Error al desactivar categoría');
      }
    }
  }

  void _activarCategoria(Categoria categoria) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Activar Categoría',
      message: '¿Está seguro de activar la categoría "${categoria.nombre}"?',
      confirmText: 'Activar',
      icon: Icons.check_circle,
      confirmColor: DesignTokens.successColor,
    );

    if (confirmed == true) {
      try {
        await _service.activarCategoria(categoria.categoriaId);
        _showSuccess('Categoría activada exitosamente');
        await _loadCategorias();
      } catch (e) {
        _showError('Error al activar categoría');
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
                    hintText: 'Buscar categorías...',
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
                  onPressed: _crearCategoria,
                  backgroundColor: DesignTokens.primaryColor,
                  foregroundColor: DesignTokens.textInverseColor,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          // Lista de categorías
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _categoriasFiltradas.isEmpty
                    ? EmptyState(
                        icon: Icons.category_outlined,
                        title: _mostrarInactivos
                            ? (_searchQuery.isNotEmpty
                                ? 'No se encontraron categorías inactivas'
                                : 'No hay categorías inactivas')
                            : (_searchQuery.isNotEmpty
                                ? 'No se encontraron categorías'
                                : 'No hay categorías registradas'),
                        subtitle: _mostrarInactivos
                            ? 'Todas las categorías están activas'
                            : (_searchQuery.isNotEmpty
                                ? 'Intenta con otro término de búsqueda'
                                : 'Agrega tu primera categoría'),
                        action: ElevatedButton.icon(
                          onPressed: _crearCategoria,
                          icon: const Icon(Icons.add),
                          label: const Text('Agregar Categoría'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: DesignTokens.primaryColor,
                            foregroundColor: DesignTokens.textInverseColor,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _categoriasFiltradas.length,
                        itemBuilder: (context, index) {
                          final categoria = _categoriasFiltradas[index];
                          return CrudCard(
                            title: categoria.nombre,
                            subtitle: 'ID: ${categoria.categoriaId}',
                            leadingIcon: Icons.category,
                            leadingColor: DesignTokens.accentColor,
                            actions: _mostrarInactivos
                                ? [
                                    CrudAction(
                                      label: 'Activar',
                                      icon: Icons.check_circle,
                                      onPressed: () => _activarCategoria(categoria),
                                      color: DesignTokens.successColor,
                                    ),
                                  ]
                                : [
                                    CrudAction(
                                      label: 'Editar',
                                      icon: Icons.edit,
                                      onPressed: () => _editarCategoria(categoria),
                                      color: DesignTokens.primaryColor,
                                    ),
                                    CrudAction(
                                      label: 'Desactivar',
                                      icon: Icons.delete_outline,
                                      onPressed: () => _desactivarCategoria(categoria),
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