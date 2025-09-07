CREATE TYPE "user_role" AS ENUM (
  'SUPER_ADMIN',
  'ADMIN',
  'MANAGER',
  'INVENTORY_CLERK',
  'CASHIER',
  'ACCOUNTANT'
);

CREATE TYPE "product_unit" AS ENUM (
  'unidad',
  'kilogramo',
  'gramo',
  'litro',
  'mililitro',
  'metro',
  'centimetro',
  'paquete',
  'caja',
  'docena'
);

CREATE TYPE "customer_type" AS ENUM (
  'particular',
  'empresa'
);

CREATE TYPE "document_type" AS ENUM (
  'cedula',
  'nit',
  'pasaporte',
  'cedula_extranjeria'
);

CREATE TYPE "movement_type" AS ENUM (
  'entrada',
  'salida',
  'ajuste_positivo',
  'ajuste_negativo',
  'devolucion',
  'merma'
);

CREATE TYPE "reference_type" AS ENUM (
  'compra',
  'venta',
  'ajuste',
  'devolucion',
  'inicial'
);

CREATE TYPE "sale_status" AS ENUM (
  'pendiente',
  'pagada',
  'parcial',
  'vencida',
  'anulada'
);

CREATE TYPE "payment_method" AS ENUM (
  'efectivo',
  'tarjeta_credito',
  'tarjeta_debito',
  'transferencia',
  'credito',
  'cheque'
);

CREATE TYPE "purchase_status" AS ENUM (
  'pendiente',
  'recibida',
  'parcial',
  'cancelada'
);

CREATE TYPE "view_type" AS ENUM (
  'page',
  'modal',
  'tab',
  'widget',
  'report'
);

CREATE TYPE "action_type" AS ENUM (
  'button',
  'link',
  'menu_item',
  'fab',
  'inline'
);

CREATE TYPE "http_method" AS ENUM (
  'GET',
  'POST',
  'PUT',
  'DELETE',
  'PATCH'
);

CREATE TYPE "component_type" AS ENUM (
  'table',
  'form',
  'chart',
  'card',
  'list',
  'filter',
  'pagination',
  'breadcrumbs',
  'search',
  'stats',
  'calendar',
  'map'
);

CREATE TYPE "field_type" AS ENUM (
  'text',
  'email',
  'password',
  'number',
  'decimal',
  'date',
  'datetime',
  'select',
  'multiselect',
  'radio',
  'checkbox',
  'textarea',
  'file',
  'hidden',
  'custom'
);

CREATE TYPE "column_type" AS ENUM (
  'text',
  'number',
  'currency',
  'date',
  'datetime',
  'boolean',
  'badge',
  'link',
  'image',
  'actions',
  'custom'
);

CREATE TYPE "permission_type" AS ENUM (
  'module',
  'view',
  'action',
  'data'
);

CREATE TYPE "setting_data_type" AS ENUM (
  'string',
  'number',
  'boolean',
  'json',
  'date',
  'url',
  'email'
);

CREATE TYPE "nav_type" AS ENUM (
  'menu',
  'sidebar',
  'breadcrumb',
  'footer',
  'quick_access'
);

