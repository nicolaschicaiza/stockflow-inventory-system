-- ================================
-- DATOS DE PRUEBA PARA STOCKFLOW
-- ================================

-- Limpiar datos existentes (en orden de dependencias)
TRUNCATE TABLE payments CASCADE;
TRUNCATE TABLE purchase_items CASCADE;
TRUNCATE TABLE purchases CASCADE;
TRUNCATE TABLE sale_items CASCADE;
TRUNCATE TABLE sales CASCADE;
TRUNCATE TABLE inventory_movements CASCADE;
TRUNCATE TABLE current_stock CASCADE;
TRUNCATE TABLE products CASCADE;
TRUNCATE TABLE categories CASCADE;
TRUNCATE TABLE customers CASCADE;
TRUNCATE TABLE suppliers CASCADE;
TRUNCATE TABLE users CASCADE;

-- ================================
-- USUARIOS DE PRUEBA
-- ================================

INSERT INTO users (id, email, password_hash, password_salt, first_name, last_name, phone, role, is_active) VALUES
-- Contraseña: admin123 (bcrypt hash con salt único)
('550e8400-e29b-41d4-a716-446655440000', 'admin@stockflow.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBcQQzgzqS0eWu', 'Wn8rF2kP9sL6mC4vB7xZ1qE5tY3uI0o', 'Carlos', 'Administrador', '+57 300 123 4567', 'admin', true),

-- Contraseña: cajero123 (salt único)
('550e8400-e29b-41d4-a716-446655440001', 'maria.cajera@stockflow.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBcQQzgzqS1eWv', 'Qm7rF3kP8sL5mC6vB4xZ2qE9tY1uI7p', 'María', 'Rodríguez', '+57 300 123 4568', 'cajero', true),

-- Contraseña: contador123 (salt único)
('550e8400-e29b-41d4-a716-446655440002', 'juan.contador@stockflow.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBcQQzgzqS2eWw', 'Rm6rF4kP7sL8mC3vB5xZ0qE2tY6uI9q', 'Juan', 'Pérez', '+57 300 123 4569', 'contador', true),

-- Cajero adicional
('550e8400-e29b-41d4-a716-446655440003', 'ana.ventas@stockflow.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBcQQzgzqS3eWx', 'Sm9rF1kP6sL2mC8vB3xZ5qE7tY4uI1r', 'Ana', 'Gómez', '+57 300 123 4570', 'cajero', true);

-- ================================
-- CATEGORÍAS DE PRODUCTOS
-- ================================

INSERT INTO categories (id, name, description, parent_id, is_active) VALUES
-- Categorías principales
('cat-550e8400-e29b-41d4-a716-446655440000', 'Bebidas', 'Bebidas frías y calientes', null, true),
('cat-550e8400-e29b-41d4-a716-446655440001', 'Snacks', 'Snacks y comida rápida', null, true),
('cat-550e8400-e29b-41d4-a716-446655440002', 'Productos de Limpieza', 'Artículos de aseo y limpieza', null, true),
('cat-550e8400-e29b-41d4-a716-446655440003', 'Lácteos', 'Productos lácteos y derivados', null, true),

-- Subcategorías de bebidas
('cat-550e8400-e29b-41d4-a716-446655440010', 'Gaseosas', 'Bebidas gaseosas', 'cat-550e8400-e29b-41d4-a716-446655440000', true),
('cat-550e8400-e29b-41d4-a716-446655440011', 'Jugos', 'Jugos naturales y artificiales', 'cat-550e8400-e29b-41d4-a716-446655440000', true),
('cat-550e8400-e29b-41d4-a716-446655440012', 'Agua', 'Agua mineral y purificada', 'cat-550e8400-e29b-41d4-a716-446655440000', true),

-- Subcategorías de snacks
('cat-550e8400-e29b-41d4-a716-446655440020', 'Papas', 'Papas fritas y similares', 'cat-550e8400-e29b-41d4-a716-446655440001', true),
('cat-550e8400-e29b-41d4-a716-446655440021', 'Dulces', 'Caramelos y golosinas', 'cat-550e8400-e29b-41d4-a716-446655440001', true);

-- ================================
-- PROVEEDORES
-- ================================

