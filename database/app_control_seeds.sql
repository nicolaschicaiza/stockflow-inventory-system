-- ================================
-- CONFIGURACIÓN INICIAL DEL SISTEMA DE CONTROL
-- ================================

-- Limpiar datos de control de aplicación
TRUNCATE TABLE app_navigation CASCADE;
TRUNCATE TABLE role_permissions CASCADE;
TRUNCATE TABLE app_permissions CASCADE;
TRUNCATE TABLE app_table_columns CASCADE;
TRUNCATE TABLE app_form_fields CASCADE;
TRUNCATE TABLE app_components CASCADE;
TRUNCATE TABLE app_actions CASCADE;
TRUNCATE TABLE app_views CASCADE;
TRUNCATE TABLE app_modules CASCADE;
TRUNCATE TABLE app_settings CASCADE;

-- ================================
-- CONFIGURACIÓN GLOBAL
-- ================================

INSERT INTO app_settings (key, value, data_type, category, description, is_public, is_editable) VALUES
-- Configuración de UI
('app.name', 'StockFlow', 'string', 'ui', 'Nombre de la aplicación', true, true),
('app.version', '1.0.0', 'string', 'ui', 'Versión actual', true, false),
('app.logo_url', '/assets/logo.svg', 'string', 'ui', 'URL del logo', true, true),
('app.theme', 'light', 'string', 'ui', 'Tema por defecto', true, true),
('app.language', 'es', 'string', 'ui', 'Idioma por defecto', true, true),

-- Configuración de negocio
('business.company_name', 'Mi Empresa S.A.S.', 'string', 'business', 'Nombre de la empresa', true, true),
('business.tax_id', '900123456-7', 'string', 'business', 'NIT de la empresa', false, true),
('business.default_tax_rate', '19', 'number', 'business', 'Tasa de IVA por defecto', false, true),
('business.currency', 'COP', 'string', 'business', 'Moneda por defecto', true, true),
('business.low_stock_threshold', '10', 'number', 'business', 'Umbral de stock bajo', false, true),

-- Configuración del sistema
('system.session_timeout', '3600', 'number', 'system', 'Tiempo de sesión en segundos', false, true),
('system.max_login_attempts', '5', 'number', 'system', 'Máximo intentos de login', false, true),
('system.backup_frequency', '24', 'number', 'system', 'Frecuencia de backup en horas', false, true),
('system.audit_enabled', 'true', 'boolean', 'system', 'Auditoría habilitada', false, true);

-- ================================
-- MÓDULOS DE LA APLICACIÓN
-- ================================

INSERT INTO app_modules (id, name, display_name, description, icon, color, sort_order, is_active) VALUES
('mod-dashboard', 'dashboard', 'Dashboard', 'Panel principal con métricas y resúmenes', 'dashboard', '#2563eb', 1, true),
('mod-inventory', 'inventory', 'Inventario', 'Gestión de productos, stock y movimientos', 'package', '#059669', 2, true),
('mod-sales', 'sales', 'Ventas', 'Gestión de ventas, facturación y clientes', 'shopping-cart', '#dc2626', 3, true),
('mod-purchases', 'purchases', 'Compras', 'Gestión de compras y proveedores', 'truck', '#7c3aed', 4, true),
('mod-reports', 'reports', 'Reportes', 'Reportes financieros y de gestión', 'bar-chart', '#ea580c', 5, true),
('mod-admin', 'admin', 'Administración', 'Configuración del sistema y usuarios', 'settings', '#6b7280', 6, true);

