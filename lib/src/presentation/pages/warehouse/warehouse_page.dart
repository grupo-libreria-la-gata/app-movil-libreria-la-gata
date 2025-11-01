import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/design_tokens.dart';
import '../../../data/services/marca_service.dart';
import '../../../data/services/categoria_service.dart';
import '../../../data/services/producto_service.dart';
import '../../../data/services/detalle_producto_service.dart';
import '../../../data/models/marca_model.dart';
import '../../../data/models/categoria_model.dart';
import '../../../data/models/producto_model.dart';
import '../../widgets/app_header.dart';
import '../../providers/auth_provider.dart';

/// Página de Almacén para crear nuevos DetalleProducto
class WarehousePage extends ConsumerStatefulWidget {
  const WarehousePage({super.key});

  @override
  ConsumerState<WarehousePage> createState() => _WarehousePageState();
}

class _WarehousePageState extends ConsumerState<WarehousePage> {
  final _formKey = GlobalKey<FormState>();
  
  // Servicios
  final _marcaService = MarcaService();
  final _categoriaService = CategoriaService();
  final _productoService = ProductoService();
  final _detalleProductoService = DetalleProductoService();
  
  // Dropdowns
  List<Marca> _marcas = [];
  List<Categoria> _categorias = [];
  List<Producto> _productos = [];
  
  // Valores seleccionados
  Marca? _marcaSeleccionada;
  Categoria? _categoriaSeleccionada;
  Producto? _productoSeleccionado;
  
  // Controladores
  final _codigoBarraController = TextEditingController();
  final _costoController = TextEditingController();
  final _precioController = TextEditingController();
  final _stockController = TextEditingController();
  
  bool _isLoading = false;
  bool _isLoadingDropdowns = true;
  
  @override
  void initState() {
    super.initState();
    _cargarDropdowns();
  }
  
  @override
  void dispose() {
    _codigoBarraController.dispose();
    _costoController.dispose();
    _precioController.dispose();
    _stockController.dispose();
    super.dispose();
  }
  
  Future<void> _cargarDropdowns() async {
    setState(() => _isLoadingDropdowns = true);
    try {
      final resultados = await Future.wait([
        _marcaService.obtenerActivos(),
        _categoriaService.obtenerActivos(),
        _productoService.obtenerActivos(),
      ]);
      
      setState(() {
        _marcas = resultados[0] as List<Marca>;
        _categorias = resultados[1] as List<Categoria>;
        _productos = resultados[2] as List<Producto>;
        _isLoadingDropdowns = false;
      });
    } catch (e) {
      setState(() => _isLoadingDropdowns = false);
      _mostrarError('Error al cargar datos: ${e.toString()}');
    }
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
  
  Future<void> _guardarProducto() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_marcaSeleccionada == null) {
      _mostrarError('Seleccione una marca');
      return;
    }
    
    if (_categoriaSeleccionada == null) {
      _mostrarError('Seleccione una categoría');
      return;
    }
    
