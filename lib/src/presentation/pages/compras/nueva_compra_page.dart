import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/compra_model.dart';
import '../../../data/services/compra_service.dart';
import '../../../data/services/proveedor_service.dart';
import '../../../data/models/proveedor_model.dart';
import '../../../data/services/detalle_producto_service.dart';
import '../../../data/models/detalle_producto_model.dart';
import '../../providers/auth_provider.dart';
import 'detalle_compra_widget.dart';

class NuevaCompraPage extends ConsumerStatefulWidget {
  const NuevaCompraPage({super.key});

  @override
  ConsumerState<NuevaCompraPage> createState() => _NuevaCompraPageState();
}

class _NuevaCompraPageState extends ConsumerState<NuevaCompraPage> {
  final CompraService _compraService = CompraService();
  final ProveedorService _proveedorService = ProveedorService();
  final DetalleProductoService _detalleProductoService =
      DetalleProductoService();
  final _formKey = GlobalKey<FormState>();
  final _observacionesController = TextEditingController();

  int? _proveedorId;
  List<Proveedor> _proveedores = [];
  List<DetalleProducto> _detalleProductos = [];
  final List<CrearDetalleCompraRequest> _detalles = [];
  bool _isLoading = false;
  bool _cargandoProveedores = true;
  double _total = 0.0;

  @override
  void initState() {
    super.initState();
    _cargarProveedores();
    _cargarDetalleProductos();
  }

  @override
  void dispose() {
    _observacionesController.dispose();
    super.dispose();
  }

  Future<void> _cargarProveedores() async {
    try {
      final proveedores = await _proveedorService.obtenerActivos();
      setState(() {
        _proveedores = proveedores;
        _cargandoProveedores = false;
      });
    } catch (e) {
      setState(() {
        _cargandoProveedores = false;
      });
      _mostrarError('Error al cargar proveedores: ${e.toString()}');
    }
  }

  Future<void> _cargarDetalleProductos() async {
    try {
      final detalleProductos = await _detalleProductoService.obtenerActivos();
      setState(() {
        _detalleProductos = detalleProductos;
      });
    } catch (e) {
      _mostrarError('Error al cargar productos: ${e.toString()}');
    }
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
        detalleProductos: _detalleProductos,
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
        detalleProductos: _detalleProductos,
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
    print('🔍 [DEBUG] Iniciando proceso de guardar compra...');

    if (!_formKey.currentState!.validate()) {
      print('❌ [DEBUG] Validación del formulario falló');
      return;
    }

    if (_proveedorId == null) {
      print('❌ [DEBUG] No se ha seleccionado un proveedor');
      _mostrarError('Seleccione un proveedor');
      return;
    }

    if (_detalles.isEmpty) {
      print('❌ [DEBUG] No hay detalles de productos');
      _mostrarError('Agregue al menos un producto');
      return;
    }

    if (!_compraService.validarDetalles(_detalles)) {
      print('❌ [DEBUG] Validación de detalles falló');
      _mostrarError(
        'Verifique que todos los detalles tengan cantidad y precio válidos',
      );
      return;
    }

    print('✅ [DEBUG] Validaciones pasaron correctamente');
    setState(() => _isLoading = true);

    try {
      if (!mounted) return;
      final authState = ref.read(authProvider);
      final usuarioId = int.tryParse(authState.user?.id ?? '0') ?? 0;

      print('🔍 [DEBUG] Usuario ID: $usuarioId');
      print('🔍 [DEBUG] Proveedor ID: $_proveedorId');
      print('🔍 [DEBUG] Total: $_total');
      print('🔍 [DEBUG] Cantidad de detalles: ${_detalles.length}');

      final request = CrearCompraRequest(
        proveedorId: _proveedorId!,
        usuarioId: usuarioId,
        total: _total,
        observaciones: _observacionesController.text.trim().isEmpty
            ? ""
            : _observacionesController.text.trim(),
        detalles: _detalles,
      );

      print('🔍 [DEBUG] Request creado, enviando a la API...');
      final response = await _compraService.crearCompra(request);
      print(
        '🔍 [DEBUG] Respuesta recibida: success=${response.success}, message=${response.message}',
      );

      if (response.success) {
        if (mounted) {
          _mostrarExito('Compra creada exitosamente');
          _limpiarFormulario();
        }
      } else {
        if (mounted) {
          _mostrarError(response.message ?? 'Error al crear la compra');
        }
      }
    } catch (e) {
      if (mounted) _mostrarError('Error inesperado: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
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

  void _limpiarFormulario() {
    setState(() {
      _proveedorId = null;
      _detalles.clear();
      _total = 0.0;
      _observacionesController.clear();
    });
    _formKey.currentState?.reset();
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
                              initialValue: _proveedorId,
                              decoration: InputDecoration(
                                labelText: 'Seleccionar proveedor',
                                prefixIcon: const Icon(Icons.business_center),
                                border: const OutlineInputBorder(),
                              ),
                              items: _cargandoProveedores
                                  ? [
                                      const DropdownMenuItem(
                                        value: null,
                                        child: Text('Cargando...'),
                                      ),
                                    ]
                                  : _proveedores.map((proveedor) {
                                      return DropdownMenuItem<int>(
                                        value: proveedor.proveedorId,
                                        child: Text(proveedor.nombre),
                                      );
                                    }).toList(),
                              onChanged: _cargandoProveedores
                                  ? null
                                  : (value) {
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
  final List<DetalleProducto> detalleProductos;

  const _AgregarDetalleDialog({
    this.detalleExistente,
    required this.onDetalleAgregado,
    required this.detalleProductos,
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
      _precioController.text = widget.detalleExistente!.precioUnitario
          .toString();
      _subtotal =
          widget.detalleExistente!.cantidad *
          widget.detalleExistente!.precioUnitario;
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

    // Buscar el producto seleccionado para obtener su código de barras
    final productoSeleccionado = widget.detalleProductos.firstWhere(
      (p) => p.detalleProductoId == _detalleProductoId,
    );

    final detalle = CrearDetalleCompraRequest(
      detalleProductoId: _detalleProductoId!,
      cantidad: int.parse(_cantidadController.text),
      precioUnitario: double.parse(_precioController.text),
      codigoBarra: productoSeleccionado.codigoBarra,
    );

    widget.onDetalleAgregado(detalle);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.detalleExistente != null
            ? 'Editar Producto'
            : 'Agregar Producto',
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<int>(
              initialValue: _detalleProductoId,
              decoration: const InputDecoration(
                labelText: 'Producto',
                border: OutlineInputBorder(),
              ),
              items: widget.detalleProductos.map((producto) {
                return DropdownMenuItem<int>(
                  value: producto.detalleProductoId,
                  child: Text('${producto.producto} - ${producto.marca}'),
                );
              }).toList(),
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
          child: Text(
            widget.detalleExistente != null ? 'Actualizar' : 'Agregar',
          ),
        ),
      ],
    );
  }
}