-- Submódulos
INSERT INTO app_modules (id, name, display_name, description, icon, parent_id, sort_order, is_active) VALUES
('mod-inventory-products', 'products', 'Productos', 'Catálogo de productos', 'box', 'mod-inventory', 1, true),
('mod-inventory-categories', 'categories', 'Categorías', 'Categorías de productos', 'tag', 'mod-inventory', 2, true),
('mod-inventory-stock', 'stock', 'Stock', 'Control de inventario', 'layers', 'mod-inventory', 3, true),
('mod-sales-invoices', 'invoices', 'Facturas', 'Gestión de facturas', 'file-text', 'mod-sales', 1, true),
('mod-sales-customers', 'customers', 'Clientes', 'Base de clientes', 'users', 'mod-sales', 2, true),
('mod-admin-users', 'users', 'Usuarios', 'Gestión de usuarios', 'user', 'mod-admin', 1, true),
('mod-admin-settings', 'settings', 'Configuración', 'Configuración del sistema', 'sliders', 'mod-admin', 2, true);

-- ================================
-- VISTAS/PANTALLAS
-- ================================

INSERT INTO app_views (id, module_id, name, display_name, route_path, component_name, view_type, meta_data, sort_order, is_active) VALUES
-- Dashboard
('view-dashboard-main', 'mod-dashboard', 'dashboard', 'Dashboard Principal', '/', 'DashboardMain', 'page', '{"title": "Dashboard", "breadcrumbs": ["Dashboard"]}', 1, true),

-- Inventario
('view-inventory-products-list', 'mod-inventory-products', 'products_list', 'Lista de Productos', '/inventory/products', 'ProductsList', 'page', '{"title": "Productos", "breadcrumbs": ["Inventario", "Productos"]}', 1, true),
('view-inventory-products-create', 'mod-inventory-products', 'products_create', 'Crear Producto', '/inventory/products/create', 'ProductsCreate', 'page', '{"title": "Crear Producto", "breadcrumbs": ["Inventario", "Productos", "Crear"]}', 2, true),
('view-inventory-products-edit', 'mod-inventory-products', 'products_edit', 'Editar Producto', '/inventory/products/:id/edit', 'ProductsEdit', 'page', '{"title": "Editar Producto", "breadcrumbs": ["Inventario", "Productos", "Editar"]}', 3, true),
('view-inventory-stock', 'mod-inventory-stock', 'stock_overview', 'Resumen de Stock', '/inventory/stock', 'StockOverview', 'page', '{"title": "Stock", "breadcrumbs": ["Inventario", "Stock"]}', 4, true),

-- Ventas
('view-sales-list', 'mod-sales-invoices', 'sales_list', 'Lista de Ventas', '/sales', 'SalesList', 'page', '{"title": "Ventas", "breadcrumbs": ["Ventas"]}', 1, true),
('view-sales-create', 'mod-sales-invoices', 'sales_create', 'Nueva Venta', '/sales/create', 'SalesCreate', 'page', '{"title": "Nueva Venta", "breadcrumbs": ["Ventas", "Nueva Venta"]}', 2, true),
('view-customers-list', 'mod-sales-customers', 'customers_list', 'Lista de Clientes', '/customers', 'CustomersList', 'page', '{"title": "Clientes", "breadcrumbs": ["Ventas", "Clientes"]}', 3, true),

-- Compras
('view-purchases-list', 'mod-purchases', 'purchases_list', 'Órdenes de Compra', '/purchases', 'PurchasesList', 'page', '{"title": "Compras", "breadcrumbs": ["Compras"]}', 1, true),

-- Reportes
('view-reports-sales', 'mod-reports', 'reports_sales', 'Reporte de Ventas', '/reports/sales', 'ReportsSales', 'report', '{"title": "Reporte de Ventas", "breadcrumbs": ["Reportes", "Ventas"]}', 1, true),
('view-reports-inventory', 'mod-reports', 'reports_inventory', 'Reporte de Inventario', '/reports/inventory', 'ReportsInventory', 'report', '{"title": "Reporte de Inventario", "breadcrumbs": ["Reportes", "Inventario"]}', 2, true),

-- Administración
('view-admin-users', 'mod-admin-users', 'admin_users', 'Gestión de Usuarios', '/admin/users', 'AdminUsers', 'page', '{"title": "Usuarios", "breadcrumbs": ["Administración", "Usuarios"]}', 1, true),
('view-admin-settings', 'mod-admin-settings', 'admin_settings', 'Configuración', '/admin/settings', 'AdminSettings', 'page', '{"title": "Configuración", "breadcrumbs": ["Administración", "Configuración"]}', 2, true);