INSERT INTO suppliers (id, business_name, contact_name, tax_id, email, phone, address, city, payment_terms, credit_limit, is_active) VALUES
('sup-550e8400-e29b-41d4-a716-446655440000', 'Distribuidora Coca-Cola FEMSA', 'Luis Martínez', '890123456-1', 'ventas@femsa.com', '+57 1 234 5678', 'Calle 100 # 15-20', 'Bogotá', 30, 5000000, true),
('sup-550e8400-e29b-41d4-a716-446655440001', 'Productos Alimenticios Doria', 'Carmen Díaz', '890234567-2', 'pedidos@doria.com', '+57 4 567 8901', 'Carrera 50 # 25-30', 'Medellín', 15, 2000000, true),
('sup-550e8400-e29b-41d4-a716-446655440002', 'Lácteos San Fernando', 'Roberto Silva', '890345678-3', 'comercial@sanfernando.com', '+57 2 345 6789', 'Autopista Norte Km 15', 'Cali', 30, 3000000, true),
('sup-550e8400-e29b-41d4-a716-446655440003', 'Distribuciones El Sol', 'Patricia López', '890456789-4', 'info@elsol.com', '+57 5 678 9012', 'Zona Industrial Mamonal', 'Cartagena', 45, 1500000, true);

-- ================================
-- PRODUCTOS
-- ================================

INSERT INTO products (id, sku, barcode, name, description, category_id, supplier_id, unit_type, cost_price, sale_price, tax_rate, min_stock, max_stock, location, is_active) VALUES
-- Bebidas - Gaseosas
('prod-550e8400-e29b-41d4-a716-446655440000', 'COCA-350ML', '7702545001234', 'Coca-Cola 350ml', 'Gaseosa Coca-Cola lata 350ml', 'cat-550e8400-e29b-41d4-a716-446655440010', 'sup-550e8400-e29b-41d4-a716-446655440000', 'unidad', 1200, 2000, 19, 50, 200, 'A1-B2', true),
('prod-550e8400-e29b-41d4-a716-446655440001', 'SPRITE-350ML', '7702545001235', 'Sprite 350ml', 'Gaseosa Sprite lata 350ml', 'cat-550e8400-e29b-41d4-a716-446655440010', 'sup-550e8400-e29b-41d4-a716-446655440000', 'unidad', 1200, 2000, 19, 30, 150, 'A1-B3', true),
('prod-550e8400-e29b-41d4-a716-446655440002', 'PEPSI-500ML', '7702543001236', 'Pepsi 500ml', 'Gaseosa Pepsi botella 500ml', 'cat-550e8400-e29b-41d4-a716-446655440010', 'sup-550e8400-e29b-41d4-a716-446655440001', 'unidad', 1500, 2500, 19, 40, 180, 'A2-B1', true),

-- Agua
('prod-550e8400-e29b-41d4-a716-446655440003', 'CRISTAL-500ML', '7702540001237', 'Agua Cristal 500ml', 'Agua purificada Cristal 500ml', 'cat-550e8400-e29b-41d4-a716-446655440012', 'sup-550e8400-e29b-41d4-a716-446655440000', 'unidad', 800, 1500, 19, 60, 300, 'A3-B1', true),

-- Jugos
('prod-550e8400-e29b-41d4-a716-446655440004', 'JUGO-NARANJA-1L', '7702541001238', 'Jugo de Naranja 1L', 'Jugo natural de naranja 1 litro', 'cat-550e8400-e29b-41d4-a716-446655440011', 'sup-550e8400-e29b-41d4-a716-446655440001', 'unidad', 2500, 4000, 19, 20, 100, 'B1-C1', true),

-- Snacks - Papas
('prod-550e8400-e29b-41d4-a716-446655440005', 'PAPAS-MARGARITA-50G', '7702542001239', 'Papas Margarita 50g', 'Papas fritas Margarita sabor natural 50g', 'cat-550e8400-e29b-41d4-a716-446655440020', 'sup-550e8400-e29b-41d4-a716-446655440001', 'unidad', 800, 1500, 19, 100, 500, 'C1-A1', true),
('prod-550e8400-e29b-41d4-a716-446655440006', 'PAPAS-PLATANITOS-45G', '7702542001240', 'Platanitos 45g', 'Plátanos fritos Margarita 45g', 'cat-550e8400-e29b-41d4-a716-446655440020', 'sup-550e8400-e29b-41d4-a716-446655440001', 'unidad', 900, 1600, 19, 80, 400, 'C1-A2', true),

