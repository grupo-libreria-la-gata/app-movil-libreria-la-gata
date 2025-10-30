import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/design_tokens.dart';
import '../../../data/services/cliente_service.dart';
import '../../../data/models/cliente_model.dart';
import '../../widgets/common/confirmation_dialog.dart';
import '../../widgets/common/crud_card.dart';
import '../../widgets/common/search_bar.dart';
import '../../widgets/common/empty_state.dart';
import 'create_customer_page.dart';
import 'edit_customer_page.dart';

class CustomersPage extends ConsumerStatefulWidget {
  const CustomersPage({super.key});

  @override
  ConsumerState<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends ConsumerState<CustomersPage> {
  final ClienteService _clienteService = ClienteService();
  List<Cliente> _clientes = [];
  List<Cliente> _clientesFiltrados = [];
  bool _isLoading = false;
  bool _mostrarInactivos = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _cargarClientes();
  }

  Future<void> _cargarClientes() async {
    setState(() => _isLoading = true);
    try {
      final clientes = _mostrarInactivos
          ? await _clienteService.obtenerInactivos()
          : await _clienteService.obtenerActivos();

      setState(() {
        _clientes = clientes;
        _aplicarFiltros();
      });
    } catch (e) {
      _mostrarError('Error al cargar clientes: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _aplicarFiltros() async {
    if (_searchQuery.isEmpty) {
      setState(() {
        _clientesFiltrados = _clientes;
      });
      return;
    }

    try {
      final clientesBuscados = await _clienteService.buscarPorNombre(_searchQuery);
      setState(() {
        _clientesFiltrados = clientesBuscados;
      });
    } catch (e) {
      _mostrarError('Error al buscar clientes: ${e.toString()}');
      setState(() {
        _clientesFiltrados = _clientes;
      });
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

  Future<void> _crearCliente() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const CreateCustomerPage()),
    );
    if (result == true) {
      _cargarClientes();
    }
  }

  Future<void> _editarCliente(Cliente cliente) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditCustomerPage(customer: cliente),
      ),
    );
    if (result == true) {
      _cargarClientes();
    }
  }

  Future<void> _desactivarCliente(Cliente cliente) async {
    final confirm = await ConfirmationDialog.show(
      context,
      title: 'Desactivar Cliente',
      message: '¿Está seguro de desactivar a ${cliente.nombre}?',
      confirmText: 'Desactivar',
      icon: Icons.warning,
      confirmColor: DesignTokens.errorColor,
    );

    if (confirm == true) {
      try {
        final response = await _clienteService.desactivarCliente(
          cliente.clienteId,
        );
        if (response.success) {
          _mostrarExito('Cliente desactivado exitosamente');
          _cargarClientes();
        } else {
          _mostrarError(response.message ?? 'Error desconocido');
        }
      } catch (e) {
        _mostrarError('Error al desactivar cliente: ${e.toString()}');
      }
    }
  }

  Future<void> _activarCliente(Cliente cliente) async {
    final confirm = await ConfirmationDialog.show(
      context,
      title: 'Activar Cliente',
      message: '¿Está seguro de activar a ${cliente.nombre}?',
      confirmText: 'Activar',
      icon: Icons.check_circle,
      confirmColor: DesignTokens.successColor,
    );

    if (confirm == true) {
      try {
        final response = await _clienteService.activarCliente(
          cliente.clienteId,
        );
        if (response.success) {
          _mostrarExito('Cliente activado exitosamente');
          _cargarClientes();
        } else {
          _mostrarError(response.message ?? 'Error desconocido');
        }
      } catch (e) {
        _mostrarError('Error al activar cliente: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.backgroundColor,
      body: Column(
        children: [
          // Barra de búsqueda con botón agregar
          Padding(
            padding: const EdgeInsets.all(DesignTokens.spacingMd),
            child: Row(
              children: [
                Expanded(
                  child: CustomSearchBar(
                    hintText: 'Buscar clientes...',
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
                  onPressed: _crearCliente,
                  backgroundColor: DesignTokens.primaryColor,
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          // Lista de clientes
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _clientesFiltrados.isEmpty
                    ? EmptyState(
                        icon: Icons.people_outline,
                        title: _mostrarInactivos
                            ? 'No hay clientes inactivos'
                            : 'No hay clientes registrados',
                        subtitle: _mostrarInactivos
                            ? 'Todos los clientes están activos'
                            : 'Agrega tu primer cliente',
                        action: ElevatedButton.icon(
                          onPressed: _crearCliente,
                          icon: const Icon(Icons.add),
                          label: const Text('Agregar Cliente'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: DesignTokens.primaryColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _clientesFiltrados.length,
                        itemBuilder: (context, index) {
                          final cliente = _clientesFiltrados[index];
                          return CrudCard(
                            title: cliente.nombre,
                            subtitle: _buildClienteSubtitle(cliente),
                            leadingIcon: Icons.person,
                            leadingColor: cliente.activo
                                ? DesignTokens.primaryColor
                                : Colors.grey,
                            isActive: cliente.activo,
                            actions: [
                              CrudAction(
                                label: 'Editar',
                                icon: Icons.edit,
                                onPressed: () => _editarCliente(cliente),
                                color: DesignTokens.primaryColor,
                              ),
                              CrudAction(
                                label: cliente.activo ? 'Desactivar' : 'Activar',
                                icon: cliente.activo
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                onPressed: cliente.activo
                                    ? () => _desactivarCliente(cliente)
                                    : () => _activarCliente(cliente),
                                color: cliente.activo
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

  String _buildClienteSubtitle(Cliente cliente) {
    final List<String> details = [];
    if (cliente.telefono.isNotEmpty) details.add('Tel: ${cliente.telefono}');
    if (cliente.email.isNotEmpty) details.add('Email: ${cliente.email}');
    if (cliente.direccion.isNotEmpty) details.add('Dir: ${cliente.direccion}');
    return details.join(' • ');
  }
}
