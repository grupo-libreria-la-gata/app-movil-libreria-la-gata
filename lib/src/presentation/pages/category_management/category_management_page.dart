import 'package:flutter/material.dart';
import '../../../data/services/categoria_service.dart';
import '../../../data/models/categoria_model.dart';

class CategoryManagementPage extends StatefulWidget {
  const CategoryManagementPage({super.key});

  @override
  State<CategoryManagementPage> createState() => _CategoryManagementPageState();
}

class _CategoryManagementPageState extends State<CategoryManagementPage> {
  final CategoriaService _service = CategoriaService();
  List<Categoria> _categorias = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCategorias();
  }

  Future<void> _loadCategorias() async {
    try {
      final categorias = await _service.obtenerActivos();
      setState(() {
        _categorias = categorias;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      _showError('Error al cargar categorías');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _crearCategoria() async {
    final nombre = await _mostrarDialogo('Nueva Categoría');
    if (nombre != null && nombre.isNotEmpty) {
      try {
        await _service.crearCategoria(nombre);
        await _loadCategorias();
      } catch (e) {
        _showError('Error al crear categoría');
      }
    }
  }

  void _editarCategoria(Categoria categoria) async {
    final nuevoNombre = await _mostrarDialogo('Editar Categoría', initial: categoria.nombre);
    if (nuevoNombre != null && nuevoNombre.isNotEmpty) {
      try {
        await _service.editarCategoria(categoria.categoriaId, nuevoNombre);
        await _loadCategorias();
      } catch (e) {
        _showError('Error al editar categoría');
      }
    }
  }

  void _desactivarCategoria(Categoria categoria) async {
    try {
      await _service.desactivarCategoria(categoria.categoriaId);
      await _loadCategorias();
    } catch (e) {
      _showError('Error al desactivar categoría');
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
          decoration: const InputDecoration(labelText: 'Nombre de la categoría'),
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
      appBar: AppBar(title: const Text('Gestión de Categorías')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _categorias.length,
              itemBuilder: (context, index) {
                final categoria = _categorias[index];
                return ListTile(
                  title: Text(categoria.nombre),
                  subtitle: Text('ID: ${categoria.categoriaId}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit), onPressed: () => _editarCategoria(categoria)),
                      IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => _desactivarCategoria(categoria)),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _crearCategoria,
        child: const Icon(Icons.add),
      ),
    );
  }
}