import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/compra_model.dart';
import '../../../data/services/compra_service.dart';
import '../../providers/auth_provider_legacy.dart';
import 'detalle_compra_widget.dart';

class NuevaCompraPage extends StatefulWidget {
  const NuevaCompraPage({super.key});

  @override
  State<NuevaCompraPage> createState() => _NuevaCompraPageState();
}

class _NuevaCompraPageState extends State<NuevaCompraPage> {
  final CompraService _compraService = CompraService();
  final _formKey = GlobalKey<FormState>();
  final _observacionesController = TextEditingController();
  
  int? _proveedorId;
  final List<CrearDetalleCompraRequest> _detalles = [];
  bool _isLoading = false;
  double _total = 0.0;

  @override
  void dispose() {
    _observacionesController.dispose();
    super.dispose();
  }

  void _calcularTotal() {
    setState(() {
      _total = _compraService.calcularTotal(_detalles);
    });
  }

  void _agregarDetalle() {
    showDialog(
      context: context,
      builder: (context) => _AgregarDetalleDialog(
        onDetalleAgregado: (detalle) {
          setState(() {
            _detalles.add(detalle);
          });
          _calcularTotal();
        },
      ),
    );
  }

  void _editarDetalle(int index) {
    showDialog(
      context: context,
      builder: (context) => _AgregarDetalleDialog(
        detalleExistente: _detalles[index],
        onDetalleAgregado: (detalle) {
          setState(() {
            _detalles[index] = detalle;
          });
          _calcularTotal();
        },
      ),
    );
  }

  void _eliminarDetalle(int index) {
    setState(() {
      _detalles.removeAt(index);
    });
    _calcularTotal();
  }

  Future<void> _guardarCompra() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_proveedorId == null) {
      _mostrarError('Seleccione un proveedor');
      return;
    }

    if (_detalles.isEmpty) {
      _mostrarError('Agregue al menos un producto');
      return;
    }

    if (!_compraService.validarDetalles(_detalles)) {
      _mostrarError('Verifique que todos los detalles tengan cantidad y precio válidos');
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (!mounted) return;
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final usuarioId = int.tryParse(authProvider.currentUser?.id ?? '0') ?? 0;

      final request = CrearCompraRequest(
        proveedorId: _proveedorId!,
        usuarioId: usuarioId,
        total: _total,
        observaciones: _observacionesController.text.trim().isEmpty 
            ? null 
            : _observacionesController.text.trim(),
        detalles: _detalles,
      );

      final response = await _compraService.crearCompra(request);

      if (response.success) {
        if (mounted) _mostrarExito('Compra creada exitosamente');
        Navigator.of(context).pop(true);
      } else {
        if (mounted) _mostrarError(response.message ?? 'Error al crear la compra');
      }
    } catch (e) {
      if (mounted) _mostrarError('Error inesperado: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _mostrarExito(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Compra'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(
              onPressed: _guardarCompra,
              child: const Text(
                'Guardar',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Selección de proveedor
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Proveedor',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<int>(
                              value: _proveedorId,
                              decoration: const InputDecoration(
                                labelText: 'Seleccionar proveedor',
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                // Cargar proveedores desde el servicio
                                DropdownMenuItem(value: 1, child: Text('Proveedor 1')),
                                DropdownMenuItem(value: 2, child: Text('Proveedor 2')),
                                DropdownMenuItem(value: 3, child: Text('Proveedor 3')),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _proveedorId = value;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Seleccione un proveedor';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Observaciones
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Observaciones',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _observacionesController,
                              decoration: const InputDecoration(
                                labelText: 'Observaciones (opcional)',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Detalles de la compra
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Productos',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: _agregarDetalle,
                                  icon: const Icon(Icons.add),
                                  label: const Text('Agregar'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            
                            if (_detalles.isEmpty)
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(32.0),
                                  child: Text(
                                    'No hay productos agregados',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            else
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _detalles.length,
                                itemBuilder: (context, index) {
                                  final detalle = _detalles[index];
                                  return DetalleCompraWidget(
                                    detalle: detalle,
                                    onEdit: () => _editarDetalle(index),
                                    onDelete: () => _eliminarDetalle(index),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Total y botón guardar
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${_total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _guardarCompra,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Guardar Compra',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AgregarDetalleDialog extends StatefulWidget {
  final CrearDetalleCompraRequest? detalleExistente;
  final Function(CrearDetalleCompraRequest) onDetalleAgregado;

  const _AgregarDetalleDialog({
    this.detalleExistente,
    required this.onDetalleAgregado,
  });

  @override
  State<_AgregarDetalleDialog> createState() => _AgregarDetalleDialogState();
}

class _AgregarDetalleDialogState extends State<_AgregarDetalleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _cantidadController = TextEditingController();
  final _precioController = TextEditingController();
  
  int? _detalleProductoId;
  double _subtotal = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.detalleExistente != null) {
      _detalleProductoId = widget.detalleExistente!.detalleProductoId;
      _cantidadController.text = widget.detalleExistente!.cantidad.toString();
      _precioController.text = widget.detalleExistente!.precioUnitario.toString();
      _subtotal = widget.detalleExistente!.subtotal;
    }
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  void _calcularSubtotal() {
    final cantidad = int.tryParse(_cantidadController.text) ?? 0;
    final precio = double.tryParse(_precioController.text) ?? 0.0;
    setState(() {
      _subtotal = cantidad * precio;
    });
  }

  void _guardarDetalle() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_detalleProductoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seleccione un producto'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final detalle = CrearDetalleCompraRequest(
      detalleProductoId: _detalleProductoId!,
      cantidad: int.parse(_cantidadController.text),
      precioUnitario: double.parse(_precioController.text),
      subtotal: _subtotal,
    );

    widget.onDetalleAgregado(detalle);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.detalleExistente != null ? 'Editar Producto' : 'Agregar Producto'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<int>(
              value: _detalleProductoId,
              decoration: const InputDecoration(
                labelText: 'Producto',
                border: OutlineInputBorder(),
              ),
              items: const [
                // Cargar productos desde el servicio
                DropdownMenuItem(value: 1, child: Text('Producto 1')),
                DropdownMenuItem(value: 2, child: Text('Producto 2')),
                DropdownMenuItem(value: 3, child: Text('Producto 3')),
              ],
              onChanged: (value) {
                setState(() {
                  _detalleProductoId = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Seleccione un producto';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _cantidadController,
              decoration: const InputDecoration(
                labelText: 'Cantidad',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calcularSubtotal(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingrese la cantidad';
                }
                final cantidad = int.tryParse(value);
                if (cantidad == null || cantidad <= 0) {
                  return 'La cantidad debe ser mayor a 0';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _precioController,
              decoration: const InputDecoration(
                labelText: 'Precio Unitario',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calcularSubtotal(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingrese el precio';
                }
                final precio = double.tryParse(value);
                if (precio == null || precio <= 0) {
                  return 'El precio debe ser mayor a 0';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Subtotal:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${_subtotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _guardarDetalle,
          child: Text(widget.detalleExistente != null ? 'Actualizar' : 'Agregar'),
        ),
      ],
    );
  }
}