-- ================================
-- ACCIONES EN VISTAS
-- ================================

INSERT INTO app_actions (id, view_id, name, display_name, action_type, icon, button_style, api_endpoint, http_method, redirect_to, sort_order, is_active) VALUES
-- Acciones para lista de productos
('act-products-create', 'view-inventory-products-list', 'create', 'Nuevo Producto', 'button', 'plus', 'primary', null, 'GET', '/inventory/products/create', 1, true),
('act-products-export', 'view-inventory-products-list', 'export', 'Exportar', 'button', 'download', 'secondary', '/api/products/export', 'GET', null, 2, true),
('act-products-import', 'view-inventory-products-list', 'import', 'Importar', 'button', 'upload', 'secondary', '/api/products/import', 'POST', null, 3, true),

-- Acciones inline para tabla de productos
('act-products-edit', 'view-inventory-products-list', 'edit', 'Editar', 'inline', 'edit', 'secondary', null, 'GET', '/inventory/products/:id/edit', 1, true),
('act-products-delete', 'view-inventory-products-list', 'delete', 'Eliminar', 'inline', 'trash', 'danger', '/api/products/:id', 'DELETE', null, 2, true),
('act-products-duplicate', 'view-inventory-products-list', 'duplicate', 'Duplicar', 'inline', 'copy', 'secondary', '/api/products/:id/duplicate', 'POST', '/inventory/products/:new_id/edit', 3, true),

-- Acciones para nueva venta
('act-sales-add-item', 'view-sales-create', 'add_item', 'Agregar Producto', 'button', 'plus', 'primary', null, 'GET', null, 1, true),
('act-sales-save-draft', 'view-sales-create', 'save_draft', 'Guardar Borrador', 'button', 'save', 'secondary', '/api/sales/draft', 'POST', null, 2, true),
('act-sales-process', 'view-sales-create', 'process', 'Procesar Venta', 'button', 'check', 'primary', '/api/sales', 'POST', '/sales/:id', 3, true),

-- Acciones para dashboard
('act-dashboard-refresh', 'view-dashboard-main', 'refresh', 'Actualizar', 'button', 'refresh-cw', 'secondary', '/api/dashboard/metrics', 'GET', null, 1, true);

-- ================================
-- COMPONENTES DE LAS VISTAS
-- ================================

-- Componentes del Dashboard
INSERT INTO app_components (id, view_id, name, component_type, position, props, data_source, sort_order, is_active) VALUES
('comp-dashboard-stats', 'view-dashboard-main', 'dashboard_stats', 'stats', 'main', '{"columns": 4, "variant": "cards"}', '/api/dashboard/stats', 1, true),
('comp-dashboard-sales-chart', 'view-dashboard-main', 'sales_chart', 'chart', 'main', '{"type": "line", "title": "Ventas del Mes", "height": 300}', '/api/dashboard/sales-chart', 2, true),
('comp-dashboard-low-stock', 'view-dashboard-main', 'low_stock_alert', 'table', 'sidebar', '{"title": "Stock Bajo", "maxRows": 5, "showPagination": false}', '/api/dashboard/low-stock', 3, true);

-- Componentes de lista de productos
INSERT INTO app_components (id, view_id, name, component_type, position, props, data_source, sort_order, is_active) VALUES
('comp-products-filters', 'view-inventory-products-list', 'products_filters', 'filter', 'header', '{"fields": ["category", "supplier", "status"], "layout": "horizontal"}', null, 1, true),
('comp-products-search', 'view-inventory-products-list', 'products_search', 'search', 'header', '{"placeholder": "Buscar por nombre, SKU o código de barras", "fields": ["name", "sku", "barcode"]}', null, 2, true),
('comp-products-table', 'view-inventory-products-list', 'products_table', 'table', 'main', '{"pagination": true, "sortable": true, "selectable": true, "pageSize": 25}', '/api/products', 3, true);