CREATE TABLE "users" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "email" varchar(255) UNIQUE NOT NULL,
  "password_hash" varchar(255) NOT NULL,
  "password_salt" varchar(255) NOT NULL,
  "password_reset_token" varchar(255),
  "password_reset_expires" timestamp,
  "failed_login_attempts" integer DEFAULT 0,
  "account_locked_until" timestamp,
  "first_name" varchar(100) NOT NULL,
  "last_name" varchar(100) NOT NULL,
  "phone" varchar(20),
  "role" user_role NOT NULL DEFAULT 'CASHIER',
  "is_active" boolean DEFAULT true,
  "last_login_at" timestamp,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "categories" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "name" varchar(100) UNIQUE NOT NULL,
  "description" text,
  "parent_id" uuid,
  "is_active" boolean DEFAULT true,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "suppliers" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "business_name" varchar(200) NOT NULL,
  "contact_name" varchar(100),
  "tax_id" varchar(50) UNIQUE,
  "email" varchar(255),
  "phone" varchar(20),
  "mobile" varchar(20),
  "address" text,
  "city" varchar(100),
  "state" varchar(100),
  "postal_code" varchar(20),
  "country" varchar(100) DEFAULT 'Colombia',
  "payment_terms" integer DEFAULT 30,
  "credit_limit" decimal(15,2) DEFAULT 0,
  "is_active" boolean DEFAULT true,
  "notes" text,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "products" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "sku" varchar(100) UNIQUE NOT NULL,
  "barcode" varchar(100) UNIQUE,
  "name" varchar(200) NOT NULL,
  "description" text,
  "category_id" uuid NOT NULL,
  "supplier_id" uuid,
  "unit_type" product_unit NOT NULL DEFAULT 'unidad',
  "cost_price" decimal(15,2) NOT NULL DEFAULT 0,
  "sale_price" decimal(15,2) NOT NULL DEFAULT 0,
  "tax_rate" decimal(5,2) DEFAULT 19,
  "min_stock" integer DEFAULT 0,
  "max_stock" integer,
  "location" varchar(100),
  "expiration_days" integer,
  "is_active" boolean DEFAULT true,
  "image_url" varchar(500),
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "customers" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "customer_type" customer_type NOT NULL DEFAULT 'particular',
  "business_name" varchar(200),
  "first_name" varchar(100),
  "last_name" varchar(100),
  "document_type" document_type NOT NULL DEFAULT 'cedula',
  "document_number" varchar(50) UNIQUE NOT NULL,
  "email" varchar(255),
  "phone" varchar(20),
  "mobile" varchar(20),
  "address" text,
  "city" varchar(100),
  "state" varchar(100),
  "postal_code" varchar(20),
  "country" varchar(100) DEFAULT 'Colombia',
  "credit_limit" decimal(15,2) DEFAULT 0,
  "payment_terms" integer DEFAULT 0,
  "is_active" boolean DEFAULT true,
  "notes" text,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "inventory_movements" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "product_id" uuid NOT NULL,
  "movement_type" movement_type NOT NULL,
  "quantity" integer NOT NULL,
  "unit_cost" decimal(15,2),
  "total_cost" decimal(15,2),
  "reference_type" reference_type,
  "reference_id" uuid,
  "supplier_id" uuid,
  "user_id" uuid NOT NULL,
  "notes" text,
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "current_stock" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "product_id" uuid UNIQUE NOT NULL,
  "current_quantity" integer NOT NULL DEFAULT 0,
  "reserved_quantity" integer NOT NULL DEFAULT 0,
  "available_quantity" integer NOT NULL DEFAULT 0,
  "average_cost" decimal(15,2) NOT NULL DEFAULT 0,
  "last_movement_at" timestamp,
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "sales" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "sale_number" varchar(50) UNIQUE NOT NULL,
  "customer_id" uuid NOT NULL,
  "user_id" uuid NOT NULL,
  "sale_date" timestamp NOT NULL DEFAULT (now()),
  "due_date" timestamp,
  "status" sale_status NOT NULL DEFAULT 'pendiente',
  "payment_method" payment_method NOT NULL DEFAULT 'efectivo',
  "subtotal" decimal(15,2) NOT NULL DEFAULT 0,
  "tax_amount" decimal(15,2) NOT NULL DEFAULT 0,
  "discount_amount" decimal(15,2) NOT NULL DEFAULT 0,
  "total_amount" decimal(15,2) NOT NULL DEFAULT 0,
  "tax_id" varchar(50),
  "resolution" varchar(100),
  "notes" text,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "sale_items" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "sale_id" uuid NOT NULL,
  "product_id" uuid NOT NULL,
  "quantity" integer NOT NULL,
  "unit_price" decimal(15,2) NOT NULL,
  "discount_percentage" decimal(5,2) DEFAULT 0,
  "discount_amount" decimal(15,2) DEFAULT 0,
  "tax_rate" decimal(5,2) NOT NULL DEFAULT 19,
  "tax_amount" decimal(15,2) NOT NULL DEFAULT 0,
  "line_total" decimal(15,2) NOT NULL,
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "payments" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "sale_id" uuid NOT NULL,
  "payment_date" timestamp NOT NULL DEFAULT (now()),
  "amount" decimal(15,2) NOT NULL,
  "payment_method" payment_method NOT NULL,
  "reference" varchar(100),
  "notes" text,
  "user_id" uuid NOT NULL,
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "purchases" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "purchase_number" varchar(50) UNIQUE NOT NULL,
  "supplier_id" uuid NOT NULL,
  "user_id" uuid NOT NULL,
  "purchase_date" timestamp NOT NULL DEFAULT (now()),
  "expected_date" timestamp,
  "received_date" timestamp,
  "status" purchase_status NOT NULL DEFAULT 'pendiente',
  "subtotal" decimal(15,2) NOT NULL DEFAULT 0,
  "tax_amount" decimal(15,2) NOT NULL DEFAULT 0,
  "total_amount" decimal(15,2) NOT NULL DEFAULT 0,
  "notes" text,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "purchase_items" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "purchase_id" uuid NOT NULL,
  "product_id" uuid NOT NULL,
  "quantity_ordered" integer NOT NULL,
  "quantity_received" integer DEFAULT 0,
  "unit_cost" decimal(15,2) NOT NULL,
  "tax_rate" decimal(5,2) DEFAULT 19,
  "tax_amount" decimal(15,2) DEFAULT 0,
  "line_total" decimal(15,2) NOT NULL,
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "app_modules" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "name" varchar(100) UNIQUE NOT NULL,
  "display_name" varchar(100) NOT NULL,
  "description" text,
  "icon" varchar(50),
  "color" varchar(20),
  "parent_id" uuid,
  "sort_order" integer DEFAULT 0,
  "is_active" boolean DEFAULT true,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "app_views" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "module_id" uuid NOT NULL,
  "name" varchar(100) NOT NULL,
  "display_name" varchar(100) NOT NULL,
  "description" text,
  "route_path" varchar(200) UNIQUE NOT NULL,
  "component_name" varchar(100) NOT NULL,
  "layout_name" varchar(50) DEFAULT 'default',
  "view_type" view_type NOT NULL DEFAULT 'page',
  "requires_auth" boolean DEFAULT true,
  "parent_view_id" uuid,
  "meta_data" jsonb,
  "sort_order" integer DEFAULT 0,
  "is_active" boolean DEFAULT true,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "app_actions" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "view_id" uuid NOT NULL,
  "name" varchar(100) NOT NULL,
  "display_name" varchar(100) NOT NULL,
  "description" text,
  "action_type" action_type NOT NULL DEFAULT 'button',
  "icon" varchar(50),
  "button_style" varchar(20) DEFAULT 'primary',
  "confirmation_message" text,
  "api_endpoint" varchar(200),
  "http_method" http_method DEFAULT 'GET',
  "redirect_to" varchar(200),
  "sort_order" integer DEFAULT 0,
  "is_active" boolean DEFAULT true,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "app_components" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "view_id" uuid NOT NULL,
  "name" varchar(100) NOT NULL,
  "component_type" component_type NOT NULL,
  "position" varchar(50),
  "grid_area" varchar(50),
  "props" jsonb,
  "data_source" varchar(200),
  "conditional_render" jsonb,
  "sort_order" integer DEFAULT 0,
  "is_active" boolean DEFAULT true,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "app_form_fields" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "component_id" uuid NOT NULL,
  "name" varchar(100) NOT NULL,
  "label" varchar(100) NOT NULL,
  "field_type" field_type NOT NULL,
  "validation_rules" jsonb,
  "options" jsonb,
  "placeholder" varchar(200),
  "help_text" text,
  "default_value" varchar(200),
  "is_required" boolean DEFAULT false,
  "is_readonly" boolean DEFAULT false,
  "conditional_logic" jsonb,
  "sort_order" integer DEFAULT 0,
  "is_active" boolean DEFAULT true,
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "app_table_columns" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "component_id" uuid NOT NULL,
  "name" varchar(100) NOT NULL,
  "label" varchar(100) NOT NULL,
  "column_type" column_type NOT NULL DEFAULT 'text',
  "width" varchar(20),
  "is_sortable" boolean DEFAULT true,
  "is_filterable" boolean DEFAULT true,
  "format_pattern" varchar(100),
  "render_as" varchar(50),
  "conditional_style" jsonb,
  "sort_order" integer DEFAULT 0,
  "is_visible" boolean DEFAULT true,
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "app_permissions" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "name" varchar(100) UNIQUE NOT NULL,
  "display_name" varchar(100) NOT NULL,
  "description" text,
  "module_id" uuid,
  "view_id" uuid,
  "action_id" uuid,
  "permission_type" permission_type NOT NULL DEFAULT 'action',
  "is_active" boolean DEFAULT true,
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "role_permissions" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "role" user_role NOT NULL,
  "permission_id" uuid NOT NULL,
  "is_granted" boolean DEFAULT true,
  "conditions" jsonb,
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "app_settings" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "key" varchar(100) UNIQUE NOT NULL,
  "value" text,
  "data_type" setting_data_type NOT NULL DEFAULT 'string',
  "category" varchar(50),
  "description" text,
  "is_public" boolean DEFAULT false,
  "is_editable" boolean DEFAULT true,
  "validation_pattern" varchar(200),
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "app_navigation" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "name" varchar(100) NOT NULL,
  "display_name" varchar(100) NOT NULL,
  "view_id" uuid,
  "external_url" varchar(500),
  "icon" varchar(50),
  "parent_id" uuid,
  "required_permission" varchar(100),
  "navigation_type" nav_type NOT NULL DEFAULT 'menu',
  "sort_order" integer DEFAULT 0,
  "is_active" boolean DEFAULT true,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE UNIQUE INDEX ON "products" ("sku");

