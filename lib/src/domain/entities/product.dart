/// Entidad que representa un producto (licor) en el sistema
class Product {
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

  const Product({
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
  });

  /// Verifica si el producto está en stock
  bool get inStock => stock > 0;

  /// Verifica si el stock está bajo (menor al mínimo)
  bool get lowStock => stock <= minStock;

  /// Verifica si el producto está agotado
  bool get outOfStock => stock == 0;

  /// Obtiene el estado del stock como texto
  String get stockStatus {
    if (outOfStock) return 'Agotado';
    if (lowStock) return 'Stock bajo';
    return 'Disponible';
  }

  /// Obtiene el color del estado del stock
  String get stockStatusColor {
    if (outOfStock) return 'error';
    if (lowStock) return 'warning';
    return 'success';
  }

  /// Copia el producto con nuevos valores
  Product copyWith({
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
  }) {
    return Product(
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
    );
  }

  /// Convierte la entidad a un Map
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
    };
  }

  /// Crea una entidad desde un Map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
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
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, brand: $brand, price: $price, stock: $stock)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Categorías de productos (licores)
enum ProductCategory {
  whiskey,
  vodka,
  rum,
  tequila,
  gin,
  wine,
  beer,
  liqueur,
  other,
}

/// Extension para obtener nombres legibles de las categorías
extension ProductCategoryExtension on ProductCategory {
  String get displayName {
    switch (this) {
      case ProductCategory.whiskey:
        return 'Whiskey';
      case ProductCategory.vodka:
        return 'Vodka';
      case ProductCategory.rum:
        return 'Ron';
      case ProductCategory.tequila:
        return 'Tequila';
      case ProductCategory.gin:
        return 'Gin';
      case ProductCategory.wine:
        return 'Vino';
      case ProductCategory.beer:
        return 'Cerveza';
      case ProductCategory.liqueur:
        return 'Licor';
      case ProductCategory.other:
        return 'Otros';
    }
  }
}
