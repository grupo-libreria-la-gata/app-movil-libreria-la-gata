import '../../config/app_config.dart';

/// Servicio para cálculos de negocio
class BusinessService {
  static final BusinessService _instance = BusinessService._internal();
  factory BusinessService() => _instance;
  BusinessService._internal();

  /// Calcula el subtotal de una lista de items
  double calculateSubtotal(List<Map<String, dynamic>> items) {
    return items.fold(0.0, (total, item) {
      final price = (item['price'] as num).toDouble();
      final quantity = (item['quantity'] as num).toInt();
      return total + (price * quantity);
    });
  }

  /// Calcula el impuesto sobre el subtotal
  double calculateTax(double subtotal) {
    return subtotal * (AppConfig.taxRate / 100);
  }

  /// Calcula el descuento basado en el tipo y valor
  double calculateDiscount(double subtotal, DiscountType type, double value) {
    switch (type) {
      case DiscountType.percentage:
        return subtotal * (value / 100);
      case DiscountType.fixed:
        return value;
      case DiscountType.none:
        return 0.0;
    }
  }

  /// Calcula el total final
  double calculateTotal(double subtotal, double tax, double discount) {
    return subtotal + tax - discount;
  }

  /// Calcula el total con todos los parámetros
  Map<String, double> calculateAllTotals(
    List<Map<String, dynamic>> items, {
    DiscountType discountType = DiscountType.none,
    double discountValue = 0.0,
  }) {
    final subtotal = calculateSubtotal(items);
    final tax = calculateTax(subtotal);
    final discount = calculateDiscount(subtotal, discountType, discountValue);
    final total = calculateTotal(subtotal, tax, discount);

    return {
      'subtotal': subtotal,
      'tax': tax,
      'discount': discount,
      'total': total,
    };
  }

  /// Genera número de factura
  String generateInvoiceNumber() {
    final now = DateTime.now();
    final year = now.year.toString().substring(2);
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    final random = (1000 + (now.millisecondsSinceEpoch % 9000)).toString();
    
    return '${AppConfig.invoicePrefix}$year$month$day$random';
  }

  /// Formatea precio para mostrar
  String formatPrice(double price) {
    return '₡${price.toStringAsFixed(0)}';
  }

  /// Formatea porcentaje para mostrar
  String formatPercentage(double percentage) {
    return '${percentage.toStringAsFixed(1)}%';
  }

  /// Valida si hay stock suficiente
  bool hasEnoughStock(Map<String, dynamic> product, int quantity) {
    final availableStock = (product['stock'] as num).toInt();
    return availableStock >= quantity;
  }

  /// Calcula el stock restante después de una venta
  int calculateRemainingStock(Map<String, dynamic> product, int quantity) {
    final currentStock = (product['stock'] as num).toInt();
    return currentStock - quantity;
  }

  /// Verifica si un producto está bajo stock mínimo
  bool isLowStock(Map<String, dynamic> product) {
    final currentStock = (product['stock'] as num).toInt();
    final minStock = (product['minStock'] as num).toInt();
    return currentStock <= minStock;
  }

  /// Calcula el valor total del inventario
  double calculateInventoryValue(List<Map<String, dynamic>> products) {
    return products.fold(0.0, (total, product) {
      final price = (product['price'] as num).toDouble();
      final stock = (product['stock'] as num).toInt();
      return total + (price * stock);
    });
  }

  /// Calcula estadísticas de ventas
  Map<String, dynamic> calculateSalesStats(List<Map<String, dynamic>> sales) {
    if (sales.isEmpty) {
      return {
        'totalSales': 0,
        'totalRevenue': 0.0,
        'averageTicket': 0.0,
        'totalItems': 0,
      };
    }

    final totalSales = sales.length;
    final totalRevenue = sales.fold(0.0, (total, sale) {
      return total + (sale['total'] as num).toDouble();
    });
    final averageTicket = totalRevenue / totalSales;
    final totalItems = sales.fold(0, (total, sale) {
      final items = sale['items'] as List<dynamic>;
      return total + items.fold(0, (itemTotal, item) {
        return itemTotal + (item['quantity'] as num).toInt();
      });
    });

    return {
      'totalSales': totalSales,
      'totalRevenue': totalRevenue,
      'averageTicket': averageTicket,
      'totalItems': totalItems,
    };
  }

