-- ============================================================
-- DATOS DE PRUEBA
-- ============================================================

-- 10 ingredientes con stock inicial (compra del lunes)
INSERT INTO ingrediente (nombre, unidad, stock_actual, stock_inicial) VALUES
    ('Carne de res',    'g',      5000.00, 5000.00),
    ('Carne de cerdo',  'g',      4000.00, 4000.00),
    ('Tortilla de maíz','piezas', 500.00,  500.00),
    ('Tortilla de harina','piezas',300.00, 300.00),
    ('Cebolla',         'g',      2000.00, 2000.00),
    ('Piña',            'g',      3000.00, 3000.00),
    ('Cilantro',        'g',      1000.00, 1000.00),
    ('Limón',           'piezas', 200.00,  200.00),
    ('Queso Oaxaca',    'g',      2500.00, 2500.00),
    ('Salsa roja',      'ml',     3000.00, 3000.00);

-- 5 platillos con sus recetas (entre 3 y 8 ingredientes cada uno)
INSERT INTO platillo (nombre, precio) VALUES
    ('Tacos al Pastor',       65.00),
    ('Quesadilla de Res',     55.00),
    ('Burrito de Cerdo',      80.00),
    ('Tacos de Res',          60.00),
    ('Quesadilla de Cerdo',   55.00);

-- Recetas (platillo_ingrediente)
-- 1: Tacos al Pastor → cerdo 200g, tortilla maíz 3, piña 50g, cebolla 30g, cilantro 10g, limón 1, salsa roja 30ml
INSERT INTO platillo_ingrediente (platillo_id, ingrediente_id, cantidad_por_porcion) VALUES
    (1, 2, 200.00),   -- cerdo
    (1, 3, 3.00),     -- tortilla maíz
    (1, 6, 50.00),    -- piña
    (1, 5, 30.00),    -- cebolla
    (1, 7, 10.00),    -- cilantro
    (1, 8, 1.00),     -- limón
    (1, 10, 30.00);   -- salsa roja

-- 2: Quesadilla de Res → res 150g, tortilla harina 2, queso 80g, cebolla 20g, salsa roja 20ml
INSERT INTO platillo_ingrediente (platillo_id, ingrediente_id, cantidad_por_porcion) VALUES
    (2, 1, 150.00),   -- res
    (2, 4, 2.00),     -- tortilla harina
    (2, 9, 80.00),    -- queso
    (2, 5, 20.00),    -- cebolla
    (2, 10, 20.00);   -- salsa roja

-- 3: Burrito de Cerdo → cerdo 250g, tortilla harina 1, queso 60g, cebolla 40g, cilantro 15g, salsa roja 40ml
INSERT INTO platillo_ingrediente (platillo_id, ingrediente_id, cantidad_por_porcion) VALUES
    (3, 2, 250.00),   -- cerdo
    (3, 4, 1.00),     -- tortilla harina
    (3, 9, 60.00),    -- queso
    (3, 5, 40.00),    -- cebolla
    (3, 7, 15.00),    -- cilantro
    (3, 10, 40.00);   -- salsa roja

-- 4: Tacos de Res → res 200g, tortilla maíz 3, cebolla 30g, cilantro 10g, limón 1, salsa roja 25ml
INSERT INTO platillo_ingrediente (platillo_id, ingrediente_id, cantidad_por_porcion) VALUES
    (4, 1, 200.00),   -- res
    (4, 3, 3.00),     -- tortilla maíz
    (4, 5, 30.00),    -- cebolla
    (4, 7, 10.00),    -- cilantro
    (4, 8, 1.00),     -- limón
    (4, 10, 25.00);   -- salsa roja

-- 5: Quesadilla de Cerdo → cerdo 150g, tortilla harina 2, queso 80g, cebolla 20g, salsa roja 20ml
INSERT INTO platillo_ingrediente (platillo_id, ingrediente_id, cantidad_por_porcion) VALUES
    (5, 2, 150.00),   -- cerdo
    (5, 4, 2.00),     -- tortilla harina
    (5, 9, 80.00),    -- queso
    (5, 5, 20.00),    -- cebolla
    (5, 10, 20.00);   -- salsa roja

-- 3 meseros
INSERT INTO mesero (nombre) VALUES
    ('Carlos López'),
    ('María Hernández'),
    ('José García');

-- 8 ventas de ejemplo (simulan la semana actual)
INSERT INTO venta (platillo_id, mesero_id, porciones, fecha_hora) VALUES
    (1, 1, 3, NOW() - INTERVAL '5 days'),
    (2, 2, 2, NOW() - INTERVAL '4 days'),
    (3, 3, 1, NOW() - INTERVAL '4 days'),
    (1, 2, 4, NOW() - INTERVAL '3 days'),
    (4, 1, 2, NOW() - INTERVAL '2 days'),
    (5, 3, 3, NOW() - INTERVAL '1 day'),
    (2, 1, 1, NOW() - INTERVAL '1 day'),
    (1, 2, 2, NOW());