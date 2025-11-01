import 'package:flutter/material.dart';
import '../../core/design/design_tokens.dart';

/// Widget para filtros avanzados
class AdvancedFiltersWidget extends StatefulWidget {
  final Map<String, dynamic> filters;
  final Function(Map<String, dynamic>) onFiltersChanged;
  final VoidCallback? onClearFilters;

  const AdvancedFiltersWidget({
    super.key,
    required this.filters,
    required this.onFiltersChanged,
    this.onClearFilters,
  });

  @override
  State<AdvancedFiltersWidget> createState() => _AdvancedFiltersWidgetState();
}

class _AdvancedFiltersWidgetState extends State<AdvancedFiltersWidget> {
  late TextEditingController _minPriceController;
  late TextEditingController _maxPriceController;
  late TextEditingController _minStockController;
  late TextEditingController _maxStockController;
  late TextEditingController _barcodeController;
  
  DateTime? _startDate;
  DateTime? _endDate;
  bool _showAdvancedFilters = false;

  @override
  void initState() {
    super.initState();
    _minPriceController = TextEditingController(text: widget.filters['minPrice']?.toString() ?? '');
    _maxPriceController = TextEditingController(text: widget.filters['maxPrice']?.toString() ?? '');
    _minStockController = TextEditingController(text: widget.filters['minStock']?.toString() ?? '');
    _maxStockController = TextEditingController(text: widget.filters['maxStock']?.toString() ?? '');
    _barcodeController = TextEditingController(text: widget.filters['barcode'] ?? '');
    _startDate = widget.filters['startDate'];
    _endDate = widget.filters['endDate'];
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _minStockController.dispose();
    _maxStockController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Botón para mostrar/ocultar filtros avanzados
        _buildToggleButton(),
        
        // Filtros avanzados
        if (_showAdvancedFilters) ...[
          const SizedBox(height: DesignTokens.spacingMd),
          _buildAdvancedFilters(),
        ],
      ],
    );
  }

  /// Construye el botón para mostrar/ocultar filtros
  Widget _buildToggleButton() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _showAdvancedFilters = !_showAdvancedFilters;
              });
            },
            icon: Icon(
              _showAdvancedFilters ? Icons.expand_less : Icons.expand_more,
              size: 20,
            ),
            label: Text(
              _showAdvancedFilters ? 'Ocultar filtros avanzados' : 'Mostrar filtros avanzados',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeSm,
                color: DesignTokens.textSecondaryColor,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: DesignTokens.dividerColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
              ),
            ),
          ),
        ),
        if (_hasActiveFilters()) ...[
          const SizedBox(width: DesignTokens.spacingSm),
          IconButton(
            onPressed: _clearFilters,
            icon: const Icon(Icons.clear, size: 20),
            tooltip: 'Limpiar filtros',
            style: IconButton.styleFrom(
              backgroundColor: DesignTokens.errorColor.withValues(alpha: 0.1),
              foregroundColor: DesignTokens.errorColor,
            ),
          ),
        ],
      ],
    );
  }

  /// Construye los filtros avanzados
  Widget _buildAdvancedFilters() {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: DesignTokens.surfaceColor,
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
        border: Border.all(color: DesignTokens.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filtros Avanzados',
            style: TextStyle(
              fontSize: DesignTokens.fontSizeMd,
              fontWeight: DesignTokens.fontWeightBold,
              color: DesignTokens.textPrimaryColor,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          
          // Filtros de precio
          _buildPriceFilters(),
          const SizedBox(height: DesignTokens.spacingMd),
          
          // Filtros de stock
          _buildStockFilters(),
          const SizedBox(height: DesignTokens.spacingMd),
          
          // Filtros de fecha
          _buildDateFilters(),
          const SizedBox(height: DesignTokens.spacingMd),
          
          // Búsqueda por código de barras
          _buildBarcodeFilter(),
          const SizedBox(height: DesignTokens.spacingMd),
          
          // Botones de acción
          _buildActionButtons(),
        ],
      ),
    );
  }

  /// Construye los filtros de precio
  Widget _buildPriceFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rango de Precio',
          style: TextStyle(
            fontSize: DesignTokens.fontSizeSm,
            fontWeight: DesignTokens.fontWeightMedium,
            color: DesignTokens.textSecondaryColor,
          ),
        ),
        const SizedBox(height: DesignTokens.spacingSm),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _minPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Precio mínimo',
                  hintText: '₡0',
                  prefixText: '₡',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingSm,
                    vertical: DesignTokens.spacingXs,
                  ),
                ),
                onChanged: (value) => _updateFilters(),
              ),
            ),
            const SizedBox(width: DesignTokens.spacingSm),
            Expanded(
              child: TextFormField(
                controller: _maxPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Precio máximo',
                  hintText: '₡100000',
                  prefixText: '₡',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingSm,
                    vertical: DesignTokens.spacingXs,
                  ),
                ),
                onChanged: (value) => _updateFilters(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Construye los filtros de stock
  Widget _buildStockFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rango de Stock',
          style: TextStyle(
            fontSize: DesignTokens.fontSizeSm,
            fontWeight: DesignTokens.fontWeightMedium,
            color: DesignTokens.textSecondaryColor,
          ),
        ),
        const SizedBox(height: DesignTokens.spacingSm),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _minStockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Stock mínimo',
                  hintText: '0',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingSm,
                    vertical: DesignTokens.spacingXs,
                  ),
                ),
                onChanged: (value) => _updateFilters(),
              ),
            ),
            const SizedBox(width: DesignTokens.spacingSm),
            Expanded(
              child: TextFormField(
                controller: _maxStockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Stock máximo',
                  hintText: '100',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingSm,
                    vertical: DesignTokens.spacingXs,
                  ),
                ),
                onChanged: (value) => _updateFilters(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Construye los filtros de fecha
  Widget _buildDateFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rango de Fecha',
          style: TextStyle(
            fontSize: DesignTokens.fontSizeSm,
            fontWeight: DesignTokens.fontWeightMedium,
            color: DesignTokens.textSecondaryColor,
          ),
        ),
        const SizedBox(height: DesignTokens.spacingSm),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _selectDate(true),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingSm,
                    vertical: DesignTokens.spacingSm,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: DesignTokens.dividerColor),
                    borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: DesignTokens.textSecondaryColor,
                      ),
                      const SizedBox(width: DesignTokens.spacingXs),
                      Expanded(
                        child: Text(
                          _startDate != null
                              ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                              : 'Fecha inicio',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeSm,
                            color: _startDate != null
                                ? DesignTokens.textPrimaryColor
                                : DesignTokens.textSecondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: DesignTokens.spacingSm),
            Expanded(
              child: InkWell(
                onTap: () => _selectDate(false),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingSm,
                    vertical: DesignTokens.spacingSm,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: DesignTokens.dividerColor),
                    borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: DesignTokens.textSecondaryColor,
                      ),
                      const SizedBox(width: DesignTokens.spacingXs),
                      Expanded(
                        child: Text(
                          _endDate != null
                              ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                              : 'Fecha fin',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeSm,
                            color: _endDate != null
                                ? DesignTokens.textPrimaryColor
                                : DesignTokens.textSecondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Construye el filtro de código de barras
  Widget _buildBarcodeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Código de Barras',
          style: TextStyle(
            fontSize: DesignTokens.fontSizeSm,
            fontWeight: DesignTokens.fontWeightMedium,
            color: DesignTokens.textSecondaryColor,
          ),
        ),
        const SizedBox(height: DesignTokens.spacingSm),
        TextFormField(
          controller: _barcodeController,
          decoration: InputDecoration(
            labelText: 'Buscar por código de barras',
            hintText: '1234567890123',
            prefixIcon: const Icon(Icons.qr_code),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingSm,
              vertical: DesignTokens.spacingSm,
            ),
          ),
          onChanged: (value) => _updateFilters(),
        ),
      ],
    );
  }

  /// Construye los botones de acción
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _clearFilters,
            child: const Text('Limpiar'),
          ),
        ),
        const SizedBox(width: DesignTokens.spacingSm),
        Expanded(
          child: ElevatedButton(
            onPressed: _applyFilters,
            style: ElevatedButton.styleFrom(
              backgroundColor: DesignTokens.primaryColor,
              foregroundColor: DesignTokens.textInverseColor,
            ),
            child: const Text('Aplicar'),
          ),
        ),
      ],
    );
  }

  /// Selecciona una fecha
  Future<void> _selectDate(bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
      _updateFilters();
    }
  }

  /// Actualiza los filtros
  void _updateFilters() {
    final filters = <String, dynamic>{};
    
    // Precio
    if (_minPriceController.text.isNotEmpty) {
      filters['minPrice'] = double.tryParse(_minPriceController.text);
    }
    if (_maxPriceController.text.isNotEmpty) {
      filters['maxPrice'] = double.tryParse(_maxPriceController.text);
    }
    
    // Stock
    if (_minStockController.text.isNotEmpty) {
      filters['minStock'] = int.tryParse(_minStockController.text);
    }
    if (_maxStockController.text.isNotEmpty) {
      filters['maxStock'] = int.tryParse(_maxStockController.text);
    }
    
    // Fechas
    if (_startDate != null) {
      filters['startDate'] = _startDate;
    }
    if (_endDate != null) {
      filters['endDate'] = _endDate;
    }
    
    // Código de barras
    if (_barcodeController.text.isNotEmpty) {
      filters['barcode'] = _barcodeController.text;
    }
    
    widget.onFiltersChanged(filters);
  }

  /// Aplica los filtros
  void _applyFilters() {
    _updateFilters();
    setState(() {
      _showAdvancedFilters = false;
    });
  }

  /// Limpia todos los filtros
  void _clearFilters() {
    setState(() {
      _minPriceController.clear();
      _maxPriceController.clear();
      _minStockController.clear();
      _maxStockController.clear();
      _barcodeController.clear();
      _startDate = null;
      _endDate = null;
    });
    
    widget.onFiltersChanged({});
    widget.onClearFilters?.call();
  }

  /// Verifica si hay filtros activos
  bool _hasActiveFilters() {
    return _minPriceController.text.isNotEmpty ||
           _maxPriceController.text.isNotEmpty ||
           _minStockController.text.isNotEmpty ||
           _maxStockController.text.isNotEmpty ||
           _barcodeController.text.isNotEmpty ||
           _startDate != null ||
           _endDate != null;
  }
}
