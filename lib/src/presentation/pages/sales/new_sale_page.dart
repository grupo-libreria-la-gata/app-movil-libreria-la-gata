import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/design_tokens.dart';
import '../../../data/services/venta_service.dart';
import '../../../data/services/detalle_producto_service.dart';
import '../../../data/services/cliente_service.dart';
import '../../../data/models/cliente_model.dart';
import '../../../data/models/detalle_producto_model.dart';
import '../../../data/models/request_models.dart';
import '../../providers/auth_provider.dart';

class NewSalePage extends ConsumerStatefulWidget {
  const NewSalePage({super.key});

  @override
  ConsumerState<NewSalePage> createState() => _NewSalePageState();
}

class _NewSalePageState extends ConsumerState<NewSalePage> {
  final VentaService _ventaService = VentaService();
  final DetalleProductoService _detalleProductoService = DetalleProductoService();
  final ClienteService _clienteService = ClienteService();
  final _formKey = GlobalKey<FormState>();
  final _observacionesController = TextEditingController();

  Cliente? _clienteSeleccionado;
  List<Cliente> _clientes = [];
  List<DetalleProducto> _detalleProductos = [];
  List<CrearVentaDetalleRequest> _detalles = [];
  String _metodoPago = 'Efectivo';
  bool _isLoading = false;

  final List<String> _metodosPago = ['Efectivo', 'Tarjeta', 'Transferencia'];

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
      final futures = await Future.wait([
        _clienteService.obtenerActivos(),
        _detalleProductoService.obtenerActivos(),
      ]);
      
