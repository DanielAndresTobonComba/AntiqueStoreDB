SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
drop SCHEMA if exists `AntiqueStore`;
CREATE SCHEMA IF NOT EXISTS `AntiqueStore` DEFAULT CHARACTER SET utf8;
USE `AntiqueStore`;

-- -----------------------------------------------------
-- Table `mydb`.`Rol`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Rol` (
  `idRol` INT NOT NULL AUTO_INCREMENT,
  `Nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idRol`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Persona`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Persona` (
  `idPersona` INT NOT NULL AUTO_INCREMENT,
  `Nombre` VARCHAR(45) NOT NULL,
  `Rol_idRol` INT NOT NULL,
  `Usuario` VARCHAR(45) NOT NULL,
  `Contrasena` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`idPersona`),
  INDEX `fk_Persona_Rol_idx` (`Rol_idRol` ASC),
  CONSTRAINT `fk_Persona_Rol`
    FOREIGN KEY (`Rol_idRol`)
    REFERENCES `Rol` (`idRol`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Epoca`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Epoca` (
  `idEpoca` INT NOT NULL AUTO_INCREMENT,
  `Nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idEpoca`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Estado_Conservacion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Estado_Conservacion` (
  `idEstadoArticulo` INT NOT NULL AUTO_INCREMENT,
  `Nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idEstadoArticulo`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Categoria_Articulo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Categoria_Articulo` (
  `idArticuloCategoria` INT NOT NULL AUTO_INCREMENT,
  `Nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idArticuloCategoria`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Articulo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Articulo` (
  `idArticulo` INT NOT NULL AUTO_INCREMENT,
  `Nombre` VARCHAR(45) NOT NULL,
  `Descripcion` TEXT NOT NULL,
  `Precio` DECIMAL(12,2) NOT NULL,
  `idEpoca` INT NOT NULL,
  `idEstadoArticulo` INT NOT NULL,
  `idArticuloCategoria` INT NOT NULL,
  `Foto` JSON NULL,
  `idPersona` INT NOT NULL,
  `Visualizaciones` INT NULL,
  PRIMARY KEY (`idArticulo`),
  INDEX `fk_Articulo_Epoca1_idx` (`idEpoca` ASC),
  INDEX `fk_Articulo_Estado_articulo1_idx` (`idEstadoArticulo` ASC),
  INDEX `fk_Articulo_Articulo_Categoria1_idx` (`idArticuloCategoria` ASC),
  INDEX `fk_Articulo_Persona1_idx` (`idPersona` ASC),
  CONSTRAINT `fk_Articulo_Epoca1`
    FOREIGN KEY (`idEpoca`)
    REFERENCES `Epoca` (`idEpoca`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Articulo_Estado_articulo1`
    FOREIGN KEY (`idEstadoArticulo`)
    REFERENCES `Estado_Conservacion` (`idEstadoArticulo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Articulo_Articulo_Categoria1`
    FOREIGN KEY (`idArticuloCategoria`)
    REFERENCES `Categoria_Articulo` (`idArticuloCategoria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Articulo_Persona1`
    FOREIGN KEY (`idPersona`)
    REFERENCES `Persona` (`idPersona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Estado_Venta_Articulo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Estado_Venta_Articulo` (
  `idEstado_Venta_Articulo` INT NOT NULL AUTO_INCREMENT,
  `Nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idEstado_Venta_Articulo`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Tipo_Transaccion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Tipo_Transaccion` (
  `idTipo_Transaccion` INT NOT NULL AUTO_INCREMENT,
  `Nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idTipo_Transaccion`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Transaccion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Transaccion` (
  `idTransaccion` INT NOT NULL AUTO_INCREMENT,
  `idVendedor` INT NOT NULL,
  `idComprador` INT NOT NULL,
  `idTipoTransaccion` INT NOT NULL,
  `Fecha` DATE NOT NULL,
  `Total` DECIMAL(12,2) NULL,
  PRIMARY KEY (`idTransaccion`),
  INDEX `fk_Transaccion_Persona1_idx` (`idVendedor` ASC),
  INDEX `fk_Transaccion_Persona2_idx` (`idComprador` ASC),
  INDEX `fk_Transaccion_Tipo_Transaccion1_idx` (`idTipoTransaccion` ASC),
  CONSTRAINT `fk_Transaccion_Persona1`
    FOREIGN KEY (`idVendedor`)
    REFERENCES `Persona` (`idPersona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Transaccion_Persona2`
    FOREIGN KEY (`idComprador`)
    REFERENCES `Persona` (`idPersona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Transaccion_Tipo_Transaccion1`
    FOREIGN KEY (`idTipoTransaccion`)
    REFERENCES `Tipo_Transaccion` (`idTipo_Transaccion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Articulo_Transaccion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Articulo_Transaccion` (
  `idArticulo` INT NOT NULL AUTO_INCREMENT,
  `idTransaccion` INT NOT NULL,
  `Precio_Unitario` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `Cantidad` INT NOT NULL,
  PRIMARY KEY (`idArticulo`, `idTransaccion`),
  INDEX `fk_Articulo_has_Transaccion_Transaccion1_idx` (`idTransaccion` ASC),
  INDEX `fk_Articulo_has_Transaccion_Articulo1_idx` (`idArticulo` ASC),
  CONSTRAINT `fk_Articulo_has_Transaccion_Articulo1`
    FOREIGN KEY (`idArticulo`)
    REFERENCES `Articulo` (`idArticulo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Articulo_has_Transaccion_Transaccion1`
    FOREIGN KEY (`idTransaccion`)
    REFERENCES `Transaccion` (`idTransaccion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Historial_Precios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Historial_Precios` (
  `idHistorial_Precios` INT NOT NULL AUTO_INCREMENT,
  `Fecha` DATE NOT NULL,
  `Precio` DECIMAL(12,2) NOT NULL,
  `Articulo_idArticulo` INT NOT NULL,
  PRIMARY KEY (`idHistorial_Precios`),
  INDEX `fk_Historial_Precios_Articulo1_idx` (`Articulo_idArticulo` ASC),
  CONSTRAINT `fk_Historial_Precios_Articulo1`
    FOREIGN KEY (`Articulo_idArticulo`)
    REFERENCES `Articulo` (`idArticulo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Stock`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Stock` (
  `idArticulo` INT NOT NULL AUTO_INCREMENT,
  `Cantidad` INT NOT NULL,
  PRIMARY KEY (`idArticulo`),
  CONSTRAINT `fk_Stock_Articulo1`
    FOREIGN KEY (`idArticulo`)
    REFERENCES `Articulo` (`idArticulo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Estado_Venta_Articulo_Stock`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Estado_Venta_Articulo_Stock` (
  `Stock_idArticulo` INT NOT NULL AUTO_INCREMENT,
  `Estado_Venta_Articulo_idEstado_Venta_Articulo` INT NOT NULL,
  `Cantidad` INT NULL,
  PRIMARY KEY (`Stock_idArticulo`),
  INDEX `fk_table1_Estado_Venta_Articulo1_idx` (`Estado_Venta_Articulo_idEstado_Venta_Articulo` ASC),
  CONSTRAINT `fk_table1_Stock1`
    FOREIGN KEY (`Stock_idArticulo`)
    REFERENCES `Stock` (`idArticulo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_table1_Estado_Venta_Articulo1`
    FOREIGN KEY (`Estado_Venta_Articulo_idEstado_Venta_Articulo`)
    REFERENCES `Estado_Venta_Articulo` (`idEstado_Venta_Articulo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;



-- INSERCIONES TABLAS 

-- Inserciones para la tabla `Rol`
INSERT INTO `Rol` (`Nombre`) VALUES
('Administrador'),
('Vendedor'),
('Comprador');


-- Inserciones para la tabla `Persona`
INSERT INTO `Persona` (`Nombre`, `Rol_idRol`, `Usuario`, `Contrasena`) VALUES
('Juan Pérez', 1, 'jperez', 'admin123'),
('María López', 2, 'mlopez', 'vendedor456'),
('Carlos García', 2, 'cgarcia', 'comprador789'),
('Ana Torres', 3, 'atorres', 'artista987'),
('Pedro Ruiz', 3, 'pruiz', 'curador654');

-- Inserciones para la tabla `Epoca`
INSERT INTO `Epoca` (`Nombre`) VALUES
('Renacimiento'),
('Barroco'),
('Impresionismo'),
('Modernismo'),
('Contemporánea');

-- Inserciones para la tabla `Estado_Conservacion`
INSERT INTO `Estado_Conservacion` (`Nombre`) VALUES
('Excelente'),
('Bueno'),
('Regular'),
('Malo'),
('Restaurado');

-- Inserciones para la tabla `Categoria_Articulo`
INSERT INTO `Categoria_Articulo` (`Nombre`) VALUES
('Pintura'),
('Escultura'),
('Fotografía'),
('Dibujo'),
('Instalación');

-- Inserciones para la tabla `Articulo`
INSERT INTO `Articulo` (`Nombre`, `Descripcion`, `Precio`, `idEpoca`, `idEstadoArticulo`, `idArticuloCategoria`, `Foto`, `idPersona`, `Visualizaciones`) VALUES
('Mona Lisa', 'Retrato de una mujer realizado por Leonardo da Vinci.', 1500000.00, 1, 1, 1, NULL, 2, 100),
('El David', 'Escultura de mármol creada por Miguel Ángel.', 3000000.00, 1, 2, 2, NULL, 2, 200),
('Starry Night', 'Famosa pintura de Vincent van Gogh.', 2000000.00, 3, 1, 1, NULL,3, 150),
('Guernica', 'Obra de Pablo Picasso que representa la guerra.', 4000000.00, 4, 1, 1, NULL, 3, 300),
('Las Meninas', 'Pintura del pintor español Diego Velázquez.', 5000000.00, 2, 3, 1, NULL, 3, 120);

-- Inserciones para la tabla `Estado_Venta_Articulo`
INSERT INTO `Estado_Venta_Articulo` (`Nombre`) VALUES
('Disponible'),
('Vendido'),
('Reservado'),
('En subasta'),
('No disponible');

-- Inserciones para la tabla `Tipo_Transaccion`
INSERT INTO `Tipo_Transaccion` (`Nombre`) VALUES
('Venta directa'),
('Subasta'),
('Intercambio'),
('Donación'),
('Compra pública');

-- Inserciones para la tabla `Transaccion`
INSERT INTO `Transaccion` (`idVendedor`, `idComprador`, `idTipoTransaccion`, `Fecha`, `Total`) VALUES
(2, 4, 1, '2024-01-15', 1500000.00),
(2, 5, 1, '2024-02-20', 3000000.00),
(3, 4, 2, '2024-03-10', 2000000.00),
(3, 5, 1, '2024-04-05', 4000000.00),
(3, 4, 1, '2024-05-22', 5000000.00);

-- Inserciones para la tabla `Articulo_Transaccion`
INSERT INTO `Articulo_Transaccion` (`idArticulo`, `idTransaccion`, `Precio_Unitario`, `Cantidad`) VALUES
(1, 1, 1500000.00, 1),
(2, 2, 3000000.00, 1),
(3, 3, 2000000.00, 1),
(4, 4, 4000000.00, 1),
(5, 5, 5000000.00, 1);

-- Inserciones para la tabla `Historial_Precios`
INSERT INTO `Historial_Precios` (`Fecha`, `Precio`, `Articulo_idArticulo`) VALUES
('2024-01-01', 1400000.00, 1),
('2024-01-10', 1450000.00, 1),
('2024-02-01', 2900000.00, 2),
('2024-02-15', 2950000.00, 2),
('2024-03-01', 1950000.00, 3);

-- Inserciones para la tabla `Stock`
INSERT INTO `Stock` (`idArticulo`, `Cantidad`) VALUES
(1, 5),
(2, 3),
(3, 7),
(4, 2),
(5, 4);

-- Inserciones para la tabla `Estado_Venta_Articulo_Stock`
INSERT INTO `Estado_Venta_Articulo_Stock` (`Stock_idArticulo`, `Estado_Venta_Articulo_idEstado_Venta_Articulo`, `Cantidad`) VALUES
(1, 1, 5),
(2, 2, 0),
(3, 1, 7),
(4, 3, 1),
(5, 4, 4);


-- CONSULTAS SQL 

-- 1. Consulta para listar todas las antigüedades disponibles para la venta:

SELECT A.Nombre, C.Nombre AS Categoria, A.Precio, E.Nombre AS Estado_Conservacion
FROM Articulo A
JOIN Categoria_Articulo C ON A.idArticuloCategoria = C.idArticuloCategoria
JOIN Estado_Conservacion E ON A.idEstadoArticulo = E.idEstadoArticulo
JOIN Estado_Venta_Articulo_Stock EVS ON EVS.Stock_idArticulo = A.idArticulo
JOIN Estado_Venta_Articulo EV ON EVS.Estado_Venta_Articulo_idEstado_Venta_Articulo = EV.idEstado_Venta_Articulo
WHERE EV.Nombre = 'Disponible';

-- 2. Consulta para buscar antigüedades por categoría y rango de precio:

SELECT A.Nombre, A.Precio, C.Nombre AS Categoria
FROM Articulo A
JOIN Categoria_Articulo C ON A.idArticuloCategoria = C.idArticuloCategoria
WHERE C.Nombre = 'Pintura' 
AND A.Precio BETWEEN 1000000 AND 2500000; 


-- 3. Consulta para mostrar el historial de ventas de un cliente específico:

SELECT A.Nombre, T.Fecha, AT.Precio_Unitario, P.Nombre AS Comprador
FROM Transaccion T
JOIN Articulo_Transaccion AT ON T.idTransaccion = AT.idTransaccion
JOIN Articulo A ON A.idArticulo = AT.idArticulo
JOIN Persona P ON T.idComprador = P.idPersona
WHERE T.idVendedor = 2;
 
 
 -- 4. Consulta para obtener el total de ventas realizadas en un periodo de tiempo:
 
 
 SELECT SUM(T.Total) AS Total_Ventas
FROM Transaccion T
WHERE T.Fecha BETWEEN '2024-01-01' AND '2024-03-11';

-- 5. Consulta para encontrar los clientes más activos (con más compras realizadas):

SELECT P.Nombre, COUNT(T.idTransaccion) AS Compras_Realizadas
FROM Transaccion T
JOIN Persona P ON T.idComprador = P.idPersona
GROUP BY P.Nombre
ORDER BY Compras_Realizadas DESC
LIMIT 2;


-- 6. Consulta para listar las antigüedades más populares por número de visitas o consultas:

SELECT A.Nombre, A.Visualizaciones
FROM Articulo A
ORDER BY A.Visualizaciones DESC
LIMIT 5;


-- 7. Consulta para listar las antigüedades vendidas en un rango de fechas específico:
SELECT A.Nombre, T.Fecha, Vendedor.Nombre AS Vendedor, Comprador.Nombre AS Comprador
FROM Transaccion T
JOIN Articulo_Transaccion AT ON T.idTransaccion = AT.idTransaccion
JOIN Articulo A ON A.idArticulo = AT.idArticulo
JOIN Persona Vendedor ON T.idVendedor = Vendedor.idPersona
JOIN Persona Comprador ON T.idComprador = Comprador.idPersona
WHERE T.Fecha BETWEEN '2024-01-01' AND '2024-03-31';
 
-- 8. Consulta para obtener un informe de inventario actual por categoria:
SELECT C.Nombre AS Categoria, SUM(S.Cantidad) AS Total_Articulos
FROM Stock S
JOIN Articulo A ON S.idArticulo = A.idArticulo
JOIN Categoria_Articulo C ON A.idArticuloCategoria = C.idArticuloCategoria
GROUP BY C.Nombre;


select * from Stock;
select * from Transaccion;
select * from Articulo;
select * from Categoria_Articulo;






