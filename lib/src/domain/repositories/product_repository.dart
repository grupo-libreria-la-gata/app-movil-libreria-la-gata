import '../entities/product.dart';
import '../../data/models/base_model.dart';

/// Interfaz del repositorio de productos
abstract class ProductRepository {
  /// Obtiene todos los productos con paginación
  Future<PaginatedResponse<Product>> getProducts({
    int page = 1,
    int limit = 20,
    String? search,
    String? category,
    String? brand,
    double? minPrice,
    double? maxPrice,
    bool? inStock,
    bool? lowStock,
    bool? isActive,
    String? sortBy,
    String? sortOrder,
  });

  /// Obtiene un producto por ID
  Future<Product?> getProductById(String id);

  /// Obtiene un producto por código de barras
  Future<Product?> getProductByBarcode(String barcode);

  /// Crea un nuevo producto
  Future<Product> createProduct(Product product);

  /// Actualiza un producto existente
  Future<Product> updateProduct(String id, Product product);

  /// Elimina un producto
  Future<bool> deleteProduct(String id);

  /// Actualiza el stock de un producto
  Future<Product> updateStock(String productId, int quantity, String operation);

  /// Obtiene productos con stock bajo
  Future<List<Product>> getLowStockProducts();

  /// Obtiene productos agotados
  Future<List<Product>> getOutOfStockProducts();

  /// Obtiene productos por categoría
  Future<List<Product>> getProductsByCategory(String category);

  /// Obtiene productos por marca
  Future<List<Product>> getProductsByBrand(String brand);

  /// Busca productos por nombre o descripción
  Future<List<Product>> searchProducts(String query);

  /// Obtiene estadísticas de productos
  Future<Map<String, dynamic>> getProductStats();

  /// Obtiene todas las categorías disponibles
  Future<List<String>> getCategories();

  /// Obtiene todas las marcas disponibles
  Future<List<String>> getBrands();

  /// Importa productos desde un archivo
  Future<List<Product>> importProducts(String filePath);

  /// Exporta productos a un archivo
  Future<String> exportProducts(List<String> productIds, String format);
}




