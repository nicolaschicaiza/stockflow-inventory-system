-- ================================
-- TRIGGERS Y FUNCIONES PARA STOCKFLOW
-- ================================

-- ================================
-- FUNCIONES DE SEGURIDAD PARA USUARIOS
-- ================================

-- Función para generar salt aleatorio
CREATE OR REPLACE FUNCTION generate_salt()
RETURNS TEXT AS $$
BEGIN
    RETURN encode(gen_random_bytes(32), 'base64');
END;
$$ LANGUAGE plpgsql;

-- Función para incrementar intentos fallidos de login
CREATE OR REPLACE FUNCTION increment_failed_login(user_email VARCHAR)
RETURNS VOID AS $$
DECLARE
    current_attempts INTEGER;
BEGIN
    -- Obtener intentos actuales
    SELECT failed_login_attempts INTO current_attempts
    FROM users WHERE email = user_email;
    
    -- Incrementar intentos
    UPDATE users 
    SET 
        failed_login_attempts = failed_login_attempts + 1,
        -- Bloquear cuenta por 30 minutos después de 5 intentos fallidos
        account_locked_until = CASE 
            WHEN failed_login_attempts >= 4 
            THEN CURRENT_TIMESTAMP + INTERVAL '30 minutes'
            ELSE account_locked_until
        END,
        updated_at = CURRENT_TIMESTAMP
    WHERE email = user_email;
END;
$$ LANGUAGE plpgsql;

-- Función para resetear intentos fallidos (login exitoso)
CREATE OR REPLACE FUNCTION reset_failed_login(user_email VARCHAR)
RETURNS VOID AS $$
BEGIN
    UPDATE users 
    SET 
        failed_login_attempts = 0,
        account_locked_until = NULL,
        last_login_at = CURRENT_TIMESTAMP,
        updated_at = CURRENT_TIMESTAMP
    WHERE email = user_email;
END;
$$ LANGUAGE plpgsql;

-- Función para verificar si cuenta está bloqueada
CREATE OR REPLACE FUNCTION is_account_locked(user_email VARCHAR)
RETURNS BOOLEAN AS $$
DECLARE
    locked_until TIMESTAMP;
BEGIN
    SELECT account_locked_until INTO locked_until
    FROM users WHERE email = user_email;
    
    RETURN (locked_until IS NOT NULL AND locked_until > CURRENT_TIMESTAMP);
END;
$$ LANGUAGE plpgsql;

-- Trigger para generar salt automáticamente en INSERT
CREATE OR REPLACE FUNCTION auto_generate_salt()
RETURNS TRIGGER AS $$
BEGIN
    -- Solo generar salt si no se proporciona uno
    IF NEW.password_salt IS NULL THEN
        NEW.password_salt := generate_salt();
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_auto_salt
    BEFORE INSERT ON users
    FOR EACH ROW EXECUTE FUNCTION auto_generate_salt();

-- Función para actualizar timestamp automáticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Aplicar trigger de updated_at a todas las tablas que lo necesiten
CREATE TRIGGER update_users_updated_at 
    BEFORE UPDATE ON users 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_categories_updated_at 
    BEFORE UPDATE ON categories 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_suppliers_updated_at 
    BEFORE UPDATE ON suppliers 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_products_updated_at 
    BEFORE UPDATE ON products 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_customers_updated_at 
    BEFORE UPDATE ON customers 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_current_stock_updated_at 
    BEFORE UPDATE ON current_stock 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_sales_updated_at 
    BEFORE UPDATE ON sales 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_purchases_updated_at 
    BEFORE UPDATE ON purchases 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ================================
-- TRIGGER PARA ACTUALIZAR STOCK AUTOMÁTICAMENTE
-- ================================