CREATE UNIQUE INDEX ON "products" ("barcode");

CREATE INDEX ON "products" ("category_id");

CREATE INDEX ON "products" ("supplier_id");

CREATE INDEX ON "products" USING BTREE ("name");

CREATE UNIQUE INDEX ON "customers" ("document_number");

CREATE INDEX ON "customers" ("email");

CREATE INDEX ON "customers" ("customer_type");

CREATE INDEX ON "inventory_movements" ("product_id");

CREATE INDEX ON "inventory_movements" ("movement_type");

CREATE INDEX ON "inventory_movements" ("reference_type", "reference_id");

CREATE INDEX ON "inventory_movements" ("created_at");

CREATE UNIQUE INDEX ON "sales" ("sale_number");

CREATE INDEX ON "sales" ("customer_id");

CREATE INDEX ON "sales" ("user_id");

CREATE INDEX ON "sales" ("sale_date");

CREATE INDEX ON "sales" ("status");

CREATE INDEX ON "sale_items" ("sale_id");

CREATE INDEX ON "sale_items" ("product_id");

CREATE INDEX ON "payments" ("sale_id");

CREATE INDEX ON "payments" ("payment_date");

CREATE INDEX ON "payments" ("payment_method");

CREATE UNIQUE INDEX ON "purchases" ("purchase_number");

