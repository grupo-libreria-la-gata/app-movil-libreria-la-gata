import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design/design_tokens.dart';

/// Entidad que representa un cliente
class Customer {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? address;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int totalPurchases;
  final double totalSpent;

  const Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.address,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
    this.totalPurchases = 0,
    this.totalSpent = 0.0,
  });

  Customer copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? totalPurchases,
    double? totalSpent,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      totalPurchases: totalPurchases ?? this.totalPurchases,
      totalSpent: totalSpent ?? this.totalSpent,
    );
  }
}

/// Página de gestión de clientes
class CustomersPage extends ConsumerStatefulWidget {
  const CustomersPage({super.key});

  @override
  ConsumerState<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends ConsumerState<CustomersPage> {
  String _searchQuery = '';
  bool _showOnlyActive = true;
  String _sortBy = 'name'; // name, email, totalSpent, lastPurchase

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.backgroundColor,
      appBar: AppBar(
        backgroundColor: DesignTokens.primaryColor,
        elevation: 0,
        title: const Text(
          'Gestión de Clientes',
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
          if (_searchQuery.isNotEmpty || !_showOnlyActive)
            _buildActiveFilters(),

          // Lista de clientes
          Expanded(child: _buildCustomersList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditCustomerDialog(),
        backgroundColor: DesignTokens.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
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
          hintText: 'Buscar clientes por nombre, email...',
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
          if (_searchQuery.isNotEmpty)
            Chip(
              label: Text('Búsqueda: $_searchQuery'),
              onDeleted: () {
                setState(() {
                  _searchQuery = '';
                });
              },
              backgroundColor: DesignTokens.primaryColor.withValues(alpha: 0.1),
            ),
          if (!_showOnlyActive)
            Chip(
              label: const Text('Incluir inactivos'),
              onDeleted: () {
                setState(() {
                  _showOnlyActive = true;
                });
              },
              backgroundColor: DesignTokens.warningColor.withValues(alpha: 0.1),
            ),
        ],
      ),
    );
  }

  Widget _buildCustomersList() {
    final customers = _getFilteredCustomers();

    if (customers.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      itemCount: customers.length,
      itemBuilder: (context, index) {
        final customer = customers[index];
        return _buildCustomerCard(customer);
      },
    );
  }

