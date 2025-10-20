import 'base_model.dart';
import '../../domain/entities/sale.dart';

/// Modelo de datos para Venta con serialización JSON
class SaleModel extends BaseModel {
  @override
  final String id;
  final String invoiceNumber;
  final String customerName;
  final String? customerEmail;
  final String? customerPhone;
  final List<SaleItemModel> items;
  final double subtotal;
  final double tax;
  final double discount;
  final double total;
  final String sellerId;
  final String sellerName;
  final SaleStatus status;
  final PaymentMethod paymentMethod;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  final String? notes;
  final Map<String, dynamic>? metadata;

  SaleModel({
    required this.id,
    required this.invoiceNumber,
    required this.customerName,
    this.customerEmail,
    this.customerPhone,
    required this.items,
    required this.subtotal,
    required this.tax,
    this.discount = 0.0,
    required this.total,
    required this.sellerId,
    required this.sellerName,
    this.status = SaleStatus.completed,
    this.paymentMethod = PaymentMethod.cash,
    required this.createdAt,
    this.updatedAt,
    this.notes,
    this.metadata,
  });

  @override
  bool get isValid =>
      id.isNotEmpty &&
      invoiceNumber.isNotEmpty &&
      customerName.isNotEmpty &&
      items.isNotEmpty &&
      total > 0;

  /// Convierte el modelo a una entidad de dominio
  Sale toEntity() {
    return Sale(
      id: id,
      invoiceNumber: invoiceNumber,
      customerName: customerName,
      customerEmail: customerEmail,
      customerPhone: customerPhone,
      items: items.map((item) => item.toEntity()).toList(),
      subtotal: subtotal,
      tax: tax,
      total: total,
      sellerId: sellerId,
      sellerName: sellerName,
      status: status,
      paymentMethod: paymentMethod,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Crea un modelo desde una entidad de dominio
  factory SaleModel.fromEntity(Sale sale) {
    return SaleModel(
      id: sale.id,
      invoiceNumber: sale.invoiceNumber,
      customerName: sale.customerName,
      customerEmail: sale.customerEmail,
      customerPhone: sale.customerPhone,
      items: sale.items.map((item) => SaleItemModel.fromEntity(item)).toList(),
      subtotal: sale.subtotal,
      tax: sale.tax,
      total: sale.total,
      sellerId: sale.sellerId,
      sellerName: sale.sellerName,
      status: sale.status,
      paymentMethod: sale.paymentMethod,
      createdAt: sale.createdAt,
      updatedAt: sale.updatedAt,
    );
  }

  /// Copia el modelo con nuevos valores
  SaleModel copyWith({
    String? id,
    String? invoiceNumber,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    List<SaleItemModel>? items,
    double? subtotal,
    double? tax,
    double? discount,
    double? total,
    String? sellerId,
    String? sellerName,
    SaleStatus? status,
    PaymentMethod? paymentMethod,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
    Map<String, dynamic>? metadata,
  }) {
    return SaleModel(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: notes ?? this.notes,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
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
      'discount': discount,
      'total': total,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'status': status.name,
      'paymentMethod': paymentMethod.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'notes': notes,
      'metadata': metadata,
    };
  }

  /// Crea un modelo desde un Map
  factory SaleModel.fromMap(Map<String, dynamic> map) {
    return SaleModel(
      id: map['id'] ?? '',
      invoiceNumber: map['invoiceNumber'] ?? '',
      customerName: map['customerName'] ?? '',
      customerEmail: map['customerEmail'],
      customerPhone: map['customerPhone'],
      items: List<SaleItemModel>.from(
        map['items']?.map((x) => SaleItemModel.fromMap(x)) ?? [],
      ),
      subtotal: (map['subtotal'] ?? 0.0).toDouble(),
      tax: (map['tax'] ?? 0.0).toDouble(),
      discount: (map['discount'] ?? 0.0).toDouble(),
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
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : null,
      notes: map['notes'],
      metadata: map['metadata'] != null
          ? Map<String, dynamic>.from(map['metadata'])
          : null,
    );
  }

  /// Crea un modelo desde JSON
  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel.fromMap(json);
  }

  /// Convierte el modelo a JSON
  @override
  Map<String, dynamic> toJson() => toMap();

  @override
  String toString() {
    return 'SaleModel(id: $id, invoiceNumber: $invoiceNumber, total: $total, status: $status)';
  }
}

/// Modelo de datos para Item de Venta
class SaleItemModel {
  final String productId;
  final String productName;
  final String productBrand;
  final double unitPrice;
  final int quantity;
  final double total;
  final double? discount;
  final Map<String, dynamic>? metadata;

