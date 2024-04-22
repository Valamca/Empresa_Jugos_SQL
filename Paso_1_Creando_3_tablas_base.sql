/* Crearemos nuestro schema*/

CREATE DATABASE IF NOT EXISTS empresa;

/* 1.- Comenzaremos realizando la creación de 3 tablas
 La PRIMER tabla será la encargada de los datos de los clientes */
CREATE TABLE Clientes (
	DNI VARCHAR(11) NOT NULL,
	NOMBRE VARCHAR(100) NOT NULL,
	DIRECCION VARCHAR(150) NOT NULL, 
	BARRIO VARCHAR(50) NOT NULL,
	CIUDAD VARCHAR(50) NOT NULL,
	ESTADO VARCHAR(10) NOT NULL,
	CP VARCHAR(10) NOT NULL,
	FECHA_NACIMIENTO DATE NOT NULL,
	EDAD SMALLINT NOT NULL,
	SEXO VARCHAR(1) NOT NULL,
	LIMITE_CREDITO FLOAT NOT NULL,
	VOLUMEN_COMPRA FLOAT NOT NULL,
	PRIMERA_COMPRA BIT(1),

PRIMARY KEY (DNI)
);
	-- Validamos el resultado
SELECT * FROM Clientes;

/* La SEGUNDA tabla que fue creada con el asistente de MYSQL se encargará de manejar la información de los vendedores */
CREATE TABLE `vendedores` (
  `MATRICULA` varchar(5) NOT NULL,
  `NOMBRE` varchar(100) DEFAULT NULL,
  `BARRIO` varchar(50) DEFAULT NULL,
  `COMISION` float DEFAULT NULL,
  `FECHA_ADMISION` date DEFAULT NULL,
  `VACACIONES` bit(1) DEFAULT NULL,
  PRIMARY KEY (`MATRICULA`));
  
	-- validamos el resultado
SELECT * FROM vendedores;

/* La TERCER tabla se encargará de manejar los datos de los productos que tenemos disponibles */
CREATE TABLE productos (
	CODIGO VARCHAR(10) NOT NULL,
	DESCRIPCION VARCHAR(100),
	SABOR VARCHAR(50),
	TAMANO VARCHAR(50),
	ENVASE VARCHAR(50),
	PRECIO_LISTA FLOAT,

PRIMARY KEY (CODIGO)
);

	-- Validamos el resultado
SELECT * FROM productos;

/* 2.- En este caso me equivoque en la primer tabla, la cual tiene todas sus columnas como NOT NULL, pero no la quería así,
	entonces procedo a modificar los campos con lo siguiente*/
ALTER TABLE `empresa`.`clientes` 
	CHANGE COLUMN `NOMBRE` `NOMBRE` VARCHAR(100) NULL ,
	CHANGE COLUMN `DIRECCION` `DIRECCION` VARCHAR(150) NULL ,
	CHANGE COLUMN `BARRIO` `BARRIO` VARCHAR(50) NULL ,
	CHANGE COLUMN `CIUDAD` `CIUDAD` VARCHAR(50) NULL ,
	CHANGE COLUMN `ESTADO` `ESTADO` VARCHAR(10) NULL ,
	CHANGE COLUMN `CP` `CP` VARCHAR(10) NULL ,
	CHANGE COLUMN `FECHA_NACIMIENTO` `FECHA_NACIMIENTO` DATE NULL ,
	CHANGE COLUMN `EDAD` `EDAD` SMALLINT NULL ,
	CHANGE COLUMN `SEXO` `SEXO` VARCHAR(1) NULL ,
	CHANGE COLUMN `LIMITE_CREDITO` `LIMITE_CREDITO` FLOAT NULL ,
	CHANGE COLUMN `VOLUMEN_COMPRA` `VOLUMEN_COMPRA` FLOAT NULL ;