  Widget _buildCustomerCard(Customer customer) {
    return Card(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingMd),
      elevation: DesignTokens.elevationSm,
      child: InkWell(
        onTap: () => _showCustomerDetail(customer),
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con nombre y estado
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: DesignTokens.primaryColor,
                    radius: 20,
                    child: Text(
                      customer.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spacingMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer.name,
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeLg,
                            fontWeight: DesignTokens.fontWeightBold,
                            color: DesignTokens.textPrimaryColor,
                          ),
                        ),
                        Text(
                          customer.email,
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeMd,
                            color: DesignTokens.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacingSm,
                      vertical: DesignTokens.spacingXs,
                    ),
                    decoration: BoxDecoration(
                      color: customer.isActive
                          ? DesignTokens.successColor.withValues(alpha: 0.1)
                          : DesignTokens.errorColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        DesignTokens.borderRadiusSm,
                      ),
                      border: Border.all(
                        color: customer.isActive
                            ? DesignTokens.successColor.withValues(alpha: 0.3)
                            : DesignTokens.errorColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      customer.isActive ? 'Activo' : 'Inactivo',
                      style: TextStyle(
                        color: customer.isActive
                            ? DesignTokens.successColor
                            : DesignTokens.errorColor,
                        fontSize: DesignTokens.fontSizeSm,
                        fontWeight: DesignTokens.fontWeightMedium,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: DesignTokens.spacingMd),

              // Información de contacto
              Row(
                children: [
                  Icon(
                    Icons.phone,
                    size: 16,
                    color: DesignTokens.textSecondaryColor,
                  ),
                  const SizedBox(width: DesignTokens.spacingXs),
                  Text(
                    customer.phone,
                    style: TextStyle(
                      color: DesignTokens.textSecondaryColor,
                      fontSize: DesignTokens.fontSizeMd,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: DesignTokens.spacingSm),

              // Estadísticas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatItem(
                    'Compras',
                    '${customer.totalPurchases}',
                    Icons.shopping_cart,
                  ),
                  _buildStatItem(
                    'Total Gastado',
                    '₡${_formatCurrency(customer.totalSpent)}',
                    Icons.attach_money,
                  ),
                  _buildStatItem(
                    'Registrado',
                    _formatDate(customer.createdAt),
                    Icons.calendar_today,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 16, color: DesignTokens.textSecondaryColor),
        const SizedBox(height: DesignTokens.spacingXs),
        Text(
          value,
          style: TextStyle(
            fontSize: DesignTokens.fontSizeSm,
            fontWeight: DesignTokens.fontWeightMedium,
            color: DesignTokens.textPrimaryColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: DesignTokens.fontSizeXs,
            color: DesignTokens.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people, size: 64, color: DesignTokens.textSecondaryColor),
          const SizedBox(height: DesignTokens.spacingMd),
          Text(
            'No se encontraron clientes',
            style: TextStyle(
              fontSize: DesignTokens.fontSizeLg,
              fontWeight: DesignTokens.fontWeightMedium,
              color: DesignTokens.textSecondaryColor,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          Text(
            'Intenta ajustar los filtros o agregar un nuevo cliente',
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
        title: const Text('Filtrar Clientes'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Filtro por estado
            SwitchListTile(
              title: const Text('Solo clientes activos'),
              value: _showOnlyActive,
              onChanged: (value) {
                setState(() {
                  _showOnlyActive = value;
                });
              },
            ),

            const SizedBox(height: DesignTokens.spacingMd),

            // Ordenamiento
            DropdownButtonFormField<String>(
              initialValue: _sortBy,
              decoration: const InputDecoration(
                labelText: 'Ordenar por',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'name', child: Text('Nombre')),
                DropdownMenuItem(value: 'email', child: Text('Email')),
                DropdownMenuItem(
                  value: 'totalSpent',
                  child: Text('Total gastado'),
                ),
                DropdownMenuItem(
                  value: 'lastPurchase',
                  child: Text('Última compra'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _sortBy = value!;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _showOnlyActive = true;
                _sortBy = 'name';
              });
              Navigator.of(context).pop();
            },
            child: const Text('Restablecer'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );
  }

  void _showAddEditCustomerDialog([Customer? customer]) {
    final isEditing = customer != null;
    final nameController = TextEditingController(text: customer?.name ?? '');
    final emailController = TextEditingController(text: customer?.email ?? '');
    final phoneController = TextEditingController(text: customer?.phone ?? '');
    final addressController = TextEditingController(
      text: customer?.address ?? '',
    );
    bool isActive = customer?.isActive ?? true;

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Editar Cliente' : 'Agregar Cliente'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre completo',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El nombre es requerido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: DesignTokens.spacingMd),

                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El email es requerido';
                    }
                    if (!value.contains('@')) {
                      return 'Ingrese un email válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: DesignTokens.spacingMd),

                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El teléfono es requerido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: DesignTokens.spacingMd),

                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Dirección (opcional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: DesignTokens.spacingMd),

                if (isEditing)
                  SwitchListTile(
                    title: const Text('Cliente activo'),
                    value: isActive,
                    onChanged: (value) {
                      isActive = value;
                    },
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                // Aquí se guardaría en la API
                Customer(
                  id:
                      customer?.id ??
                      DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                  address: addressController.text.isNotEmpty
                      ? addressController.text
                      : null,
                  isActive: isActive,
                  createdAt: customer?.createdAt ?? DateTime.now(),
                  updatedAt: DateTime.now(),
                  totalPurchases: customer?.totalPurchases ?? 0,
                  totalSpent: customer?.totalSpent ?? 0.0,
                );

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isEditing ? 'Cliente actualizado' : 'Cliente agregado',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: Text(isEditing ? 'Actualizar' : 'Agregar'),
          ),
        ],
      ),
    );
  }

  void _showCustomerDetail(Customer customer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detalle de ${customer.name}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Email', customer.email, Icons.email),
              _buildDetailRow('Teléfono', customer.phone, Icons.phone),
              if (customer.address != null)
                _buildDetailRow(
                  'Dirección',
                  customer.address!,
                  Icons.location_on,
                ),
              _buildDetailRow(
                'Estado',
                customer.isActive ? 'Activo' : 'Inactivo',
                Icons.circle,
              ),
              _buildDetailRow(
                'Compras totales',
                '${customer.totalPurchases}',
                Icons.shopping_cart,
              ),
              _buildDetailRow(
                'Total gastado',
                '₡${_formatCurrency(customer.totalSpent)}',
                Icons.attach_money,
              ),
              _buildDetailRow(
                'Registrado',
                _formatDate(customer.createdAt),
                Icons.calendar_today,
              ),
              if (customer.updatedAt != null)
                _buildDetailRow(
                  'Actualizado',
                  _formatDate(customer.updatedAt!),
                  Icons.update,
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showAddEditCustomerDialog(customer);
            },
            child: const Text('Editar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacingMd),
      child: Row(
        children: [
          Icon(icon, size: 20, color: DesignTokens.textSecondaryColor),
          const SizedBox(width: DesignTokens.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeSm,
                    color: DesignTokens.textSecondaryColor,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeMd,
                    fontWeight: DesignTokens.fontWeightMedium,
                    color: DesignTokens.textPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Datos mock para los clientes
  List<Customer> _getMockCustomers() {
    return [
      Customer(
        id: '1',
        name: 'María González',
        email: 'maria.gonzalez@email.com',
        phone: '+505 8888 1111',
        address: 'Managua, Nicaragua',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        totalPurchases: 25,
        totalSpent: 125000.0,
      ),
      Customer(
        id: '2',
        name: 'Carlos Rodríguez',
        email: 'carlos.rodriguez@email.com',
        phone: '+505 8888 2222',
        address: 'León, Nicaragua',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 180)),
        totalPurchases: 15,
        totalSpent: 75000.0,
      ),
      Customer(
        id: '3',
        name: 'Ana Martínez',
        email: 'ana.martinez@email.com',
        phone: '+505 8888 3333',
        isActive: false,
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        totalPurchases: 5,
        totalSpent: 25000.0,
      ),
      Customer(
        id: '4',
        name: 'Luis Pérez',
        email: 'luis.perez@email.com',
        phone: '+505 8888 4444',
        address: 'Granada, Nicaragua',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        totalPurchases: 8,
        totalSpent: 40000.0,
      ),
    ];
  }

  List<Customer> _getFilteredCustomers() {
    List<Customer> customers = _getMockCustomers();

    // Filtro por búsqueda
    if (_searchQuery.isNotEmpty) {
      customers = customers
          .where(
            (customer) =>
                customer.name.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                customer.email.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                customer.phone.contains(_searchQuery),
          )
          .toList();
    }

    // Filtro por estado
    if (_showOnlyActive) {
      customers = customers.where((customer) => customer.isActive).toList();
    }

    // Ordenamiento
    switch (_sortBy) {
      case 'name':
        customers.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'email':
        customers.sort((a, b) => a.email.compareTo(b.email));
        break;
      case 'totalSpent':
        customers.sort((a, b) => b.totalSpent.compareTo(a.totalSpent));
        break;
      case 'lastPurchase':
        customers.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }

    return customers;
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