      setState(() {
        _clientes = futures[0] as List<Cliente>;
        _detalleProductos = futures[1] as List<DetalleProducto>;
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
      orElse: () => CrearVentaDetalleRequest(
        detalleProductoId: 0,
        cantidad: 0,
        precioUnitario: 0,
        codigoBarra: '',
      ),
    );

    if (detalleExistente.detalleProductoId == 0) {
      setState(() {
        _detalles.add(
          CrearVentaDetalleRequest(
            detalleProductoId: producto.detalleProductoId,
            cantidad: cantidad,
            precioUnitario: precioUnitario,
            codigoBarra: producto.codigoBarra,
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
      setState(() {
        _detalles.removeAt(index);
      });
    } else {
      setState(() {
        final detalle = _detalles[index];
        _detalles[index] = CrearVentaDetalleRequest(
          detalleProductoId: detalle.detalleProductoId,
          cantidad: nuevaCantidad,
          precioUnitario: detalle.precioUnitario,
          codigoBarra: detalle.codigoBarra,
        );
      });
    }
  }

  Future<void> _guardarVenta() async {
    if (!_formKey.currentState!.validate()) return;

    if (_clienteSeleccionado == null) {
      _mostrarError('Seleccione un cliente');
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
      final usuarioId = int.tryParse(authState.user?.id ?? '1') ?? 1; // Default to 1 if not found

      final request = CrearVentaRequest(
        clienteId: _clienteSeleccionado!.clienteId,
        usuarioId: usuarioId,
        metodoPago: _metodoPago,
        total: _total,
        observaciones: _observacionesController.text.trim(),
        detalles: _detalles,
      );

      await _ventaService.crearVenta(request);
      if (!mounted) return;
      _mostrarExito('Venta creada exitosamente');
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      _mostrarError('Error al crear venta: ${e.toString()}');
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  double get _total => _detalles.fold(0.0, (sum, detalle) => sum + (detalle.cantidad * detalle.precioUnitario));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.backgroundColor,
      appBar: AppBar(
        backgroundColor: DesignTokens.primaryColor,
        foregroundColor: Colors.white,
        title: const Text('Nueva Venta'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
                          // Selección de Cliente
                          _buildClienteSection(),
                          const SizedBox(height: DesignTokens.spacingLg),

                          // Método de Pago
                          _buildMetodoPagoSection(),
                          const SizedBox(height: DesignTokens.spacingLg),

                          // Productos
                          _buildProductosSection(),
                          const SizedBox(height: DesignTokens.spacingLg),

                          // Lista de Productos Agregados
                          _buildListaProductos(),
                          const SizedBox(height: DesignTokens.spacingLg),

                          // Observaciones
                          _buildObservacionesSection(),
                        ],
                      ),
                    ),
                  ),
                  _buildFooter(),
                ],
              ),
            ),
    );
  }

  Widget _buildClienteSection() {
    return Card(
      elevation: DesignTokens.elevationSm,
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cliente',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeLg,
                fontWeight: DesignTokens.fontWeightBold,
                color: DesignTokens.textPrimaryColor,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingSm),
            DropdownButtonFormField<Cliente>(
              initialValue: _clienteSeleccionado,
              decoration: InputDecoration(
                hintText: 'Seleccionar cliente',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingSm,
                  vertical: DesignTokens.spacingSm,
                ),
              ),
              items: _clientes.map((cliente) {
                return DropdownMenuItem<Cliente>(
                  value: cliente,
                  child: Text(
                    cliente.nombre,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (Cliente? cliente) {
                setState(() {
                  _clienteSeleccionado = cliente;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Seleccione un cliente';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetodoPagoSection() {
    return Card(
      elevation: DesignTokens.elevationSm,
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Método de Pago',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeLg,
                fontWeight: DesignTokens.fontWeightBold,
                color: DesignTokens.textPrimaryColor,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingSm),
            DropdownButtonFormField<String>(
              initialValue: _metodoPago,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingSm,
                  vertical: DesignTokens.spacingSm,
                ),
              ),
              items: _metodosPago.map((metodo) {
                return DropdownMenuItem<String>(
                  value: metodo,
                  child: Text(metodo),
                );
              }).toList(),
              onChanged: (String? metodo) {
                setState(() {
                  _metodoPago = metodo!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductosSection() {
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
                  onPressed: () => _mostrarModalProductos(),
                  icon: const Icon(Icons.add),
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
          ],
        ),
      ),
    );
  }

  Widget _buildListaProductos() {
    if (_detalles.isEmpty) {
      return Card(
        elevation: DesignTokens.elevationSm,
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingLg),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 48,
                  color: DesignTokens.textSecondaryColor,
                ),
                const SizedBox(height: DesignTokens.spacingSm),
                Text(
                  'No hay productos agregados',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeMd,
                    color: DesignTokens.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: DesignTokens.elevationSm,
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Productos Agregados',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeLg,
                fontWeight: DesignTokens.fontWeightBold,
                color: DesignTokens.textPrimaryColor,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingSm),
            ..._detalles.asMap().entries.map((entry) {
              final index = entry.key;
              final detalle = entry.value;
              final producto = _detalleProductos.firstWhere(
                (p) => p.detalleProductoId == detalle.detalleProductoId,
                orElse: () => DetalleProducto(
                  detalleProductoId: 0,
                  producto: 'Producto no encontrado',
                  marca: '',
                  categoria: '',
                  codigoBarra: '',
                  precio: 0,
                  costo: 0,
                  stock: 0,
                  fechaCreacion: DateTime.now(),
                ),
              );
              return _buildProductItem(producto, detalle, index);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem(DetalleProducto producto, CrearVentaDetalleRequest detalle, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingSm),
      padding: const EdgeInsets.all(DesignTokens.spacingSm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producto.producto,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeMd,
                    fontWeight: DesignTokens.fontWeightMedium,
                    color: DesignTokens.textPrimaryColor,
                  ),
                ),
                Text(
                  'Marca: ${producto.marca}',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeSm,
                    color: DesignTokens.textSecondaryColor,
                  ),
                ),
                Text(
                  'Precio: \$${_formatCurrency(detalle.precioUnitario)}',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeSm,
                    color: DesignTokens.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => _actualizarCantidad(index, detalle.cantidad - 1),
                icon: const Icon(Icons.remove),
                iconSize: 20,
              ),
              Container(
                width: 50,
                height: 30,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                ),
                child: Center(
                  child: Text(
                    '${detalle.cantidad}',
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeMd,
                      fontWeight: DesignTokens.fontWeightMedium,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _actualizarCantidad(index, detalle.cantidad + 1),
                icon: const Icon(Icons.add),
                iconSize: 20,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _detalles.removeAt(index);
                  });
                },
                icon: const Icon(Icons.delete),
                iconSize: 20,
                color: DesignTokens.errorColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildObservacionesSection() {
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
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Observaciones (opcional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.all(DesignTokens.spacingSm),
              ),
            ),
          ],
        ),
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
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                  fontSize: DesignTokens.fontSizeXl,
                  fontWeight: DesignTokens.fontWeightBold,
                  color: DesignTokens.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _guardarVenta,
              style: ElevatedButton.styleFrom(
                backgroundColor: DesignTokens.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Guardar Venta',
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
        onAgregar: (producto, cantidad, precio) {
          _agregarDetalle(producto, cantidad, precio);
        },
      ),
    );
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0);
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: DesignTokens.errorColor,
      ),
    );
  }

  void _mostrarExito(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: DesignTokens.successColor,
      ),
    );
  }
}

