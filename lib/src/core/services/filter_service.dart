/// Servicio para manejo de filtros y búsquedas avanzadas
class FilterService {
  static final FilterService _instance = FilterService._internal();
  factory FilterService() => _instance;
  FilterService._internal();

  /// Aplica filtros combinados a una lista de productos
  List<Map<String, dynamic>> applyProductFilters(
    List<Map<String, dynamic>> products,
    Map<String, dynamic> filters,
  ) {
    var filteredProducts = List<Map<String, dynamic>>.from(products);

    // Filtro por búsqueda de texto
    if (filters['search'] != null && filters['search'].toString().isNotEmpty) {
      final search = filters['search'].toString().toLowerCase();
      filteredProducts = filteredProducts.where((product) {
        return product['name'].toString().toLowerCase().contains(search) ||
               product['brand'].toString().toLowerCase().contains(search) ||
               product['description'].toString().toLowerCase().contains(search);
      }).toList();
    }

    // Filtro por categoría
    if (filters['category'] != null && filters['category'] != 'Todas') {
      filteredProducts = filteredProducts.where((product) {
        return product['category'] == filters['category'];
      }).toList();
    }

    // Filtro por precio mínimo
    if (filters['minPrice'] != null) {
      filteredProducts = filteredProducts.where((product) {
        final price = (product['price'] as num).toDouble();
        return price >= filters['minPrice'];
      }).toList();
    }

    // Filtro por precio máximo
    if (filters['maxPrice'] != null) {
      filteredProducts = filteredProducts.where((product) {
        final price = (product['price'] as num).toDouble();
        return price <= filters['maxPrice'];
      }).toList();
    }

    // Filtro por stock mínimo
    if (filters['minStock'] != null) {
      filteredProducts = filteredProducts.where((product) {
        final stock = (product['stock'] as num).toInt();
        return stock >= filters['minStock'];
      }).toList();
    }

    // Filtro por stock máximo
    if (filters['maxStock'] != null) {
      filteredProducts = filteredProducts.where((product) {
        final stock = (product['stock'] as num).toInt();
        return stock <= filters['maxStock'];
      }).toList();
    }

    // Filtro por código de barras
    if (filters['barcode'] != null && filters['barcode'].toString().isNotEmpty) {
      final barcode = filters['barcode'].toString().toLowerCase();
      filteredProducts = filteredProducts.where((product) {
        return product['barcode'].toString().toLowerCase().contains(barcode);
      }).toList();
    }

    // Filtro por fecha de creación
    if (filters['startDate'] != null) {
      filteredProducts = filteredProducts.where((product) {
        final createdAt = DateTime.parse(product['createdAt']);
        return createdAt.isAfter(filters['startDate']);
      }).toList();
    }

    if (filters['endDate'] != null) {
      filteredProducts = filteredProducts.where((product) {
        final createdAt = DateTime.parse(product['createdAt']);
        return createdAt.isBefore(filters['endDate']);
      }).toList();
    }

    // Filtro por estado activo/inactivo
    if (filters['isActive'] != null) {
      filteredProducts = filteredProducts.where((product) {
        return product['isActive'] == filters['isActive'];
      }).toList();
    }

    // Filtro por stock bajo
    if (filters['lowStock'] == true) {
      filteredProducts = filteredProducts.where((product) {
        final stock = (product['stock'] as num).toInt();
        final minStock = (product['minStock'] as num).toInt();
        return stock <= minStock;
      }).toList();
    }

    // Filtro por productos agotados
    if (filters['outOfStock'] == true) {
      filteredProducts = filteredProducts.where((product) {
        final stock = (product['stock'] as num).toInt();
        return stock == 0;
      }).toList();
    }

    return filteredProducts;
  }