-- Lácteos
('prod-550e8400-e29b-41d4-a716-446655440007', 'LECHE-ALPINA-1L', '7702544001241', 'Leche Alpina 1L', 'Leche entera UHT Alpina 1 litro', 'cat-550e8400-e29b-41d4-a716-446655440003', 'sup-550e8400-e29b-41d4-a716-446655440002', 'unidad', 2200, 3500, 19, 30, 150, 'D1-A1', true),
('prod-550e8400-e29b-41d4-a716-446655440008', 'YOGURT-ALPINA-200ML', '7702544001242', 'Yogurt Alpina 200ml', 'Yogurt natural Alpina 200ml', 'cat-550e8400-e29b-41d4-a716-446655440003', 'sup-550e8400-e29b-41d4-a716-446655440002', 'unidad', 1800, 2800, 19, 25, 120, 'D1-B1', true),

-- Productos de limpieza
('prod-550e8400-e29b-41d4-a716-446655440009', 'JABON-FAB-500G', '7702545001243', 'Jabón en Polvo Fab 500g', 'Detergente en polvo Fab 500 gramos', 'cat-550e8400-e29b-41d4-a716-446655440002', 'sup-550e8400-e29b-41d4-a716-446655440003', 'unidad', 3200, 5000, 19, 15, 80, 'E1-A1', true);

-- ================================
-- CLIENTES
-- ================================

INSERT INTO customers (id, customer_type, business_name, first_name, last_name, document_type, document_number, email, phone, mobile, address, city, credit_limit, payment_terms, is_active) VALUES
-- Clientes particulares
('cust-550e8400-e29b-41d4-a716-446655440000', 'particular', null, 'Pedro', 'González', 'cedula', '12345678', 'pedro.gonzalez@email.com', null, '+57 300 111 2222', 'Carrera 15 # 25-30', 'Bogotá', 0, 0, true),
('cust-550e8400-e29b-41d4-a716-446655440001', 'particular', null, 'Laura', 'Martínez', 'cedula', '23456789', 'laura.martinez@email.com', null, '+57 310 222 3333', 'Calle 80 # 10-15', 'Bogotá', 100000, 8, true),
('cust-550e8400-e29b-41d4-a716-446655440002', 'particular', null, 'Andrea', 'Ramírez', 'cedula', '34567890', null, null, '+57 320 333 4444', 'Avenida 68 # 45-20', 'Bogotá', 0, 0, true),

-- Clientes empresariales
('cust-550e8400-e29b-41d4-a716-446655440003', 'empresa', 'Restaurante El Buen Sabor', 'Miguel', 'Torres', 'nit', '900123456-7', 'gerencia@elbuensabor.com', '+57 1 456 7890', '+57 315 555 6666', 'Zona Rosa, Local 105', 'Bogotá', 500000, 15, true),
('cust-550e8400-e29b-41d4-a716-446655440004', 'empresa', 'Cafetería Central', 'Sandra', 'López', 'nit', '900234567-8', 'admin@cafeteriacentral.com', '+57 1 567 8901', '+57 325 666 7777', 'Centro Comercial Andino', 'Bogotá', 300000, 10, true),
('cust-550e8400-e29b-41d4-a716-446655440005', 'empresa', 'Tienda Don José', null, 'José', 'nit', '900345678-9', 'donjosenunez@gmail.com', null, '+57 318 777 8888', 'Barrio La Candelaria', 'Bogotá', 200000, 30, true);

-- ================================
-- INVENTARIO INICIAL
-- ================================

-- Crear registros en current_stock primero
INSERT INTO current_stock (product_id, current_quantity, available_quantity, average_cost) VALUES
('prod-550e8400-e29b-41d4-a716-446655440000', 100, 100, 1200), -- Coca-Cola
('prod-550e8400-e29b-41d4-a716-446655440001', 75, 75, 1200),   -- Sprite
('prod-550e8400-e29b-41d4-a716-446655440002', 80, 80, 1500),   -- Pepsi
('prod-550e8400-e29b-41d4-a716-446655440003', 150, 150, 800),  -- Agua Cristal
('prod-550e8400-e29b-41d4-a716-446655440004', 40, 40, 2500),   -- Jugo Naranja
('prod-550e8400-e29b-41d4-a716-446655440005', 200, 200, 800),  -- Papas Margarita
('prod-550e8400-e29b-41d4-a716-446655440006', 150, 150, 900),  -- Platanitos
('prod-550e8400-e29b-41d4-a716-446655440007', 60, 60, 2200),   -- Leche Alpina
('prod-550e8400-e29b-41d4-a716-446655440008', 80, 80, 1800),   -- Yogurt Alpina
('prod-550e8400-e29b-41d4-a716-446655440009', 25, 25, 3200);   -- Jabón Fab