CREATE INDEX ON "purchases" ("supplier_id");

CREATE INDEX ON "purchases" ("purchase_date");

CREATE INDEX ON "purchases" ("status");

CREATE INDEX ON "purchase_items" ("purchase_id");

CREATE INDEX ON "purchase_items" ("product_id");

CREATE INDEX ON "app_views" ("module_id");

CREATE UNIQUE INDEX ON "app_views" ("route_path");

CREATE INDEX ON "app_views" ("component_name");

CREATE INDEX ON "app_actions" ("view_id");

CREATE INDEX ON "app_actions" ("name");

CREATE INDEX ON "app_components" ("view_id");

CREATE INDEX ON "app_components" ("component_type");

CREATE INDEX ON "app_components" ("position");

CREATE INDEX ON "app_form_fields" ("component_id");

CREATE INDEX ON "app_form_fields" ("name");

CREATE INDEX ON "app_form_fields" ("field_type");

CREATE INDEX ON "app_table_columns" ("component_id");

CREATE INDEX ON "app_table_columns" ("name");

CREATE UNIQUE INDEX ON "app_permissions" ("name");

CREATE INDEX ON "app_permissions" ("module_id");

CREATE INDEX ON "app_permissions" ("view_id");

CREATE INDEX ON "app_permissions" ("action_id");

CREATE UNIQUE INDEX ON "role_permissions" ("role", "permission_id");

CREATE INDEX ON "role_permissions" ("permission_id");

CREATE UNIQUE INDEX ON "app_settings" ("key");

CREATE INDEX ON "app_settings" ("category");

CREATE INDEX ON "app_settings" ("is_public");

CREATE INDEX ON "app_navigation" ("parent_id");

CREATE INDEX ON "app_navigation" ("view_id");

CREATE INDEX ON "app_navigation" ("navigation_type");

COMMENT ON TABLE "users" IS 'Usuarios del sistema con diferentes roles y permisos';

COMMENT ON COLUMN "users"."id" IS 'ID único del usuario';

COMMENT ON COLUMN "users"."email" IS 'Email de autenticación';

COMMENT ON COLUMN "users"."password_hash" IS 'Hash de contraseña con bcrypt + salt';

COMMENT ON COLUMN "users"."password_salt" IS 'Salt único para cada contraseña';

COMMENT ON COLUMN "users"."password_reset_token" IS 'Token para reseteo de contraseña';

COMMENT ON COLUMN "users"."password_reset_expires" IS 'Expiración del token de reseteo';

COMMENT ON COLUMN "users"."failed_login_attempts" IS 'Intentos fallidos de login';

COMMENT ON COLUMN "users"."account_locked_until" IS 'Cuenta bloqueada hasta esta fecha';

COMMENT ON COLUMN "users"."first_name" IS 'Nombre del usuario';

