import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design/design_tokens.dart';
import '../../../domain/entities/sale.dart';

/// Página que muestra el historial de ventas
class SalesHistoryPage extends ConsumerStatefulWidget {
  const SalesHistoryPage({super.key});

  @override
  ConsumerState<SalesHistoryPage> createState() => _SalesHistoryPageState();
}

class _SalesHistoryPageState extends ConsumerState<SalesHistoryPage> {
  String _searchQuery = '';
  SaleStatus? _selectedStatus;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.backgroundColor,
      appBar: AppBar(
        backgroundColor: DesignTokens.primaryColor,
        elevation: 0,
        title: const Text(
          'Historial de Ventas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          _buildSearchBar(),
          
          // Filtros activos
          if (_selectedStatus != null || _selectedDate != null)
            _buildActiveFilters(),
          
          // Lista de ventas
          Expanded(
            child: _buildSalesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: DesignTokens.cardColor,
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
        boxShadow: DesignTokens.cardShadow,
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Buscar ventas por cliente, factura...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingMd,
            vertical: DesignTokens.spacingSm,
          ),
        ),
      ),
    );
  }

  Widget _buildActiveFilters() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingMd),
      child: Wrap(
        spacing: DesignTokens.spacingSm,
        children: [
          if (_selectedStatus != null)
            Chip(
              label: Text(_getStatusDisplayName(_selectedStatus!)),
              onDeleted: () {
                setState(() {
                  _selectedStatus = null;
                });
              },
              backgroundColor: DesignTokens.primaryColor.withValues(alpha: 0.1),
            ),
          if (_selectedDate != null)
            Chip(
              label: Text(_formatDate(_selectedDate!)),
              onDeleted: () {
                setState(() {
                  _selectedDate = null;
                });
              },
              backgroundColor: DesignTokens.accentColor.withValues(alpha: 0.1),
            ),
        ],
      ),
    );
  }

  Widget _buildSalesList() {
    final sales = _getFilteredSales();
    
    if (sales.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      itemCount: sales.length,
      itemBuilder: (context, index) {
        final sale = sales[index];
        return _buildSaleCard(sale);
      },
    );
  }

  Widget _buildSaleCard(Sale sale) {
    return Card(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingMd),
      elevation: DesignTokens.elevationSm,
      child: InkWell(
        onTap: () => context.push('/sales/${sale.id}'),
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con número de factura y estado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Factura #${sale.invoiceNumber}',
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeLg,
                      fontWeight: DesignTokens.fontWeightBold,
                      color: DesignTokens.textPrimaryColor,
                    ),
                  ),
                  _buildStatusChip(sale.status),
                ],
              ),
              
              const SizedBox(height: DesignTokens.spacingSm),
              
              // Información del cliente
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 16,
                    color: DesignTokens.textSecondaryColor,
                  ),
                  const SizedBox(width: DesignTokens.spacingXs),
                  Expanded(
                    child: Text(
                      sale.customerName,
                      style: TextStyle(
                        color: DesignTokens.textSecondaryColor,
                        fontSize: DesignTokens.fontSizeMd,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: DesignTokens.spacingSm),
              
              // Información de la venta
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${sale.items.length} productos',
                        style: TextStyle(
                          color: DesignTokens.textSecondaryColor,
                          fontSize: DesignTokens.fontSizeSm,
                        ),
                      ),
                      Text(
                        _formatDate(sale.createdAt),
                        style: TextStyle(
                          color: DesignTokens.textSecondaryColor,
                          fontSize: DesignTokens.fontSizeSm,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total: ₡${_formatCurrency(sale.total)}',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeLg,
                          fontWeight: DesignTokens.fontWeightBold,
                          color: DesignTokens.primaryColor,
                        ),
                      ),
                      Text(
                        'Vendedor: ${sale.sellerName}',
                        style: TextStyle(
                          color: DesignTokens.textSecondaryColor,
                          fontSize: DesignTokens.fontSizeSm,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(SaleStatus status) {
    Color color;
    String text;
    
    switch (status) {
      case SaleStatus.completed:
        color = DesignTokens.successColor;
        text = 'Completada';
        break;
      case SaleStatus.pending:
        color = DesignTokens.warningColor;
        text = 'Pendiente';
        break;
      case SaleStatus.cancelled:
        color = DesignTokens.errorColor;
        text = 'Cancelada';
        break;
      case SaleStatus.refunded:
        color = DesignTokens.infoColor;
        text = 'Reembolsada';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingSm,
        vertical: DesignTokens.spacingXs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: DesignTokens.fontSizeSm,
          fontWeight: DesignTokens.fontWeightMedium,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 64,
            color: DesignTokens.textSecondaryColor,
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          Text(
            'No se encontraron ventas',
            style: TextStyle(
              fontSize: DesignTokens.fontSizeLg,
              fontWeight: DesignTokens.fontWeightMedium,
              color: DesignTokens.textSecondaryColor,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          Text(
            'Intenta ajustar los filtros o crear una nueva venta',
            style: TextStyle(
              fontSize: DesignTokens.fontSizeMd,
              color: DesignTokens.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtrar Ventas'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Filtro por estado
            DropdownButtonFormField<SaleStatus?>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Estado',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('Todos los estados'),
                ),
                ...SaleStatus.values.map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(_getStatusDisplayName(status)),
                )),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value;
                });
              },
            ),
            
            const SizedBox(height: DesignTokens.spacingMd),
            
            // Filtro por fecha
            ListTile(
              title: const Text('Fecha específica'),
              subtitle: Text(_selectedDate != null 
                ? _formatDate(_selectedDate!) 
                : 'Seleccionar fecha'),
              trailing: _selectedDate != null
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _selectedDate = null;
                        });
                      },
                    )
                  : null,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _selectedDate = date;
                  });
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedStatus = null;
                _selectedDate = null;
              });
              Navigator.of(context).pop();
            },
            child: const Text('Limpiar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );
  }

  // Datos mock para las ventas
  List<Sale> _getMockSales() {
    return [
      Sale(
        id: '1',
        invoiceNumber: 'F001-2024',
        customerName: 'María González',
        items: [
          SaleItem(
            productId: '1',
            productName: 'Ron Flor de Caña 7 años',
            productBrand: 'Flor de Caña',
            quantity: 2,
            unitPrice: 8500,
            total: 17000,
          ),
        ],
        subtotal: 17000,
        tax: 1700,
        total: 18700,
        sellerId: '1',
        sellerName: 'Juan López',
        status: SaleStatus.completed,
        paymentMethod: PaymentMethod.cash,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Sale(
        id: '2',
        invoiceNumber: 'F002-2024',
        customerName: 'Carlos Rodríguez',
        items: [
          SaleItem(
            productId: '2',
            productName: 'Vodka Absolut',
            productBrand: 'Absolut',
            quantity: 1,
            unitPrice: 12000,
            total: 12000,
          ),
          SaleItem(
            productId: '3',
            productName: 'Whisky Jack Daniel\'s',
            productBrand: 'Jack Daniel\'s',
            quantity: 1,
            unitPrice: 15000,
            total: 15000,
          ),
        ],
        subtotal: 27000,
        tax: 2700,
        total: 29700,
        sellerId: '1',
        sellerName: 'Juan López',
        status: SaleStatus.completed,
        paymentMethod: PaymentMethod.card,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Sale(
        id: '3',
        invoiceNumber: 'F003-2024',
        customerName: 'Ana Martínez',
        items: [
          SaleItem(
            productId: '4',
            productName: 'Tequila José Cuervo',
            productBrand: 'José Cuervo',
            quantity: 1,
            unitPrice: 9500,
            total: 9500,
          ),
        ],
        subtotal: 9500,
        tax: 950,
        total: 10450,
        sellerId: '1',
        sellerName: 'Juan López',
        status: SaleStatus.pending,
        paymentMethod: PaymentMethod.cash,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
    ];
  }

  List<Sale> _getFilteredSales() {
    List<Sale> sales = _getMockSales();
    
    // Filtro por búsqueda
    if (_searchQuery.isNotEmpty) {
      sales = sales.where((sale) =>
        sale.customerName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        sale.invoiceNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        sale.sellerName.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    // Filtro por estado
    if (_selectedStatus != null) {
      sales = sales.where((sale) => sale.status == _selectedStatus).toList();
    }
    
    // Filtro por fecha
    if (_selectedDate != null) {
      sales = sales.where((sale) =>
        sale.createdAt.year == _selectedDate!.year &&
        sale.createdAt.month == _selectedDate!.month &&
        sale.createdAt.day == _selectedDate!.day
      ).toList();
    }
    
    return sales;
  }

  String _getStatusDisplayName(SaleStatus status) {
    switch (status) {
      case SaleStatus.completed:
        return 'Completada';
      case SaleStatus.pending:
        return 'Pendiente';
      case SaleStatus.cancelled:
        return 'Cancelada';
      case SaleStatus.refunded:
        return 'Reembolsada';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0);
  }
}