-- Crear movimientos de inventario inicial
INSERT INTO inventory_movements (product_id, movement_type, quantity, unit_cost, total_cost, reference_type, user_id, notes) VALUES
-- Inventario inicial para todos los productos
('prod-550e8400-e29b-41d4-a716-446655440000', 'entrada', 100, 1200, 120000, 'inicial', '550e8400-e29b-41d4-a716-446655440000', 'Inventario inicial - Coca-Cola 350ml'),
('prod-550e8400-e29b-41d4-a716-446655440001', 'entrada', 75, 1200, 90000, 'inicial', '550e8400-e29b-41d4-a716-446655440000', 'Inventario inicial - Sprite 350ml'),
('prod-550e8400-e29b-41d4-a716-446655440002', 'entrada', 80, 1500, 120000, 'inicial', '550e8400-e29b-41d4-a716-446655440000', 'Inventario inicial - Pepsi 500ml'),
('prod-550e8400-e29b-41d4-a716-446655440003', 'entrada', 150, 800, 120000, 'inicial', '550e8400-e29b-41d4-a716-446655440000', 'Inventario inicial - Agua Cristal 500ml'),
('prod-550e8400-e29b-41d4-a716-446655440004', 'entrada', 40, 2500, 100000, 'inicial', '550e8400-e29b-41d4-a716-446655440000', 'Inventario inicial - Jugo Naranja 1L'),
('prod-550e8400-e29b-41d4-a716-446655440005', 'entrada', 200, 800, 160000, 'inicial', '550e8400-e29b-41d4-a716-446655440000', 'Inventario inicial - Papas Margarita 50g'),
('prod-550e8400-e29b-41d4-a716-446655440006', 'entrada', 150, 900, 135000, 'inicial', '550e8400-e29b-41d4-a716-446655440000', 'Inventario inicial - Platanitos 45g'),
('prod-550e8400-e29b-41d4-a716-446655440007', 'entrada', 60, 2200, 132000, 'inicial', '550e8400-e29b-41d4-a716-446655440000', 'Inventario inicial - Leche Alpina 1L'),
('prod-550e8400-e29b-41d4-a716-446655440008', 'entrada', 80, 1800, 144000, 'inicial', '550e8400-e29b-41d4-a716-446655440000', 'Inventario inicial - Yogurt Alpina 200ml'),
('prod-550e8400-e29b-41d4-a716-446655440009', 'entrada', 25, 3200, 80000, 'inicial', '550e8400-e29b-41d4-a716-446655440000', 'Inventario inicial - Jabón Fab 500g');

-- ================================
-- VENTAS DE EJEMPLO
-- ================================

-- Venta 1: Cliente particular - Pedro González
INSERT INTO sales (id, sale_number, customer_id, user_id, sale_date, status, payment_method) VALUES
('sale-550e8400-e29b-41d4-a716-446655440000', 'FAC-001', 'cust-550e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440001', '2025-08-30 14:30:00', 'pagada', 'efectivo');

-- Items de la venta 1
INSERT INTO sale_items (sale_id, product_id, quantity, unit_price, tax_rate, tax_amount, line_total) VALUES
('sale-550e8400-e29b-41d4-a716-446655440000', 'prod-550e8400-e29b-41d4-a716-446655440000', 2, 2000, 19, 380, 4380), -- 2 Coca-Colas
('sale-550e8400-e29b-41d4-a716-446655440000', 'prod-550e8400-e29b-41d4-a716-446655440005', 3, 1500, 19, 855, 5355), -- 3 Papas Margarita
('sale-550e8400-e29b-41d4-a716-446655440000', 'prod-550e8400-e29b-41d4-a716-446655440003', 1, 1500, 19, 285, 1785);  -- 1 Agua

-- Venta 2: Cliente empresarial - Restaurante El Buen Sabor
INSERT INTO sales (id, sale_number, customer_id, user_id, sale_date, status, payment_method) VALUES
('sale-550e8400-e29b-41d4-a716-446655440001', 'FAC-002', 'cust-550e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440003', '2025-08-30 16:45:00', 'pagada', 'transferencia');

-- Items de la venta 2 (compra más grande)
INSERT INTO sale_items (sale_id, product_id, quantity, unit_price, tax_rate, tax_amount, line_total) VALUES
('sale-550e8400-e29b-41d4-a716-446655440001', 'prod-550e8400-e29b-41d4-a716-446655440000', 12, 2000, 19, 4560, 28560), -- 12 Coca-Colas
('sale-550e8400-e29b-41d4-a716-446655440001', 'prod-550e8400-e29b-41d4-a716-446655440001', 8, 2000, 19, 3040, 19040),   -- 8 Sprites
('sale-550e8400-e29b-41d4-a716-446655440001', 'prod-550e8400-e29b-41d4-a716-446655440003', 20, 1500, 19, 5700, 35700),  -- 20 Aguas
('sale-550e8400-e29b-41d4-a716-446655440001', 'prod-550e8400-e29b-41d4-a716-446655440007', 5, 3500, 19, 3325, 20825);   -- 5 Leches

