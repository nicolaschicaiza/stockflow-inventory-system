# 🎨 Guía Completa de Wireframes en Figma para StockFlow

## 📋 **Índice**
1. [Setup Inicial en Figma](#setup-inicial)
2. [Sistema de Diseño](#sistema-de-diseño)
3. [Componentes Base](#componentes-base)
4. [Pantallas Principales](#pantallas-principales)
5. [Prototipado Interactivo](#prototipado)
6. [Documentación y Handoff](#documentación)
7. [Recursos y Assets](#recursos)

---

## 🚀 **Setup Inicial en Figma** {#setup-inicial}

### **Paso 1: Crear Proyecto**
1. **Ir a Figma.com** → Crear cuenta gratuita
2. **Crear nuevo archivo** → "StockFlow - Wireframes & Design System"
3. **Configurar páginas**:
   ```
   📄 Cover (Portada del proyecto)
   📄 Design System (Componentes y estilos)
   📄 Wireframes (Bocetos low-fi)
   📄 UI Design (Diseño final)
   📄 Prototypes (Flujos interactivos)
   📄 Developer Handoff (Especificaciones)
   ```

### **Paso 2: Configurar Workspace**
```figma
// Configuración de Canvas
- Frame size: Desktop (1440x1024)
- Mobile breakpoint: 375x812 (iPhone)
- Tablet breakpoint: 768x1024 (iPad)

// Grid System
- Columns: 12 columnas
- Gutter: 24px
- Margin: 80px (Desktop), 24px (Mobile)
```

---

## 🎨 **Sistema de Diseño** {#sistema-de-diseño}

### **Paso 3: Color Palette**

#### **Colores Primarios**
```scss
// Brand Colors (basado en tu BD)
$primary-blue: #2563EB    // Dashboard, acciones principales
$success-green: #059669   // Inventario, confirmaciones
$danger-red: #DC2626      // Ventas, alertas, eliminar
$warning-orange: #EA580C  // Reportes, advertencias
$purple: #7C3AED          // Compras, funciones premium
$gray: #6B7280            // Administración, neutro

// Semantic Colors
$success: #10B981
$warning: #F59E0B
$error: #EF4444
$info: #3B82F6

// Neutral Scale
$gray-50: #F9FAFB
$gray-100: #F3F4F6
$gray-200: #E5E7EB
$gray-300: #D1D5DB
$gray-400: #9CA3AF
$gray-500: #6B7280
$gray-600: #4B5563
$gray-700: #374151
$gray-800: #1F2937
$gray-900: #111827
```

#### **Crear Color Styles en Figma:**
1. **Seleccionar rectangle** → Fill → Crear estilo
2. **Nombrar**: `Primary/Blue-500`, `Success/Green-500`, etc.
3. **Agrupar por categorías**: Primary, Semantic, Gray Scale

### **Paso 4: Typography Scale**

#### **Fuentes del Sistema**
```css
/* Primary Font */
font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;

/* Typography Scale */
.text-xs { font-size: 12px; line-height: 16px; }    /* Captions, labels */
.text-sm { font-size: 14px; line-height: 20px; }    /* Body small, forms */
.text-base { font-size: 16px; line-height: 24px; }  /* Body text */
.text-lg { font-size: 18px; line-height: 28px; }    /* Lead text */
.text-xl { font-size: 20px; line-height: 28px; }    /* H4 */
.text-2xl { font-size: 24px; line-height: 32px; }   /* H3 */
.text-3xl { font-size: 30px; line-height: 36px; }   /* H2 */
.text-4xl { font-size: 36px; line-height: 40px; }   /* H1 */

/* Font Weights */
.font-normal { font-weight: 400; }
.font-medium { font-weight: 500; }
.font-semibold { font-weight: 600; }
.font-bold { font-weight: 700; }
```

#### **Crear Text Styles en Figma:**
1. **Crear texto de ejemplo** para cada tamaño
2. **Aplicar Inter font** (Google Fonts)
3. **Crear estilos**: `H1/Bold`, `Body/Regular`, `Caption/Medium`, etc.

### **Paso 5: Spacing System**

```scss
// Spacing Scale (múltiplos de 4px)
$spacing-1: 4px;    // xs - iconos pequeños
$spacing-2: 8px;    // sm - espaciado mínimo
$spacing-3: 12px;   // md - elementos relacionados
$spacing-4: 16px;   // base - espaciado estándar
$spacing-5: 20px;   // lg - separación de secciones
$spacing-6: 24px;   // xl - márgenes principales
$spacing-8: 32px;   // 2xl - separación de componentes
$spacing-10: 40px;  // 3xl - separación de módulos
$spacing-12: 48px;  // 4xl - espaciado hero
$spacing-16: 64px;  // 5xl - espaciado de página
```

### **Paso 6: Components Library**

#### **6.1 Crear Componentes Base**

##### **Button Component**
```figma
// Estados del botón
Primary Button
├── Default (bg: primary-blue, text: white)
├── Hover (bg: primary-blue-600, shadow)
├── Pressed (bg: primary-blue-700)
├── Disabled (bg: gray-100, text: gray-400)

Secondary Button  
├── Default (border: gray-300, text: gray-700)
├── Hover (bg: gray-50)
├── Pressed (bg: gray-100)

Danger Button
├── Default (bg: red-600, text: white)
├── Hover (bg: red-700)

// Variantes por tamaño
├── Small (32px height, 12px padding)
├── Medium (40px height, 16px padding) 
├── Large (48px height, 20px padding)
```

**Propiedades del componente:**
- **Type**: Primary, Secondary, Danger
- **Size**: Small, Medium, Large  
- **State**: Default, Hover, Pressed, Disabled
- **Icon**: None, Left, Right, Only
- **Full Width**: Boolean

##### **Input Field Component**
```figma
Input Field
├── Default
├── Focused (border: primary-blue)
├── Error (border: red-500, helper text red)
├── Disabled (bg: gray-50)
├── With Icon (search, calendar, etc.)

// Variantes
├── Text Input
├── Email Input  
├── Password Input
├── Number Input
├── Search Input
├── Textarea
```

##### **Card Component**
```figma
Card
├── Default (bg: white, border: gray-200, shadow-sm)
├── Hover (shadow-md)
├── Selected (border: primary-blue)

// Variantes de contenido
├── Basic Card (padding, title, content)
├── Stat Card (number, label, trend)
├── Product Card (image, title, price, actions)
├── List Item Card (avatar, title, meta, actions)
```

#### **6.2 Componentes de Layout**

##### **Navigation Sidebar**
```figma
Sidebar
├── Expanded (280px width)
├── Collapsed (72px width)

// Elementos internos
├── Logo Area
├── Navigation Items
│   ├── Active (bg: primary-blue-50, text: primary-blue)
│   ├── Inactive (text: gray-600)
│   ├── With Submenu
├── User Profile Section
├── Settings/Logout
```

##### **Header/Topbar**
```figma
Header (height: 64px)
├── Left Section (breadcrumbs, page title)
├── Center Section (search bar)
├── Right Section (notifications, user menu)
```

##### **Data Table Component**
```figma
Data Table
├── Header Row (sortable columns)
├── Data Rows
├── Selection (checkbox column)
├── Actions Column (edit, delete, more)
├── Pagination Footer
├── Loading State
├── Empty State
├── Filters Panel (collapsible)
```

---

## 📱 **Pantallas Principales** {#pantallas-principales}

### **Paso 7: Wireframes Low-Fidelity**

#### **7.1 Dashboard Principal**

**Información mostrada** (basada en tu BD):
```sql
-- Métricas desde tu BD
- Total ventas del mes (sales table)
- Productos con stock bajo (current_stock + products)
- Top productos vendidos (v_top_selling_products view)
- Ventas recientes (sales + customers)
```

**Layout Wireframe:**
```
┌─ Header (breadcrumbs: Dashboard) ──────────────────┐
│ ┌─ Stats Grid (4 columnas) ─────────────────────┐  │
│ │ [Ventas Hoy] [Stock Bajo] [Clientes] [Órdenes]│  │
│ └─────────────────────────────────────────────┘   │
│ ┌─ Charts Section ─────────────────────────────┐   │
│ │ ┌─ Sales Chart ──┐ ┌─ Top Products ────────┐ │   │
│ │ │ Line Chart     │ │ Table (5 rows)       │ │   │
│ │ │ (Last 30 days) │ │ - Product name       │ │   │
│ │ │                │ │ - Quantity sold      │ │   │
│ │ │                │ │ - Revenue            │ │   │
│ │ └────────────────┘ └──────────────────────┘ │   │
│ └─────────────────────────────────────────────┘   │
│ ┌─ Recent Activity ───────────────────────────┐    │
│ │ - Latest sales                              │    │
│ │ - Low stock alerts                          │    │
│ │ - Recent customers                          │    │
│ └─────────────────────────────────────────────┘    │
└───────────────────────────────────────────────────┘
```

**Figma Steps:**
1. **Crear frame** 1440x1024 "Dashboard - Desktop"
2. **Agregar grid** 12 columnas
3. **Usar auto-layout** para secciones
4. **Placeholder components**:
   - Stats cards (4 columnas)
   - Chart placeholders (graybox con "Chart" label)
   - Table placeholder (líneas grises)

#### **7.2 Lista de Productos**

**Funcionalidades** (basadas en tu app_* tables):
```sql
-- Basado en tu configuración de BD
- Filtros: category, supplier, status (app_components)
- Columnas: name, sku, category, stock, cost, price, actions (app_table_columns)
- Acciones: create, edit, delete, export (app_actions)
- Búsqueda: name, sku, barcode (app_components search)
```

**Layout Wireframe:**
```
┌─ Header (breadcrumbs: Inventario > Productos) ────┐
│ ┌─ Actions Bar ─────────────────────────────────┐  │
│ │ [Nuevo Producto] [Exportar] [Importar]   🔍   │  │
│ └─────────────────────────────────────────────┘   │
│ ┌─ Filters Panel ──────────────────────────────┐   │
│ │ [Categoría ▼] [Proveedor ▼] [Estado ▼] [Reset]│  │
│ └─────────────────────────────────────────────┘   │
│ ┌─ Products Table ─────────────────────────────┐   │
│ │ □ Producto      SKU     Cat.  Stock  Precio ⚙│   │
│ │ ─────────────────────────────────────────────│   │
│ │ □ Coca-Cola 350ml COCA... Bebid. 100   $2000 ●│   │
│ │ □ Sprite 350ml    SPRIT... Bebid. 75    $2000 ●│   │
│ │ ... (25 rows total)                          │   │
│ └─────────────────────────────────────────────┘   │
│ ┌─ Pagination ─────────────────────────────────┐   │
│ │ Showing 1-25 of 150    ← 1 2 3 ... 6 →      │   │
│ └─────────────────────────────────────────────┘   │
└───────────────────────────────────────────────────┘
```

#### **7.3 Formulario de Producto**

**Campos** (basados en app_form_fields):
```sql
-- Campos desde tu BD configuration
name, sku, barcode, description          (text fields)
category_id, supplier_id, unit_type      (select fields)  
cost_price, sale_price, tax_rate         (number fields)
min_stock, max_stock, location           (number/text fields)
```

**Layout Wireframe:**
```
┌─ Header (breadcrumbs: Inventario > Productos > Crear) ─┐
│ ┌─ Form Container (2 columns) ─────────────────────┐   │
│ │ ┌─ Column 1 ─────────┐ ┌─ Column 2 ─────────────┐ │ │
│ │ │ [Nombre*]          │ │ [SKU*]                  │ │ │
│ │ │ [Descripción]      │ │ [Código de Barras]      │ │ │
│ │ │ [Categoría*] ▼     │ │ [Proveedor] ▼           │ │ │
│ │ │ [Precio Costo*]    │ │ [Precio Venta*]         │ │ │
│ │ │ [IVA (%)]          │ │ [Unidad de Medida] ▼    │ │ │
│ │ │ [Stock Mínimo]     │ │ [Stock Máximo]          │ │ │
│ │ │ [Ubicación]        │ │ [Imagen] 📁             │ │ │
│ │ └────────────────────┘ └─────────────────────────┘ │ │
│ └─────────────────────────────────────────────────┘   │
│ ┌─ Actions ────────────────────────────────────────┐   │
│ │               [Cancelar] [Guardar Borrador] [Crear]│  │
│ └─────────────────────────────────────────────────┘   │
└───────────────────────────────────────────────────────┘
```

#### **7.4 Punto de Venta (Nueva Venta)**

**Funcionalidad compleja**:
```sql
-- Proceso de venta
1. Seleccionar cliente (customers table)
2. Agregar productos (products + current_stock)
3. Calcular totales automáticos (sales + sale_items)
4. Procesar pago (payments table)
```

**Layout Wireframe:**
```
┌─ Header (breadcrumbs: Ventas > Nueva Venta) ───────────┐
│ ┌─ Customer Section ──────────────────────────────────┐ │
│ │ Cliente: [Buscar cliente...] ▼  [+ Nuevo Cliente]   │ │  
│ └─────────────────────────────────────────────────────┘ │
│ ┌─ Products Section ──────────────────────────────────┐ │
│ │ ┌─ Search ─────┐ ┌─ Cart ─────────────────────────┐ │ │
│ │ │🔍[Buscar...] │ │ Producto    Cant. Precio Total│ │ │
│ │ │              │ │ ─────────────────────────────  │ │ │
│ │ │ Coca-Cola    │ │ Coca-Cola    2    $2000  $4000│ │ │
│ │ │ Sprite       │ │ Sprite       1    $2000  $2000│ │ │
│ │ │ Pepsi        │ │                             │ │ │
│ │ │ ...          │ │ [+ Agregar Producto]        │ │ │
│ │ └──────────────┘ └─────────────────────────────┘ │ │
│ └─────────────────────────────────────────────────────┘ │
│ ┌─ Totals & Payment ──────────────────────────────────┐ │
│ │ Subtotal:                               $6,000.00   │ │
│ │ IVA (19%):                              $1,140.00   │ │  
│ │ ──────────────────────────────────────────────────  │ │
│ │ TOTAL:                                  $7,140.00   │ │
│ │                                                     │ │
│ │ Método de Pago: [Efectivo ▼]                        │ │
│ │        [Cancelar] [Guardar Borrador] [Procesar]     │ │
│ └─────────────────────────────────────────────────────┘ │
└───────────────────────────────────────────────────────┘
```

### **Paso 8: High-Fidelity Design**

#### **8.1 Aplicar Design System**
1. **Convertir wireframes** a componentes reales
2. **Aplicar color palette** según funcionalidad:
   - Dashboard → Primary Blue
   - Inventario → Success Green  
   - Ventas → Danger Red
   - Botones → Semantic colors
3. **Agregar iconografía** (Heroicons, Lucide)
4. **Aplicar shadows y borders**

#### **8.2 Estados Interactivos**
- **Hover states** en botones y links
- **Focus states** en inputs
- **Loading states** en tablas
- **Empty states** cuando no hay datos
- **Error states** en formularios

---

## 🔄 **Prototipado Interactivo** {#prototipado}

### **Paso 9: Crear Flujos de Usuario**

#### **Flujo Principal 1: Crear Producto**
```
Dashboard → Inventario → Productos → [Nuevo Producto] → 
Formulario → [Crear] → Lista de Productos (con nuevo producto)
```

#### **Flujo Principal 2: Procesar Venta**
```
Dashboard → Ventas → [Nueva Venta] → 
Seleccionar Cliente → Agregar Productos → 
Configurar Pago → [Procesar] → Confirmación
```

#### **Configurar Transiciones:**
- **Trigger**: On Click
- **Animation**: Smart Animate (300ms ease-out)
- **Overlays**: Para modals y confirmaciones

---

## 📚 **Documentación y Handoff** {#documentación}

### **Paso 10: Design Tokens**

**Crear archivo de especificaciones:**
```json
{
  "colors": {
    "primary": {"500": "#2563EB"},
    "success": {"500": "#059669"}
  },
  "typography": {
    "h1": {"size": 36, "weight": 700, "lineHeight": 40}
  },
  "spacing": {
    "xs": 4, "sm": 8, "md": 16, "lg": 24
  },
  "shadows": {
    "sm": "0 1px 2px 0 rgba(0, 0, 0, 0.05)"
  }
}
```

### **Paso 11: Developer Handoff**

#### **Preparar assets:**
1. **Exportar iconos** en SVG
2. **Generar CSS** de componentes
3. **Documentar interactions**
4. **Crear component specs**

#### **Figma Dev Mode:**
- Activar **Dev Mode** para desarrolladores
- **Generar código CSS/React** automáticamente
- **Medir espaciados** y dimensiones
- **Exportar assets** en diferentes formatos

---

## 📦 **Recursos y Assets** {#recursos}

### **Íconos Recomendados:**
- **Heroicons** (heroicons.com) - Matches Tailwind CSS
- **Lucide** (lucide.dev) - Beautiful, consistent icons
- **Phosphor** (phosphoricons.com) - Large icon family

### **Plugins Útiles:**
```
🔧 Figma Plugins:
├── Auto Layout → Organización automática
├── Content Reel → Datos realistas
├── Stark → Accesibilidad y contraste  
├── Design System Organizer → Componentes
├── FigJam → Brainstorming colaborativo
└── Dev Mode → Handoff a desarrolladores
```

### **Recursos de UI:**
- **Shadcn/ui Figma Kit** - Componentes de Tailwind
- **Tailwind UI Kit** - Patrones profesionales
- **Material Design 3** - Sistema de Google

---

## ✅ **Checklist de Completitud**

### **Fase 1: Fundación** (1-2 horas)
- [ ] Proyecto configurado en Figma
- [ ] Color palette definida
- [ ] Typography scale creada
- [ ] Grid system configurado

### **Fase 2: Componentes** (3-4 horas)
- [ ] Botones (todos los estados)
- [ ] Inputs y formularios
- [ ] Cards y containers
- [ ] Navigation components
- [ ] Table components

### **Fase 3: Wireframes** (2-3 horas)
- [ ] Dashboard wireframe
- [ ] Lista de productos wireframe
- [ ] Formulario producto wireframe
- [ ] Nueva venta wireframe
- [ ] Login wireframe

### **Fase 4: High-Fidelity** (4-5 horas)
- [ ] Dashboard con design system
- [ ] Todas las pantallas con estilos
- [ ] Estados interactivos
- [ ] Responsive behavior

### **Fase 5: Prototipo** (1-2 horas)
- [ ] Flujos de usuario conectados
- [ ] Transiciones configuradas
- [ ] Casos de uso principales

### **Fase 6: Documentación** (1 hora)
- [ ] Design tokens documentados
- [ ] Component specs
- [ ] Developer handoff
- [ ] Assets exportados

---

## 🚀 **Próximos Pasos**

**Después de completar los wireframes:**

1. **Testing de Usabilidad** - Validar flujos con usuarios
2. **Responsive Design** - Adaptar a mobile y tablet  
3. **Dark Mode** - Variante oscura del sistema
4. **Accessibility** - Cumplir WCAG 2.1
5. **Animation System** - Micro-interactions
6. **Implementation** - Convertir a código React + Tailwind

---

## 📝 **REGISTRO DE PROGRESO**

### ✅ **COMPLETADO - Sesión 1 (31 Agosto 2025)**

#### **🏗️ Estructura Figma Configurada:**
```
📁 StockFlow - Sistema de Inventario (Equipo)
  └── 📂 StockFlow Design (Proyecto)
      ├── 📄 StockFlow - Design System
      │   ├── Cover & Overview
      │   ├── Colors & Typography ← TRABAJANDO AQUÍ
      │   └── Components Library
      ├── 📄 StockFlow - Wireframes & UX
      └── 📄 StockFlow - UI Design & Prototypes
```

#### **🎨 Fase 1: Fundación (EN PROGRESO)**

**✅ COMPLETADO:**
1. **Setup Inicial** 
   - ✅ Equipo Figma creado
   - ✅ Proyecto y archivos configurados
   - ✅ Frame Desktop (1440x1024) con grid 12 columnas
   - ✅ Márgenes 80px, gutter 24px

2. **Color Palette** 
   - ✅ 6 Color Styles creados:
     ```
     Primary/Blue-500 → #2563EB (Dashboard)
     Success/Green-500 → #059669 (Inventario) 
     Danger/Red-500 → #DC2626 (Ventas)
     Warning/Orange-500 → #EA580C (Reportes)
     Purple/Purple-500 → #7C3AED (Compras)
     Neutral/Gray-500 → #6B7280 (Admin)
     ```

3. **Typography Scale**
   - ✅ 8 Text Styles creados:
     ```
     H1/Bold → 36px/700/40lh
     H2/Bold → 30px/700/36lh  
     H3/Semibold → 24px/600/32lh
     H4/Semibold → 20px/600/28lh
     Body/Regular → 16px/400/24lh
     Body/Medium → 16px/500/24lh
     Small/Regular → 14px/400/20lh
     Caption/Medium → 12px/500/16lh
     ```

4. **Spacing System**
   - ✅ 8 espaciados visuales creados:
     ```
     4px - XS - Para iconos pequeños
     8px - SM - Espaciado mínimo  
     12px - MD - Elementos relacionados
     16px - BASE - Espaciado estándar
     24px - LG - Separación de secciones
     32px - XL - Separación de componentes
     48px - 2XL - Separación de módulos
     64px - 3XL - Espaciado de página
     ```

5. **Shadow System**
   - ✅ 4 niveles de elevación creados:
     ```
     Shadow SM → Y:1px, Blur:2px, 5% - Bordes sutiles
     Shadow MD → Y:4px, Blur:6px, 7% - Cards normales
     Shadow LG → Y:10px, Blur:15px, 10% - Cards elevados  
     Shadow XL → Y:20px, Blur:25px, 15% - Modals/Overlays
     ```

**🟡 EN PROGRESO:**
- Border Radius System (próximo paso)

**⏳ PENDIENTE:**
- Components Library (Página 3)
- Wireframes (Archivo 2)
- High-Fidelity Design (Archivo 3)

### 📋 **PRÓXIMA SESIÓN - CONTINUAR CON:**

#### **Paso Inmediato:**
```
🔲 Border Radius System (5 min)
├── 0px - None → Elementos cuadrados/tablas
├── 4px - SM → Inputs, botones pequeños  
├── 8px - MD → Botones, cards
├── 12px - LG → Modals, containers
├── 16px - XL → Cards grandes
├── 24px - 2XL → Elementos destacados
└── 999px - Full → Pills, badges, avatars
```

#### **Siguiente Fase:**
```
🎯 Fase 2: Components Library (Página 3)
├── Button Component (todos los estados)
├── Input Field Component
├── Card Component  
├── Navigation Sidebar
├── Header/Topbar
└── Data Table Component
```

### 🎯 **UBICACIÓN ACTUAL:**
- **Archivo**: `StockFlow - Design System`
- **Página**: `Colors & Typography` (2/3)
- **Progreso Fase 1**: 85% completado
- **Tiempo invertido**: ~2 horas
- **Tiempo restante estimado**: 10-15 horas

### 🚀 **COMANDO DE RETORNO:**
```
"Continuemos con el Border Radius System en la página Colors & Typography del archivo StockFlow - Design System. Necesitamos crear 7 rectángulos con corner radius desde 0px hasta 999px (Full)."
```

---

**📅 Tiempo Estimado Total: 12-17 horas distribuidas en 2-3 días**

**Estado actual: Fundación 85% → Siguiente: Components Library**