class _ProductoModal extends StatefulWidget {
  final List<DetalleProducto> productos;
  final Function(DetalleProducto, int, double) onAgregar;

  const _ProductoModal({
    required this.productos,
    required this.onAgregar,
  });

  @override
  State<_ProductoModal> createState() => _ProductoModalState();
}

class _ProductoModalState extends State<_ProductoModal> {
  DetalleProducto? _productoSeleccionado;
  final _cantidadController = TextEditingController(text: '1');
  final _precioController = TextEditingController();

  @override
  void dispose() {
    _cantidadController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  double get _subtotal {
    final cantidad = int.tryParse(_cantidadController.text) ?? 0;
    final precio = double.tryParse(_precioController.text) ?? 0;
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
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
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

              // Selección de Producto
              Text(
                'Producto',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeMd,
                  fontWeight: DesignTokens.fontWeightMedium,
                  color: DesignTokens.textPrimaryColor,
                ),
              ),
              const SizedBox(height: DesignTokens.spacingXs),
              DropdownButtonFormField<DetalleProducto>(
                initialValue: _productoSeleccionado,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingSm,
                    vertical: DesignTokens.spacingSm,
                  ),
                ),
                hint: const Text('Seleccionar producto'),
                items: widget.productos.map((producto) {
                  return DropdownMenuItem<DetalleProducto>(
                    value: producto,
                    child: Text(
                      '${producto.producto} - ${producto.marca}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (DetalleProducto? producto) {
                  setState(() {
                    _productoSeleccionado = producto;
                    if (producto != null) {
                      _precioController.text = producto.precio.toString();
                    }
                  });
                },
              ),

              const SizedBox(height: DesignTokens.spacingMd),

              // Cantidad
              Text(
                'Cantidad',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeMd,
                  fontWeight: DesignTokens.fontWeightMedium,
                  color: DesignTokens.textPrimaryColor,
                ),
              ),
              const SizedBox(height: DesignTokens.spacingXs),
              TextFormField(
                controller: _cantidadController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingSm,
                    vertical: DesignTokens.spacingSm,
                  ),
                ),
                onChanged: (value) => setState(() {}),
              ),

              const SizedBox(height: DesignTokens.spacingMd),

              // Precio Unitario
              Text(
                'Precio Unitario',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeMd,
                  fontWeight: DesignTokens.fontWeightMedium,
                  color: DesignTokens.textPrimaryColor,
                ),
              ),
              const SizedBox(height: DesignTokens.spacingXs),
              TextFormField(
                controller: _precioController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingSm,
                    vertical: DesignTokens.spacingSm,
                  ),
                ),
                onChanged: (value) => setState(() {}),
              ),

              const SizedBox(height: DesignTokens.spacingMd),

              // Subtotal
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacingSm),
                decoration: BoxDecoration(
                  color: DesignTokens.backgroundColor,
                  borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subtotal:',
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeMd,
                        fontWeight: DesignTokens.fontWeightBold,
                        color: DesignTokens.textPrimaryColor,
                      ),
                    ),
                    Text(
                      '\$${_subtotal.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeLg,
                        fontWeight: DesignTokens.fontWeightBold,
                        color: DesignTokens.primaryColor,
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
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spacingSm),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _productoSeleccionado == null ? null : _agregarProducto,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DesignTokens.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Agregar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _agregarProducto() {
    if (_productoSeleccionado == null) return;

    final cantidad = int.tryParse(_cantidadController.text) ?? 1;
    final precio = double.tryParse(_precioController.text) ?? 0.0;

    if (cantidad <= 0 || precio <= 0) return;

    widget.onAgregar(_productoSeleccionado!, cantidad, precio);
    Navigator.pop(context);
  }
}