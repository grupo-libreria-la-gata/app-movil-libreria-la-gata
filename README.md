# AviFy - Plataforma de Aviturismo

## 📋 Descripción del Proyecto

AviFy es una aplicación móvil desarrollada en Flutter para promover el aviturismo y las reservas naturales de Nicaragua. La plataforma centraliza información de especies de aves, gestiona reservas de visitas guiadas y facilita la conexión entre operadores locales con turistas nacionales e internacionales.

## 🎯 Objetivos del MVP

### Funcionalidades Prioridad Alta (MVP)
- ✅ Autenticación básica (registro/login)
- ✅ Listado de reservas naturales
- ✅ Ficha de reserva con información y mapa
- ✅ Catálogo de aves con fotos y descripciones
- ✅ Sistema de reservas online
- ✅ Panel básico para operadores

### Funcionalidades Prioridad Media
- 📅 Calendario de temporadas y eventos
- 📚 Módulo educativo
- 💬 Chat básico entre turista y guía
- 🔔 Notificaciones push

### Funcionalidades Prioridad Baja
- 🐦 Conteos ciudadanos (crowdsourcing)
- ⭐ Sistema de valoraciones/reseñas
- 🌍 Multi-idioma (español/inglés)

## 🏗️ Arquitectura del Proyecto

### Estructura de Carpetas
```
lib/
├── main.dart
├── src/
│   ├── config/
│   │   ├── app_config.dart
│   │   └── feature_flags.dart
│   ├── core/
│   │   ├── design/
│   │   │   └── design_tokens.dart
│   │   ├── interfaces/
│   │   │   └── api_interfaces.dart
│   │   ├── theme/
│   │   │   └── app_theme.dart
│   │   └── utils/
│   │       └── helpers.dart
│   ├── data/
│   │   ├── models/
│   │   │   ├── user_model.dart
│   │   │   ├── bird_model.dart
│   │   │   ├── reserve_model.dart
│   │   │   └── booking_model.dart
│   │   └── services/
│   │       ├── api_service.dart
│   │       ├── auth_service.dart
│   │       └── database_service.dart
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── user.dart
│   │   │   ├── bird.dart
│   │   │   ├── reserve.dart
│   │   │   └── booking.dart
│   │   └── repositories/
│   │       ├── user_repository.dart
│   │       ├── bird_repository.dart
│   │       ├── reserve_repository.dart
│   │       └── booking_repository.dart
│   ├── presentation/
│   │   ├── pages/
│   │   │   ├── home_page.dart
│   │   │   ├── auth/
│   │   │   │   ├── login_page.dart
│   │   │   │   ├── register_page.dart
│   │   │   │   ├── forgot_password_page.dart
│   │   │   │   └── email_verification_page.dart
│   │   │   ├── reserves/
│   │   │   │   ├── reserves_page.dart
│   │   │   │   └── reserve_detail_page.dart
│   │   │   ├── birds/
│   │   │   │   ├── birds_page.dart
│   │   │   │   └── bird_detail_page.dart
│   │   │   ├── bookings/
│   │   │   │   ├── bookings_page.dart
│   │   │   │   └── create_booking_page.dart
│   │   │   ├── events/
│   │   │   │   └── events_page.dart
│   │   │   ├── education/
│   │   │   │   └── education_page.dart
│   │   │   └── profile/
│   │   │       └── profile_page.dart
│   │   ├── providers/
│   │   │   ├── auth_provider.dart
│   │   │   ├── bird_provider.dart
│   │   │   ├── reserve_provider.dart
│   │   │   └── booking_provider.dart
│   │   └── widgets/
│   │       ├── custom_button.dart
│   │       ├── bird_card.dart
│   │       ├── reserve_card.dart
│   │       └── loading_widget.dart
│   └── routes/
│       └── app_routes.dart
└── docs/
    └── TEAM_COORDINATION.md
```

### **Patrones de Diseño Implementados**
- **Clean Architecture:** Separación de responsabilidades
- **Repository Pattern:** Abstracción de fuentes de datos
- **Provider/Riverpod:** Gestión de estado
- **Feature Flags:** Control de funcionalidades
- **Design Tokens:** Sistema de diseño centralizado

## 🗄️ Base de Datos

### Tablas Principales
- **Users**: Usuarios del sistema (turistas, guías, admin)
- **Birds**: Catálogo de aves con información detallada
- **Reserves**: Reservas naturales habilitadas
- **Guides**: Guías certificados
- **Bookings**: Reservas de visitas
- **Events**: Eventos y temporadas
- **Sightings**: Avistamientos ciudadanos
- **Reviews**: Valoraciones y reseñas

## 🛠️ Tecnologías y Dependencias