COMMENT ON COLUMN "users"."last_name" IS 'Apellido del usuario';

COMMENT ON COLUMN "users"."phone" IS 'Teléfono de contacto';

COMMENT ON COLUMN "users"."role" IS 'Rol del usuario en el sistema';

COMMENT ON COLUMN "users"."is_active" IS 'Estado activo/inactivo';

COMMENT ON COLUMN "users"."last_login_at" IS 'Último inicio de sesión';

COMMENT ON COLUMN "users"."created_at" IS 'Fecha de creación';

COMMENT ON COLUMN "users"."updated_at" IS 'Última actualización';

COMMENT ON TABLE "categories" IS 'Categorías jerárquicas de productos';

COMMENT ON COLUMN "categories"."parent_id" IS 'Categoría padre para estructura jerárquica';

COMMENT ON TABLE "suppliers" IS 'Proveedores de productos';

COMMENT ON COLUMN "suppliers"."business_name" IS 'Razón social';

COMMENT ON COLUMN "suppliers"."contact_name" IS 'Nombre de contacto';

COMMENT ON COLUMN "suppliers"."tax_id" IS 'NIT o documento fiscal';

COMMENT ON COLUMN "suppliers"."payment_terms" IS 'Días de plazo de pago';

COMMENT ON COLUMN "suppliers"."credit_limit" IS 'Límite de crédito';

COMMENT ON TABLE "products" IS 'Productos del inventario con información completa';

COMMENT ON COLUMN "products"."sku" IS 'Código interno del producto';

COMMENT ON COLUMN "products"."barcode" IS 'Código de barras';

COMMENT ON COLUMN "products"."name" IS 'Nombre del producto';

COMMENT ON COLUMN "products"."supplier_id" IS 'Proveedor principal';

COMMENT ON COLUMN "products"."unit_type" IS 'Unidad de medida';

COMMENT ON COLUMN "products"."cost_price" IS 'Precio de costo';

COMMENT ON COLUMN "products"."sale_price" IS 'Precio de venta';

COMMENT ON COLUMN "products"."tax_rate" IS 'Tasa de impuesto (IVA)';

COMMENT ON COLUMN "products"."min_stock" IS 'Stock mínimo para alerta';

COMMENT ON COLUMN "products"."max_stock" IS 'Stock máximo recomendado';

COMMENT ON COLUMN "products"."location" IS 'Ubicación en almacén';

COMMENT ON COLUMN "products"."expiration_days" IS 'Días hasta vencimiento (productos perecederos)';

COMMENT ON COLUMN "products"."image_url" IS 'URL de imagen del producto';

COMMENT ON TABLE "customers" IS 'Clientes del negocio (particulares y empresas)';

COMMENT ON COLUMN "customers"."business_name" IS 'Razón social (para empresas)';

COMMENT ON COLUMN "customers"."first_name" IS 'Nombre (para particulares)';

COMMENT ON COLUMN "customers"."last_name" IS 'Apellido (para particulares)';

COMMENT ON COLUMN "customers"."payment_terms" IS 'Días de crédito';

COMMENT ON TABLE "inventory_movements" IS 'Registro de todos los movimientos de inventario';

COMMENT ON COLUMN "inventory_movements"."quantity" IS 'Cantidad (positiva para entrada, negativa para salida)';

COMMENT ON COLUMN "inventory_movements"."unit_cost" IS 'Costo unitario al momento del movimiento';

COMMENT ON COLUMN "inventory_movements"."total_cost" IS 'Costo total del movimiento';

COMMENT ON COLUMN "inventory_movements"."reference_type" IS 'Tipo de documento que genera el movimiento';

COMMENT ON COLUMN "inventory_movements"."reference_id" IS 'ID del documento de referencia';

COMMENT ON COLUMN "inventory_movements"."supplier_id" IS 'Proveedor (para entradas)';

COMMENT ON COLUMN "inventory_movements"."user_id" IS 'Usuario que registra el movimiento';

COMMENT ON TABLE "current_stock" IS 'Stock actual por producto (tabla de resumen para performance)';

COMMENT ON COLUMN "current_stock"."product_id" IS 'Relación 1:1 con producto';

COMMENT ON COLUMN "current_stock"."current_quantity" IS 'Cantidad actual en stock';

COMMENT ON COLUMN "current_stock"."reserved_quantity" IS 'Cantidad reservada (pedidos pendientes)';

COMMENT ON COLUMN "current_stock"."available_quantity" IS 'Cantidad disponible (actual - reservada)';