-- Componente de formulario de producto
INSERT INTO app_components (id, view_id, name, component_type, position, props, data_source, sort_order, is_active) VALUES
('comp-product-form', 'view-inventory-products-create', 'product_form', 'form', 'main', '{"layout": "two-columns", "autoSave": false, "showRequiredIndicator": true}', null, 1, true);

-- ================================
-- CAMPOS DE FORMULARIO DE PRODUCTO
-- ================================

INSERT INTO app_form_fields (id, component_id, name, label, field_type, validation_rules, placeholder, is_required, sort_order, is_active) VALUES
-- Información básica
('field-product-name', 'comp-product-form', 'name', 'Nombre del Producto', 'text', '{"required": true, "minLength": 3, "maxLength": 200}', 'Ej: Coca-Cola 350ml', true, 1, true),
('field-product-sku', 'comp-product-form', 'sku', 'Código SKU', 'text', '{"required": true, "unique": true, "pattern": "^[A-Z0-9-]+$"}', 'Ej: COCA-350ML', true, 2, true),
('field-product-barcode', 'comp-product-form', 'barcode', 'Código de Barras', 'text', '{"unique": true, "pattern": "^[0-9]+$"}', 'Código de barras del producto', false, 3, true),
('field-product-description', 'comp-product-form', 'description', 'Descripción', 'textarea', '{"maxLength": 500}', 'Descripción detallada del producto', false, 4, true),

-- Categorización
('field-product-category', 'comp-product-form', 'category_id', 'Categoría', 'select', '{"required": true}', null, true, 5, true),
('field-product-supplier', 'comp-product-form', 'supplier_id', 'Proveedor Principal', 'select', null, null, false, 6, true),

-- Precios
('field-product-cost-price', 'comp-product-form', 'cost_price', 'Precio de Costo', 'decimal', '{"required": true, "min": 0, "step": 0.01}', '0.00', true, 7, true),
('field-product-sale-price', 'comp-product-form', 'sale_price', 'Precio de Venta', 'decimal', '{"required": true, "min": 0, "step": 0.01}', '0.00', true, 8, true),
('field-product-tax-rate', 'comp-product-form', 'tax_rate', 'Tasa de IVA (%)', 'number', '{"min": 0, "max": 100, "step": 0.01}', '19', false, 9, true),

-- Inventario
('field-product-unit-type', 'comp-product-form', 'unit_type', 'Unidad de Medida', 'select', '{"required": true}', null, true, 10, true),
('field-product-min-stock', 'comp-product-form', 'min_stock', 'Stock Mínimo', 'number', '{"min": 0}', '0', false, 11, true),
('field-product-max-stock', 'comp-product-form', 'max_stock', 'Stock Máximo', 'number', '{"min": 0}', null, false, 12, true),
('field-product-location', 'comp-product-form', 'location', 'Ubicación en Almacén', 'text', '{"maxLength": 100}', 'Ej: A1-B2', false, 13, true);

-- ================================
-- COLUMNAS DE TABLA DE PRODUCTOS
-- ================================

INSERT INTO app_table_columns (id, component_id, name, label, column_type, width, is_sortable, is_filterable, format_pattern, render_as, sort_order, is_visible) VALUES
('col-products-name', 'comp-products-table', 'name', 'Producto', 'text', '250px', true, true, null, 'link', 1, true),
('col-products-sku', 'comp-products-table', 'sku', 'SKU', 'text', '120px', true, true, null, 'badge', 2, true),
('col-products-category', 'comp-products-table', 'category_name', 'Categoría', 'text', '150px', true, true, null, null, 3, true),
('col-products-stock', 'comp-products-table', 'current_quantity', 'Stock', 'number', '80px', true, true, null, null, 4, true),
('col-products-cost-price', 'comp-products-table', 'cost_price', 'Costo', 'currency', '100px', true, false, 'COP', null, 5, true),
('col-products-sale-price', 'comp-products-table', 'sale_price', 'Precio', 'currency', '100px', true, true, 'COP', null, 6, true),
('col-products-status', 'comp-products-table', 'is_active', 'Estado', 'boolean', '80px', true, true, null, 'badge', 7, true),
('col-products-actions', 'comp-products-table', 'actions', 'Acciones', 'actions', '120px', false, false, null, null, 8, true);