### Dependencias Principales
```yaml
# State Management
provider: ^6.1.1
riverpod: ^2.4.9
flutter_riverpod: ^2.4.9

# Networking & API
http: ^1.1.0
dio: ^5.4.0

# Local Database
sqflite: ^2.3.0
path: ^1.8.3

# Authentication
firebase_auth: ^4.15.3
google_sign_in: ^6.1.6

# Maps & Location
google_maps_flutter: ^2.5.3
geolocator: ^10.1.0

# Navigation
go_router: ^12.1.3

# UI Components
cached_network_image: ^3.3.0
flutter_staggered_grid_view: ^0.7.0
shimmer: ^3.0.0
```

## 🚀 Plan de Implementación

### Fase 1: Configuración Base (Completado)
- ✅ Estructura de carpetas
- ✅ Configuración de dependencias
- ✅ Tema de la aplicación
- ✅ Rutas principales
- ✅ Página de inicio

### Fase 2: Autenticación y Usuarios
- 🔄 Entidades y modelos de usuario
- 🔄 Servicios de autenticación
- 🔄 Páginas de login/registro
- 🔄 Providers de estado

### Fase 3: Reservas Naturales
- 🔄 Entidades y modelos de reservas
- 🔄 API service para reservas
- 🔄 Páginas de listado y detalle
- 🔄 Integración con mapas

### Fase 4: Catálogo de Aves
- 🔄 Entidades y modelos de aves
- 🔄 API service para aves
- 🔄 Páginas de catálogo y detalle
- 🔄 Filtros y búsqueda

### Fase 5: Sistema de Reservas
- 🔄 Entidades y modelos de bookings
- 🔄 API service para reservas
- 🔄 Páginas de creación y gestión
- 🔄 Integración con guías

### Fase 6: Funcionalidades Adicionales
- 🔄 Eventos y calendario
- 🔄 Módulo educativo
- 🔄 Notificaciones
- 🔄 Panel de administración

## 📱 Características de la UI/UX

### Diseño
- **Tema**: Material Design 3 con colores naturales
- **Paleta**: Verde (naturaleza), Azul (aves), Naranja (accent)
- **Tipografía**: Poppins (moderna y legible)
- **Iconografía**: Material Icons + iconos personalizados

### Navegación
- **Bottom Navigation**: Para secciones principales
- **Drawer**: Menú lateral para opciones adicionales
- **Breadcrumbs**: Para navegación profunda
- **Gestos**: Swipe para acciones rápidas

## 🔧 Configuración del Entorno

### Requisitos
- Flutter SDK: ^3.8.1
- Dart SDK: ^3.8.1
- Android Studio / VS Code
- Git

### Instalación
```bash
# Clonar el repositorio
git clone [url-del-repositorio]

# Instalar dependencias
flutter pub get

# Ejecutar la aplicación
flutter run
```

### Configuración de APIs
1. **Google Maps API Key**: Configurar en `app_config.dart`
2. **Firebase**: Configurar proyecto y credenciales
3. **Backend API**: Configurar URL base en `app_config.dart`

## 📊 Métricas y Analytics

### KPIs del MVP
- Usuarios registrados
- Reservas creadas
- Tiempo de sesión
- Tasa de conversión
- Valoraciones promedio

### Herramientas
- Firebase Analytics
- Crashlytics
- Performance Monitoring

## 🔒 Seguridad

### Implementaciones
- Autenticación JWT
- Encriptación de datos sensibles
- Validación de entrada
- Rate limiting
- HTTPS obligatorio

## 🧪 Testing

### Estrategia
- **Unit Tests**: Lógica de negocio
- **Widget Tests**: Componentes UI
- **Integration Tests**: Flujos completos
- **E2E Tests**: Casos de uso críticos

## 📦 Despliegue

### Plataformas
- **Android**: Google Play Store
- **iOS**: App Store
- **Web**: PWA (futuro)

### CI/CD
- GitHub Actions
- Firebase App Distribution
- Automated testing
- Code quality checks

## 🤝 Contribución

### Guías
1. Fork del repositorio
2. Crear rama feature: `git checkout -b feature/nueva-funcionalidad`
3. Commit cambios: `git commit -m 'Agregar nueva funcionalidad'`
4. Push a la rama: `git push origin feature/nueva-funcionalidad`
5. Crear Pull Request

### Estándares de Código
- Dart/Flutter linting rules
- Conventional commits
- Code review obligatorio
- Documentación inline

## 📞 Contacto

- **Desarrollador**: [Tu Nombre]
- **Email**: [tu-email@ejemplo.com]
- **Proyecto**: AveTurismo Nicaragua

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

---

**Nota**: Este es un proyecto en desarrollo activo. Las funcionalidades se implementarán según las prioridades establecidas en el MVP.
