import 'package:flutter/material.dart';
import '../../../data/services/marca_service.dart';
import '../../../data/models/marca_model.dart';
import '../../../core/design/design_tokens.dart';
import '../../widgets/common/confirmation_dialog.dart';
import '../../widgets/common/input_dialog.dart';
import '../../widgets/common/crud_card.dart';
import '../../widgets/common/search_bar.dart';
import '../../widgets/common/empty_state.dart';

class BrandManagementPage extends StatefulWidget {
  const BrandManagementPage({super.key});

  @override
  State<BrandManagementPage> createState() => _BrandManagementPageState();
}

class _BrandManagementPageState extends State<BrandManagementPage> {
  final MarcaService _service = MarcaService();
  List<Marca> _marcas = [];
  List<Marca> _marcasFiltradas = [];
  bool _loading = true;
  String _searchQuery = '';
  bool _mostrarInactivos = false;

  @override
  void initState() {
    super.initState();
    _loadMarcas();
  }

  Future<void> _loadMarcas() async {
    setState(() => _loading = true);
    try {
      final marcas = _mostrarInactivos
          ? await _service.obtenerInactivos()
          : await _service.obtenerActivos();
      setState(() {
        _marcas = marcas;
        _aplicarFiltros();
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      _showError('Error al cargar marcas');
    }
  }

  void _toggleMostrarInactivos(bool value) {
    setState(() => _mostrarInactivos = value);
    _loadMarcas();
  }

  void _aplicarFiltros() async {
    if (_searchQuery.isEmpty) {
      setState(() {
        _marcasFiltradas = _marcas;
      });
      return;
    }

    try {
      final marcasBuscadas = await _service.buscarPorNombre(_searchQuery);
      setState(() {
        _marcasFiltradas = marcasBuscadas;
      });
    } catch (e) {
      _showError('Error al buscar marcas: ${e.toString()}');
      setState(() {
        _marcasFiltradas = _marcas;
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

  void _crearMarca() async {
    final nombre = await InputDialog.show(
      context,
      title: 'Nueva Marca',
      labelText: 'Nombre de la marca',
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'El nombre es requerido';
        }
        return null;
      },
    );
    if (nombre != null && nombre.isNotEmpty) {
      try {
        await _service.crearMarca(nombre);
        _showSuccess('Marca creada exitosamente');
        await _loadMarcas();
      } catch (e) {
        _showError('Error al crear marca');
      }
    }
  }

  void _editarMarca(Marca marca) async {
    final nuevoNombre = await InputDialog.show(
      context,
      title: 'Editar Marca',
      labelText: 'Nombre de la marca',
      initialValue: marca.nombre,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'El nombre es requerido';
        }
        return null;
      },
    );
    if (nuevoNombre != null && nuevoNombre.isNotEmpty) {
      try {
        await _service.editarMarca(marca.marcaId, nuevoNombre);
        _showSuccess('Marca actualizada exitosamente');
        await _loadMarcas();
      } catch (e) {
        _showError('Error al editar marca');
      }
    }
  }

  void _desactivarMarca(Marca marca) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Desactivar Marca',
      message: '¿Está seguro de desactivar la marca "${marca.nombre}"?',
      confirmText: 'Desactivar',
      icon: Icons.warning,
      confirmColor: DesignTokens.errorColor,
    );

    if (confirmed == true) {
      try {
        await _service.desactivarMarca(marca.marcaId);
        _showSuccess('Marca desactivada exitosamente');
        await _loadMarcas();
      } catch (e) {
        _showError('Error al desactivar marca');
      }
    }
  }

  void _activarMarca(Marca marca) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Activar Marca',
      message: '¿Está seguro de activar la marca "${marca.nombre}"?',
      confirmText: 'Activar',
      icon: Icons.check_circle,
      confirmColor: DesignTokens.successColor,
    );

    if (confirmed == true) {
      try {
        await _service.activarMarca(marca.marcaId);
        _showSuccess('Marca activada exitosamente');
        await _loadMarcas();
      } catch (e) {
        _showError('Error al activar marca');
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
                    hintText: 'Buscar marcas...',
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
                  onPressed: _crearMarca,
                  backgroundColor: DesignTokens.primaryColor,
                  foregroundColor: DesignTokens.textInverseColor,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          // Lista de marcas
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _marcasFiltradas.isEmpty
                    ? EmptyState(
                        icon: Icons.branding_watermark_outlined,
                        title: _mostrarInactivos
                            ? (_searchQuery.isNotEmpty
                                ? 'No se encontraron marcas inactivas'
                                : 'No hay marcas inactivas')
                            : (_searchQuery.isNotEmpty
                                ? 'No se encontraron marcas'
                                : 'No hay marcas registradas'),
                        subtitle: _mostrarInactivos
                            ? 'Todas las marcas están activas'
                            : (_searchQuery.isNotEmpty
                                ? 'Intenta con otro término de búsqueda'
                                : 'Agrega tu primera marca'),
                        action: ElevatedButton.icon(
                          onPressed: _crearMarca,
                          icon: const Icon(Icons.add),
                          label: const Text('Agregar Marca'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: DesignTokens.primaryColor,
                            foregroundColor: DesignTokens.textInverseColor,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _marcasFiltradas.length,
                        itemBuilder: (context, index) {
                          final marca = _marcasFiltradas[index];
                          return CrudCard(
                            title: marca.nombre,
                            subtitle: 'ID: ${marca.marcaId}',
                            leadingIcon: Icons.branding_watermark,
                            leadingColor: DesignTokens.primaryColor,
                            actions: _mostrarInactivos
                                ? [
                                    CrudAction(
                                      label: 'Activar',
                                      icon: Icons.check_circle,
                                      onPressed: () => _activarMarca(marca),
                                      color: DesignTokens.successColor,
                                    ),
                                  ]
                                : [
                                    CrudAction(
                                      label: 'Editar',
                                      icon: Icons.edit,
                                      onPressed: () => _editarMarca(marca),
                                      color: DesignTokens.primaryColor,
                                    ),
                                    CrudAction(
                                      label: 'Desactivar',
                                      icon: Icons.delete_outline,
                                      onPressed: () => _desactivarMarca(marca),
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