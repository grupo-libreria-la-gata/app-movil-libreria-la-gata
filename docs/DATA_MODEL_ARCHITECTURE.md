# Arquitectura del Modelo de Datos - La Gata

## Resumen

Este documento describe la arquitectura del modelo de datos implementada para el sistema de facturación "La Gata". El modelo está diseñado para trabajar correctamente con un backend separado, siguiendo principios de Clean Architecture y patrones de diseño robustos.

## Estructura General

```
lib/src/
├── data/
│   ├── models/           # Modelos de datos con serialización JSON
│   ├── repositories/     # Implementaciones de repositorios
│   └── services/         # Servicios de API y comunicación
├── domain/
│   ├── entities/         # Entidades de dominio (lógica de negocio)
│   └── repositories/     # Interfaces de repositorios
└── config/              # Configuración de la aplicación
```

## Componentes Principales

### 1. Modelos Base (`base_model.dart`)

#### `BaseModel`
- Clase abstracta que proporciona funcionalidad común
- Incluye validación, serialización y comparación
- Métodos estándar: `toMap()`, `fromMap()`, `isValid`

#### `ApiResponse<T>`
- Clase genérica para respuestas de API
- Maneja respuestas exitosas y errores
- Incluye metadatos y códigos de estado

#### `PaginatedResponse<T>`
- Clase para respuestas paginadas
- Incluye información de paginación completa
- Soporte para navegación entre páginas

#### `ApiException`
- Excepción personalizada para errores de API
- Incluye códigos de estado y detalles específicos

### 2. Modelos de Entidades

#### UserModel
```dart
class UserModel extends BaseModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final UserRole role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLogin;
  final String? avatarUrl;
  final Map<String, dynamic>? preferences;
}
```

**DTOs relacionados:**
- `CreateUserDto`: Para crear nuevos usuarios
- `UpdateUserDto`: Para actualizar usuarios existentes
- `LoginDto`: Para autenticación
- `AuthResponseDto`: Respuesta de autenticación

#### ProductModel
```dart
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
}
```

**DTOs relacionados:**
- `CreateProductDto`: Para crear nuevos productos
- `UpdateProductDto`: Para actualizar productos
- `UpdateStockDto`: Para actualizar stock
- `ProductFilterDto`: Para filtros de búsqueda

#### SaleModel
```dart
class SaleModel extends BaseModel {
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
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? notes;
  final Map<String, dynamic>? metadata;
}
```

**DTOs relacionados:**
- `CreateSaleDto`: Para crear nuevas ventas
- `UpdateSaleDto`: Para actualizar ventas
- `CreateSaleItemDto`: Para items de venta
- `SaleFilterDto`: Para filtros de búsqueda

### 3. Servicio de API (`api_service.dart`)

#### Características principales:
- **Singleton pattern**: Una instancia global
- **Manejo de autenticación**: Tokens JWT automáticos
- **Refresh automático**: Renovación de tokens expirados
- **Manejo de errores**: Clasificación y manejo robusto
- **Conectividad**: Verificación de conexión a internet
- **Logging**: Registro de peticiones en desarrollo
- **Upload/Download**: Soporte para archivos

#### Métodos HTTP soportados:
- `get<T>()`: Peticiones GET
- `post<T>()`: Peticiones POST
- `put<T>()`: Peticiones PUT
- `patch<T>()`: Peticiones PATCH
- `delete<T>()`: Peticiones DELETE
- `uploadFile<T>()`: Subida de archivos
- `downloadFile()`: Descarga de archivos

### 4. Repositorios

