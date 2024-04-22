/*
Creando TRIGGERS para el uso de la tabla de Facturacion

Los Triggers son herramientas que nos ayudan realizando acciones en diferentes eventos especificos.
	Se activan ANTES o DESPUÉS (Según se definan) de las siguientes acciones:
		- INSERT's
        - UPDATE's
        - DELETE's
	Generan una respuesta personalizada automática a estos eventos, ayudandonos a automatizar ciertas acciones. 
*/

-- 1.- Creamos una tabla auxiliar que es dónde tendrán efecto los procedimientos de los TRIGGERS
CREATE TABLE facturacion(
FECHA DATE NULL,
VENTA_TOTAL FLOAT
);

-- Trigger encargado de los INSERT
-- Cada que realicemos un INSERT nos mostrará la venta total de la factura.
DELIMITER //
CREATE TRIGGER TG_FACTURACION_INSERT 
AFTER INSERT ON items
FOR EACH ROW BEGIN
  DELETE FROM facturacion;
  INSERT INTO facturacion
  SELECT A.FECHA, SUM(B.CANTIDAD * B.PRECIO) AS VENTA_TOTAL
  FROM facturas A
  INNER JOIN
  items B
  ON A.NUMERO = B.NUMERO
  GROUP BY A.FECHA;
END //

-- Trigger encargado de los DELETE
-- Nos mostrará lo mismo que el anterior del datos que eliminemos
DELIMITER //
CREATE TRIGGER TG_FACTURACION_DELETE
AFTER DELETE ON items
FOR EACH ROW BEGIN
  DELETE FROM facturacion;
  INSERT INTO facturacion
  SELECT A.FECHA, SUM(B.CANTIDAD * B.PRECIO) AS VENTA_TOTAL
  FROM facturas A
  INNER JOIN
  items B
  ON A.NUMERO = B.NUMERO
  GROUP BY A.FECHA;
END //

-- Trigger encargado de los UPDATE
-- Lo mismo en caso de una actualización
DELIMITER //
CREATE TRIGGER TG_FACTURACION_UPDATE
AFTER UPDATE ON items
FOR EACH ROW BEGIN
  DELETE FROM facturacion;
  INSERT INTO facturacion
  SELECT A.FECHA, SUM(B.CANTIDAD * B.PRECIO) AS VENTA_TOTAL
  FROM facturas A
  INNER JOIN
  items B
  ON A.NUMERO = B.NUMERO
  GROUP BY A.FECHA;
END //

/*
	Ahora podemos observar el comportamiento de los TRIGGERS
*/

SELECT * FROM facturacion; -- Observamos la tabla auxiliar

-- Hacemos uso del STORED PROCEDURE para probar
CALL sp_venta("20210622",15,75);

	-- Podemos observar que el TRIGGER nos crea la facturación automaticamente en la tabla auxiliar
    SELECT * FROM facturacion WHERE FECHA = "20210622";

/*
PROBLEMAS CON ACTUALIZACIÓN DE TABLAS O REGLAS DE NEGOCIO
	Nuestros TRIGGERS funcionan perfectamente hasta este momento, pero ¿Qué pasa sí en un futuro nuestras reglas cambian
	y tenemos que modificar los TRIGGERS?, tendríamos que modificar cada uno o rehacerlos, para estos casos podemos usar 
	un TRIGGER que llame a un STORED PROCEDURE.
*/

-- Para realizar lo anterior primero debemos eliminar los Triggers actuales

DROP TRIGGER TG_FACTURACION_INSERT; 
DROP TRIGGER TG_FACTURACION_DELETE;
DROP TRIGGER TG_FACTURACION_UPDATE;

-- Ahora sí podemos comenzar a editar nuestros nuevos TRIGGERS

/*
	La manera de abordar lo anterior es usando un STORED PROCEDURE que tenga la lógica común
    de nuestros TRIGGERS:
    
	CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_triggers`()
	BEGIN
		DELETE FROM facturacion;
		INSERT INTO facturacion
		SELECT A.FECHA, SUM(B.CANTIDAD * B.PRECIO) AS VENTA_TOTAL
		FROM facturas A
		INNER JOIN
		items B
		ON A.NUMERO = B.NUMERO
		GROUP BY A.FECHA;
	END
*/

-- Trigger encargado de los INSERT
DELIMITER //
CREATE TRIGGER TG_FACTURACION_INSERT 
AFTER INSERT ON items
FOR EACH ROW BEGIN
	CALL sp_triggers;
END //

-- Trigger encargado de los DELETE
DELIMITER //
CREATE TRIGGER TG_FACTURACION_DELETE
AFTER DELETE ON items
FOR EACH ROW BEGIN
	CALL sp_triggers;
END //

-- Trigger encargado de los UPDATE
DELIMITER //
CREATE TRIGGER TG_FACTURACION_UPDATE
AFTER UPDATE ON items
FOR EACH ROW BEGIN
	CALL sp_triggers;
END //

/*
	Como podemos observar en los TRIGGERS en lugar de generar toda la lógica de programación dentro de ellos,
	Ahora sólo llamamos a un STORED PROCEDURE, que en caso de ser necesario tener modificaciones sólo debemos ir al 
	STORED PROCEDURE y modificar una única vez y tendrá efecto en todos los TRIGGERS, ya que en muchos casos la lógica
	dentro de un TRIGGER suelen compartirla más de uno.
*/

-- Hacemos uso de nuevo de nuestro procedimiento almacenado para probar nuestros triggers 
CALL sp_venta("20210622",15,100);

	-- Podemos observar que el TRIGGER nos crea la facturación automaticamente en la tabla auxiliar
    SELECT * FROM facturacion WHERE FECHA = "20210622";
	-- Y observamos que nuestros TRIGGERS funcionan de manera correcta, eficiente y están adaptados para afrontar
    -- de manera sencilla modificaciones que afecten a todos y no solo a uno en particular.