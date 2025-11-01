# Configuración de Variables de Entorno

Este proyecto usa variables de entorno para configurar la conexión a la API y otros parámetros.

## 📝 Archivo .env

Crea un archivo `.env` en la raíz del proyecto `LaGata_Movil/` con el siguiente contenido:

```env
# Configuración de la API
API_BASE_URL=http://localhost:5044

# Configuración de la Base de Datos
DATABASE_NAME=la_gata_facturacion.db
DATABASE_VERSION=1

# Configuración de la Aplicación
APP_NAME=La Gata
APP_VERSION=1.0.0

# Configuración de Timeouts (en milisegundos)
CONNECTION_TIMEOUT=30000
RECEIVE_TIMEOUT=30000

# Configuración de Paginación
PAGE_SIZE=20

# Configuración de Cache (días)
CACHE_EXPIRATION_DAYS=7
```

## 🔧 Configuración de la URL de la API

La variable `API_BASE_URL` debe configurarse según tu entorno:

### Para desarrollo local:
- **Web/Desktop**: `http://localhost:5044`
- **Emulador Android**: `http://10.0.2.2:5044`
- **Dispositivo físico Android**: Usa la IP de tu máquina (ej: `http://192.168.1.100:5044`)

### Para encontrar tu IP:
- **Windows**: Ejecuta `ipconfig` y busca "IPv4 Address"
- **Mac/Linux**: Ejecuta `ifconfig` o `ip addr`

## ✅ Verificación

Todos los servicios ahora usan `AppConfig.baseUrl` en lugar de URLs hardcodeadas:

✅ `VentaService`
✅ `CompraService`
✅ `DetalleProductoService`
✅ `ClienteService`
✅ `ProveedorService`
✅ `ProductoService`
✅ `CategoriaService`
✅ `MarcaService`

## 📦 Dependencia

El proyecto usa `flutter_dotenv: ^5.1.0` para cargar las variables de entorno.

## 🚀 Uso

Las variables se cargan automáticamente al iniciar la aplicación en `main.dart`.

Para acceder a las variables en el código:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

String apiUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:5044';
```

O mejor aún, usa `AppConfig`:
```dart
import 'src/config/app_config.dart';

String apiUrl = AppConfig.baseUrl;
```