  /// Aplica filtros combinados a una lista de ventas
  List<Map<String, dynamic>> applySaleFilters(
    List<Map<String, dynamic>> sales,
    Map<String, dynamic> filters,
  ) {
    var filteredSales = List<Map<String, dynamic>>.from(sales);

    // Filtro por búsqueda de texto
    if (filters['search'] != null && filters['search'].toString().isNotEmpty) {
      final search = filters['search'].toString().toLowerCase();
      filteredSales = filteredSales.where((sale) {
        return sale['customerName'].toString().toLowerCase().contains(search) ||
               sale['invoiceNumber'].toString().toLowerCase().contains(search) ||
               sale['sellerName'].toString().toLowerCase().contains(search);
      }).toList();
    }

    // Filtro por estado
    if (filters['status'] != null && filters['status'] != 'Todos') {
      filteredSales = filteredSales.where((sale) {
        return sale['status'] == filters['status'];
      }).toList();
    }

    // Filtro por método de pago
    if (filters['paymentMethod'] != null && filters['paymentMethod'] != 'Todos') {
      filteredSales = filteredSales.where((sale) {
        return sale['paymentMethod'] == filters['paymentMethod'];
      }).toList();
    }

    // Filtro por vendedor
    if (filters['sellerId'] != null) {
      filteredSales = filteredSales.where((sale) {
        return sale['sellerId'] == filters['sellerId'];
      }).toList();
    }

    // Filtro por cliente
    if (filters['customerId'] != null) {
      filteredSales = filteredSales.where((sale) {
        return sale['customerId'] == filters['customerId'];
      }).toList();
    }

    // Filtro por total mínimo
    if (filters['minTotal'] != null) {
      filteredSales = filteredSales.where((sale) {
        final total = (sale['total'] as num).toDouble();
        return total >= filters['minTotal'];
      }).toList();
    }

    // Filtro por total máximo
    if (filters['maxTotal'] != null) {
      filteredSales = filteredSales.where((sale) {
        final total = (sale['total'] as num).toDouble();
        return total <= filters['maxTotal'];
      }).toList();
    }

    // Filtro por fecha de venta
    if (filters['startDate'] != null) {
      filteredSales = filteredSales.where((sale) {
        final saleDate = DateTime.parse(sale['createdAt']);
        return saleDate.isAfter(filters['startDate']);
      }).toList();
    }

    if (filters['endDate'] != null) {
      filteredSales = filteredSales.where((sale) {
        final saleDate = DateTime.parse(sale['createdAt']);
        return saleDate.isBefore(filters['endDate']);
      }).toList();
    }

    return filteredSales;
  }

  /// Aplica filtros combinados a una lista de clientes
  List<Map<String, dynamic>> applyCustomerFilters(
    List<Map<String, dynamic>> customers,
    Map<String, dynamic> filters,
  ) {
    var filteredCustomers = List<Map<String, dynamic>>.from(customers);

    // Filtro por búsqueda de texto
    if (filters['search'] != null && filters['search'].toString().isNotEmpty) {
      final search = filters['search'].toString().toLowerCase();
      filteredCustomers = filteredCustomers.where((customer) {
        return customer['name'].toString().toLowerCase().contains(search) ||
               customer['email'].toString().toLowerCase().contains(search) ||
               customer['phone'].toString().toLowerCase().contains(search) ||
               customer['address'].toString().toLowerCase().contains(search);
      }).toList();
    }

    // Filtro por estado activo/inactivo
    if (filters['isActive'] != null) {
      filteredCustomers = filteredCustomers.where((customer) {
        return customer['isActive'] == filters['isActive'];
      }).toList();
    }

    // Filtro por total gastado mínimo
    if (filters['minTotalSpent'] != null) {
      filteredCustomers = filteredCustomers.where((customer) {
        final totalSpent = (customer['totalSpent'] as num).toDouble();
        return totalSpent >= filters['minTotalSpent'];
      }).toList();
    }

    // Filtro por total gastado máximo
    if (filters['maxTotalSpent'] != null) {
      filteredCustomers = filteredCustomers.where((customer) {
        final totalSpent = (customer['totalSpent'] as num).toDouble();
        return totalSpent <= filters['maxTotalSpent'];
      }).toList();
    }

    // Filtro por cantidad de compras mínima
    if (filters['minPurchaseCount'] != null) {
      filteredCustomers = filteredCustomers.where((customer) {
        final purchaseCount = (customer['purchaseCount'] as num).toInt();
        return purchaseCount >= filters['minPurchaseCount'];
      }).toList();
    }

    // Filtro por cantidad de compras máxima
    if (filters['maxPurchaseCount'] != null) {
      filteredCustomers = filteredCustomers.where((customer) {
        final purchaseCount = (customer['purchaseCount'] as num).toInt();
        return purchaseCount <= filters['maxPurchaseCount'];
      }).toList();
    }

    // Filtro por última compra
    if (filters['lastPurchaseStart'] != null) {
      filteredCustomers = filteredCustomers.where((customer) {
        final lastPurchase = DateTime.parse(customer['lastPurchase']);
        return lastPurchase.isAfter(filters['lastPurchaseStart']);
      }).toList();
    }

    if (filters['lastPurchaseEnd'] != null) {
      filteredCustomers = filteredCustomers.where((customer) {
        final lastPurchase = DateTime.parse(customer['lastPurchase']);
        return lastPurchase.isBefore(filters['lastPurchaseEnd']);
      }).toList();
    }

    return filteredCustomers;
  }

