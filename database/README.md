# 🗄️ StockFlow Database Schema

## 📋 Descripción General

Base de datos diseñada para el sistema de gestión de inventario StockFlow, optimizada para pequeñas y medianas empresas que requieren control de stock, facturación y reportes financieros.

## 🏗️ Arquitectura de la Base de Datos

### 📊 Entidades Principales

#### 🏢 **Entidades de Negocio**
| Entidad | Descripción | Registros Estimados |
|---------|-------------|-------------------|
| `users` | Usuarios del sistema con roles | 5-50 |
| `products` | Catálogo de productos | 100-10,000 |
| `customers` | Base de clientes | 50-5,000 |
| `suppliers` | Proveedores | 5-100 |
| `categories` | Categorías jerárquicas | 10-100 |
| `sales` | Ventas/facturas | 1,000-100,000/año |
| `inventory_movements` | Movimientos de stock | 10,000-1M/año |

#### 🎛️ **Entidades de Control de Aplicación**
| Entidad | Descripción | Registros Estimados |
|---------|-------------|-------------------|
| `app_modules` | Módulos de la aplicación | 10-20 |
| `app_views` | Vistas/pantallas | 50-200 |
| `app_components` | Componentes UI | 100-500 |
| `app_actions` | Acciones/botones | 200-1000 |
| `app_permissions` | Permisos granulares | 100-500 |
| `app_navigation` | Menús y navegación | 20-50 |
| `app_settings` | Configuración global | 50-200 |

### 🔗 Relaciones Clave

```
users (1) ──── (N) sales
customers (1) ── (N) sales  
sales (1) ────── (N) sale_items
products (1) ─── (N) sale_items
products (1) ─── (N) inventory_movements
products (1) ─── (1) current_stock
```

## 🎯 Funcionalidades Implementadas

### 🎛️ **Sistema de Control de Aplicación (REVOLUCIONARIO)**
- **🎨 UI Dinámica**: Componentes configurables desde BD
- **🛣️ Rutas Dinámicas**: Navegación controlada por permisos
- **📋 Formularios Configurables**: Campos y validaciones desde BD
- **📊 Tablas Personalizables**: Columnas y filtros dinámicos
- **🔐 Permisos Granulares**: Control por módulo/vista/acción
- **⚙️ Configuración Centralizada**: Toda la app configurable
- **📱 Responsive Automático**: Layouts adaptativos
- **🌐 Multi-idioma Ready**: Textos configurables

### ✅ Gestión de Usuarios
- **Roles**: Admin, Cajero, Contador  
- **Autenticación**: Hash de contraseñas con bcrypt + salt único
- **Seguridad avanzada**: 
  - Salt único por usuario (previene rainbow tables)
  - Protección contra fuerza bruta (5 intentos = bloqueo 30 min)
  - Tokens seguros para reseteo de contraseña
  - Auditoría completa de accesos
- **Funciones de seguridad**: 
  - `increment_failed_login()` - Control de intentos fallidos
  - `reset_failed_login()` - Reseteo en login exitoso  
  - `is_account_locked()` - Verificación de bloqueo
  - `generate_salt()` - Generación automática de salt

### ✅ Control de Inventario
- **Stock en tiempo real**: Trigger automático para actualizar stock
- **Costo promedio ponderado**: Cálculo automático con cada entrada
- **Alertas de stock bajo**: Vista con productos bajo mínimo
- **Trazabilidad completa**: Registro de todos los movimientos

### ✅ Sistema de Ventas
- **Facturación completa**: Cumple normativa DIAN
- **Múltiples métodos de pago**: Efectivo, tarjetas, crédito
- **Cálculo automático de totales**: Triggers para subtotales e impuestos
- **Gestión de pagos**: Registro de pagos parciales y totales

### ✅ Gestión de Compras
- **Órdenes de compra**: Control de pedidos a proveedores
- **Recepción de mercancía**: Seguimiento de entregas
- **Actualización automática de stock**: Al recibir productos

