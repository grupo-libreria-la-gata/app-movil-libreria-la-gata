import 'package:flutter/material.dart';
import '../../../data/services/cliente_service.dart';
import '../../../data/models/cliente_model.dart';
import '../../../core/design/design_tokens.dart';
import 'crear_cliente_page.dart';
import 'editar_cliente_page.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  final ClienteService _service = ClienteService();
  List<Cliente> _clientes = [];
  bool _loading = true;
  String _searchQuery = '';
  bool _mostrarInactivos = false;

  @override
  void initState() {
    super.initState();
    _cargarClientes();
  }

  Future<void> _cargarClientes() async {
    setState(() => _loading = true);
    try {
      final clientes = _mostrarInactivos
          ? await _service.obtenerInactivos()
          : await _service.obtenerActivos();
      setState(() {
        _clientes = clientes;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      _mostrarError('Error al cargar clientes: ${e.toString()}');
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

  Future<void> _buscarClientes() async {
    if (_searchQuery.trim().isEmpty) {
      _cargarClientes();
      return;
    }

    setState(() => _loading = true);
    try {
      final clientes = _mostrarInactivos
          ? await _service.buscarInactivosPorNombre(_searchQuery.trim())
          : await _service.buscarPorNombre(_searchQuery.trim());
      setState(() {
        _clientes = clientes;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      _mostrarError('Error al buscar clientes: ${e.toString()}');
    }
  }

  Future<void> _crearCliente() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const CrearClientePage()),
    );
    if (result == true) {
      _cargarClientes();
    }
  }

  Future<void> _editarCliente(Cliente cliente) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditarClientePage(cliente: cliente),
      ),
    );
    if (result == true) {
      _cargarClientes();
    }
  }

  Future<void> _desactivarCliente(Cliente cliente) async {
    final confirmacion = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Desactivar Cliente'),
        content: Text(
          '¿Está seguro de que desea desactivar al cliente "${cliente.nombre}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Desactivar'),
          ),
        ],
      ),
    );

    if (confirmacion == true) {
      try {
        final response = await _service.desactivarCliente(cliente.clienteId);
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
    final confirmacion = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Activar Cliente'),
        content: Text(
          '¿Está seguro de que desea activar al cliente "${cliente.nombre}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Activar'),
          ),
        ],
      ),
    );

    if (confirmacion == true) {
      try {
        final response = await _service.activarCliente(cliente.clienteId);
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
      appBar: AppBar(
        title: Text(
          _mostrarInactivos ? 'Clientes Inactivos' : 'Gestión de Clientes',
        ),
        backgroundColor: DesignTokens.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              _mostrarInactivos ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _mostrarInactivos = !_mostrarInactivos;
                _searchQuery = '';
              });
              _cargarClientes();
            },
            tooltip: _mostrarInactivos ? 'Ver Activos' : 'Ver Inactivos',
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Buscar clientes por nombre...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    onSubmitted: (_) => _buscarClientes(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _buscarClientes,
                  child: const Text('Buscar'),
                ),
              ],
            ),
          ),
          // Lista de clientes
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _clientes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _mostrarInactivos
                              ? 'No hay clientes inactivos'
                              : 'No hay clientes registrados',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _clientes.length,
                    itemBuilder: (context, index) {
                      final cliente = _clientes[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: cliente.activo
                                ? DesignTokens.primaryColor
                                : Colors.grey,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(
                            cliente.nombre,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: cliente.activo
                                  ? DesignTokens.textPrimaryColor
                                  : Colors.grey,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (cliente.telefono.isNotEmpty)
                                Text('Tel: ${cliente.telefono}'),
                              if (cliente.email.isNotEmpty)
                                Text('Email: ${cliente.email}'),
                              if (cliente.direccion.isNotEmpty)
                                Text('Dir: ${cliente.direccion}'),
                              Text(
                                cliente.activo ? 'Activo' : 'Inactivo',
                                style: TextStyle(
                                  color: cliente.activo
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              switch (value) {
                                case 'editar':
                                  _editarCliente(cliente);
                                  break;
                                case 'desactivar':
                                  _desactivarCliente(cliente);
                                  break;
                                case 'activar':
                                  _activarCliente(cliente);
                                  break;
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'editar',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit),
                                    SizedBox(width: 8),
                                    Text('Editar'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: cliente.activo
                                    ? 'desactivar'
                                    : 'activar',
                                child: Row(
                                  children: [
                                    Icon(
                                      cliente.activo
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      cliente.activo ? 'Desactivar' : 'Activar',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _crearCliente,
        backgroundColor: DesignTokens.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