  /// Ordena una lista de productos
  List<Map<String, dynamic>> sortProducts(
    List<Map<String, dynamic>> products,
    String sortBy,
    bool ascending,
  ) {
    final sortedProducts = List<Map<String, dynamic>>.from(products);
    
    sortedProducts.sort((a, b) {
      int comparison = 0;
      
      switch (sortBy) {
        case 'name':
          comparison = a['name'].toString().compareTo(b['name'].toString());
          break;
        case 'brand':
          comparison = a['brand'].toString().compareTo(b['brand'].toString());
          break;
        case 'category':
          comparison = a['category'].toString().compareTo(b['category'].toString());
          break;
        case 'price':
          comparison = (a['price'] as num).compareTo(b['price'] as num);
          break;
        case 'stock':
          comparison = (a['stock'] as num).compareTo(b['stock'] as num);
          break;
        case 'createdAt':
          comparison = DateTime.parse(a['createdAt']).compareTo(DateTime.parse(b['createdAt']));
          break;
        default:
          comparison = a['name'].toString().compareTo(b['name'].toString());
      }
      
      return ascending ? comparison : -comparison;
    });
    
    return sortedProducts;
  }

  /// Ordena una lista de ventas
  List<Map<String, dynamic>> sortSales(
    List<Map<String, dynamic>> sales,
    String sortBy,
    bool ascending,
  ) {
    final sortedSales = List<Map<String, dynamic>>.from(sales);
    
    sortedSales.sort((a, b) {
      int comparison = 0;
      
      switch (sortBy) {
        case 'invoiceNumber':
          comparison = a['invoiceNumber'].toString().compareTo(b['invoiceNumber'].toString());
          break;
        case 'customerName':
          comparison = a['customerName'].toString().compareTo(b['customerName'].toString());
          break;
        case 'total':
          comparison = (a['total'] as num).compareTo(b['total'] as num);
          break;
        case 'status':
          comparison = a['status'].toString().compareTo(b['status'].toString());
          break;
        case 'paymentMethod':
          comparison = a['paymentMethod'].toString().compareTo(b['paymentMethod'].toString());
          break;
        case 'createdAt':
          comparison = DateTime.parse(a['createdAt']).compareTo(DateTime.parse(b['createdAt']));
          break;
        default:
          comparison = DateTime.parse(a['createdAt']).compareTo(DateTime.parse(b['createdAt']));
      }
      
      return ascending ? comparison : -comparison;
    });
    
    return sortedSales;
  }

  /// Ordena una lista de clientes
  List<Map<String, dynamic>> sortCustomers(
    List<Map<String, dynamic>> customers,
    String sortBy,
    bool ascending,
  ) {
    final sortedCustomers = List<Map<String, dynamic>>.from(customers);
    
    sortedCustomers.sort((a, b) {
      int comparison = 0;
      
      switch (sortBy) {
        case 'name':
          comparison = a['name'].toString().compareTo(b['name'].toString());
          break;
        case 'email':
          comparison = a['email'].toString().compareTo(b['email'].toString());
          break;
        case 'totalSpent':
          comparison = (a['totalSpent'] as num).compareTo(b['totalSpent'] as num);
          break;
        case 'purchaseCount':
          comparison = (a['purchaseCount'] as num).compareTo(b['purchaseCount'] as num);
          break;
        case 'lastPurchase':
          comparison = DateTime.parse(a['lastPurchase']).compareTo(DateTime.parse(b['lastPurchase']));
          break;
        case 'createdAt':
          comparison = DateTime.parse(a['createdAt']).compareTo(DateTime.parse(b['createdAt']));
          break;
        default:
          comparison = a['name'].toString().compareTo(b['name'].toString());
      }
      
      return ascending ? comparison : -comparison;
    });
    
    return sortedCustomers;
  }

  /// Obtiene estadísticas de filtros aplicados
  Map<String, dynamic> getFilterStats(
    List<Map<String, dynamic>> originalList,
    List<Map<String, dynamic>> filteredList,
  ) {
    return {
      'total': originalList.length,
      'filtered': filteredList.length,
      'percentage': originalList.isNotEmpty 
          ? (filteredList.length / originalList.length * 100).roundToDouble()
          : 0.0,
    };
  }

  /// Valida si un filtro está activo
  bool isFilterActive(Map<String, dynamic> filters, String key) {
    final value = filters[key];
    if (value == null) return false;
    
    if (value is String) return value.isNotEmpty && value != 'Todas' && value != 'Todos';
    if (value is DateTime) return true;
    if (value is num) return value > 0;
    if (value is bool) return value;
    
    return false;
  }

  /// Obtiene el número de filtros activos
  int getActiveFiltersCount(Map<String, dynamic> filters) {
    int count = 0;
    
    for (final key in filters.keys) {
      if (isFilterActive(filters, key)) {
        count++;
      }
    }
    
    return count;
  }

  /// Limpia todos los filtros
  Map<String, dynamic> clearAllFilters() {
    return {};
  }
}