COMMENT ON COLUMN "current_stock"."average_cost" IS 'Costo promedio ponderado';

COMMENT ON COLUMN "current_stock"."last_movement_at" IS 'Fecha del último movimiento';

COMMENT ON TABLE "sales" IS 'Ventas/facturas del sistema';

COMMENT ON COLUMN "sales"."sale_number" IS 'Número de factura/venta';

COMMENT ON COLUMN "sales"."user_id" IS 'Usuario que registra la venta';

COMMENT ON COLUMN "sales"."due_date" IS 'Fecha de vencimiento (para ventas a crédito)';

COMMENT ON COLUMN "sales"."subtotal" IS 'Subtotal sin impuestos';

COMMENT ON COLUMN "sales"."tax_amount" IS 'Total de impuestos';

COMMENT ON COLUMN "sales"."discount_amount" IS 'Total de descuentos';

COMMENT ON COLUMN "sales"."total_amount" IS 'Total final';

COMMENT ON COLUMN "sales"."tax_id" IS 'Número fiscal/DIAN';

COMMENT ON COLUMN "sales"."resolution" IS 'Resolución DIAN';

COMMENT ON TABLE "sale_items" IS 'Items/líneas de cada venta';

COMMENT ON COLUMN "sale_items"."sale_id" IS 'Venta a la que pertenece';

COMMENT ON COLUMN "sale_items"."quantity" IS 'Cantidad vendida';

COMMENT ON COLUMN "sale_items"."unit_price" IS 'Precio unitario al momento de la venta';

COMMENT ON COLUMN "sale_items"."discount_percentage" IS 'Porcentaje de descuento aplicado';

COMMENT ON COLUMN "sale_items"."discount_amount" IS 'Monto de descuento';

COMMENT ON COLUMN "sale_items"."tax_rate" IS 'Tasa de impuesto aplicada';

COMMENT ON COLUMN "sale_items"."tax_amount" IS 'Monto de impuesto';

COMMENT ON COLUMN "sale_items"."line_total" IS 'Total de la línea (precio * cantidad - descuento + impuesto)';

COMMENT ON TABLE "payments" IS 'Registro de pagos recibidos por ventas';

COMMENT ON COLUMN "payments"."amount" IS 'Monto del pago';

COMMENT ON COLUMN "payments"."reference" IS 'Referencia del pago (número de transacción, cheque, etc.)';

COMMENT ON COLUMN "payments"."user_id" IS 'Usuario que registra el pago';

COMMENT ON TABLE "purchases" IS 'Órdenes de compra a proveedores';

COMMENT ON COLUMN "purchases"."purchase_number" IS 'Número de orden de compra';

COMMENT ON COLUMN "purchases"."user_id" IS 'Usuario que registra la compra';

COMMENT ON COLUMN "purchases"."expected_date" IS 'Fecha esperada de entrega';

COMMENT ON COLUMN "purchases"."received_date" IS 'Fecha de recepción';

COMMENT ON TABLE "purchase_items" IS 'Items de cada orden de compra';

COMMENT ON COLUMN "purchase_items"."quantity_ordered" IS 'Cantidad ordenada';

COMMENT ON COLUMN "purchase_items"."quantity_received" IS 'Cantidad recibida';

COMMENT ON COLUMN "purchase_items"."unit_cost" IS 'Costo unitario';

COMMENT ON TABLE "app_modules" IS 'Módulos principales de la aplicación';

COMMENT ON COLUMN "app_modules"."name" IS 'Nombre del módulo (ej: inventory, sales)';

COMMENT ON COLUMN "app_modules"."display_name" IS 'Nombre para mostrar en UI';

COMMENT ON COLUMN "app_modules"."icon" IS 'Icono del módulo (ej: package, shopping-cart)';

COMMENT ON COLUMN "app_modules"."color" IS 'Color del tema del módulo';

COMMENT ON COLUMN "app_modules"."parent_id" IS 'Módulo padre para jerarquía';

COMMENT ON COLUMN "app_modules"."sort_order" IS 'Orden de visualización';

COMMENT ON TABLE "app_views" IS 'Vistas/pantallas de la aplicación con sus rutas';

COMMENT ON COLUMN "app_views"."name" IS 'Nombre único de la vista';

COMMENT ON COLUMN "app_views"."display_name" IS 'Título de la vista';

COMMENT ON COLUMN "app_views"."route_path" IS 'Ruta de la vista (ej: /inventory/products)';

COMMENT ON COLUMN "app_views"."component_name" IS 'Nombre del componente React';

COMMENT ON COLUMN "app_views"."layout_name" IS 'Layout a usar';