-- ================================
-- PERMISOS GRANULARES
-- ================================

INSERT INTO app_permissions (id, name, display_name, description, module_id, view_id, permission_type, is_active) VALUES
-- Permisos de módulos
('perm-dashboard-access', 'dashboard.access', 'Acceso a Dashboard', 'Permite ver el dashboard principal', 'mod-dashboard', null, 'module', true),
('perm-inventory-access', 'inventory.access', 'Acceso a Inventario', 'Permite acceder al módulo de inventario', 'mod-inventory', null, 'module', true),
('perm-sales-access', 'sales.access', 'Acceso a Ventas', 'Permite acceder al módulo de ventas', 'mod-sales', null, 'module', true),
('perm-admin-access', 'admin.access', 'Acceso a Administración', 'Permite acceder a la administración', 'mod-admin', null, 'module', true),

-- Permisos específicos de productos
('perm-products-view', 'inventory.products.view', 'Ver Productos', 'Permite ver la lista de productos', 'mod-inventory-products', 'view-inventory-products-list', 'view', true),
('perm-products-create', 'inventory.products.create', 'Crear Productos', 'Permite crear nuevos productos', 'mod-inventory-products', 'view-inventory-products-create', 'action', true),
('perm-products-edit', 'inventory.products.edit', 'Editar Productos', 'Permite editar productos existentes', 'mod-inventory-products', 'view-inventory-products-edit', 'action', true),
('perm-products-delete', 'inventory.products.delete', 'Eliminar Productos', 'Permite eliminar productos', 'mod-inventory-products', null, 'action', true),

-- Permisos de ventas
('perm-sales-view', 'sales.view', 'Ver Ventas', 'Permite ver las ventas', 'mod-sales', 'view-sales-list', 'view', true),
('perm-sales-create', 'sales.create', 'Crear Ventas', 'Permite crear nuevas ventas', 'mod-sales', 'view-sales-create', 'action', true),
('perm-sales-process', 'sales.process', 'Procesar Ventas', 'Permite procesar y finalizar ventas', 'mod-sales', null, 'action', true),

-- Permisos de reportes
('perm-reports-sales', 'reports.sales.view', 'Ver Reportes de Ventas', 'Permite ver reportes de ventas', 'mod-reports', 'view-reports-sales', 'view', true),
('perm-reports-inventory', 'reports.inventory.view', 'Ver Reportes de Inventario', 'Permite ver reportes de inventario', 'mod-reports', 'view-reports-inventory', 'view', true),

-- Permisos de administración
('perm-admin-users', 'admin.users.manage', 'Gestionar Usuarios', 'Permite gestionar usuarios del sistema', 'mod-admin-users', 'view-admin-users', 'action', true),
('perm-admin-settings', 'admin.settings.manage', 'Gestionar Configuración', 'Permite modificar la configuración del sistema', 'mod-admin-settings', 'view-admin-settings', 'action', true);

-- ================================
-- ASIGNACIÓN DE PERMISOS A ROLES
-- ================================

INSERT INTO role_permissions (role, permission_id, is_granted) VALUES
-- Admin: Acceso completo
('admin', 'perm-dashboard-access', true),
('admin', 'perm-inventory-access', true),
('admin', 'perm-sales-access', true),
('admin', 'perm-admin-access', true),
('admin', 'perm-products-view', true),
('admin', 'perm-products-create', true),
('admin', 'perm-products-edit', true),
('admin', 'perm-products-delete', true),
('admin', 'perm-sales-view', true),
('admin', 'perm-sales-create', true),
('admin', 'perm-sales-process', true),
('admin', 'perm-reports-sales', true),
('admin', 'perm-reports-inventory', true),
('admin', 'perm-admin-users', true),
('admin', 'perm-admin-settings', true),

