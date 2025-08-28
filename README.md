# La Gata — App móvil para la librería

## 📋 Descripción del Proyecto

**La Gata** es una aplicación móvil desarrollada en **Flutter** que facilita la gestión y venta de libros para la librería "La Gata". Permite a los usuarios navegar el catálogo, consultar fichas de libros, realizar reservas o compras, y a los administradores gestionar inventario, pedidos y promociones.

---

## 🎯 Objetivos del MVP

### Funcionalidades Prioridad Alta (MVP)

* ✅ Autenticación básica (registro/login con email y social login opcional)
* ✅ Catálogo de libros con imágenes, autor, sinopsis y disponibilidad
* ✅ Ficha de libro con detalles, reseñas y botón de compra/reserva
* ✅ Carrito de compras y proceso de checkout simple
* ✅ Panel básico para el personal/administrador (gestionar inventario y pedidos)

### Funcionalidades Prioridad Media

* 📅 Reservas de ejemplares y notificaciones de disponibilidad
* 🔎 Búsqueda avanzada y filtros (género, autor, precio)
* ⭐ Sistema de valoraciones y reseñas
* 🔔 Notificaciones push (promociones, reservas listas)

### Funcionalidades Prioridad Baja

* 🌍 Multi-idioma (español / inglés)
* 📚 Recomendaciones personalizadas
* 🧾 Integración con pasarelas de pago (Stripe/PayPal) para producción

---

## 🏗️ Arquitectura del Proyecto

Se mantiene una estructura basada en **Clean Architecture** y separación por capas (presentation, domain, data). Se usa **Provider / Riverpod** para el manejo de estado.

```
lib/
├── main.dart
├── src/
│   ├── config/
│   │   ├── app_config.dart
│   │   └── env.dart
│   ├── core/
│   │   ├── design/
│   │   │   └── design_tokens.dart
│   │   ├── utils/
│   │   │   └── helpers.dart
│   ├── data/
│   │   ├── models/
│   │   │   ├── user_model.dart
│   │   │   ├── book_model.dart
│   │   │   ├── order_model.dart
│   │   │   └── review_model.dart
│   │   └── services/
│   │       ├── api_service.dart
│   │       ├── auth_service.dart
│   │       └── local_storage_service.dart
│   ├── domain/
│   │   ├── entities/
│   │   └── repositories/
│   ├── presentation/
│   │   ├── pages/
│   │   ├── providers/
│   │   └── widgets/
│   └── routes/
│       └── app_routes.dart
└── docs/
    └── TEAM_COORDINATION.md
```

---

## 🗄️ Modelo de Datos (resumen)

Tablas / colecciones sugeridas:

* **Users**: id, nombre, email, rol (cliente, personal, admin)
* **Books**: id, título, autor, isbn, precio, stock, sinopsis, imágenes, categorías
* **Orders**: id, userId, items, total, estado, fecha
* **Reviews**: id, bookId, userId, rating, comment, fecha
* **Promotions**: id, bookId, discount, from, to

---

## 🛠️ Tecnologías y Dependencias (sugeridas)

* Flutter SDK: ^3.8.1 (o la versión que use el equipo)
* State Management: `flutter_riverpod`, `provider` (elige uno principal)
* Networking: `dio` o `http`
* Local DB/Cache: `sqflite` o `hive`
* Auth: `firebase_auth` (opcional) / JWT según backend
* UI: `cached_network_image`, `flutter_staggered_grid_view`
* Navigation: `go_router`

Ejemplo en `pubspec.yaml` (resumen):

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.9
  dio: ^5.4.0
  sqflite: ^2.3.0
  cached_network_image: ^3.3.0
  go_router: ^12.1.3
  intl: ^0.18.0
```

---

## 🔧 Configuración del Entorno (local)

1. Clona el repositorio (desde la organización en GitHub):

```bash
git clone https://github.com/ORG/app-movil-libreria-la-gata.git
cd app-movil-libreria-la-gata
```

2. Instala dependencias:

```bash
flutter pub get
```

3. Variables de entorno y configuración:

* Crea un archivo `lib/src/config/env.dart` o usa `.env` para claves privadas (no subir al repo).
* Configura `app_config.dart` con la `API_BASE_URL` y claves de terceros (Firebase, Stripe, etc.).

4. Ejecuta la app:

```bash
flutter run
```

---

## 🧾 .gitignore recomendado (resumen)

Incluye los archivos generados y locales que no deben subirse:

```
.dart_tool/
.packages
build/
ios/Pods/
**/local.properties
.env
*.keystore
```

---

## 🧪 Testing

* Unit tests: lógica de dominio y repositorios
* Widget tests: vistas críticas (carrito, ficha de libro)
* Integration/E2E: flujo de compra

Ejecutar tests:

```bash
flutter test
```

---

## 🚀 CI/CD

Se recomienda usar **GitHub Actions** para:

* Ejecutar `flutter analyze` y `flutter test` en `push`/`pull_request`.
* Generar builds de debug/apk en ramas específicas.

Ejemplo básico de workflow: `.github/workflows/flutter.yml` (ver plantilla en docs).

---

## 🤝 Contribución

Flujo de trabajo recomendado:

1. Fork (si no eres miembro de la organización) o crea rama desde `main`:

```bash
git checkout -b feature/nombre-descriptivo
```

2. Commits claros (Convencional Commits recomendados)
3. Push y Pull Request hacia `main` con descripción y checklist
4. Revisiones de código obligatorias antes de merge

**Reglas rápidas:**

* `main` protegido: merges sólo por PR y con al menos 1 aprobación
* Tests deben pasar antes de merge

---

## 📄 Licencia

Este proyecto usa la **Licencia MIT**. Ver `LICENSE`.

---

## 📞 Contacto

* Coordinador del proyecto: **[Tu Nombre]**
* Email: **[tu-email@ejemplo.com](mailto:tu-email@ejemplo.com)**

---

> *Nota:* Este README está adaptado para el proyecto `app-movil-libreria-la-gata`. Si quieres que lo personalice con el **nombre real de la organización**, **URLs del repo**, o que incluya instrucciones concretas para CI, keys de Firebase o ejemplos de `app_config.dart`, dímelo y lo actualizo.
