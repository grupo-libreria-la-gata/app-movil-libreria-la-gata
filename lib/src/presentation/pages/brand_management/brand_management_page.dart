import 'package:flutter/material.dart';
import '../../../data/services/marca_service.dart';
import '../../../data/models/marca_model.dart';

class BrandManagementPage extends StatefulWidget {
  const BrandManagementPage({super.key});

  @override
  State<BrandManagementPage> createState() => _BrandManagementPageState();
}

class _BrandManagementPageState extends State<BrandManagementPage> {
  final MarcaService _service = MarcaService();
  List<Marca> _marcas = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadMarcas();
  }

  Future<void> _loadMarcas() async {
    try {
      final marcas = await _service.obtenerActivos();
      setState(() {
        _marcas = marcas;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      _showError('Error al cargar marcas');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _crearMarca() async {
    final nombre = await _mostrarDialogo('Nueva Marca');
    if (nombre != null && nombre.isNotEmpty) {
      try {
        await _service.crearMarca(nombre);
        await _loadMarcas();
      } catch (e) {
        _showError('Error al crear marca');
      }
    }
  }

  void _editarMarca(Marca marca) async {
    final nuevoNombre = await _mostrarDialogo('Editar Marca', initial: marca.nombre);
    if (nuevoNombre != null && nuevoNombre.isNotEmpty) {
      try {
        await _service.editarMarca(marca.marcaId, nuevoNombre);
        await _loadMarcas();
      } catch (e) {
        _showError('Error al editar marca');
      }
    }
  }

  void _desactivarMarca(Marca marca) async {
    try {
      await _service.desactivarMarca(marca.marcaId);
      await _loadMarcas();
    } catch (e) {
      _showError('Error al desactivar marca');
    }
  }

  Future<String?> _mostrarDialogo(String titulo, {String initial = ''}) {
    final controller = TextEditingController(text: initial);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Nombre de la marca'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('Guardar')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Marcas')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _marcas.length,
              itemBuilder: (context, index) {
                final marca = _marcas[index];
                return ListTile(
                  title: Text(marca.nombre),
                  subtitle: Text('ID: ${marca.marcaId}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit), onPressed: () => _editarMarca(marca)),
                      IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => _desactivarMarca(marca)),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _crearMarca,
        child: const Icon(Icons.add),
      ),
    );
  }
}