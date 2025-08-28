import 'business_service.dart';

/// Servicio para datos mock/simulados
class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  /// Productos de ejemplo más completos
  List<Map<String, dynamic>> get mockProducts => [
    // Whiskeys
    {
      'id': '1',
      'name': 'Jack Daniel\'s',
      'brand': 'Jack Daniel\'s',
      'category': 'Whiskey',
      'price': 25000.0,
      'stock': 15,
      'minStock': 5,
      'imageUrl': null,
      'description': 'Whiskey Tennessee de alta calidad, suave y aromático',
      'barcode': '1234567890123',
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
    {
      'id': '2',
      'name': 'Johnnie Walker Black Label',
      'brand': 'Johnnie Walker',
      'category': 'Whiskey',
      'price': 35000.0,
      'stock': 8,
      'minStock': 3,
      'imageUrl': null,
      'description': 'Blend premium escocés con notas de vainilla y especias',
      'barcode': '1234567890124',
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 25)).toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
    {
      'id': '3',
      'name': 'Jameson Irish Whiskey',
      'brand': 'Jameson',
      'category': 'Whiskey',
      'price': 22000.0,
      'stock': 12,
      'minStock': 5,
      'imageUrl': null,
      'description': 'Whiskey irlandés triple destilado, suave y equilibrado',
      'barcode': '1234567890125',
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 20)).toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
    
    // Rones
    {
      'id': '4',
      'name': 'Bacardi Superior',
      'brand': 'Bacardi',
      'category': 'Ron',
      'price': 18000.0,
      'stock': 8,
      'minStock': 5,
      'imageUrl': null,
      'description': 'Ron blanco premium, perfecto para cócteles',
      'barcode': '1234567890126',
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 35)).toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
    {
      'id': '5',
      'name': 'Havana Club Añejo 7 Años',
      'brand': 'Havana Club',
      'category': 'Ron',
      'price': 28000.0,
      'stock': 6,
      'minStock': 3,
      'imageUrl': null,
      'description': 'Ron añejo cubano con 7 años de maduración',
      'barcode': '1234567890127',
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 15)).toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
    {
      'id': '6',
      'name': 'Flor de Caña 12 Años',
      'brand': 'Flor de Caña',
      'category': 'Ron',
      'price': 32000.0,
      'stock': 4,
      'minStock': 2,
      'imageUrl': null,
      'description': 'Ron premium nicaragüense, 12 años de añejamiento',
      'barcode': '1234567890128',
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 10)).toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
    
    // Vodkas
    {
      'id': '7',
      'name': 'Grey Goose',
      'brand': 'Grey Goose',
      'category': 'Vodka',
      'price': 35000.0,
      'stock': 3,
      'minStock': 5,
      'imageUrl': null,
      'description': 'Vodka premium francés, destilado de trigo',
      'barcode': '1234567890129',
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 40)).toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
    {
      'id': '8',
      'name': 'Absolut Vodka',
      'brand': 'Absolut',
      'category': 'Vodka',
      'price': 22000.0,
      'stock': 10,
      'minStock': 5,
      'imageUrl': null,
      'description': 'Vodka sueco clásico, destilado de centeno',
      'barcode': '1234567890130',
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 28)).toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
    
    // Tequilas
    {
      'id': '9',
      'name': 'Patrón Silver',
      'brand': 'Patrón',
      'category': 'Tequila',
      'price': 45000.0,
      'stock': 12,
      'minStock': 5,
      'imageUrl': null,
      'description': 'Tequila premium 100% agave azul, destilado en Jalisco',
      'barcode': '1234567890131',
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 22)).toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
    {
      'id': '10',
      'name': 'Don Julio Blanco',
      'brand': 'Don Julio',
      'category': 'Tequila',
      'price': 38000.0,
      'stock': 7,
      'minStock': 3,
      'imageUrl': null,
      'description': 'Tequila artesanal de alta calidad',
      'barcode': '1234567890132',
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 18)).toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
    
    // Gins
    {
      'id': '11',
      'name': 'Bombay Sapphire',
      'brand': 'Bombay Sapphire',
      'category': 'Gin',
      'price': 28000.0,
      'stock': 9,
      'minStock': 4,
      'imageUrl': null,
      'description': 'Gin premium con 10 botánicos seleccionados',
      'barcode': '1234567890133',
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 32)).toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
    {
      'id': '12',
      'name': 'Hendrick\'s Gin',
      'brand': 'Hendrick\'s',
      'category': 'Gin',
      'price': 42000.0,
      'stock': 5,
      'minStock': 2,
      'imageUrl': null,
      'description': 'Gin artesanal con notas de rosa y pepino',
      'barcode': '1234567890134',
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 12)).toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
    
    // Vinos
    {
      'id': '13',
      'name': 'Concha y Toro Cabernet Sauvignon',
      'brand': 'Concha y Toro',
      'category': 'Vino',
      'price': 15000.0,
      'stock': 20,
      'minStock': 8,
      'imageUrl': null,
      'description': 'Vino tinto chileno, cuerpo medio y taninos suaves',
      'barcode': '1234567890135',
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 45)).toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
    {
      'id': '14',
      'name': 'Santa Rita 120 Sauvignon Blanc',
      'brand': 'Santa Rita',
      'category': 'Vino',
      'price': 12000.0,
      'stock': 15,
      'minStock': 6,
      'imageUrl': null,
      'description': 'Vino blanco chileno, fresco y aromático',
      'barcode': '1234567890136',
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 38)).toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
    
    // Cervezas
    {
      'id': '15',
      'name': 'Toña',
      'brand': 'Toña',
      'category': 'Cerveza',
      'price': 800.0,
      'stock': 50,
      'minStock': 20,
      'imageUrl': null,
      'description': 'Cerveza nacional, refrescante y suave',
      'barcode': '1234567890137',
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 50)).toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
    {
      'id': '16',
      'name': 'Victoria',
      'brand': 'Victoria',
      'category': 'Cerveza',
      'price': 750.0,
      'stock': 45,
      'minStock': 15,
      'imageUrl': null,
      'description': 'Cerveza nacional, tradicional y popular',
      'barcode': '1234567890138',
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 42)).toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
    
    // Licores
    {
      'id': '17',
      'name': 'Baileys Irish Cream',
      'brand': 'Baileys',
      'category': 'Licor',
      'price': 18000.0,
      'stock': 8,
      'minStock': 4,
      'imageUrl': null,
      'description': 'Licor de crema irlandesa, suave y cremoso',
      'barcode': '1234567890139',
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 26)).toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
    {
      'id': '18',
      'name': 'Kahlúa',
      'brand': 'Kahlúa',
      'category': 'Licor',
      'price': 16000.0,
      'stock': 10,
      'minStock': 5,
      'imageUrl': null,
      'description': 'Licor de café mexicano, rico y aromático',
      'barcode': '1234567890140',
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 33)).toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
  ];

  /// Clientes de ejemplo
  List<Map<String, dynamic>> get mockCustomers => [
    {
      'id': '1',
      'name': 'Juan Carlos Pérez',
      'email': 'juan.perez@email.com',
      'phone': '+505 8888 1111',
      'address': 'Managua, Nicaragua',
      'totalSpent': 125000.0,
      'lastPurchase': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      'purchaseCount': 8,
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 60)).toIso8601String(),
    },
    {
      'id': '2',
      'name': 'María Elena Rodríguez',
      'email': 'maria.rodriguez@email.com',
      'phone': '+505 8888 2222',
      'address': 'León, Nicaragua',
      'totalSpent': 89000.0,
      'lastPurchase': DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
      'purchaseCount': 5,
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 45)).toIso8601String(),
    },
    {
      'id': '3',
      'name': 'Carlos Alberto López',
      'email': 'carlos.lopez@email.com',
      'phone': '+505 8888 3333',
      'address': 'Granada, Nicaragua',
      'totalSpent': 156000.0,
      'lastPurchase': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      'purchaseCount': 12,
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 90)).toIso8601String(),
    },
    {
      'id': '4',
      'name': 'Ana Sofía Martínez',
      'email': 'ana.martinez@email.com',
      'phone': '+505 8888 4444',
      'address': 'Masaya, Nicaragua',
      'totalSpent': 67000.0,
      'lastPurchase': DateTime.now().subtract(const Duration(days: 8)).toIso8601String(),
      'purchaseCount': 4,
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
    },
    {
      'id': '5',
      'name': 'Roberto José González',
      'email': 'roberto.gonzalez@email.com',
      'phone': '+505 8888 5555',
      'address': 'Chinandega, Nicaragua',
      'totalSpent': 98000.0,
      'lastPurchase': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
      'purchaseCount': 7,
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 55)).toIso8601String(),
    },
    {
      'id': '6',
      'name': 'Isabella María Torres',
      'email': 'isabella.torres@email.com',
      'phone': '+505 8888 6666',
      'address': 'Estelí, Nicaragua',
      'totalSpent': 134000.0,
      'lastPurchase': DateTime.now().subtract(const Duration(days: 0)).toIso8601String(),
      'purchaseCount': 9,
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 75)).toIso8601String(),
    },
    {
      'id': '7',
      'name': 'Fernando Antonio Silva',
      'email': 'fernando.silva@email.com',
      'phone': '+505 8888 7777',
      'address': 'Rivas, Nicaragua',
      'totalSpent': 45000.0,
      'lastPurchase': DateTime.now().subtract(const Duration(days: 12)).toIso8601String(),
      'purchaseCount': 3,
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 25)).toIso8601String(),
    },
    {
      'id': '8',
      'name': 'Carmen Elena Herrera',
      'email': 'carmen.herrera@email.com',
      'phone': '+505 8888 8888',
      'address': 'Jinotega, Nicaragua',
      'totalSpent': 112000.0,
      'lastPurchase': DateTime.now().subtract(const Duration(days: 4)).toIso8601String(),
      'purchaseCount': 6,
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 65)).toIso8601String(),
    },
  ];

  /// Ventas simuladas para reportes
  List<Map<String, dynamic>> get mockSales {
    final businessService = BusinessService();
    final sales = <Map<String, dynamic>>[];
    
    // Generar ventas de los últimos 30 días
    for (int i = 0; i < 50; i++) {
      final saleDate = DateTime.now().subtract(Duration(days: i));
      final customer = mockCustomers[i % mockCustomers.length];
      final items = _generateRandomItems();
      final totals = businessService.calculateAllTotals(items);
      
      sales.add({
        'id': 'SALE${(i + 1).toString().padLeft(4, '0')}',
        'invoiceNumber': businessService.generateInvoiceNumber(),
        'customerName': customer['name'],
        'customerId': customer['id'],
        'items': items,
        'subtotal': totals['subtotal']!,
        'tax': totals['tax']!,
        'discount': totals['discount']!,
        'total': totals['total']!,
        'sellerId': '1',
        'sellerName': 'Vendedor Principal',
        'status': _getRandomSaleStatus(),
        'paymentMethod': _getRandomPaymentMethod(),
        'createdAt': saleDate.toIso8601String(),
        'updatedAt': saleDate.toIso8601String(),
      });
    }
    
    return sales;
  }

  /// Genera items aleatorios para una venta
  List<Map<String, dynamic>> _generateRandomItems() {
    final items = <Map<String, dynamic>>[];
    final random = DateTime.now().millisecondsSinceEpoch;
    final itemCount = (random % 4) + 1; // 1-4 items
    
    for (int i = 0; i < itemCount; i++) {
      final product = mockProducts[random % mockProducts.length];
      final quantity = (random % 3) + 1; // 1-3 unidades
      
      items.add({
        'productId': product['id'],
        'productName': product['name'],
        'productBrand': product['brand'],
        'price': product['price'],
        'quantity': quantity,
        'total': (product['price'] as double) * quantity,
      });
    }
    
    return items;
  }

  /// Obtiene un estado de venta aleatorio
  String _getRandomSaleStatus() {
    final statuses = ['completed', 'pending', 'cancelled'];
    final random = DateTime.now().millisecondsSinceEpoch;
    return statuses[random % statuses.length];
  }

  /// Obtiene un método de pago aleatorio
  String _getRandomPaymentMethod() {
    final methods = ['Efectivo', 'Tarjeta', 'Transferencia', 'Móvil'];
    final random = DateTime.now().millisecondsSinceEpoch;
    return methods[random % methods.length];
  }

  /// Obtiene productos por categoría
  List<Map<String, dynamic>> getProductsByCategory(String category) {
    if (category == 'Todas') return mockProducts;
    return mockProducts.where((product) => product['category'] == category).toList();
  }

  /// Obtiene productos con stock bajo
  List<Map<String, dynamic>> getLowStockProducts() {
    return mockProducts.where((product) {
      final stock = product['stock'] as int;
      final minStock = product['minStock'] as int;
      return stock <= minStock;
    }).toList();
  }

  /// Obtiene productos agotados
  List<Map<String, dynamic>> getOutOfStockProducts() {
    return mockProducts.where((product) => (product['stock'] as int) == 0).toList();
  }

  /// Obtiene ventas por período
  List<Map<String, dynamic>> getSalesByPeriod(DateTime startDate, DateTime endDate) {
    return mockSales.where((sale) {
      final saleDate = DateTime.parse(sale['createdAt'] as String);
      return saleDate.isAfter(startDate) && saleDate.isBefore(endDate);
    }).toList();
  }

  /// Obtiene estadísticas de ventas
  Map<String, dynamic> getSalesStats() {
    return BusinessService().calculateSalesStats(mockSales);
  }

  /// Obtiene estadísticas por período
  Map<String, dynamic> getPeriodStats(DateTime startDate, DateTime endDate) {
    final periodSales = getSalesByPeriod(startDate, endDate);
    return BusinessService().calculateSalesStats(periodSales);
  }
}
