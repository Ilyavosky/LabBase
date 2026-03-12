/*
  VIEW 1: ¿Qué platillos puedo ofrecer mañana?
  Calcula cuántas porciones completas se pueden preparar de cada platillo
  según el inventario actual. Solo muestra platillos con al menos 1 porción posible.
*/
CREATE OR REPLACE VIEW vw_platillos_disponibles AS
SELECT
    p.id AS platillo_id,
    p.nombre AS platillo,
    p.precio,
    FLOOR(MIN(i.stock_actual / pi.cantidad_por_porcion))::INT AS porciones_disponibles
FROM platillo p
JOIN platillo_ingrediente pi ON pi.platillo_id = p.id
JOIN ingrediente i ON i.id = pi.ingrediente_id
GROUP BY p.id, p.nombre, p.precio
HAVING FLOOR(MIN(i.stock_actual / pi.cantidad_por_porcion)) > 0
ORDER BY porciones_disponibles DESC;

/*
  VIEW 2: ¿Qué se ha vendido?
  Registro histórico completo de todas las ventas con nombre del platillo,
  porciones, fecha/hora y mesero que atendió.
*/
CREATE OR REPLACE VIEW vw_historial_ventas AS
SELECT
    v.id AS venta_id,
    p.nombre AS platillo,
    v.porciones,
    v.fecha_hora,
    m.nombre AS mesero,
    (p.precio * v.porciones) AS total_venta
FROM venta v
JOIN platillo p ON p.id = v.platillo_id
JOIN mesero m ON m.id = v.mesero_id
ORDER BY v.fecha_hora DESC;

/*
  VIEW 3: ¿Qué es popular?
  Resumen de los platillos más vendidos en la semana actual
  (últimos 7 días), ordenados por total de porciones vendidas.
*/
CREATE OR REPLACE VIEW vw_platillos_populares AS
SELECT
    p.id AS platillo_id,
    p.nombre AS platillo,
    SUM(v.porciones) AS total_porciones,
    COUNT(v.id) AS total_ventas,
    SUM(p.precio * v.porciones) AS ingresos_generados
FROM venta v
JOIN platillo p ON p.id = v.platillo_id
WHERE v.fecha_hora >= NOW() - INTERVAL '7 days'
GROUP BY p.id, p.nombre
ORDER BY total_porciones DESC;