  const SaleItemModel({
    required this.productId,
    required this.productName,
    required this.productBrand,
    required this.unitPrice,
    required this.quantity,
    required this.total,
    this.discount,
    this.metadata,
  });

  /// Convierte el modelo a una entidad de dominio
  SaleItem toEntity() {
    return SaleItem(
      productId: productId,
      productName: productName,
      productBrand: productBrand,
      unitPrice: unitPrice,
      quantity: quantity,
      total: total,
    );
  }

  /// Crea un modelo desde una entidad de dominio
  factory SaleItemModel.fromEntity(SaleItem item) {
    return SaleItemModel(
      productId: item.productId,
      productName: item.productName,
      productBrand: item.productBrand,
      unitPrice: item.unitPrice,
      quantity: item.quantity,
      total: item.total,
    );
  }

  /// Copia el modelo con nuevos valores
  SaleItemModel copyWith({
    String? productId,
    String? productName,
    String? productBrand,
    double? unitPrice,
    int? quantity,
    double? total,
    double? discount,
    Map<String, dynamic>? metadata,
  }) {
    return SaleItemModel(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productBrand: productBrand ?? this.productBrand,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      total: total ?? this.total,
      discount: discount ?? this.discount,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Convierte el modelo a un Map
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productBrand': productBrand,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'total': total,
      'discount': discount,
      'metadata': metadata,
    };
  }

  /// Crea un modelo desde un Map
  factory SaleItemModel.fromMap(Map<String, dynamic> map) {
    return SaleItemModel(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      productBrand: map['productBrand'] ?? '',
      unitPrice: (map['unitPrice'] ?? 0.0).toDouble(),
      quantity: map['quantity'] ?? 0,
      total: (map['total'] ?? 0.0).toDouble(),
      discount: map['discount']?.toDouble(),
      metadata: map['metadata'] != null
          ? Map<String, dynamic>.from(map['metadata'])
          : null,
    );
  }

  @override
  String toString() {
    return 'SaleItemModel(productName: $productName, quantity: $quantity, total: $total)';
  }
}

/// DTO para crear una nueva venta
class CreateSaleDto {
  final String customerName;
  final String? customerEmail;
  final String? customerPhone;
  final List<CreateSaleItemDto> items;
  final double? discount;
  final PaymentMethod paymentMethod;
  final String? notes;
  final Map<String, dynamic>? metadata;

  const CreateSaleDto({
    required this.customerName,
    this.customerEmail,
    this.customerPhone,
    required this.items,
    this.discount = 0.0,
    this.paymentMethod = PaymentMethod.cash,
    this.notes,
    this.metadata,
  });

  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'items': items.map((item) => item.toMap()).toList(),
      'discount': discount,
      'paymentMethod': paymentMethod.name,
      'notes': notes,
      'metadata': metadata,
    };
  }

  factory CreateSaleDto.fromMap(Map<String, dynamic> map) {
    return CreateSaleDto(
      customerName: map['customerName'] ?? '',
      customerEmail: map['customerEmail'],
      customerPhone: map['customerPhone'],
      items: List<CreateSaleItemDto>.from(
        map['items']?.map((x) => CreateSaleItemDto.fromMap(x)) ?? [],
      ),
      discount: map['discount']?.toDouble() ?? 0.0,
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.name == map['paymentMethod'],
        orElse: () => PaymentMethod.cash,
      ),
      notes: map['notes'],
      metadata: map['metadata'] != null
          ? Map<String, dynamic>.from(map['metadata'])
          : null,
    );
  }
}

/// DTO para crear un item de venta
class CreateSaleItemDto {
  final String productId;
  final int quantity;
  final double? unitPrice;
  final double? discount;

  const CreateSaleItemDto({
    required this.productId,
    required this.quantity,
    this.unitPrice,
    this.discount,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'discount': discount,
    };
  }

  factory CreateSaleItemDto.fromMap(Map<String, dynamic> map) {
    return CreateSaleItemDto(
      productId: map['productId'] ?? '',
      quantity: map['quantity'] ?? 0,
      unitPrice: map['unitPrice']?.toDouble(),
      discount: map['discount']?.toDouble(),
    );
  }
}

