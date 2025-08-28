# Coordinación del Equipo - AveTurismo Nicaragua

## 📋 **Información del Proyecto**

**Proyecto:** AviFy - Aplicación Móvil  
**Tecnología:** Flutter/Dart  
**Arquitectura:** Clean Architecture  
**Estado:** Desarrollo MVP  

## 👥 **Equipo**

### **Desarrollo Móvil (Flutter)**
- **Responsable:** Juan Nicolas Lopez
- **Rol:** Desarrollador Flutter
- **Tareas:** Desarrollo de la aplicación móvil, UI/UX, integración con API

### **Backend (.NET)**
- **Responsable:** [Nombre del desarrollador backend]
- **Rol:** Desarrollador Backend
- **Tareas:** API REST, base de datos SQL Server, autenticación

### **Frontend Web**
- **Responsable:** [Nombre del desarrollador frontend]
- **Rol:** Desarrollador Frontend Web
- **Tareas:** Página web, dashboard administrativo

### **Diseño UX/UI**
- **Responsable:** [Nombre de la diseñadora]
- **Rol:** Diseñadora Gráfica/UX
- **Tareas:** Diseño de interfaz, identidad visual, experiencia de usuario

## 🏗️ **Arquitectura del Proyecto**

### **Estructura de Carpetas**
```
lib/
├── src/
│   ├── config/           # Configuraciones (AppConfig, FeatureFlags)
│   ├── core/             # Lógica central (interfaces, utils, design)
│   ├── data/             # Capa de datos (repositories, datasources)
│   ├── domain/           # Entidades y casos de uso
│   └── presentation/     # UI y controladores
├── assets/               # Recursos (imágenes, fuentes, etc.)
└── docs/                 # Documentación
```

### **Patrones de Diseño**
- **Clean Architecture:** Separación de responsabilidades
- **Repository Pattern:** Abstracción de fuentes de datos
- **Provider/Riverpod:** Gestión de estado
- **Feature Flags:** Control de funcionalidades

## 🔄 **Proceso de Integración**

### **Fase 1: Desarrollo Paralelo (Actual)**
- ✅ **Móvil:** Páginas de autenticación, navegación básica
- 🔄 **Backend:** Desarrollo de API y base de datos
- 🔄 **Web:** Desarrollo del frontend
- 🔄 **Diseño:** Creación de identidad visual

### **Fase 2: Integración API**
1. **Definir contratos de API** (interfaces ya creadas)
2. **Implementar servicios mock** (datos de prueba)
3. **Integrar API real** cuando esté lista
4. **Testing de integración**

### **Fase 3: Diseño Final**
1. **Recibir diseño de UX/UI**
2. **Actualizar Design Tokens**
3. **Adaptar componentes existentes**
4. **Testing de UI/UX**

### **Fase 4: Testing y Despliegue**
1. **Testing en Android Studio**
2. **Testing en dispositivos reales**
3. **Optimización de rendimiento**
4. **Despliegue a producción**

## 📝 **Convenciones de Código**

### **Nomenclatura**
```dart
// Clases: PascalCase
class UserRepository { }

// Variables y métodos: camelCase
String userName;
void getUserData() { }

// Constantes: SCREAMING_SNAKE_CASE
static const String API_BASE_URL = 'https://api.aveturismo.com';

// Archivos: snake_case
user_repository.dart
auth_service.dart
```

### **Estructura de Archivos**
```dart
// Cada archivo debe tener:
/// Descripción de la clase/función
/// 
/// TODO: Tareas pendientes
/// 
/// Autor: [Nombre]
/// Fecha: [Fecha]

import 'package:flutter/material.dart';

class MiClase {
  // Constantes estáticas primero
  static const String _privateConstant = 'valor';
  
  // Variables de instancia
  final String _privateVariable;
  
  // Constructor
  const MiClase(this._privateVariable);
  
  // Métodos públicos
  void publicMethod() { }
  
  // Métodos privados
  void _privateMethod() { }
}
```