-- Venta 3: Cliente a crédito
INSERT INTO sales (id, sale_number, customer_id, user_id, sale_date, due_date, status, payment_method) VALUES
('sale-550e8400-e29b-41d4-a716-446655440002', 'FAC-003', 'cust-550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', '2025-08-29 11:20:00', '2025-09-06 11:20:00', 'pendiente', 'credito');

-- Items de la venta 3
INSERT INTO sale_items (sale_id, product_id, quantity, unit_price, tax_rate, tax_amount, line_total) VALUES
('sale-550e8400-e29b-41d4-a716-446655440002', 'prod-550e8400-e29b-41d4-a716-446655440004', 2, 4000, 19, 1520, 9520), -- 2 Jugos Naranja
('sale-550e8400-e29b-41d4-a716-446655440002', 'prod-550e8400-e29b-41d4-a716-446655440008', 4, 2800, 19, 2128, 13328); -- 4 Yogurts

-- ================================
-- PAGOS DE EJEMPLO
-- ================================

-- Pagos para ventas pagadas
INSERT INTO payments (sale_id, amount, payment_method, reference, user_id) VALUES
('sale-550e8400-e29b-41d4-a716-446655440000', 11520, 'efectivo', 'EFECTIVO-001', '550e8400-e29b-41d4-a716-446655440001'),
('sale-550e8400-e29b-41d4-a716-446655440001', 104125, 'transferencia', 'TRANS-20250830-001', '550e8400-e29b-41d4-a716-446655440003');

-- ================================
-- COMPRAS DE EJEMPLO
-- ================================

-- Compra 1: Restock de bebidas
INSERT INTO purchases (id, purchase_number, supplier_id, user_id, purchase_date, status) VALUES
('purch-550e8400-e29b-41d4-a716-446655440000', 'OC-001', 'sup-550e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440000', '2025-08-28 10:00:00', 'recibida');

-- Items de la compra 1
INSERT INTO purchase_items (purchase_id, product_id, quantity_ordered, quantity_received, unit_cost, tax_rate, tax_amount, line_total) VALUES
('purch-550e8400-e29b-41d4-a716-446655440000', 'prod-550e8400-e29b-41d4-a716-446655440000', 50, 50, 1200, 19, 11400, 71400), -- 50 Coca-Colas
('purch-550e8400-e29b-41d4-a716-446655440000', 'prod-550e8400-e29b-41d4-a716-446655440001', 30, 30, 1200, 19, 6840, 42840),   -- 30 Sprites
('purch-550e8400-e29b-41d4-a716-446655440000', 'prod-550e8400-e29b-41d4-a716-446655440003', 100, 100, 800, 19, 15200, 95200); -- 100 Aguas

-- ================================
-- VERIFICACIÓN DE DATOS
-- ================================

-- Contar registros insertados
SELECT 'users' as tabla, COUNT(*) as registros FROM users
UNION ALL
SELECT 'categories', COUNT(*) FROM categories
UNION ALL
SELECT 'suppliers', COUNT(*) FROM suppliers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'customers', COUNT(*) FROM customers
UNION ALL
SELECT 'current_stock', COUNT(*) FROM current_stock
UNION ALL
SELECT 'inventory_movements', COUNT(*) FROM inventory_movements
UNION ALL
SELECT 'sales', COUNT(*) FROM sales
UNION ALL
SELECT 'sale_items', COUNT(*) FROM sale_items
UNION ALL
SELECT 'payments', COUNT(*) FROM payments
UNION ALL
SELECT 'purchases', COUNT(*) FROM purchases
UNION ALL
SELECT 'purchase_items', COUNT(*) FROM purchase_items;

-- Mostrar resumen de stock actual
SELECT 
    p.name as producto,
    cs.current_quantity as stock_actual,
    cs.available_quantity as disponible,
    p.min_stock as minimo,
    CASE 
        WHEN cs.current_quantity <= p.min_stock THEN 'STOCK BAJO' 
        ELSE 'OK' 
    END as estado
FROM current_stock cs
JOIN products p ON cs.product_id = p.id
ORDER BY cs.current_quantity;