-- Función para actualizar stock cuando hay movimientos
CREATE OR REPLACE FUNCTION update_current_stock()
RETURNS TRIGGER AS $$
BEGIN
    -- Insertar o actualizar registro en current_stock
    INSERT INTO current_stock (product_id, current_quantity, available_quantity, last_movement_at)
    VALUES (
        NEW.product_id, 
        NEW.quantity,
        NEW.quantity,
        NEW.created_at
    )
    ON CONFLICT (product_id) DO UPDATE SET
        current_quantity = current_stock.current_quantity + NEW.quantity,
        available_quantity = current_stock.available_quantity + NEW.quantity,
        last_movement_at = NEW.created_at;

    RETURN NEW;
END;
$$ language 'plpgsql';

-- Aplicar trigger al insertar movimientos de inventario
CREATE TRIGGER inventory_movement_update_stock
    AFTER INSERT ON inventory_movements
    FOR EACH ROW EXECUTE FUNCTION update_current_stock();

-- ================================
-- TRIGGER PARA ACTUALIZAR TOTALES DE VENTA
-- ================================

-- Función para calcular totales de venta automáticamente
CREATE OR REPLACE FUNCTION calculate_sale_totals()
RETURNS TRIGGER AS $$
DECLARE
    sale_subtotal DECIMAL(15,2) := 0;
    sale_tax_amount DECIMAL(15,2) := 0;
    sale_discount_amount DECIMAL(15,2) := 0;
    sale_total DECIMAL(15,2) := 0;
BEGIN
    -- Calcular totales basados en los items de la venta
    SELECT 
        COALESCE(SUM((unit_price * quantity) - discount_amount), 0),
        COALESCE(SUM(tax_amount), 0),
        COALESCE(SUM(discount_amount), 0)
    INTO sale_subtotal, sale_tax_amount, sale_discount_amount
    FROM sale_items 
    WHERE sale_id = COALESCE(NEW.sale_id, OLD.sale_id);

    sale_total := sale_subtotal + sale_tax_amount;

    -- Actualizar la tabla sales
    UPDATE sales SET
        subtotal = sale_subtotal,
        tax_amount = sale_tax_amount,
        discount_amount = sale_discount_amount,
        total_amount = sale_total,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = COALESCE(NEW.sale_id, OLD.sale_id);

    RETURN COALESCE(NEW, OLD);
END;
$$ language 'plpgsql';

-- Aplicar trigger a sale_items
CREATE TRIGGER sale_items_update_totals
    AFTER INSERT OR UPDATE OR DELETE ON sale_items
    FOR EACH ROW EXECUTE FUNCTION calculate_sale_totals();

-- ================================
-- TRIGGER PARA CREAR MOVIMIENTOS DE INVENTARIO AL VENDER
-- ================================

-- Función para crear movimientos de salida automáticamente
CREATE OR REPLACE FUNCTION create_sale_inventory_movement()
RETURNS TRIGGER AS $$
BEGIN
    -- Solo crear movimiento si es un INSERT (nueva venta)
    IF TG_OP = 'INSERT' THEN
        INSERT INTO inventory_movements (
            product_id,
            movement_type,
            quantity,
            reference_type,
            reference_id,
            user_id,
            notes,
            created_at
        )
        SELECT 
            NEW.product_id,
            'salida',
            -NEW.quantity, -- Negativo para salida
            'venta',
            NEW.sale_id,
            s.user_id,
            'Venta automática: ' || s.sale_number,
            NEW.created_at
        FROM sales s
        WHERE s.id = NEW.sale_id;
    END IF;

    RETURN NEW;
END;
$$ language 'plpgsql';

-- Aplicar trigger a sale_items para crear movimientos automáticamente
CREATE TRIGGER sale_items_create_inventory_movement
    AFTER INSERT ON sale_items
    FOR EACH ROW EXECUTE FUNCTION create_sale_inventory_movement();

-- ================================
-- FUNCIÓN PARA CALCULAR COSTO PROMEDIO PONDERADO
-- ================================

CREATE OR REPLACE FUNCTION update_average_cost()
RETURNS TRIGGER AS $$
DECLARE
    current_qty INTEGER;
    current_avg_cost DECIMAL(15,2);
    new_avg_cost DECIMAL(15,2);
