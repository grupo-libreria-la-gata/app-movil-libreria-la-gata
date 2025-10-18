import 'package:flutter/material.dart';
import '../../../data/services/producto_service.dart';
import '../../../data/models/producto_model.dart';

class ProductManagementPage extends StatefulWidget {
  const ProductManagementPage({super.key});

  @override
  State<ProductManagementPage> createState() => _ProductManagementPageState();
}

class _ProductManagementPageState extends State<ProductManagementPage> {
  final ProductoService _service = ProductoService();
  List<Producto> _productos = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProductos();
  }

  Future<void> _loadProductos() async {
    try {
      final productos = await _service.obtenerActivos();
      setState(() {
        _productos = productos;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      _showError('Error al cargar productos');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _crearProducto() async {
    final nombre = await _mostrarDialogo('Nuevo Producto');
    if (nombre != null && nombre.isNotEmpty) {
      try {
        await _service.crearProducto(nombre);
        await _loadProductos();
      } catch (e) {
        _showError('Error al crear producto');
      }
    }
  }

  void _editarProducto(Producto producto) async {
    final nuevoNombre = await _mostrarDialogo('Editar Producto', initial: producto.nombre);
    if (nuevoNombre != null && nuevoNombre.isNotEmpty) {
      try {
        await _service.editarProducto(producto.productoId, nuevoNombre);
        await _loadProductos();
      } catch (e) {
        _showError('Error al editar producto');
      }
    }
  }

  void _desactivarProducto(Producto producto) async {
    try {
      await _service.desactivarProducto(producto.productoId);
      await _loadProductos();
    } catch (e) {
      _showError('Error al desactivar producto');
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
          decoration: const InputDecoration(labelText: 'Nombre del producto'),
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
      appBar: AppBar(title: const Text('Gestión de Productos')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _productos.length,
              itemBuilder: (context, index) {
                final producto = _productos[index];
                return ListTile(
                  title: Text(producto.nombre),
                  subtitle: Text('ID: ${producto.productoId}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit), onPressed: () => _editarProducto(producto)),
                      IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => _desactivarProducto(producto)),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _crearProducto,
        child: const Icon(Icons.add),
      ),
    );
  }
}