## 🔧 Características Técnicas

### 🚀 Performance
- **Índices optimizados**: Para consultas frecuentes
- **Vistas materializadas**: Para reportes complejos
- **Índices compuestos**: Para búsquedas multi-criterio
- **Búsqueda de texto completo**: Para productos

### 🛡️ Integridad de Datos
- **Triggers automáticos**: Para mantener consistencia
- **Constraints**: Validaciones a nivel de BD
- **Transacciones**: Para operaciones críticas
- **Auditoría**: Timestamps automáticos

### 📈 Escalabilidad
- **UUIDs**: Para distribución futura
- **Particionado preparado**: Para tablas grandes
- **Índices selectivos**: Para consultas específicas
- **Archivado**: Estrategia para datos históricos

## 📁 Estructura de Archivos

```
database/
├── schema.dbml          # Esquema principal en DBML
├── triggers.sql         # Triggers y funciones
├── seeds.sql           # Datos de prueba (próximo)
├── migrations/         # Migraciones (próximo)
└── README.md           # Esta documentación
```

## 🛠️ Instalación y Setup

### 1. **Requisitos**
```bash
# PostgreSQL 14+
sudo apt install postgresql postgresql-contrib

# dbml-cli para generar SQL desde DBML
npm install -g @dbml/cli
```

### 2. **Generar SQL desde DBML**
```bash
# Generar schema SQL
dbml2sql schema.dbml --postgres -o schema.sql

# Aplicar a base de datos
psql -U postgres -d stockflow < schema.sql
psql -U postgres -d stockflow < triggers.sql
```

### 3. **Verificar Instalación**
```sql
-- Verificar tablas creadas
\dt

-- Verificar triggers
\df

-- Verificar vistas
\dv
```

## 📊 Consultas de Ejemplo

### Top 10 Productos Más Vendidos
```sql
SELECT * FROM v_top_selling_products LIMIT 10;
```

### Productos con Stock Bajo
```sql
SELECT * FROM v_current_stock_detailed 
WHERE low_stock_alert = true;
```

### Ventas del Mes Actual
```sql
SELECT 
    COUNT(*) as total_sales,
    SUM(total_amount) as total_revenue
FROM sales 
WHERE sale_date >= DATE_TRUNC('month', CURRENT_DATE)
AND status = 'pagada';
```

### Movimientos de Inventario por Producto
```sql
SELECT 
    p.name,
    im.movement_type,
    im.quantity,
    im.created_at
FROM inventory_movements im
JOIN products p ON im.product_id = p.id
WHERE p.sku = 'PROD-001'
ORDER BY im.created_at DESC;
```

## 🎨 Visualización del Esquema

Para generar diagramas visuales:

1. **dbdiagram.io**: Pegar el contenido de `schema.dbml`
2. **draw.io**: Importar SQL generado
3. **DBeaver**: Conectar a BD y generar diagrama ER

## 🔄 Próximos Pasos

- [ ] **Migraciones**: Sistema de versionado de BD
- [ ] **Seeds**: Datos de prueba realistas
- [ ] **Backup automático**: Scripts de respaldo
- [ ] **Monitoring**: Métricas de performance
- [ ] **Archivado**: Estrategia para datos antiguos

## 📈 Métricas de Diseño

- **Tiempo de consulta stock**: < 10ms
- **Inserción de venta**: < 50ms
- **Reporte mensual**: < 2s
- **Búsqueda de productos**: < 100ms
- **Actualización de stock**: Automática (triggers)

## 🤝 Contribución

Para modificar el esquema:

1. Editar `schema.dbml`
2. Regenerar SQL con `dbml2sql`
3. Crear migración para cambios
4. Actualizar documentación
5. Ejecutar tests de integridad

---

**Nota**: Este esquema está diseñado para ser escalable y seguir las mejores prácticas de diseño de bases de datos relacionales.