BEGIN
    -- Solo calcular para movimientos de entrada con costo
    IF NEW.movement_type = 'entrada' AND NEW.unit_cost IS NOT NULL AND NEW.unit_cost > 0 THEN
        
        -- Obtener cantidad y costo actual
        SELECT current_quantity, average_cost 
        INTO current_qty, current_avg_cost
        FROM current_stock 
        WHERE product_id = NEW.product_id;

        -- Calcular nuevo costo promedio ponderado
        IF current_qty > 0 AND current_avg_cost > 0 THEN
            new_avg_cost := ((current_avg_cost * current_qty) + (NEW.unit_cost * NEW.quantity)) 
                           / (current_qty + NEW.quantity);
        ELSE
            new_avg_cost := NEW.unit_cost;
        END IF;

        -- Actualizar costo promedio
        UPDATE current_stock 
        SET average_cost = new_avg_cost
        WHERE product_id = NEW.product_id;
    END IF;

    RETURN NEW;
END;
$$ language 'plpgsql';

-- Aplicar trigger para calcular costo promedio
CREATE TRIGGER inventory_movement_update_avg_cost
    AFTER INSERT ON inventory_movements
    FOR EACH ROW EXECUTE FUNCTION update_average_cost();

-- ================================
-- ÍNDICES ADICIONALES PARA PERFORMANCE
-- ================================

-- Índices compuestos para consultas comunes
CREATE INDEX idx_inventory_movements_product_date ON inventory_movements(product_id, created_at DESC);
CREATE INDEX idx_sale_items_sale_product ON sale_items(sale_id, product_id);
CREATE INDEX idx_sales_customer_date ON sales(customer_id, sale_date DESC);
CREATE INDEX idx_products_active_category ON products(is_active, category_id) WHERE is_active = true;

-- Índice para búsqueda de productos
CREATE INDEX idx_products_search ON products USING gin(to_tsvector('spanish', name || ' ' || COALESCE(description, '')));

-- ================================
-- VISTAS ÚTILES PARA REPORTES
-- ================================

-- Vista de stock con información del producto
CREATE VIEW v_current_stock_detailed AS
SELECT 
    cs.*,
    p.name as product_name,
    p.sku,
    p.barcode,
    p.sale_price,
    p.min_stock,
    CASE 
        WHEN cs.current_quantity <= p.min_stock THEN true 
        ELSE false 
    END as low_stock_alert,
    c.name as category_name
FROM current_stock cs
JOIN products p ON cs.product_id = p.id
LEFT JOIN categories c ON p.category_id = c.id
WHERE p.is_active = true;

-- Vista de ventas con información del cliente
CREATE VIEW v_sales_detailed AS
SELECT 
    s.*,
    CASE 
        WHEN c.customer_type = 'empresa' THEN c.business_name
        ELSE c.first_name || ' ' || c.last_name
    END as customer_name,
    c.document_number,
    u.first_name || ' ' || u.last_name as seller_name
FROM sales s
JOIN customers c ON s.customer_id = c.id
JOIN users u ON s.user_id = u.id;

-- Vista de top productos más vendidos
CREATE VIEW v_top_selling_products AS
SELECT 
    p.id,
    p.name,
    p.sku,
    SUM(si.quantity) as total_sold,
    SUM(si.line_total) as total_revenue,
    COUNT(DISTINCT si.sale_id) as times_sold,
    AVG(si.unit_price) as avg_selling_price
FROM products p
JOIN sale_items si ON p.id = si.product_id
JOIN sales s ON si.sale_id = s.id
WHERE s.status IN ('pagada', 'parcial')
GROUP BY p.id, p.name, p.sku
ORDER BY total_sold DESC;

-- ================================
-- FUNCIONES PARA SISTEMA DE CONTROL DE APLICACIÓN
-- ================================

