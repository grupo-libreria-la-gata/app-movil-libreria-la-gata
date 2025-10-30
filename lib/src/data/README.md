# Modelo de Datos - La Gata

## Descripción

Este directorio contiene la implementación completa del modelo de datos para el sistema de facturación La Gata. El modelo está diseñado para trabajar correctamente con un backend separado, siguiendo principios de Clean Architecture.

## Estructura

```
data/
├── models/              # Modelos de datos con serialización JSON
│   ├── base_model.dart     # Clase base y utilidades comunes
│   ├── user_model.dart     # Modelo de usuario con DTOs
│   ├── product_model.dart  # Modelo de producto con DTOs
│   └── sale_model.dart     # Modelo de venta con DTOs
├── repositories/         # Implementaciones de repositorios
│   └── user_repository_impl.dart
├── services/            # Servicios de comunicación
│   └── api_service.dart    # Servicio base de API
└── README.md           # Este archivo
```

## Características Principales

### ✅ Modelos Base
- **BaseModel**: Clase abstracta con funcionalidad común
- **ApiResponse<T>**: Respuestas tipadas de API
- **PaginatedResponse<T>**: Respuestas paginadas
- **ApiException**: Manejo de errores específicos

### ✅ Modelos de Entidades
- **UserModel**: Usuario con roles y autenticación
- **ProductModel**: Productos con stock y categorías
- **SaleModel**: Ventas con items y estados

### ✅ DTOs (Data Transfer Objects)
- **CreateUserDto**: Creación de usuarios
- **UpdateUserDto**: Actualización de usuarios
- **LoginDto**: Autenticación
- **AuthResponseDto**: Respuesta de autenticación
- **CreateProductDto**: Creación de productos
- **UpdateProductDto**: Actualización de productos
- **UpdateStockDto**: Actualización de stock
- **ProductFilterDto**: Filtros de búsqueda
- **CreateSaleDto**: Creación de ventas
- **UpdateSaleDto**: Actualización de ventas
- **SaleFilterDto**: Filtros de ventas

### ✅ Servicio de API
- **Singleton pattern**: Una instancia global
- **Manejo de autenticación**: Tokens JWT automáticos
- **Refresh automático**: Renovación de tokens expirados
- **Manejo de errores**: Clasificación y manejo robusto
- **Conectividad**: Verificación de conexión a internet
- **Upload/Download**: Soporte para archivos
- **Logging**: Registro de peticiones en desarrollo

### ✅ Repositorios
- **Patrón Repository**: Separación de lógica de negocio
- **UserRepository**: Gestión completa de usuarios
- **Interfaces claras**: Contratos bien definidos

## Uso Básico

### 1. Inicialización

```dart
import 'package:la_gata_app/src/core/di/service_locator.dart';

void main() async {
  // Configurar dependencias
  await configureDependencies();
  
  // Inicializar servicios
  await initializeServices();
  
  runApp(MyApp());
}
```

### 2. Autenticación

```dart
final userRepository = serviceLocator<UserRepository>();

try {
  final authResponse = await userRepository.authenticate(
    'admin@lagata.com',
    'password123',
  );
  
  print('Usuario autenticado: ${authResponse['user']['name']}');
} catch (e) {
  print('Error de autenticación: $e');
}
```

### 3. Creación de Usuario

```dart
final user = User(
  id: 'user_123',
  name: 'Juan Pérez',
  email: 'juan@lagata.com',
  role: UserRole.seller,
  createdAt: DateTime.now(),
);

final createdUser = await userRepository.createUser(user);
```

### 4. Obtención con Paginación

```dart
final response = await userRepository.getUsers(
  page: 1,
  limit: 10,
  search: 'admin',
  role: UserRole.admin,
);

print('Total: ${response.totalItems}');
for (final user in response.data) {
  print('- ${user.name}');
}
```

### 5. Uso de DTOs

```dart
final createUserDto = CreateUserDto(
  name: 'Ana López',
  email: 'ana@lagata.com',
  role: UserRole.inventory,
  password: 'password123',
);

final updateUserDto = UpdateUserDto(
  name: 'Ana López García',
  phone: '+505 9876-5433',
);
```

### 6. Manejo de Errores

```dart
try {
  final user = await userRepository.getUserById('user_123');
} on ApiException catch (e) {
  switch (e.statusCode) {
    case 401:
      // Token expirado, redirigir a login
      break;
    case 404:
      // Usuario no encontrado
      break;
    default:
      // Error genérico
  }
} catch (e) {
  // Error inesperado
}
```

## Configuración del Backend

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

- `GET /users` - Lista de usuarios (paginada)
- `GET /users/{id}` - Usuario por ID
- `POST /users` - Crear usuario
- `PUT /users/{id}` - Actualizar usuario
- `DELETE /users/{id}` - Eliminar usuario
- `POST /auth/login` - Autenticación
- `POST /auth/refresh` - Refrescar token
- `POST /auth/logout` - Cerrar sesión

## Próximos Pasos

### 🔄 Pendientes
- [ ] Implementar `ProductRepositoryImpl`
- [ ] Implementar `SaleRepositoryImpl`
- [ ] Agregar caché local con SQLite
- [ ] Implementar sincronización offline
- [ ] Crear tests unitarios
- [ ] Agregar validaciones de datos

### 🚀 Mejoras Futuras
- [ ] Implementar caché inteligente
- [ ] Agregar métricas y analytics
- [ ] Implementar notificaciones push
- [ ] Agregar soporte para múltiples idiomas
- [ ] Implementar auditoría de cambios

## Testing

### Ejemplo de Test

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:la_gata_app/src/data/models/user_model.dart';

void main() {
  group('UserModel Tests', () {
    test('should create user model from map', () {
      final map = {
        'id': 'user_123',
        'name': 'Juan Pérez',
        'email': 'juan@lagata.com',
        'role': 'seller',
        'isActive': true,
        'createdAt': '2024-01-01T00:00:00.000Z',
      };

      final user = UserModel.fromMap(map);
      
      expect(user.id, 'user_123');
      expect(user.name, 'Juan Pérez');
      expect(user.email, 'juan@lagata.com');
      expect(user.role, UserRole.seller);
      expect(user.isValid, true);
    });

    test('should convert user model to map', () {
      final user = UserModel(
        id: 'user_123',
        name: 'Juan Pérez',
        email: 'juan@lagata.com',
        role: UserRole.seller,
        createdAt: DateTime.now(),
      );

      final map = user.toMap();
      
      expect(map['id'], 'user_123');
      expect(map['name'], 'Juan Pérez');
      expect(map['email'], 'juan@lagata.com');
      expect(map['role'], 'seller');
    });
  });
}
```

## Contribución

Para contribuir al modelo de datos:

1. **Sigue las convenciones**: Usa los patrones establecidos
2. **Documenta cambios**: Actualiza la documentación
3. **Escribe tests**: Cubre nuevas funcionalidades
4. **Valida datos**: Agrega validaciones necesarias
5. **Maneja errores**: Implementa manejo robusto

## Soporte

Para soporte o preguntas sobre el modelo de datos:

- 📧 Email: dev@lagata.com
- 📱 WhatsApp: +505 1234-5678
- 🐛 Issues: [GitHub Issues](https://github.com/lagata/issues)

---

**Versión**: 1.0.0  
**Última actualización**: Enero 2024  
**Mantenido por**: Equipo de Desarrollo La Gata




