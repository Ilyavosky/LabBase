-- STORED PROCEDURE: Alerta de stock bajo
-- Si algún ingrediente baja del 20% de su stock inicial de la semana, el
-- sistema debe registrar una alerta en una tabla de notificaciones.
--
-- Elegí usuar un stored procedure en lugar de un trigger porque:
-- La revisión de stock bajo es una operación que se ejecuta periodicamente.
-- Usar un trigger aquí me causaría dos problemas:
--   1. Recursividad: el trigger del UPDATE en "ingrediente" podría
--      disparar otro trigger, cuyo caso fue planteado por el maestro en una clase, siendo clasificado como mala práctica.
--   2. Semántica incorrecta: el dueño puede decidir cuándo revisar su stock semanal,
--      no que el sistema inserte alertas en cada UPDATE de stock.

DROP PROCEDURE IF EXISTS sp_alerta_stock_bajo();
CREATE OR REPLACE PROCEDURE sp_alerta_stock_bajo()
LANGUAGE plpgsql
AS $$
DECLARE
    rec        RECORD;
    porcentaje DECIMAL(5,2);
BEGIN
    FOR rec IN
        SELECT ingrediente_id, nombre, stock_actual, stock_inicial, unidad
        FROM ingrediente
        WHERE stock_actual < (stock_inicial * 0.20)
    LOOP
        porcentaje := ROUND((rec.stock_actual / rec.stock_inicial) * 100, 2);

        -- Solo insertar si no existe ya una alerta activa para este ingrediente.
        -- Evita duplicar notificaciones si el dueño llama al procedure varias veces al día.
        IF NOT EXISTS (
            SELECT 1 FROM alerta_stock
            WHERE ingrediente_id = rec.ingrediente_id
              AND atendida = FALSE
        ) THEN
            INSERT INTO alerta_stock (ingrediente_id, stock_al_momento, porcentaje_restante)
            VALUES (rec.ingrediente_id, rec.stock_actual, porcentaje);

            RAISE NOTICE 'ALERTA: "%" tiene stock bajo — % %% restante (% de % %)',
                rec.nombre,
                porcentaje,
                rec.stock_actual,
                rec.stock_inicial,
                rec.unidad;
        END IF;
    END LOOP;
END;
$$;