COMMENT ON COLUMN "app_views"."requires_auth" IS 'Requiere autenticación';

COMMENT ON COLUMN "app_views"."parent_view_id" IS 'Vista padre (para modals, tabs)';

COMMENT ON COLUMN "app_views"."meta_data" IS 'Metadatos adicionales (breadcrumbs, SEO, etc.)';

COMMENT ON TABLE "app_actions" IS 'Acciones disponibles en cada vista (botones, enlaces, etc.)';

COMMENT ON COLUMN "app_actions"."name" IS 'Nombre de la acción (ej: create, edit, delete)';

COMMENT ON COLUMN "app_actions"."display_name" IS 'Texto del botón/enlace';

COMMENT ON COLUMN "app_actions"."icon" IS 'Icono de la acción';

COMMENT ON COLUMN "app_actions"."button_style" IS 'Estilo del botón (primary, secondary, danger)';

COMMENT ON COLUMN "app_actions"."confirmation_message" IS 'Mensaje de confirmación antes de ejecutar';

COMMENT ON COLUMN "app_actions"."api_endpoint" IS 'Endpoint de API a llamar';

COMMENT ON COLUMN "app_actions"."redirect_to" IS 'Vista a donde redirigir después';

COMMENT ON TABLE "app_components" IS 'Componentes configurables por vista';

COMMENT ON COLUMN "app_components"."name" IS 'Nombre del componente';

COMMENT ON COLUMN "app_components"."position" IS 'Posición en la vista (header, main, sidebar, footer)';

COMMENT ON COLUMN "app_components"."grid_area" IS 'Área de CSS Grid';

COMMENT ON COLUMN "app_components"."props" IS 'Props/configuración del componente en JSON';

COMMENT ON COLUMN "app_components"."data_source" IS 'Endpoint o query para datos';

COMMENT ON COLUMN "app_components"."conditional_render" IS 'Condiciones para mostrar el componente';

COMMENT ON TABLE "app_form_fields" IS 'Campos configurables de formularios';

COMMENT ON COLUMN "app_form_fields"."name" IS 'Nombre del campo (atributo del modelo)';

COMMENT ON COLUMN "app_form_fields"."label" IS 'Etiqueta visible';

COMMENT ON COLUMN "app_form_fields"."validation_rules" IS 'Reglas de validación en JSON';

COMMENT ON COLUMN "app_form_fields"."options" IS 'Opciones para select, radio, etc.';

COMMENT ON COLUMN "app_form_fields"."placeholder" IS 'Placeholder del campo';

COMMENT ON COLUMN "app_form_fields"."help_text" IS 'Texto de ayuda';

COMMENT ON COLUMN "app_form_fields"."default_value" IS 'Valor por defecto';

COMMENT ON COLUMN "app_form_fields"."conditional_logic" IS 'Lógica condicional para mostrar/ocultar';

COMMENT ON TABLE "app_table_columns" IS 'Columnas configurables de tablas';

COMMENT ON COLUMN "app_table_columns"."name" IS 'Nombre de la columna (campo de la BD)';

COMMENT ON COLUMN "app_table_columns"."label" IS 'Etiqueta de la columna';

COMMENT ON COLUMN "app_table_columns"."width" IS 'Ancho de la columna (ej: 150px, 20%)';

COMMENT ON COLUMN "app_table_columns"."format_pattern" IS 'Patrón de formato (ej: currency, date)';

COMMENT ON COLUMN "app_table_columns"."render_as" IS 'Como renderizar (link, badge, image, etc.)';

COMMENT ON COLUMN "app_table_columns"."conditional_style" IS 'Estilos condicionales basados en valor';

COMMENT ON TABLE "app_permissions" IS 'Permisos granulares del sistema';

COMMENT ON COLUMN "app_permissions"."name" IS 'Nombre del permiso (ej: inventory.products.create)';

COMMENT ON COLUMN "app_permissions"."view_id" IS 'Vista específica (opcional)';

COMMENT ON COLUMN "app_permissions"."action_id" IS 'Acción específica (opcional)';

COMMENT ON TABLE "role_permissions" IS 'Permisos asignados a cada rol';

COMMENT ON COLUMN "role_permissions"."is_granted" IS 'true = permitir, false = denegar explícitamente';

COMMENT ON COLUMN "role_permissions"."conditions" IS 'Condiciones adicionales para el permiso';

COMMENT ON TABLE "app_settings" IS 'Configuración global de la aplicación';

COMMENT ON COLUMN "app_settings"."key" IS 'Clave de configuración';