-- Cajero: Operaciones básicas
('cajero', 'perm-dashboard-access', true),
('cajero', 'perm-inventory-access', true),
('cajero', 'perm-sales-access', true),
('cajero', 'perm-products-view', true),
('cajero', 'perm-sales-view', true),
('cajero', 'perm-sales-create', true),
('cajero', 'perm-sales-process', true),

-- Contador: Reportes y consultas
('contador', 'perm-dashboard-access', true),
('contador', 'perm-inventory-access', true),
('contador', 'perm-sales-access', true),
('contador', 'perm-products-view', true),
('contador', 'perm-sales-view', true),
('contador', 'perm-reports-sales', true),
('contador', 'perm-reports-inventory', true);

-- ================================
-- NAVEGACIÓN PRINCIPAL
-- ================================

INSERT INTO app_navigation (id, name, display_name, view_id, icon, required_permission, navigation_type, sort_order, is_active) VALUES
('nav-dashboard', 'dashboard', 'Dashboard', 'view-dashboard-main', 'dashboard', 'dashboard.access', 'menu', 1, true),
('nav-inventory', 'inventory', 'Inventario', null, 'package', 'inventory.access', 'menu', 2, true),
('nav-sales', 'sales', 'Ventas', 'view-sales-list', 'shopping-cart', 'sales.access', 'menu', 3, true),
('nav-reports', 'reports', 'Reportes', null, 'bar-chart', 'reports.sales.view', 'menu', 4, true),
('nav-admin', 'admin', 'Administración', null, 'settings', 'admin.access', 'menu', 5, true);

-- Subnavegación
INSERT INTO app_navigation (id, name, display_name, view_id, parent_id, icon, required_permission, navigation_type, sort_order, is_active) VALUES
-- Inventario
('nav-inventory-products', 'products', 'Productos', 'view-inventory-products-list', 'nav-inventory', 'box', 'inventory.products.view', 'menu', 1, true),
('nav-inventory-stock', 'stock', 'Stock', 'view-inventory-stock', 'nav-inventory', 'layers', 'inventory.products.view', 'menu', 2, true),

-- Ventas
('nav-sales-customers', 'customers', 'Clientes', 'view-customers-list', 'nav-sales', 'users', 'sales.view', 'menu', 1, true),

-- Reportes
('nav-reports-sales', 'reports-sales', 'Ventas', 'view-reports-sales', 'nav-reports', 'trending-up', 'reports.sales.view', 'menu', 1, true),
('nav-reports-inventory', 'reports-inventory', 'Inventario', 'view-reports-inventory', 'nav-reports', 'clipboard-list', 'reports.inventory.view', 'menu', 2, true),

-- Administración
('nav-admin-users', 'users', 'Usuarios', 'view-admin-users', 'nav-admin', 'user', 'admin.users.manage', 'menu', 1, true),
('nav-admin-settings', 'settings', 'Configuración', 'view-admin-settings', 'nav-admin', 'sliders', 'admin.settings.manage', 'menu', 2, true);

-- ================================
-- VERIFICACIÓN DE DATOS
-- ================================

SELECT 'app_modules' as tabla, COUNT(*) as registros FROM app_modules
UNION ALL SELECT 'app_views', COUNT(*) FROM app_views
UNION ALL SELECT 'app_actions', COUNT(*) FROM app_actions
UNION ALL SELECT 'app_components', COUNT(*) FROM app_components
UNION ALL SELECT 'app_form_fields', COUNT(*) FROM app_form_fields
UNION ALL SELECT 'app_table_columns', COUNT(*) FROM app_table_columns
UNION ALL SELECT 'app_permissions', COUNT(*) FROM app_permissions
UNION ALL SELECT 'role_permissions', COUNT(*) FROM role_permissions
UNION ALL SELECT 'app_navigation', COUNT(*) FROM app_navigation
UNION ALL SELECT 'app_settings', COUNT(*) FROM app_settings;