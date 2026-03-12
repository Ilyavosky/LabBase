-- VIEW 1: ¿Qué platillos puedo ofrecer mañana?
-- Calcula las porciones posibles como el mínimo entre
-- (stock_actual / cantidad_por_porcion) de todos los ingredientes del platillo.
-- Solo muestra platillos con al menos 1 porción disponible.

CREATE OR REPLACE VIEW vw_platillos_disponibles AS
SELECT
    p.platillo_id,
    p.nombre AS platillo,
    p.precio,
    FLOOR(MIN(i.stock_actual / pi.cantidad_por_porcion))::INT AS porciones_disponibles
FROM platillo p
JOIN platillo_ingrediente pi ON pi.platillo_id = p.platillo_id
JOIN ingrediente i ON i.ingrediente_id = pi.ingrediente_id
GROUP BY p.platillo_id, p.nombre, p.precio
HAVING FLOOR(MIN(i.stock_actual / pi.cantidad_por_porcion)) > 0
ORDER BY porciones_disponibles DESC;


-- VIEW 2: ¿Qué se ha vendido?
-- Historial completo de ventas: platillo, porciones, fecha/hora, mesero y total en pesos mexicanos.

CREATE OR REPLACE VIEW vw_historial_ventas AS
SELECT
    v.venta_id,
    p.nombre AS platillo,
    v.porciones,
    v.fecha_hora,
    m.nombre AS mesero,
    (p.precio * v.porciones) AS total_venta
FROM venta v
JOIN platillo p ON p.platillo_id = v.platillo_id
JOIN mesero m ON m.mesero_id = v.mesero_id
ORDER BY v.fecha_hora DESC;


-- VIEW 3: ¿Qué es popular esta semana?
-- Platillos más vendidos en los últimos 7 días, ordenados por porciones totales.

CREATE OR REPLACE VIEW vw_platillos_populares AS
SELECT
    p.platillo_id,
    p.nombre AS platillo,
    SUM(v.porciones) AS total_porciones,
    COUNT(v.venta_id) AS total_ventas,
    SUM(p.precio * v.porciones) AS ingresos_generados
FROM venta v
JOIN platillo p ON p.platillo_id = v.platillo_id
WHERE v.fecha_hora >= NOW() - INTERVAL '7 days'
GROUP BY p.platillo_id, p.nombre
ORDER BY total_porciones DESC;