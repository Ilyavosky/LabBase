DROP TRIGGER   IF EXISTS trg_descontar_inventario ON venta;
DROP FUNCTION  IF EXISTS fn_descontar_inventario();

-- ¿Por qué TRIGGER y no PROCEDURE?
-- El descuento de ingredientes debe ocurrir de forma automática.
-- Un TRIGGER AFTER INSERT es ideal porque garantiza que no exista una venta sin su descuento de inventario correspondiente.
-- Un PROCEDURE requeriría que se recuerde ejecutar un segundo paso, lo cual da errores y rompe la integridad del sistema.

-- La función asociada (fn_descontar_inventario) itera la receta del platillo vendido, verifica stock suficiente por ingrediente, y descuenta.
-- Si algún ingrediente no tiene stock, lanza EXCEPTION y hace un ROLLBACK
-- automático de toda la venta.

CREATE OR REPLACE FUNCTION fn_descontar_inventario()
RETURNS TRIGGER AS $$
DECLARE
    rec              RECORD;
    cantidad_total   DECIMAL(10,2);
    stock_disponible DECIMAL(10,2);
BEGIN
    -- Itera cada ingrediente de la receta del platillo vendido
    FOR rec IN
        SELECT ingrediente_id, cantidad_por_porcion
        FROM platillo_ingrediente
        WHERE platillo_id = NEW.platillo_id
    LOOP
        cantidad_total := rec.cantidad_por_porcion * NEW.porciones;

        -- Verificar stock suficiente antes de descontar
        SELECT stock_actual INTO stock_disponible
        FROM ingrediente
        WHERE ingrediente_id = rec.ingrediente_id;

        IF stock_disponible < cantidad_total THEN
            RAISE EXCEPTION
                'Stock insuficiente del ingrediente ID %. Disponible: %, Requerido: %',
                rec.ingrediente_id, stock_disponible, cantidad_total;
        END IF;

        -- Descontar del inventario
        UPDATE ingrediente
        SET stock_actual = stock_actual - cantidad_total
        WHERE ingrediente_id = rec.ingrediente_id;

    END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_descontar_inventario
    AFTER INSERT ON venta
    FOR EACH ROW
    EXECUTE FUNCTION fn_descontar_inventario();