    if (_productoSeleccionado == null) {
      _mostrarError('Seleccione un producto');
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      // Obtener el usuario actual
      final authState = ref.read(authProvider);
      final usuarioId = int.tryParse(authState.user?.id ?? '1') ?? 1;
      
      // Validar que el precio sea mayor al costo
      final costo = double.parse(_costoController.text);
      final precio = double.parse(_precioController.text);
      
      if (precio <= costo) {
        _mostrarError('El precio de venta debe ser mayor al costo');
        setState(() => _isLoading = false);
        return;
      }
      
      // Crear el DetalleProducto
      await _detalleProductoService.crearDetalleProducto(
        productoId: _productoSeleccionado!.productoId,
        categoriaId: _categoriaSeleccionada!.categoriaId,
        marcaId: _marcaSeleccionada!.marcaId,
        codigoBarra: _codigoBarraController.text.trim().isEmpty 
            ? null 
            : _codigoBarraController.text.trim(),
        costo: costo,
        precio: precio,
        stock: int.parse(_stockController.text),
        usuarioId: usuarioId,
      );
      
      _mostrarExito('Producto creado exitosamente en el almacén');
      
      // Limpiar formulario
      _formKey.currentState!.reset();
      setState(() {
        _marcaSeleccionada = null;
        _categoriaSeleccionada = null;
        _productoSeleccionado = null;
        _codigoBarraController.clear();
        _costoController.clear();
        _precioController.clear();
        _stockController.clear();
      });
    } catch (e) {
      _mostrarError('Error al guardar producto: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.backgroundColor,
      appBar: const AppHeader(
        showBackButton: true,
        title: 'Almacén',
      ),
      body: _isLoadingDropdowns
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(DesignTokens.spacingLg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título
                    Text(
                      'Crear Nuevo Producto en Almacén',
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeXl,
                        fontWeight: DesignTokens.fontWeightBold,
                        color: DesignTokens.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacingMd),
                    Text(
                      'Complete todos los campos para registrar un nuevo producto en el inventario.',
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeMd,
                        color: DesignTokens.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacingXl),
                    
                    // Dropdown de Producto
                    DropdownButtonFormField<Producto>(
                      value: _productoSeleccionado,
                      decoration: InputDecoration(
                        labelText: 'Producto *',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                        ),
                        filled: true,
                        fillColor: DesignTokens.surfaceColor,
                      ),
                      items: _productos.map((producto) {
                        return DropdownMenuItem<Producto>(
                          value: producto,
                          child: Text(producto.nombre),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _productoSeleccionado = value);
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Seleccione un producto';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: DesignTokens.spacingLg),
                    
                    // Dropdown de Categoría
                    DropdownButtonFormField<Categoria>(
                      value: _categoriaSeleccionada,
                      decoration: InputDecoration(
                        labelText: 'Categoría *',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                        ),
                        filled: true,
                        fillColor: DesignTokens.surfaceColor,
                      ),
                      items: _categorias.map((categoria) {
                        return DropdownMenuItem<Categoria>(
                          value: categoria,
                          child: Text(categoria.nombre),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _categoriaSeleccionada = value);
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Seleccione una categoría';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: DesignTokens.spacingLg),
                    
                    // Dropdown de Marca
                    DropdownButtonFormField<Marca>(
                      value: _marcaSeleccionada,
                      decoration: InputDecoration(
                        labelText: 'Marca *',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                        ),
                        filled: true,
                        fillColor: DesignTokens.surfaceColor,
                      ),
                      items: _marcas.map((marca) {
                        return DropdownMenuItem<Marca>(
                          value: marca,
                          child: Text(marca.nombre),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _marcaSeleccionada = value);
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Seleccione una marca';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: DesignTokens.spacingLg),
                    
                    // Campo Código de Barras
                    TextFormField(
                      controller: _codigoBarraController,
                      decoration: InputDecoration(
                        labelText: 'Código de Barras',
                        hintText: 'Ingrese el código de barras (opcional)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                        ),
                        filled: true,
                        fillColor: DesignTokens.surfaceColor,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacingLg),
                    
                    // Campo Costo
                    TextFormField(
                      controller: _costoController,
                      decoration: InputDecoration(
                        labelText: 'Costo *',
                        hintText: '0.00',
                        prefixText: '₡',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                        ),
                        filled: true,
                        fillColor: DesignTokens.surfaceColor,
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese el costo';
                        }
                        final costo = double.tryParse(value);
                        if (costo == null || costo <= 0) {
                          return 'El costo debe ser mayor a cero';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: DesignTokens.spacingLg),
                    
                    // Campo Precio
                    TextFormField(
                      controller: _precioController,
                      decoration: InputDecoration(
                        labelText: 'Precio de Venta *',
                        hintText: '0.00',
                        prefixText: '₡',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                        ),
                        filled: true,
                        fillColor: DesignTokens.surfaceColor,
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese el precio de venta';
                        }
                        final precio = double.tryParse(value);
                        if (precio == null || precio <= 0) {
                          return 'El precio debe ser mayor a cero';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: DesignTokens.spacingLg),
                    
                    // Campo Stock
                    TextFormField(
                      controller: _stockController,
                      decoration: InputDecoration(
                        labelText: 'Stock Inicial *',
                        hintText: '0',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                        ),
                        filled: true,
                        fillColor: DesignTokens.surfaceColor,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese el stock inicial';
                        }
                        final stock = int.tryParse(value);
                        if (stock == null || stock < 0) {
                          return 'El stock debe ser un número positivo';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: DesignTokens.spacingXl),
                    
                    // Botón Guardar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _guardarProducto,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DesignTokens.primaryColor,
                          foregroundColor: DesignTokens.textInverseColor,
                          padding: const EdgeInsets.symmetric(
                            vertical: DesignTokens.spacingMd,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    DesignTokens.textInverseColor,
                                  ),
                                ),
                              )
                            : const Text(
                                'Guardar Producto',
                                style: TextStyle(
                                  fontSize: DesignTokens.fontSizeLg,
                                  fontWeight: DesignTokens.fontWeightBold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