  /// Calcula estadísticas por período
  Map<String, dynamic> calculatePeriodStats(
    List<Map<String, dynamic>> sales,
    DateTime startDate,
    DateTime endDate,
  ) {
    final periodSales = sales.where((sale) {
      final saleDate = DateTime.parse(sale['createdAt'] as String);
      return saleDate.isAfter(startDate) && saleDate.isBefore(endDate);
    }).toList();

    return calculateSalesStats(periodSales);
  }

  /// Calcula el margen de ganancia
  double calculateProfitMargin(double revenue, double cost) {
    if (revenue == 0) return 0.0;
    return ((revenue - cost) / revenue) * 100;
  }

  /// Calcula el ROI (Return on Investment)
  double calculateROI(double profit, double investment) {
    if (investment == 0) return 0.0;
    return (profit / investment) * 100;
  }

  /// Aplica redondeo comercial
  double roundCommercial(double value) {
    return (value * 100).round() / 100;
  }

  /// Calcula el cambio a devolver
  double calculateChange(double total, double payment) {
    return payment - total;
  }

  /// Valida si el pago es suficiente
  bool isPaymentSufficient(double total, double payment) {
    return payment >= total;
  }

  /// Calcula cuotas de pago
  List<double> calculateInstallments(double total, int installments) {
    if (installments <= 1) return [total];
    
    final baseAmount = total / installments;
    final remainder = total % installments;
    
    List<double> amounts = [];
    for (int i = 0; i < installments; i++) {
      if (i < remainder) {
        amounts.add(baseAmount + 1);
      } else {
        amounts.add(baseAmount);
      }
    }
    
    return amounts;
  }
}

/// Tipos de descuento
enum DiscountType {
  none,
  percentage,
  fixed,
}

/// Extension para mostrar nombres de descuento
extension DiscountTypeExtension on DiscountType {
  String get displayName {
    switch (this) {
      case DiscountType.none:
        return 'Sin descuento';
      case DiscountType.percentage:
        return 'Porcentaje';
      case DiscountType.fixed:
        return 'Monto fijo';
    }
  }
}

/// Clase para configuraciones de negocio
class BusinessConfig {
  static double taxRate = AppConfig.taxRate;
  static double defaultDiscount = 0.0;
  static DiscountType defaultDiscountType = DiscountType.none;
  static int invoiceNumberLength = AppConfig.invoiceNumberLength;
  static String invoicePrefix = AppConfig.invoicePrefix;
  static String businessName = AppConfig.businessName;
  static String businessAddress = AppConfig.businessAddress;
  static String businessPhone = AppConfig.businessPhone;
  static String businessEmail = AppConfig.businessEmail;
  static String businessRuc = AppConfig.businessRuc;
  
  /// Actualiza la configuración de impuestos
  static void updateTaxRate(double newRate) {
    taxRate = newRate;
  }
  
  /// Actualiza la configuración de descuentos
  static void updateDiscountConfig(DiscountType type, double value) {
    defaultDiscountType = type;
    defaultDiscount = value;
  }
  
  /// Obtiene la configuración actual
  static Map<String, dynamic> getCurrentConfig() {
    return {
      'taxRate': taxRate,
      'defaultDiscount': defaultDiscount,
      'defaultDiscountType': defaultDiscountType.name,
      'invoiceNumberLength': invoiceNumberLength,
      'invoicePrefix': invoicePrefix,
      'businessName': businessName,
      'businessAddress': businessAddress,
      'businessPhone': businessPhone,
      'businessEmail': businessEmail,
      'businessRuc': businessRuc,
    };
  }
}
