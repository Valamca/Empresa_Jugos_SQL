/*
	Podemos crear STORED PROCEDURES para automatizar tareas cotidianas.

	En esta sección nos encargaremos de crear un STORED PROCEDURE para generar una FACTURA
	con ayuda de las funciones generadas en los pasos anteriores.
*/

-- Utilizando las funciones realizadas de manera conjunta para observar su funcionamiento.↓↓

SELECT 
	f_cliente_aleatorio() AS Cliete,
    f_producto_aleatorio() AS Producto,
    f_vendedor_aleatorio() AS Vendedor;

/* 
	1.- Creamos nuestro STORED PRODECURE en la sección del mismo nombre:

	CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_venta`(fecha DATE, max_items INT, max_cantidad INT)
	
    BEGIN
	-- Variables del procedimiento
	DECLARE vcliente VARCHAR(11);
	DECLARE vproducto VARCHAR(10);
	DECLARE vvendedor VARCHAR(5);
	DECLARE vcantidad INT;
	DECLARE vprecio FLOAT;
	DECLARE vitems INT;
	DECLARE vfactura INT;
	DECLARE vcontador INT DEFAULT 1;
	DECLARE vnumeroitems INT;

	-- Procedimiento para conocer la última factura registrada y generar la siguiente
	SELECT MAX(NUMERO) + 1 INTO vfactura FROM facturas;

	-- Generamos nuestro cliente y vendedor aleatoriamente
	SET vcliente = f_cliente_aleatorio();
	SET vvendedor =  f_vendedor_aleatorio();

	-- Insertamos el nuevo registro a la tabla de facturas con los datos obtenidos
	INSERT INTO facturas (NUMERO, FECHA, DNI, MATRICULA, IMPUESTO) VALUES (vfactura, fecha, vcliente, vvendedor, 0.16);

	-- Generamos un nuevo número aleatorio de ITEMS
	SET vitems = f_aleatorio(1, max_items);

	-- Loop para obtener el número de productos necesarios que se obtuvieron en el procedimiento anterior
	WHILE 
		vcontador <= vitems
	DO
		-- Obtenemos un producto aleatorio en cada ciclo
		SET vproducto = f_producto_aleatorio();
    
    -- En esta selección nos aseguramos que tanto el CODIGO, como el NUMERO no se haya repetido en la base
    -- Sí se repiten guardaran en el contador el recuento de duplicidad.
    
    SELECT COUNT(*) INTO vnumeroitems FROM items WHERE CODIGO = vproducto AND NUMERO = vfactura;
    
    -- Sí el procedimiento anterior no encontró datos repetidos, entonces sí permite continuar con la
    -- generación de una nueva factura con valores aleatorios, caso contrario no registrará nada 
    
    IF
		vnumeroitems = 0  -- Esto nos asegura que no haya duplicados.
	THEN 
		-- Generamos los datos restantes para obtener una factura.
		SET vcantidad = f_aleatorio(1, max_cantidad);
		SELECT PRECIO_LISTA INTO vprecio FROM productos WHERE CODIGO = vproducto;
		
		-- Ingresamos el producto generado a la tabla de items
		INSERT INTO items (NUMERO, CODIGO, CANTIDAD, PRECIO) VALUES (vfactura, vproducto, vcantidad, vprecio);
    END IF;
    
    -- Sumamos 1 al contador para seguir corriendo el codigo hasta cumplir la cantidad necesaria
    -- de productos para la factura.
    SET vcontador = vcontador + 1;
    
END WHILE;

END
*/


/*
	Cómo podemos observar es un procedimiento mucho más largo y complejo que las funciones creadas anteriormente.

	Una vez hayamos realizado el STORED PROCEDURE para nuestras FACTURAS, lo llamamos a continuacion 
	ingresando los siguiente 3 valores: Fecha, Máximo de items por producto para la factura y cantidad máxima de productos.
*/
CALL sp_venta("20210619", 15,100);

	/*DATO: El procedimiento anterior da un error porque existe en problema en la declaración
	de columnas para la tabla de facturas que son del tipo VARCHAR y que deben ser INTEGERS*/