#### Patrón Repository
- **Interfaces en domain/**: Contratos de repositorios
- **Implementaciones en data/**: Lógica de acceso a datos
- **Separación de responsabilidades**: Lógica de negocio vs acceso a datos

#### UserRepository
```dart
abstract class UserRepository {
  Future<PaginatedResponse<User>> getUsers({...});
  Future<User?> getUserById(String id);
  Future<User?> getUserByEmail(String email);
  Future<User> createUser(User user);
  Future<User> updateUser(String id, User user);
  Future<bool> deleteUser(String id);
  Future<Map<String, dynamic>> authenticate(String email, String password);
  // ... más métodos
}
```

#### ProductRepository
```dart
abstract class ProductRepository {
  Future<PaginatedResponse<Product>> getProducts({...});
  Future<Product?> getProductById(String id);
  Future<Product?> getProductByBarcode(String barcode);
  Future<Product> createProduct(Product product);
  Future<Product> updateProduct(String id, Product product);
  Future<bool> deleteProduct(String id);
  Future<Product> updateStock(String productId, int quantity, String operation);
  // ... más métodos
}
```

#### SaleRepository
```dart
abstract class SaleRepository {
  Future<PaginatedResponse<Sale>> getSales({...});
  Future<Sale?> getSaleById(String id);
  Future<Sale?> getSaleByInvoiceNumber(String invoiceNumber);
  Future<Sale> createSale(Sale sale);
  Future<Sale> updateSale(String id, Sale sale);
  Future<bool> deleteSale(String id);
  Future<Sale> cancelSale(String id, String reason);
  // ... más métodos
}
```

## Flujo de Datos

### 1. Petición desde UI
```
UI Widget → Provider/Bloc → Repository → API Service → Backend
```

### 2. Respuesta del Backend
```
Backend → API Service → Repository → Entity → UI Widget
```

### 3. Transformación de Datos
```
JSON → Model → Entity → UI State
```

## Manejo de Errores

### Tipos de Errores
1. **Errores de Red**: Sin conexión, timeouts
2. **Errores de Autenticación**: Tokens expirados, credenciales inválidas
3. **Errores de Validación**: Datos inválidos del servidor
4. **Errores del Servidor**: Errores 500, 404, etc.

### Estrategia de Manejo
```dart
try {
  final result = await repository.getUsers();
  // Manejar resultado exitoso
} on ApiException catch (e) {
  // Manejar errores específicos de API
  switch (e.statusCode) {
    case 401:
      // Redirigir a login
      break;
    case 404:
      // Mostrar mensaje de no encontrado
      break;
    default:
      // Mostrar error genérico
  }
} catch (e) {
  // Manejar errores inesperados
}
```

## Configuración

### Variables de Entorno
```dart
class AppConfig {
  static const String baseUrl = 'https://api.lagata.com/api/v1';
  static const String apiKey = 'your_api_key_here';
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  // ... más configuraciones
}
```

### Inicialización
```dart
void main() {
  // Inicializar servicios
  ApiService().initialize();
  
  // Configurar dependencias
  final apiService = ApiService();
  final userRepository = UserRepositoryImpl(apiService);
  
  runApp(MyApp());
}
```

## Ventajas de esta Arquitectura

### 1. **Separación de Responsabilidades**
- Modelos de datos separados de entidades de dominio
- Lógica de negocio independiente del acceso a datos
- Interfaces claras entre capas

### 2. **Testabilidad**
- Repositorios mockeables
- Servicios inyectables
- Entidades puras sin dependencias externas

### 3. **Mantenibilidad**
- Código organizado y estructurado
- Fácil agregar nuevas funcionalidades
- Cambios aislados por capas

### 4. **Escalabilidad**
- Fácil agregar nuevos endpoints
- Soporte para diferentes fuentes de datos
- Patrones consistentes

### 5. **Robustez**
- Manejo completo de errores
- Validación de datos
- Recuperación automática de tokens

## Consideraciones para el Backend

### Estructura de Respuestas Esperada
```json
{
  "success": true,
  "message": "Operación exitosa",
  "data": { ... },
  "metadata": { ... },
  "errors": [ ... ]
}
```

### Respuestas Paginadas
```json
{
  "data": [ ... ],
  "currentPage": 1,
  "totalPages": 10,
  "totalItems": 100,
  "itemsPerPage": 10,
  "hasNextPage": true,
  "hasPreviousPage": false
}
```

### Autenticación
- **JWT Tokens**: Access token + Refresh token
- **Headers**: `Authorization: Bearer <token>`
- **Refresh**: Endpoint `/auth/refresh`

### Endpoints Principales
- `/users` - Gestión de usuarios
- `/products` - Gestión de productos
- `/sales` - Gestión de ventas
- `/auth` - Autenticación

## Próximos Pasos

1. **Implementar repositorios restantes** (Product, Sale)
2. **Agregar caché local** con SQLite
3. **Implementar sincronización offline**
4. **Agregar validaciones de datos**
5. **Crear tests unitarios**
6. **Documentar endpoints del backend**

## Conclusión

Esta arquitectura proporciona una base sólida y escalable para el sistema de facturación La Gata, con separación clara de responsabilidades, manejo robusto de errores y compatibilidad completa con un backend separado. El diseño permite fácil mantenimiento, testing y extensión de funcionalidades.