-- Función para obtener menú de navegación por usuario
CREATE OR REPLACE FUNCTION get_user_navigation(user_role_param user_role)
RETURNS TABLE (
    id uuid,
    name varchar(100),
    display_name varchar(100),
    route_path varchar(200),
    icon varchar(50),
    parent_id uuid,
    sort_order integer,
    has_permission boolean
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        n.id,
        n.name,
        n.display_name,
        COALESCE(v.route_path, n.external_url) as route_path,
        n.icon,
        n.parent_id,
        n.sort_order,
        CASE 
            WHEN n.required_permission IS NULL THEN true
            ELSE EXISTS (
                SELECT 1 FROM role_permissions rp
                JOIN app_permissions ap ON rp.permission_id = ap.id
                WHERE rp.role = user_role_param 
                AND ap.name = n.required_permission 
                AND rp.is_granted = true
            )
        END as has_permission
    FROM app_navigation n
    LEFT JOIN app_views v ON n.view_id = v.id
    WHERE n.is_active = true
    AND n.navigation_type = 'menu'
    ORDER BY n.sort_order;
END;
$$ LANGUAGE plpgsql;

-- Función para verificar permisos de usuario
CREATE OR REPLACE FUNCTION check_user_permission(user_role_param user_role, permission_name varchar)
RETURNS boolean AS $$
DECLARE
    has_permission boolean := false;
BEGIN
    SELECT rp.is_granted INTO has_permission
    FROM role_permissions rp
    JOIN app_permissions ap ON rp.permission_id = ap.id
    WHERE rp.role = user_role_param 
    AND ap.name = permission_name;
    
    RETURN COALESCE(has_permission, false);
END;
$$ LANGUAGE plpgsql;

-- Función para obtener configuración de vista por ruta
CREATE OR REPLACE FUNCTION get_view_config(route_path_param varchar, user_role_param user_role)
RETURNS TABLE (
    view_id uuid,
    view_name varchar(100),
    display_name varchar(100),
    component_name varchar(100),
    layout_name varchar(50),
    meta_data jsonb,
    has_access boolean
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        v.id as view_id,
        v.name as view_name,
        v.display_name,
        v.component_name,
        v.layout_name,
        v.meta_data,
        CASE 
            WHEN v.requires_auth = false THEN true
            ELSE EXISTS (
                SELECT 1 FROM role_permissions rp
                JOIN app_permissions ap ON rp.permission_id = ap.id
                WHERE rp.role = user_role_param 
                AND (ap.view_id = v.id OR ap.module_id = v.module_id)
                AND rp.is_granted = true
            )
        END as has_access
    FROM app_views v
    WHERE v.route_path = route_path_param
    AND v.is_active = true;
END;
$$ LANGUAGE plpgsql;

-- Función para obtener componentes de una vista
CREATE OR REPLACE FUNCTION get_view_components(view_id_param uuid, user_role_param user_role)
RETURNS TABLE (
    component_id uuid,
    component_name varchar(100),
    component_type component_type,
    position varchar(50),
    props jsonb,
    data_source varchar(200),
    sort_order integer
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.id as component_id,
        c.name as component_name,
        c.component_type,
        c.position,
        c.props,
        c.data_source,
        c.sort_order
    FROM app_components c
    WHERE c.view_id = view_id_param
    AND c.is_active = true
    ORDER BY c.sort_order;
END;
$$ LANGUAGE plpgsql;

-- Función para obtener acciones disponibles en una vista
CREATE OR REPLACE FUNCTION get_view_actions(view_id_param uuid, user_role_param user_role)
RETURNS TABLE (
    action_id uuid,
    action_name varchar(100),
    display_name varchar(100),
    action_type action_type,
    icon varchar(50),
    button_style varchar(20),
    api_endpoint varchar(200),
    http_method http_method,
    has_permission boolean
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        a.id as action_id,
        a.name as action_name,
        a.display_name,
        a.action_type,
        a.icon,
        a.button_style,
        a.api_endpoint,
        a.http_method,
        -- Verificar si el usuario tiene permiso para esta acción
        EXISTS (
            SELECT 1 FROM role_permissions rp
            JOIN app_permissions ap ON rp.permission_id = ap.id
            WHERE rp.role = user_role_param 
            AND (ap.action_id = a.id OR ap.view_id = view_id_param)
            AND rp.is_granted = true
        ) as has_permission
    FROM app_actions a
    WHERE a.view_id = view_id_param
    AND a.is_active = true
    ORDER BY a.sort_order;
END;
$$ LANGUAGE plpgsql;

-- Función para obtener configuración de formulario
CREATE OR REPLACE FUNCTION get_form_config(component_id_param uuid)
RETURNS TABLE (
    field_id uuid,
    field_name varchar(100),
    label varchar(100),
    field_type field_type,
    validation_rules jsonb,
    options jsonb,
    placeholder varchar(200),
    help_text text,
    default_value varchar(200),
    is_required boolean,
    is_readonly boolean,
    sort_order integer
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        f.id as field_id,
        f.name as field_name,
        f.label,
        f.field_type,
        f.validation_rules,
        f.options,
        f.placeholder,
        f.help_text,
        f.default_value,
        f.is_required,
        f.is_readonly,
        f.sort_order
    FROM app_form_fields f
    WHERE f.component_id = component_id_param
    AND f.is_active = true
    ORDER BY f.sort_order;
END;
$$ LANGUAGE plpgsql;

-- Función para obtener configuración de tabla
CREATE OR REPLACE FUNCTION get_table_config(component_id_param uuid)
RETURNS TABLE (
    column_id uuid,
    column_name varchar(100),
    label varchar(100),
    column_type column_type,
    width varchar(20),
    is_sortable boolean,
    is_filterable boolean,
    format_pattern varchar(100),
    render_as varchar(50),
    sort_order integer,
    is_visible boolean
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        tc.id as column_id,
        tc.name as column_name,
        tc.label,
        tc.column_type,
        tc.width,
        tc.is_sortable,
        tc.is_filterable,
        tc.format_pattern,
        tc.render_as,
        tc.sort_order,
        tc.is_visible
    FROM app_table_columns tc
    WHERE tc.component_id = component_id_param
    AND tc.is_visible = true
    ORDER BY tc.sort_order;
END;
$$ LANGUAGE plpgsql;

-- Función para obtener configuración global de la aplicación
CREATE OR REPLACE FUNCTION get_app_config(category_filter varchar DEFAULT NULL, public_only boolean DEFAULT false)
RETURNS TABLE (
    setting_key varchar(100),
    setting_value text,
    data_type setting_data_type,
    category varchar(50)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        s.key as setting_key,
        s.value as setting_value,
        s.data_type,
        s.category
    FROM app_settings s
    WHERE (category_filter IS NULL OR s.category = category_filter)
    AND (public_only = false OR s.is_public = true)
    ORDER BY s.category, s.key;
END;
$$ LANGUAGE plpgsql;

-- Función para registrar auditoría de acciones
CREATE OR REPLACE FUNCTION log_user_action(
    user_id_param uuid,
    action_name_param varchar,
    view_name_param varchar,
    details_param jsonb DEFAULT NULL
)
RETURNS void AS $$
BEGIN
    -- Por ahora solo insertamos en una tabla de logs básica
    -- En el futuro se puede expandir para auditoría completa
    INSERT INTO inventory_movements (product_id, movement_type, quantity, reference_type, user_id, notes)
    SELECT 
        'prod-550e8400-e29b-41d4-a716-446655440000', -- Producto dummy para audit
        'ajuste_positivo', 
        0, 
        'inicial',
        user_id_param,
        'AUDIT: ' || action_name_param || ' en ' || view_name_param || COALESCE(' - ' || details_param::text, '');
    -- Esta es una implementación temporal, idealmente habría una tabla de audit específica
END;
$$ LANGUAGE plpgsql;