-- Podemos validar lo anterior ordenando los números y observando que se ordenan como caracteres, no como NÚMEROS ENTEROS.
SELECT NUMERO FROM facturas ORDER BY NUMERO DESC LIMIT 88000; 
	/* Ejemplo del ordenamiento erroneo al ser caracteres.
		99879
		99878
        9887
        9886
        98857   Lo cual no tiene sentidad para una operación con numeros enteros.
    */

-- Para corregir lo anterior modificamos la tablas de FACTURAS e ITEMS.

CREATE TABLE facturas (
	NUMERO INT NOT NULL, -- Por ser clave primaria no puede ser nulo
	FECHA DATE,
	DNI VARCHAR(11) NOT NULL, -- Una clave foranea no puede ser nula
	MATRICULA VARCHAR(5) NOT NULL, -- Una clave foranea no puede ser nula
	IMPUESTO FLOAT,

PRIMARY KEY (NUMERO),
FOREIGN KEY (DNI) REFERENCES clientes(DNI),
FOREIGN KEY (MATRICULA) REFERENCES vendedores(MATRICULA)
);

CREATE TABLE items (
NUMERO INT NOT NULL, -- Por ser clave primaria y foranea no puede ser nula
CODIGO VARCHAR(10) NOT NULL, -- Una clave foranea no puede ser nula
CANTIDAD INT,
PRECIO FLOAT,

PRIMARY KEY(NUMERO, CODIGO),
FOREIGN KEY (NUMERO) REFERENCES facturas (NUMERO),
FOREIGN KEY (CODIGO) REFERENCES productos (CODIGO)

);

/*Rellenamos la tabla facturas con los datos de la tabla facturas de la base de datos de jugos_ventas*/ 
 INSERT INTO facturas
	SELECT 
		NUMERO,
        FECHA_VENTA AS FECHA,
        DNI,
        MATRICULA,
        IMPUESTO
	FROM
		jugos_ventas.facturas;

/*Con los datos de la tabla items_pedidos rellenaremos nuestra tabla items*/
 INSERT INTO items
	SELECT 
		NUMERO, 
        CODIGO_DEL_PRODUCTO AS CODIGO,
        CANTIDAD,
        PRECIO
	FROM
		jugos_ventas.items_facturas;
        
/*Ahora podemos continuar nuestro procedimiento con las Tablas corregidas*/

SELECT MAX(NUMERO) FROM facturas;
	/* Ahora podemos observar un ordenamiento correcto de NUMEROS ENTEROS
    99879
	99878
	98857
	9887
	9886   Con este ordenamiento ya podemos trabajar correctamente
    */

-- Ahora si podemos correr nuestro STORED PROCEDURE

CALL sp_venta("20210619",3,100);

-- Ahora generaremos una tabla para obtener la Facturación Total de nuestro procedimiento, con la fecha elegida.

SELECT 
	A.FECHA AS FECHA,
    SUM(B.CANTIDAD * B.PRECIO) AS Facturacion
FROM 
	facturas AS A
INNER JOIN
	items AS B ON A.NUMERO = B.NUMERO
WHERE 
	A.FECHA = "20210619"
GROUP BY
	A.FECHA;
    
--  Sí queremos seguir generando más facturas podemos modificar los valores dentro del STORED PROCEDURE y continuar

CALL sp_venta("20210619",20,100);

-- No hemos manejado los impuestos, pero sin duda podemos calcular el total de los mismos por año 
SELECT 
	YEAR(A.FECHA) AS FECHA,
    FLOOR(SUM(B.CANTIDAD * B.PRECIO)) AS Facturacion,
    CEIL(SUM(B.CANTIDAD * B.PRECIO *A.IMPUESTO)) AS Impuestos
FROM 
	facturas AS A
INNER JOIN
	items AS B ON A.NUMERO = B.NUMERO
WHERE 
	YEAR(A.FECHA) = 2021
GROUP BY
	YEAR(A.FECHA);