import 'base_model.dart';
import '../../domain/entities/product.dart';

/// Modelo de datos para Producto con serialización JSON
class ProductModel extends BaseModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String brand;
  final double price;
  final int stock;
  final int minStock;
  final String? imageUrl;
  final String? barcode;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final double? costPrice;
  final double? profitMargin;
  final String? supplier;
  final Map<String, dynamic>? specifications;
  final List<String>? tags;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.brand,
    required this.price,
    required this.stock,
    this.minStock = 5,
    this.imageUrl,
    this.barcode,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
    this.costPrice,
    this.profitMargin,
    this.supplier,
    this.specifications,
    this.tags,
  });

  @override
  bool get isValid => 
      id.isNotEmpty && 
      name.isNotEmpty && 
      description.isNotEmpty && 
      category.isNotEmpty && 
      brand.isNotEmpty && 
      price > 0;

  /// Convierte el modelo a una entidad de dominio
  Product toEntity() {
    return Product(
      id: id,
      name: name,
      description: description,
      category: category,
      brand: brand,
      price: price,
      stock: stock,
      minStock: minStock,
      imageUrl: imageUrl,
      barcode: barcode,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Crea un modelo desde una entidad de dominio
  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      category: product.category,
      brand: product.brand,
      price: product.price,
      stock: product.stock,
      minStock: product.minStock,
      imageUrl: product.imageUrl,
      barcode: product.barcode,
      isActive: product.isActive,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
    );
  }

  /// Copia el modelo con nuevos valores
  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? brand,
    double? price,
    int? stock,
    int? minStock,
    String? imageUrl,
    String? barcode,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? costPrice,
    double? profitMargin,
    String? supplier,
    Map<String, dynamic>? specifications,
    List<String>? tags,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      minStock: minStock ?? this.minStock,
      imageUrl: imageUrl ?? this.imageUrl,
      barcode: barcode ?? this.barcode,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      costPrice: costPrice ?? this.costPrice,
      profitMargin: profitMargin ?? this.profitMargin,
      supplier: supplier ?? this.supplier,
      specifications: specifications ?? this.specifications,
      tags: tags ?? this.tags,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'brand': brand,
      'price': price,
      'stock': stock,
      'minStock': minStock,
      'imageUrl': imageUrl,
      'barcode': barcode,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'costPrice': costPrice,
      'profitMargin': profitMargin,
      'supplier': supplier,
      'specifications': specifications,
      'tags': tags,
    };
  }

  /// Crea un modelo desde un Map
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      brand: map['brand'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      stock: map['stock'] ?? 0,
      minStock: map['minStock'] ?? 5,
      imageUrl: map['imageUrl'],
      barcode: map['barcode'],
      isActive: map['isActive'] ?? true,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      costPrice: map['costPrice']?.toDouble(),
      profitMargin: map['profitMargin']?.toDouble(),
      supplier: map['supplier'],
      specifications: map['specifications'] != null 
          ? Map<String, dynamic>.from(map['specifications']) 
          : null,
      tags: map['tags']?.cast<String>(),
    );
  }

  /// Crea un modelo desde JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel.fromMap(json);
  }

  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() => toMap();

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, brand: $brand, price: $price, stock: $stock)';
  }
}

/// DTO para crear un nuevo producto
class CreateProductDto {
  final String name;
  final String description;
  final String category;
  final String brand;
  final double price;
  final int stock;
  final int minStock;
  final String? imageUrl;
  final String? barcode;
  final double? costPrice;
  final String? supplier;
  final Map<String, dynamic>? specifications;
  final List<String>? tags;

  const CreateProductDto({
    required this.name,
    required this.description,
    required this.category,
    required this.brand,
    required this.price,
    required this.stock,
    this.minStock = 5,
    this.imageUrl,
    this.barcode,
    this.costPrice,
    this.supplier,
    this.specifications,
    this.tags,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'brand': brand,
      'price': price,
      'stock': stock,
      'minStock': minStock,
      'imageUrl': imageUrl,
      'barcode': barcode,
      'costPrice': costPrice,
      'supplier': supplier,
      'specifications': specifications,
      'tags': tags,
    };
  }

  factory CreateProductDto.fromMap(Map<String, dynamic> map) {
    return CreateProductDto(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      brand: map['brand'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      stock: map['stock'] ?? 0,
      minStock: map['minStock'] ?? 5,
      imageUrl: map['imageUrl'],
      barcode: map['barcode'],
      costPrice: map['costPrice']?.toDouble(),
      supplier: map['supplier'],
      specifications: map['specifications'] != null 
          ? Map<String, dynamic>.from(map['specifications']) 
          : null,
      tags: map['tags']?.cast<String>(),
    );
  }
}

/// DTO para actualizar un producto
class UpdateProductDto {
  final String? name;
  final String? description;
  final String? category;
  final String? brand;
  final double? price;
  final int? stock;
  final int? minStock;
  final String? imageUrl;
  final String? barcode;
  final bool? isActive;
  final double? costPrice;
  final String? supplier;
  final Map<String, dynamic>? specifications;
  final List<String>? tags;