COMMENT ON COLUMN "app_settings"."value" IS 'Valor de configuración';

COMMENT ON COLUMN "app_settings"."category" IS 'Categoría de configuración (ui, business, system)';

COMMENT ON COLUMN "app_settings"."is_public" IS 'Si es visible para el frontend';

COMMENT ON COLUMN "app_settings"."is_editable" IS 'Si se puede editar desde UI';

COMMENT ON COLUMN "app_settings"."validation_pattern" IS 'Patrón de validación';

COMMENT ON TABLE "app_navigation" IS 'Estructura de navegación y menús';

COMMENT ON COLUMN "app_navigation"."name" IS 'Nombre del item de navegación';

COMMENT ON COLUMN "app_navigation"."display_name" IS 'Texto a mostrar';

COMMENT ON COLUMN "app_navigation"."view_id" IS 'Vista a la que apunta';

COMMENT ON COLUMN "app_navigation"."external_url" IS 'URL externa (si no es una vista interna)';

COMMENT ON COLUMN "app_navigation"."icon" IS 'Icono del item';

COMMENT ON COLUMN "app_navigation"."parent_id" IS 'Item padre para menús anidados';

COMMENT ON COLUMN "app_navigation"."required_permission" IS 'Permiso requerido para ver el item';

ALTER TABLE "categories" ADD FOREIGN KEY ("parent_id") REFERENCES "categories" ("id");

ALTER TABLE "products" ADD FOREIGN KEY ("category_id") REFERENCES "categories" ("id");

ALTER TABLE "products" ADD FOREIGN KEY ("supplier_id") REFERENCES "suppliers" ("id");

ALTER TABLE "inventory_movements" ADD FOREIGN KEY ("product_id") REFERENCES "products" ("id");

ALTER TABLE "inventory_movements" ADD FOREIGN KEY ("supplier_id") REFERENCES "suppliers" ("id");

ALTER TABLE "inventory_movements" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "current_stock" ADD FOREIGN KEY ("product_id") REFERENCES "products" ("id");

ALTER TABLE "sales" ADD FOREIGN KEY ("customer_id") REFERENCES "customers" ("id");

ALTER TABLE "sales" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "sale_items" ADD FOREIGN KEY ("sale_id") REFERENCES "sales" ("id");

ALTER TABLE "sale_items" ADD FOREIGN KEY ("product_id") REFERENCES "products" ("id");

ALTER TABLE "payments" ADD FOREIGN KEY ("sale_id") REFERENCES "sales" ("id");

ALTER TABLE "payments" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "purchases" ADD FOREIGN KEY ("supplier_id") REFERENCES "suppliers" ("id");

ALTER TABLE "purchases" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "purchase_items" ADD FOREIGN KEY ("purchase_id") REFERENCES "purchases" ("id");

ALTER TABLE "purchase_items" ADD FOREIGN KEY ("product_id") REFERENCES "products" ("id");

ALTER TABLE "app_modules" ADD FOREIGN KEY ("parent_id") REFERENCES "app_modules" ("id");

ALTER TABLE "app_views" ADD FOREIGN KEY ("module_id") REFERENCES "app_modules" ("id");

ALTER TABLE "app_views" ADD FOREIGN KEY ("parent_view_id") REFERENCES "app_views" ("id");

ALTER TABLE "app_actions" ADD FOREIGN KEY ("view_id") REFERENCES "app_views" ("id");

ALTER TABLE "app_components" ADD FOREIGN KEY ("view_id") REFERENCES "app_views" ("id");

ALTER TABLE "app_form_fields" ADD FOREIGN KEY ("component_id") REFERENCES "app_components" ("id");

ALTER TABLE "app_table_columns" ADD FOREIGN KEY ("component_id") REFERENCES "app_components" ("id");

ALTER TABLE "app_permissions" ADD FOREIGN KEY ("module_id") REFERENCES "app_modules" ("id");

ALTER TABLE "app_permissions" ADD FOREIGN KEY ("view_id") REFERENCES "app_views" ("id");

ALTER TABLE "app_permissions" ADD FOREIGN KEY ("action_id") REFERENCES "app_actions" ("id");

ALTER TABLE "role_permissions" ADD FOREIGN KEY ("permission_id") REFERENCES "app_permissions" ("id");

ALTER TABLE "app_navigation" ADD FOREIGN KEY ("view_id") REFERENCES "app_views" ("id");

ALTER TABLE "app_navigation" ADD FOREIGN KEY ("parent_id") REFERENCES "app_navigation" ("id");

