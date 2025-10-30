import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/design_tokens.dart';
import '../../../data/services/compra_service.dart';
import '../../../data/services/detalle_producto_service.dart';
import '../../../data/services/proveedor_service.dart';
import '../../../data/models/proveedor_model.dart';
import '../../../data/models/detalle_producto_model.dart';
import '../../../data/models/request_models.dart';
import '../../providers/auth_provider.dart';

class NewPurchasePage extends ConsumerStatefulWidget {
  const NewPurchasePage({super.key});

  @override
  ConsumerState<NewPurchasePage> createState() => _NewPurchasePageState();
}

class _NewPurchasePageState extends ConsumerState<NewPurchasePage> {
  final CompraService _compraService = CompraService();
  final DetalleProductoService _detalleProductoService = DetalleProductoService();
  final ProveedorService _proveedorService = ProveedorService();
  final _formKey = GlobalKey<FormState>();
  final _observacionesController = TextEditingController();

  Proveedor? _proveedorSeleccionado;
  List<Proveedor> _proveedores = [];
  List<DetalleProducto> _detalleProductos = [];
  List<CrearCompraDetalleRequest> _detalles = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  @override
  void dispose() {
    _observacionesController.dispose();
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    setState(() => _isLoading = true);
    try {
      final proveedores = await _proveedorService.obtenerActivos();
      final productos = await _detalleProductoService.obtenerActivos();
      setState(() {
        _proveedores = proveedores;
        _detalleProductos = productos;
      });
    } catch (e) {
      _mostrarError('Error al cargar datos: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _agregarDetalle(DetalleProducto producto, int cantidad, double precioUnitario) {
    final detalleExistente = _detalles.firstWhere(
      (d) => d.detalleProductoId == producto.detalleProductoId,
      orElse: () => CrearCompraDetalleRequest(
        detalleProductoId: 0,
        codigoBarra: '',
        cantidad: 0,
        precioUnitario: 0,
        subtotal: 0,
      ),
    );

    if (detalleExistente.detalleProductoId == 0) {
      setState(() {
        _detalles.add(
          CrearCompraDetalleRequest(
            detalleProductoId: producto.detalleProductoId,
            codigoBarra: producto.codigoBarra,
            cantidad: cantidad,
            precioUnitario: precioUnitario,
            subtotal: cantidad * precioUnitario,
          ),
        );
      });
    } else {
      _actualizarCantidad(
        _detalles.indexOf(detalleExistente),
        detalleExistente.cantidad + cantidad,
      );
    }
  }

  void _actualizarCantidad(int index, int nuevaCantidad) {
    if (nuevaCantidad <= 0) {
      _removerDetalle(index);
      return;
    }

    setState(() {
      _detalles[index] = CrearCompraDetalleRequest(
        detalleProductoId: _detalles[index].detalleProductoId,
        codigoBarra: _detalles[index].codigoBarra,
        cantidad: nuevaCantidad,
        precioUnitario: _detalles[index].precioUnitario,
        subtotal: nuevaCantidad * _detalles[index].precioUnitario,
      );
    });
  }

  void _removerDetalle(int index) {
    setState(() {
      _detalles.removeAt(index);
    });
  }

  double get _total {
    return _detalles.fold(
      0.0,
      (sum, detalle) => sum + (detalle.cantidad * detalle.precioUnitario),
    );
  }

  Future<void> _guardarCompra() async {
    if (!_formKey.currentState!.validate()) return;
    if (_proveedorSeleccionado == null) {
      _mostrarError('Seleccione un proveedor');
      return;
    }
    if (_detalles.isEmpty) {
      _mostrarError('Agregue al menos un producto');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Obtener el usuario actual
      final authState = ref.read(authProvider);
      final usuarioId = int.tryParse(authState.user?.id ?? '1') ?? 1;
      
      final request = CrearCompraRequest(
        proveedorId: _proveedorSeleccionado!.proveedorId,
        usuarioId: usuarioId,
        subtotal: _total,
        impuestos: 0.0, // Por ahora sin impuestos
        total: _total,
        observaciones: _observacionesController.text.trim(),
        detalles: _detalles,
      );

      await _compraService.crearCompra(request);
      _mostrarExito('Compra creada exitosamente');
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      _mostrarError('Error al crear compra: ${e.toString()}');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.backgroundColor,
      appBar: AppBar(
        backgroundColor: DesignTokens.primaryColor,
        foregroundColor: Colors.white,
        title: const Text('Nueva Compra'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _guardarCompra,
            child: const Text(
              'Guardar',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(DesignTokens.spacingMd),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Sección Proveedor
                          _buildProveedorCard(),
                          const SizedBox(height: DesignTokens.spacingMd),
                          
                          // Sección Observaciones
                          _buildObservacionesCard(),
                          const SizedBox(height: DesignTokens.spacingMd),
                          
                          // Sección Productos
                          _buildProductosCard(),
                        ],
                      ),
                    ),
                  ),
                  
                  // Footer con total y botón guardar
                  _buildFooter(),
                ],
              ),
            ),
    );
  }

  Widget _buildProveedorCard() {
    return Card(
      elevation: DesignTokens.elevationSm,
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Proveedor',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeLg,
                fontWeight: DesignTokens.fontWeightBold,
                color: DesignTokens.textPrimaryColor,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingSm),
            DropdownButtonFormField<Proveedor>(
              initialValue: _proveedorSeleccionado,
              decoration: InputDecoration(
                hintText: 'Seleccionar proveedor',
                prefixIcon: const Icon(Icons.business),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              items: _proveedores.map((proveedor) {
                return DropdownMenuItem<Proveedor>(
                  value: proveedor,
                  child: Text(proveedor.nombre),
                );
              }).toList(),
              onChanged: (Proveedor? nuevoProveedor) {
                setState(() {
                  _proveedorSeleccionado = nuevoProveedor;
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
    );
  }

  Widget _buildObservacionesCard() {
    return Card(
      elevation: DesignTokens.elevationSm,
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Observaciones',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeLg,
                fontWeight: DesignTokens.fontWeightBold,
                color: DesignTokens.textPrimaryColor,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingSm),
            TextFormField(
              controller: _observacionesController,
              decoration: InputDecoration(
                hintText: 'Observaciones (opcional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                ),
                contentPadding: const EdgeInsets.all(DesignTokens.spacingMd),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductosCard() {
    return Card(
      elevation: DesignTokens.elevationSm,
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Productos',
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeLg,
                      fontWeight: DesignTokens.fontWeightBold,
                      color: DesignTokens.textPrimaryColor,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _mostrarModalProductos,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Agregar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DesignTokens.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: DesignTokens.spacingSm),
            if (_detalles.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(DesignTokens.spacingLg),
                decoration: BoxDecoration(
                  color: DesignTokens.backgroundColor,
                  borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  'No hay productos agregados',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeMd,
                    color: DesignTokens.textSecondaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            else
              ..._detalles.asMap().entries.map((entry) {
                final index = entry.key;
                final detalle = entry.value;
                final producto = _detalleProductos.firstWhere(
                  (p) => p.detalleProductoId == detalle.detalleProductoId,
                  orElse: () => DetalleProducto(
                    detalleProductoId: 0,
                    producto: 'Producto no encontrado',
                    categoria: '',
                    marca: '',
                    codigoBarra: '',
                    costo: 0,
                    precio: 0,
                    stock: 0,
                    fechaCreacion: DateTime.now(),
                  ),
                );
                return _buildProductoItem(producto, detalle, index);
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildProductoItem(DetalleProducto producto, CrearCompraDetalleRequest detalle, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingSm),
      padding: const EdgeInsets.all(DesignTokens.spacingSm),
      decoration: BoxDecoration(
        color: DesignTokens.backgroundColor,
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Producto ID: ${producto.detalleProductoId}',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeMd,
                    fontWeight: DesignTokens.fontWeightBold,
                    color: DesignTokens.textPrimaryColor,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                onPressed: () => _mostrarModalEditarProducto(producto, detalle, index),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: DesignTokens.spacingXs),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                onPressed: () => _removerDetalle(index),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingXs),
          Text(
            'Cantidad: ${detalle.cantidad}  Precio: \$${_formatCurrency(detalle.precioUnitario)}',
            style: TextStyle(
              fontSize: DesignTokens.fontSizeSm,
              color: DesignTokens.textPrimaryColor,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingXs),
          Text(
            'Subtotal: \$${_formatCurrency(detalle.subtotal)}',
            style: TextStyle(
              fontSize: DesignTokens.fontSizeMd,
              fontWeight: DesignTokens.fontWeightBold,
              color: DesignTokens.successColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: Colors.white,
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
              Text(
                'Total:',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeLg,
                  fontWeight: DesignTokens.fontWeightBold,
                  color: DesignTokens.textPrimaryColor,
                ),
              ),
              Text(
                '\$${_formatCurrency(_total)}',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeLg,
                  fontWeight: DesignTokens.fontWeightBold,
                  color: DesignTokens.successColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _guardarCompra,
              style: ElevatedButton.styleFrom(
                backgroundColor: DesignTokens.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingMd),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Guardar Compra',
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeMd,
                        fontWeight: DesignTokens.fontWeightBold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarModalProductos() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _ProductoModal(
        productos: _detalleProductos,
        onAgregar: _agregarDetalle,
      ),
    );
  }

  void _mostrarModalEditarProducto(DetalleProducto producto, CrearCompraDetalleRequest detalle, int index) {
    showDialog(
      context: context,
      builder: (context) => _ProductoModal(
        productos: _detalleProductos,
        productoSeleccionado: producto,
        cantidadInicial: detalle.cantidad,
        precioInicial: detalle.precioUnitario,
        onAgregar: (producto, cantidad, precio) {
          _actualizarCantidad(index, detalle.cantidad);
        },
        onActualizar: (producto, cantidad, precio) {
          setState(() {
            _detalles[index] = CrearCompraDetalleRequest(
              detalleProductoId: producto.detalleProductoId,
              codigoBarra: producto.codigoBarra,
              cantidad: cantidad,
              precioUnitario: precio,
              subtotal: cantidad * precio,
            );
          });
        },
        esEdicion: true,
      ),
    );
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(2);
  }
}

class _ProductoModal extends StatefulWidget {
  final List<DetalleProducto> productos;
  final Function(DetalleProducto, int, double) onAgregar;
  final Function(DetalleProducto, int, double)? onActualizar;
  final DetalleProducto? productoSeleccionado;
  final int? cantidadInicial;
  final double? precioInicial;
  final bool esEdicion;

  const _ProductoModal({
    required this.productos,
    required this.onAgregar,
    this.onActualizar,
    this.productoSeleccionado,
    this.cantidadInicial,
    this.precioInicial,
    this.esEdicion = false,
  });

  @override
  State<_ProductoModal> createState() => _ProductoModalState();
}

class _ProductoModalState extends State<_ProductoModal> {
  DetalleProducto? _productoSeleccionado;
  final _cantidadController = TextEditingController();
  final _precioController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.esEdicion && widget.productoSeleccionado != null) {
      _productoSeleccionado = widget.productoSeleccionado;
      _cantidadController.text = widget.cantidadInicial.toString();
      _precioController.text = widget.precioInicial.toString();
    } else {
      _cantidadController.text = '1';
      _precioController.text = '0.00';
    }
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  void _calcularSubtotal() {
    if (_productoSeleccionado != null && 
        _cantidadController.text.isNotEmpty && 
        _precioController.text.isNotEmpty) {
      // El subtotal se calcula automáticamente en el UI
      setState(() {});
    }
  }

  double get _subtotal {
    if (_productoSeleccionado == null) return 0.0;
    final cantidad = int.tryParse(_cantidadController.text) ?? 0;
    final precio = double.tryParse(_precioController.text) ?? 0.0;
    return cantidad * precio;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Agregar Producto',
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeLg,
                      fontWeight: DesignTokens.fontWeightBold,
                      color: DesignTokens.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spacingMd),
                  
                  // Campo Producto
                  DropdownButtonFormField<DetalleProducto>(
                    initialValue: _productoSeleccionado,
                    decoration: InputDecoration(
                      labelText: 'Producto',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    items: widget.productos.map((producto) {
                      return DropdownMenuItem<DetalleProducto>(
                        value: producto,
                        child: Text(
                          '${producto.producto} - ${producto.marca}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (DetalleProducto? nuevoProducto) {
                      setState(() {
                        _productoSeleccionado = nuevoProducto;
                        if (nuevoProducto != null && !widget.esEdicion) {
                          _precioController.text = nuevoProducto.costo.toStringAsFixed(2);
                        }
                        _calcularSubtotal();
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Seleccione un producto';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: DesignTokens.spacingMd),
                  
                  // Campo Cantidad
                  TextFormField(
                    controller: _cantidadController,
                    decoration: InputDecoration(
                      labelText: 'Cantidad',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _calcularSubtotal(),
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
                  const SizedBox(height: DesignTokens.spacingMd),
                  
                  // Campo Precio Unitario
                  TextFormField(
                    controller: _precioController,
                    decoration: InputDecoration(
                      labelText: 'Precio Unitario',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _calcularSubtotal(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese el precio unitario';
                      }
                      final precio = double.tryParse(value);
                      if (precio == null || precio <= 0) {
                        return 'El precio unitario debe ser mayor a 0';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: DesignTokens.spacingMd),
                  
                  // Campo Subtotal (solo lectura)
                  Container(
                    padding: const EdgeInsets.all(DesignTokens.spacingMd),
                    decoration: BoxDecoration(
                      color: DesignTokens.backgroundColor,
                      borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Subtotal:',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeMd,
                            fontWeight: DesignTokens.fontWeightMedium,
                            color: DesignTokens.textPrimaryColor,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '\$${_subtotal.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeMd,
                            fontWeight: DesignTokens.fontWeightBold,
                            color: DesignTokens.successColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spacingLg),
                  
                  // Botones
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Cancelar',
                            style: TextStyle(
                              color: DesignTokens.primaryColor,
                              fontWeight: DesignTokens.fontWeightMedium,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: DesignTokens.spacingMd),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate() && _productoSeleccionado != null) {
                              if (widget.esEdicion && widget.onActualizar != null) {
                                widget.onActualizar!(
                                  _productoSeleccionado!,
                                  int.parse(_cantidadController.text),
                                  double.parse(_precioController.text),
                                );
                              } else {
                                widget.onAgregar(
                                  _productoSeleccionado!,
                                  int.parse(_cantidadController.text),
                                  double.parse(_precioController.text),
                                );
                              }
                              Navigator.of(context).pop();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: DesignTokens.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                            ),
                          ),
                          child: Text(
                            widget.esEdicion ? 'Actualizar' : 'Agregar',
                            style: TextStyle(fontWeight: DesignTokens.fontWeightBold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}