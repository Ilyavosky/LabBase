DROP TABLE IF EXISTS alerta_stock;
DROP TABLE IF EXISTS venta;
DROP TABLE IF EXISTS platillo_ingrediente;
DROP TABLE IF EXISTS mesero;
DROP TABLE IF EXISTS platillo;
DROP TABLE IF EXISTS ingrediente;

-- Platillos que se encuentran en el menú
CREATE TABLE platillo (
    platillo_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100)  NOT NULL UNIQUE,
    precio DECIMAL(8,2)  NOT NULL CHECK (precio > 0)
);

-- Ingredientes del inventario
CREATE TABLE ingrediente (
    ingrediente_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100)  NOT NULL UNIQUE,
    unidad VARCHAR(20)   NOT NULL,
    stock_actual DECIMAL(10,2) NOT NULL CHECK (stock_actual >= 0),
    stock_inicial DECIMAL(10,2) NOT NULL CHECK (stock_inicial > 0)
);

-- Meseros que atienden las ventas
CREATE TABLE mesero (
    mesero_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Receta de cada platillo
CREATE TABLE platillo_ingrediente (
    platillo_ingrediente_id SERIAL PRIMARY KEY,
    platillo_id INT NOT NULL REFERENCES platillo(platillo_id) ON DELETE CASCADE,
    ingrediente_id INT NOT NULL REFERENCES ingrediente(ingrediente_id) ON DELETE RESTRICT,
    cantidad_por_porcion DECIMAL(10,2) NOT NULL CHECK (cantidad_por_porcion > 0),
    UNIQUE (platillo_id, ingrediente_id)
);

-- Registro histórico de ventas
CREATE TABLE venta (
    venta_id SERIAL PRIMARY KEY,
    platillo_id INT NOT NULL REFERENCES platillo(platillo_id) ON DELETE RESTRICT,
    mesero_id INT NOT NULL REFERENCES mesero(mesero_id) ON DELETE RESTRICT,
    porciones INT NOT NULL CHECK (porciones > 0),
    fecha_hora TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Alerta de stock
CREATE TABLE alerta_stock (
    alerta_stock_id SERIAL PRIMARY KEY,
    ingrediente_id INT NOT NULL REFERENCES ingrediente(ingrediente_id) ON DELETE CASCADE,
    stock_al_momento DECIMAL(10,2) NOT NULL,
    porcentaje_restante DECIMAL(5,2)  NOT NULL,
    fecha_hora TIMESTAMP NOT NULL DEFAULT NOW(),
    atendida BOOLEAN   NOT NULL DEFAULT FALSE
);