### **Comentarios**
```dart
/// Comentario de documentación para clases y métodos públicos
/// 
/// Ejemplo de uso:
/// ```dart
/// final user = User(name: 'Juan');
/// ```
class User {
  // Comentario de línea para lógica compleja
  final String name;
  
  /// Constructor de la clase User
  /// 
  /// [name] - Nombre del usuario
  const User({required this.name});
}
```

## 🔧 **Configuración de Desarrollo**

### **Feature Flags**
Los feature flags permiten controlar funcionalidades según el estado de desarrollo:

```dart
// Habilitar/deshabilitar funcionalidades
if (FeatureFlags.isEnabled('real_api')) {
  // Usar API real
} else {
  // Usar datos mock
}
```

### **Design Tokens**
Los design tokens centralizan los elementos de diseño:

```dart
// Usar colores del sistema de diseño
Container(
  color: DesignTokens.primaryColor,
  padding: EdgeInsets.all(DesignTokens.spacingMd),
)
```

## 📊 **Estado del Desarrollo**

### **MVP (Prioridad Alta)**
- ✅ Autenticación básica (páginas creadas)
- 🔄 Listado de reservas naturales
- ⏳ Catálogo de aves
- ⏳ Sistema de reservas
- ⏳ Panel admin básico

### **Prioridad Media**
- ⏳ Calendario de eventos
- ⏳ Módulo educativo
- ⏳ Chat básico
- ⏳ Notificaciones push

### **Prioridad Baja**
- ⏳ Ciencia ciudadana
- ⏳ Sistema de reseñas
- ⏳ Multi-idioma

## 🚀 **Comandos Útiles**

### **Desarrollo**
```bash
# Limpiar y reinstalar dependencias
flutter clean && flutter pub get

# Ejecutar en Chrome (desarrollo)
flutter run -d chrome

# Ejecutar en Android Studio
flutter run -d android

# Analizar código
flutter analyze

# Ejecutar tests
flutter test
```

### **Git**
```bash
# Ver estado
git status

# Agregar cambios
git add .

# Commit con mensaje descriptivo
git commit -m "feat: descripción del cambio"

# Push a repositorio
git push origin main
```

## 📞 **Comunicación**

### **Canal Principal**
- **Plataforma:** [Slack/Discord/Teams]
- **Canal:** #aveturismo-mobile

### **Reuniones**
- **Sprint Planning:** Lunes 9:00 AM
- **Daily Standup:** 10:00 AM
- **Sprint Review:** Viernes 4:00 PM

### **Documentación Compartida**
- **Figma:** [Link al diseño]
- **API Docs:** [Link a documentación]
- **ClickUp:** https://app.clickup.com/90132174146/v/l/6-901317923368-1

## 🔍 **Checklist de Integración**

### **Antes de Integrar API**
- [ ] Interfaces de API definidas
- [ ] Servicios mock implementados
- [ ] Manejo de errores configurado
- [ ] Testing de servicios mock

### **Antes de Integrar Diseño**
- [ ] Design tokens actualizados
- [ ] Componentes reutilizables creados
- [ ] Sistema de colores implementado
- [ ] Tipografías configuradas

### **Antes de Testing**
- [ ] Feature flags configurados
- [ ] Datos de prueba preparados
- [ ] Flujos de usuario documentados
- [ ] Casos de prueba definidos

## 📚 **Recursos**

### **Documentación Flutter**
- [Flutter Docs](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)

### **Patrones de Diseño**
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Repository Pattern](https://martinfowler.com/eaaCatalog/repository.html)

### **Herramientas**
- [Flutter Inspector](https://docs.flutter.dev/development/tools/flutter-inspector)
- [Dart DevTools](https://dart.dev/tools/dart-devtools)

---

**Última actualización:** 22/08/25 
**Versión del documento:** 1.0  
**Autor:** Juan Nicolas lopez baltodano (Team lead)
