/// Entidad que representa una venta/factura en el sistema
class Sale {
  final String id;
  final String invoiceNumber;
  final String customerName;
  final String? customerEmail;
  final String? customerPhone;
  final List<SaleItem> items;
  final double subtotal;
  final double tax;
  final double total;
  final String sellerId;
  final String sellerName;
  final SaleStatus status;
  final PaymentMethod paymentMethod;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Sale({
    required this.id,
    required this.invoiceNumber,
    required this.customerName,
    this.customerEmail,
    this.customerPhone,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.sellerId,
    required this.sellerName,
    this.status = SaleStatus.completed,
    this.paymentMethod = PaymentMethod.cash,
    required this.createdAt,
    this.updatedAt,
  });

  /// Obtiene la cantidad total de items
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  /// Obtiene el estado de la venta como texto
  String get statusText {
    switch (status) {
      case SaleStatus.pending:
        return 'Pendiente';
      case SaleStatus.completed:
        return 'Completada';
      case SaleStatus.cancelled:
        return 'Cancelada';
      case SaleStatus.refunded:
        return 'Reembolsada';
    }
  }

  /// Obtiene el color del estado
  String get statusColor {
    switch (status) {
      case SaleStatus.pending:
        return 'warning';
      case SaleStatus.completed:
        return 'success';
      case SaleStatus.cancelled:
        return 'error';
      case SaleStatus.refunded:
        return 'info';
    }
  }

  /// Obtiene el método de pago como texto
  String get paymentMethodText {
    switch (paymentMethod) {
      case PaymentMethod.cash:
        return 'Efectivo';
      case PaymentMethod.card:
        return 'Tarjeta';
      case PaymentMethod.transfer:
        return 'Transferencia';
      case PaymentMethod.mobile:
        return 'Móvil';
    }
  }

  /// Copia la venta con nuevos valores
  Sale copyWith({
    String? id,
    String? invoiceNumber,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    List<SaleItem>? items,
    double? subtotal,
    double? tax,
    double? total,
    String? sellerId,
    String? sellerName,
    SaleStatus? status,
    PaymentMethod? paymentMethod,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Sale(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convierte la entidad a un Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'invoiceNumber': invoiceNumber,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'items': items.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'total': total,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'status': status.name,
      'paymentMethod': paymentMethod.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Crea una entidad desde un Map
  factory Sale.fromMap(Map<String, dynamic> map) {
    return Sale(
      id: map['id'] ?? '',
      invoiceNumber: map['invoiceNumber'] ?? '',
      customerName: map['customerName'] ?? '',
      customerEmail: map['customerEmail'],
      customerPhone: map['customerPhone'],
      items: List<SaleItem>.from(
        map['items']?.map((x) => SaleItem.fromMap(x)) ?? [],
      ),
      subtotal: (map['subtotal'] ?? 0.0).toDouble(),
      tax: (map['tax'] ?? 0.0).toDouble(),
      total: (map['total'] ?? 0.0).toDouble(),
      sellerId: map['sellerId'] ?? '',
      sellerName: map['sellerName'] ?? '',
      status: SaleStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => SaleStatus.completed,
      ),
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.name == map['paymentMethod'],
        orElse: () => PaymentMethod.cash,
      ),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  @override
  String toString() {
    return 'Sale(id: $id, invoiceNumber: $invoiceNumber, total: $total, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Sale && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Item de una venta
class SaleItem {
  final String productId;
  final String productName;
  final String productBrand;
  final double unitPrice;
  final int quantity;
  final double total;

  const SaleItem({
    required this.productId,
    required this.productName,
    required this.productBrand,
    required this.unitPrice,
    required this.quantity,
    required this.total,
  });

  /// Copia el item con nuevos valores
  SaleItem copyWith({
    String? productId,
    String? productName,
    String? productBrand,
    double? unitPrice,
    int? quantity,
    double? total,
  }) {
    return SaleItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productBrand: productBrand ?? this.productBrand,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      total: total ?? this.total,
    );
  }

  /// Convierte el item a un Map
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productBrand': productBrand,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'total': total,
    };
  }

  /// Crea un item desde un Map
  factory SaleItem.fromMap(Map<String, dynamic> map) {
    return SaleItem(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      productBrand: map['productBrand'] ?? '',
      unitPrice: (map['unitPrice'] ?? 0.0).toDouble(),
      quantity: map['quantity'] ?? 0,
      total: (map['total'] ?? 0.0).toDouble(),
    );
  }

  @override
  String toString() {
    return 'SaleItem(productName: $productName, quantity: $quantity, total: $total)';
  }
}

/// Estados de una venta
enum SaleStatus {
  pending,    // Pendiente
  completed,  // Completada
  cancelled,  // Cancelada
  refunded,   // Reembolsada
}

/// Métodos de pago
enum PaymentMethod {
  cash,       // Efectivo
  card,       // Tarjeta
  transfer,   // Transferencia
  mobile,     // Pago móvil
}
