import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/design_tokens.dart';
import '../../../data/services/proveedor_service.dart';
import '../../../data/models/proveedor_model.dart';
import '../../widgets/common/confirmation_dialog.dart';
import '../../widgets/common/crud_card.dart';
import '../../widgets/common/search_bar.dart';
import '../../widgets/common/empty_state.dart';
import 'create_supplier_page.dart';
import 'edit_supplier_page.dart';

class SuppliersPage extends ConsumerStatefulWidget {
  const SuppliersPage({super.key});

  @override
  ConsumerState<SuppliersPage> createState() => _SuppliersPageState();
}

class _SuppliersPageState extends ConsumerState<SuppliersPage> {
  final ProveedorService _proveedorService = ProveedorService();
  List<Proveedor> _proveedores = [];
  List<Proveedor> _proveedoresFiltrados = [];
  bool _isLoading = false;
  bool _mostrarInactivos = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _cargarProveedores();
  }

  Future<void> _cargarProveedores() async {
    setState(() => _isLoading = true);
    try {
      final proveedores = _mostrarInactivos
          ? await _proveedorService.obtenerInactivos()
          : await _proveedorService.obtenerActivos();

      setState(() {
        _proveedores = proveedores;
        _aplicarFiltros();
      });
    } catch (e) {
      _mostrarError('Error al cargar proveedores: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _toggleMostrarInactivos(bool value) {
    setState(() => _mostrarInactivos = value);
    _cargarProveedores();
  }

  void _aplicarFiltros() async {
    if (_searchQuery.isEmpty) {
      setState(() {
        _proveedoresFiltrados = _proveedores;
      });
      return;
    }

    try {
      final proveedoresBuscados = await _proveedorService.buscarPorNombre(_searchQuery);
      setState(() {
        _proveedoresFiltrados = proveedoresBuscados;
      });
    } catch (e) {
      _mostrarError('Error al buscar proveedores: ${e.toString()}');
      setState(() {
        _proveedoresFiltrados = _proveedores;
      });
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

  Future<void> _crearProveedor() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const CreateSupplierPage()),
    );
    if (result == true) {
      _cargarProveedores();
    }
  }

  Future<void> _editarProveedor(Proveedor proveedor) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditSupplierPage(supplier: proveedor),
      ),
    );
    if (result == true) {
      _cargarProveedores();
    }
  }

  Future<void> _desactivarProveedor(Proveedor proveedor) async {
    final confirm = await ConfirmationDialog.show(
      context,
      title: 'Desactivar Proveedor',
      message: '¿Está seguro de desactivar a ${proveedor.nombre}?',
      confirmText: 'Desactivar',
      icon: Icons.warning,
      confirmColor: DesignTokens.errorColor,
    );

    if (confirm == true) {
      try {
        final response = await _proveedorService.desactivarProveedor(
          proveedor.proveedorId,
        );
        if (response.success) {
          _mostrarExito('Proveedor desactivado exitosamente');
          _cargarProveedores();
        } else {
          _mostrarError(response.message ?? 'Error desconocido');
        }
      } catch (e) {
        _mostrarError('Error al desactivar proveedor: ${e.toString()}');
      }
    }
  }

  Future<void> _activarProveedor(Proveedor proveedor) async {
    final confirm = await ConfirmationDialog.show(
      context,
      title: 'Activar Proveedor',
      message: '¿Está seguro de activar a ${proveedor.nombre}?',
      confirmText: 'Activar',
      icon: Icons.check_circle,
      confirmColor: DesignTokens.successColor,
    );

    if (confirm == true) {
      try {
        final response = await _proveedorService.activarProveedor(
          proveedor.proveedorId,
        );
        if (response.success) {
          _mostrarExito('Proveedor activado exitosamente');
          _cargarProveedores();
        } else {
          _mostrarError(response.message ?? 'Error desconocido');
        }
      } catch (e) {
        _mostrarError('Error al activar proveedor: ${e.toString()}');
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
                    hintText: 'Buscar proveedores...',
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
                  onPressed: _crearProveedor,
                  backgroundColor: DesignTokens.primaryColor,
                  foregroundColor: DesignTokens.textInverseColor,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          // Lista de proveedores
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _proveedoresFiltrados.isEmpty
                    ? EmptyState(
                        icon: Icons.business_outlined,
                        title: _mostrarInactivos
                            ? 'No hay proveedores inactivos'
                            : 'No hay proveedores registrados',
                        subtitle: _mostrarInactivos
                            ? 'Todos los proveedores están activos'
                            : 'Agrega tu primer proveedor',
                        action: ElevatedButton.icon(
                          onPressed: _crearProveedor,
                          icon: const Icon(Icons.add),
                          label: const Text('Agregar Proveedor'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: DesignTokens.primaryColor,
                            foregroundColor: DesignTokens.textInverseColor,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _proveedoresFiltrados.length,
                        itemBuilder: (context, index) {
                          final proveedor = _proveedoresFiltrados[index];
                          return CrudCard(
                            title: proveedor.nombre,
                            subtitle: _buildProveedorSubtitle(proveedor),
                            leadingIcon: Icons.business,
                            leadingColor: proveedor.activo
                                ? DesignTokens.primaryColor
                                : DesignTokens.textSecondaryColor,
                            isActive: proveedor.activo,
                            actions: [
                              CrudAction(
                                label: 'Editar',
                                icon: Icons.edit,
                                onPressed: () => _editarProveedor(proveedor),
                                color: DesignTokens.primaryColor,
                              ),
                              CrudAction(
                                label: proveedor.activo ? 'Desactivar' : 'Activar',
                                icon: proveedor.activo
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                onPressed: proveedor.activo
                                    ? () => _desactivarProveedor(proveedor)
                                    : () => _activarProveedor(proveedor),
                                color: proveedor.activo
                                    ? DesignTokens.errorColor
                                    : DesignTokens.successColor,
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

  String _buildProveedorSubtitle(Proveedor proveedor) {
    final List<String> details = [];
    if (proveedor.telefono?.isNotEmpty == true) details.add('Tel: ${proveedor.telefono}');
    if (proveedor.email?.isNotEmpty == true) details.add('Email: ${proveedor.email}');
    if (proveedor.direccion?.isNotEmpty == true) details.add('Dir: ${proveedor.direccion}');
    return details.join(' • ');
  }
}
