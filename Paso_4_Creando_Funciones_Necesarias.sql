/*
1.- Crearemos una función para obtener nuestros datos aleatorios, desde un cliente, producto o vendedor
de la siguiente manera en la sección de 'FUNCTIONS':

	CREATE DEFINER=`root`@`localhost` FUNCTION `f_aleatorio`(min INT, max INT) RETURNS int
	BEGIN
	-- Declaramos la variable
	DECLARE vresultado INTEGER;

	-- Creamos el proceso de obtención de valores
	SELECT 
		FLOOR(RAND() * (max - min + 1) + min) INTO vresultado; 

	-- Retornamos el valor
	RETURN vresultado;
	END
    
La función de arriba se basa en el siguiente comportamiento:
*/
-- Toma un número aleatorio de la siguiente manera.
SELECT RAND();

-- Después ajustamos su valor al rango desado ejemplo: Un número aleatorio entre 20 y 250
SELECT 
	ROUND(RAND() * (250 - 20 + 1) + 20) AS Numero_Aleatorio;
SELECT 
	FLOOR(RAND() * (250 - 20 + 1) + 20) AS Numero_Aleatorio;
 
/*
 2.-  Una vez que hayamos cargado la función podemos realizar nuestros cálculos con ella.
Utilizamos la función que creamos con los procesos de arriba que recibe un 
valor máximo y un minimo para generar un numero aleatorio
*/
SELECT f_aleatorio(20,150) AS Numero_aleatorio;

-- Probando función de limites para usar después
SELECT * FROM clientes LIMIT 5;
SELECT * FROM clientes LIMIT 16,1; -- No hay más registros así que da NULL
SELECT * FROM clientes LIMIT 0,1; -- Nos devuelve el primer número después de la posición 0

/* 
3.- Utilizando nuestra función anterior y el uso de la clausula LIMIT 
    crearemos otra función para obtener un CODIGO de cliente aleatorio:

	CREATE DEFINER=`root`@`localhost` FUNCTION `f_cliente_aleatorio`() RETURNS varchar(11) CHARSET utf8mb4
	BEGIN

	-- Variables
	DECLARE vresultado VARCHAR(11);
	DECLARE vmax INT;
	DECLARE valeatorio INT;

	-- Procedimiento para obtener un dato
	SELECT COUNT(*) INTO vmax FROM clientes;

	-- Generaramos un cliente aleatorio
	SET valeatorio = f_aleatorio(1, vmax);

	-- Limitamos los registros
	SET valeatorio = valeatorio - 1;

	-- Una vez que ya tengamos el valor aleatorio, obtenemos el DNI correspondiente ↓↓
	SELECT 
		DNI INTO vresultado
	FROM 
		clientes LIMIT valeatorio, 1;

	-- Retornamos el DNI que obtuvimos aleatoriamente
	RETURN vresultado;
	END
    
Con nuestra función de cliente aleatorio podemos continuar
*/

SELECT f_cliente_aleatorio() AS Cliente;

/*
4.- Ahora se exploran los datos de productos y vendedor para generar otra función
que obtenga los correspondientes basados en la función anterior
*/
SELECT * FROM productos;
SELECT * from vendedores;

/* FUNCIÓN DE PRODUCTO ALEATORIO:
	CREATE DEFINER=`root`@`localhost` FUNCTION `f_producto_aleatorio`() RETURNS varchar(10) CHARSET utf8mb4
	BEGIN

	-- Declaramos variables
	DECLARE vdni VARCHAR(10);
	DECLARE vmax INT;
	DECLARE valeatorio INT;

	-- Encontramos el valor total de productos existentes y lo guardamos en una variable
	SELECT COUNT(*) INTO vmax FROM productos;

	-- Generamos un numero entre un rango de 1 y el valor maximo de productos
	SET valeatorio = f_aleatorio(1, vmax);
	SET valeatorio = valeatorio -1;

	-- Obtenemos el codigo del producto aleatorio
	SELECT CODIGO INTO vdni FROM productos LIMIT valeatorio,1;	

	RETURN vdni;
	END
*/
-- Utilizamos la función para obtener un producto aleatorio
SELECT f_producto_aleatorio() AS PRODUCTO;

/* FUNCION DE VENDEDOR ALEATORIO
	CREATE DEFINER=`root`@`localhost` FUNCTION `f_vendedor_aleatorio`() RETURNS varchar(5) CHARSET utf8mb4
	BEGIN

	-- Declaramos las variables necesarias
	DECLARE vmatricula VARCHAR(5);
	DECLARE vmax INT;
	DECLARE valeatorio INT;

	-- Obtenemos el numero máximo de vendedores diponibles
	SELECT COUNT(*) INTO vmax FROM vendedores;

	-- Generamos un valor aleatorio
	SET valeatorio = f_aleatorio(1, vmax);
	SET valeatorio = valeatorio -1;

	-- Obtenemos un vendedor aleatorio
	SELECT MATRICULA INTO vmatricula FROM vendedores LIMIT valeatorio,1;

	RETURN vmatricula;
	END
*/
-- Utilizamos la función para obtener un vendedor aleatorio
SELECT f_vendedor_aleatorio() AS VENDEDOR;