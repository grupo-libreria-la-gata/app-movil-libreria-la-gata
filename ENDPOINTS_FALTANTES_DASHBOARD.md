# Endpoints Faltantes para Dashboard

## 📊 Endpoints Disponibles (Ya Implementados)

### ✅ Ventas
1. **GET /api/Ventas/resumen** - Resumen de ventas por período
   - Parámetros: `fechaInicio`, `fechaFin`, `usuarioId`
   - Retorna: `TotalVentas`, `TotalMonto`, `PromedioVenta`, `VentaMinima`, `VentaMaxima`
   - ✅ **Implementado en Flutter**

2. **GET /api/Ventas/top-productos** - Top productos vendidos
   - Parámetros: `fechaInicio`, `fechaFin`, `usuarioId`
   - Retorna: Lista de productos con cantidad, monto y veces vendido
   - ✅ **Implementado en Flutter**

3. **GET /api/Ventas/por-fechas** - Listar ventas por rango de fechas
   - Parámetros: `fechaInicio`, `fechaFin`, `usuarioId`
   - Retorna: Lista de ventas
   - ✅ **Implementado en Flutter**

### ✅ Compras
1. **GET /api/Compras/resumen** - Resumen de compras por período
   - Parámetros: `fechaInicio`, `fechaFin`, `usuarioId`
   - Retorna: `TotalCompras`, `TotalMonto`, `PromedioCompra`, `CompraMinima`, `CompraMaxima`
   - ✅ **Implementado en Flutter**

2. **GET /api/Compras/top-productos** - Top productos comprados
   - Parámetros: `fechaInicio`, `fechaFin`, `usuarioId`
   - Retorna: Lista de productos más comprados
   - ✅ **Implementado en Flutter**

### ✅ Inventario
1. **GET /api/DetalleProductos/activos** - Obtener productos activos
   - Retorna: Lista de productos con stock
   - ✅ **Implementado en Flutter** (usado para calcular stock bajo)

---

## ❌ Endpoints Faltantes para Dashboard Completo

### 1. Distribución de Métodos de Pago
**Endpoint necesario:**
```
GET /api/Ventas/distribucion-metodos-pago
Parámetros: fechaInicio, fechaFin, usuarioId
Retorna: 
{
  "efectivo": { "cantidad": 10, "monto": 50000 },
  "tarjeta": { "cantidad": 8, "monto": 40000 },
  "transferencia": { "cantidad": 5, "monto": 25000 }
}
```
**Estado:** ❌ No existe en el backend
**Uso en Dashboard:** Gráfico donut de métodos de pago

---

### 2. Ventas por Hora del Día
**Endpoint necesario:**
```
GET /api/Ventas/ventas-por-hora
Parámetros: fechaInicio, fechaFin, usuarioId
Retorna: 
[
  { "hora": 8, "cantidadVentas": 3, "montoTotal": 15000 },
  { "hora": 9, "cantidadVentas": 5, "montoTotal": 25000 },
  ...
]
```
**Estado:** ❌ No existe en el backend
**Uso en Dashboard:** Gráfico de barras por hora

---

### 3. Clientes Atendidos (Únicos)
**Endpoint necesario:**
```
GET /api/Ventas/clientes-atendidos
Parámetros: fechaInicio, fechaFin, usuarioId
Retorna: 
{
  "totalClientes": 16,
  "clientesNuevos": 3,
  "clientesRecurrentes": 13
}
```
**Estado:** ❌ No existe en el backend (actualmente se calcula del lado del cliente)
**Uso en Dashboard:** KPI de clientes atendidos

---

### 4. Comparación con Período Anterior
**Endpoint necesario:**
```
GET /api/Ventas/comparacion-periodo
Parámetros: fechaInicio, fechaFin, usuarioId
Retorna: 
{
  "periodoActual": {
    "totalVentas": 18,
    "totalMonto": 125000
  },
  "periodoAnterior": {
    "totalVentas": 15,
    "totalMonto": 110000
  },
  "variacion": {
    "ventas": "+20%",
    "monto": "+13.6%"
  }
}
```
**Estado:** ❌ No existe en el backend
**Uso en Dashboard:** Indicador de tendencia (+12% vs ayer)

---

### 5. Facturas Pendientes de Cobro
**Endpoint necesario:**
```
GET /api/Ventas/pendientes-cobro
Parámetros: usuarioId
Retorna: 
{
  "totalPendientes": 5,
  "montoTotal": 42500,
  "facturas": [...]
}
```
**Estado:** ❌ No existe en el backend (actualmente se calcula del lado del cliente)
**Uso en Dashboard:** Indicador accionable de facturas por cobrar

---

### 6. Compras Pendientes de Pago
**Endpoint necesario:**
```
GET /api/Compras/pendientes-pago
Parámetros: usuarioId
Retorna: 
{
  "totalPendientes": 3,
  "montoTotal": 18000,
  "compras": [...]
}
```
**Estado:** ❌ No existe en el backend
**Uso en Dashboard:** Indicador accionable de compras por pagar

---

### 7. Productos con Stock Bajo (Endpoint Específico)
**Endpoint necesario:**
```
GET /api/DetalleProductos/stock-bajo
Parámetros: limite (opcional, default: 10)
Retorna: Lista de productos con stockActual <= stockMinimo
```
**Estado:** ❌ No existe en el backend (actualmente se filtra del lado del cliente)
**Uso en Dashboard:** KPI y lista de productos con stock crítico

---

## 📝 Resumen de Prioridades

### Alta Prioridad (Necesarios para funcionalidad completa):
1. ✅ **GET /api/Ventas/resumen** - Ya implementado
2. ✅ **GET /api/Ventas/por-fechas** - Ya implementado
3. ❌ **GET /api/Ventas/distribucion-metodos-pago** - **FALTANTE**
4. ❌ **GET /api/Ventas/ventas-por-hora** - **FALTANTE**

### Media Prioridad (Mejoras de UX):
5. ❌ **GET /api/Ventas/clientes-atendidos** - **FALTANTE**
6. ❌ **GET /api/Ventas/comparacion-periodo** - **FALTANTE**
7. ❌ **GET /api/DetalleProductos/stock-bajo** - **FALTANTE**

### Baja Prioridad (Funcionalidades adicionales):
8. ❌ **GET /api/Ventas/pendientes-cobro** - **FALTANTE**
9. ❌ **GET /api/Compras/pendientes-pago** - **FALTANTE**

---

## 🎯 Recomendaciones

1. **Implementar primero:**
   - Distribución de métodos de pago (para el gráfico donut)
   - Ventas por hora (para el gráfico de barras)
   - Stock bajo (endpoint específico más eficiente)

2. **Mejoras sugeridas:**
   - Agregar campo `clienteId` y `metodoPago` en `VentaListResponse` (ya corregido en Flutter)
   - Crear endpoint combinado de dashboard que retorne todos los KPIs en una sola llamada

3. **Workaround actual:**
   - El dashboard calcula algunos datos del lado del cliente usando los endpoints disponibles
   - Los gráficos usan datos simulados hasta que se implementen los endpoints faltantes