/// DTO para actualizar una venta
class UpdateSaleDto {
  final String? customerName;
  final String? customerEmail;
  final String? customerPhone;
  final List<CreateSaleItemDto>? items;
  final double? discount;
  final SaleStatus? status;
  final PaymentMethod? paymentMethod;
  final String? notes;
  final Map<String, dynamic>? metadata;

  const UpdateSaleDto({
    this.customerName,
    this.customerEmail,
    this.customerPhone,
    this.items,
    this.discount,
    this.status,
    this.paymentMethod,
    this.notes,
    this.metadata,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (customerName != null) map['customerName'] = customerName;
    if (customerEmail != null) map['customerEmail'] = customerEmail;
    if (customerPhone != null) map['customerPhone'] = customerPhone;
    if (items != null) {
      map['items'] = items!.map((item) => item.toMap()).toList();
    }
    if (discount != null) map['discount'] = discount;
    if (status != null) map['status'] = status!.name;
    if (paymentMethod != null) map['paymentMethod'] = paymentMethod!.name;
    if (notes != null) map['notes'] = notes;
    if (metadata != null) map['metadata'] = metadata;
    return map;
  }

  factory UpdateSaleDto.fromMap(Map<String, dynamic> map) {
    return UpdateSaleDto(
      customerName: map['customerName'],
      customerEmail: map['customerEmail'],
      customerPhone: map['customerPhone'],
      items: map['items'] != null
          ? List<CreateSaleItemDto>.from(
              map['items'].map((x) => CreateSaleItemDto.fromMap(x)),
            )
          : null,
      discount: map['discount']?.toDouble(),
      status: map['status'] != null
          ? SaleStatus.values.firstWhere(
              (e) => e.name == map['status'],
              orElse: () => SaleStatus.completed,
            )
          : null,
      paymentMethod: map['paymentMethod'] != null
          ? PaymentMethod.values.firstWhere(
              (e) => e.name == map['paymentMethod'],
              orElse: () => PaymentMethod.cash,
            )
          : null,
      notes: map['notes'],
      metadata: map['metadata'] != null
          ? Map<String, dynamic>.from(map['metadata'])
          : null,
    );
  }
}

/// DTO para filtros de búsqueda de ventas
class SaleFilterDto {
  final String? search;
  final String? customerName;
  final String? sellerId;
  final SaleStatus? status;
  final PaymentMethod? paymentMethod;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? minTotal;
  final double? maxTotal;
  final String? sortBy;
  final String? sortOrder;

  const SaleFilterDto({
    this.search,
    this.customerName,
    this.sellerId,
    this.status,
    this.paymentMethod,
    this.startDate,
    this.endDate,
    this.minTotal,
    this.maxTotal,
    this.sortBy,
    this.sortOrder,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (search != null) map['search'] = search;
    if (customerName != null) map['customerName'] = customerName;
    if (sellerId != null) map['sellerId'] = sellerId;
    if (status != null) map['status'] = status!.name;
    if (paymentMethod != null) map['paymentMethod'] = paymentMethod!.name;
    if (startDate != null) map['startDate'] = startDate!.toIso8601String();
    if (endDate != null) map['endDate'] = endDate!.toIso8601String();
    if (minTotal != null) map['minTotal'] = minTotal;
    if (maxTotal != null) map['maxTotal'] = maxTotal;
    if (sortBy != null) map['sortBy'] = sortBy;
    if (sortOrder != null) map['sortOrder'] = sortOrder;
    return map;
  }

  factory SaleFilterDto.fromMap(Map<String, dynamic> map) {
    return SaleFilterDto(
      search: map['search'],
      customerName: map['customerName'],
      sellerId: map['sellerId'],
      status: map['status'] != null
          ? SaleStatus.values.firstWhere(
              (e) => e.name == map['status'],
              orElse: () => SaleStatus.completed,
            )
          : null,
      paymentMethod: map['paymentMethod'] != null
          ? PaymentMethod.values.firstWhere(
              (e) => e.name == map['paymentMethod'],
              orElse: () => PaymentMethod.cash,
            )
          : null,
      startDate: map['startDate'] != null
          ? DateTime.parse(map['startDate'])
          : null,
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      minTotal: map['minTotal']?.toDouble(),
      maxTotal: map['maxTotal']?.toDouble(),
      sortBy: map['sortBy'],
      sortOrder: map['sortOrder'],
    );
  }
}