  const UpdateProductDto({
    this.name,
    this.description,
    this.category,
    this.brand,
    this.price,
    this.stock,
    this.minStock,
    this.imageUrl,
    this.barcode,
    this.isActive,
    this.costPrice,
    this.supplier,
    this.specifications,
    this.tags,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (name != null) map['name'] = name;
    if (description != null) map['description'] = description;
    if (category != null) map['category'] = category;
    if (brand != null) map['brand'] = brand;
    if (price != null) map['price'] = price;
    if (stock != null) map['stock'] = stock;
    if (minStock != null) map['minStock'] = minStock;
    if (imageUrl != null) map['imageUrl'] = imageUrl;
    if (barcode != null) map['barcode'] = barcode;
    if (isActive != null) map['isActive'] = isActive;
    if (costPrice != null) map['costPrice'] = costPrice;
    if (supplier != null) map['supplier'] = supplier;
    if (specifications != null) map['specifications'] = specifications;
    if (tags != null) map['tags'] = tags;
    return map;
  }

  factory UpdateProductDto.fromMap(Map<String, dynamic> map) {
    return UpdateProductDto(
      name: map['name'],
      description: map['description'],
      category: map['category'],
      brand: map['brand'],
      price: map['price']?.toDouble(),
      stock: map['stock'],
      minStock: map['minStock'],
      imageUrl: map['imageUrl'],
      barcode: map['barcode'],
      isActive: map['isActive'],
      costPrice: map['costPrice']?.toDouble(),
      supplier: map['supplier'],
      specifications: map['specifications'] != null 
          ? Map<String, dynamic>.from(map['specifications']) 
          : null,
      tags: map['tags']?.cast<String>(),
    );
  }
}

/// DTO para actualizar stock de productos
class UpdateStockDto {
  final String productId;
  final int quantity;
  final String operation; // 'add', 'subtract', 'set'
  final String? reason;
  final String? notes;

  const UpdateStockDto({
    required this.productId,
    required this.quantity,
    required this.operation,
    this.reason,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'quantity': quantity,
      'operation': operation,
      'reason': reason,
      'notes': notes,
    };
  }

  factory UpdateStockDto.fromMap(Map<String, dynamic> map) {
    return UpdateStockDto(
      productId: map['productId'] ?? '',
      quantity: map['quantity'] ?? 0,
      operation: map['operation'] ?? 'set',
      reason: map['reason'],
      notes: map['notes'],
    );
  }
}

/// DTO para filtros de búsqueda de productos
class ProductFilterDto {
  final String? search;
  final String? category;
  final String? brand;
  final double? minPrice;
  final double? maxPrice;
  final bool? inStock;
  final bool? lowStock;
  final bool? isActive;
  final List<String>? tags;
  final String? sortBy;
  final String? sortOrder;

  const ProductFilterDto({
    this.search,
    this.category,
    this.brand,
    this.minPrice,
    this.maxPrice,
    this.inStock,
    this.lowStock,
    this.isActive,
    this.tags,
    this.sortBy,
    this.sortOrder,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (search != null) map['search'] = search;
    if (category != null) map['category'] = category;
    if (brand != null) map['brand'] = brand;
    if (minPrice != null) map['minPrice'] = minPrice;
    if (maxPrice != null) map['maxPrice'] = maxPrice;
    if (inStock != null) map['inStock'] = inStock;
    if (lowStock != null) map['lowStock'] = lowStock;
    if (isActive != null) map['isActive'] = isActive;
    if (tags != null) map['tags'] = tags;
    if (sortBy != null) map['sortBy'] = sortBy;
    if (sortOrder != null) map['sortOrder'] = sortOrder;
    return map;
  }

  factory ProductFilterDto.fromMap(Map<String, dynamic> map) {
    return ProductFilterDto(
      search: map['search'],
      category: map['category'],
      brand: map['brand'],
      minPrice: map['minPrice']?.toDouble(),
      maxPrice: map['maxPrice']?.toDouble(),
      inStock: map['inStock'],
      lowStock: map['lowStock'],
      isActive: map['isActive'],
      tags: map['tags']?.cast<String>(),
      sortBy: map['sortBy'],
      sortOrder: map['sortOrder'],
    );
  }
}
