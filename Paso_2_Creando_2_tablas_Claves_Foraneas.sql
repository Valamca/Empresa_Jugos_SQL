/*Ahora Crearemos las tablas que se conectan con las tablas del paso anterior por medio de claves foraneas*/

/*Esta tabla se encargará de manejar las facturas creadas por cada compra*/
CREATE TABLE facturas (
	NUMERO VARCHAR(5) NOT NULL, -- Por ser clave primaria no puede ser nulo
	FECHA DATE,
	DNI VARCHAR(11) NOT NULL, -- Una clave foranea no puede ser nula
	MATRICULA VARCHAR(5) NOT NULL, -- Una clave foranea no puede ser nula
	IMPUESTO FLOAT,

PRIMARY KEY (NUMERO),
FOREIGN KEY (DNI) REFERENCES clientes(DNI),
FOREIGN KEY (MATRICULA) REFERENCES vendedores(MATRICULA)

);
	-- Validamos la informacion
    SELECT * FROM facturas;


/*La siguiente tabla se encargará de almacenar la cantidad de productos que llevan en cada factura*/
CREATE TABLE items (
NUMERO VARCHAR(5) NOT NULL, -- Por ser clave primaria y foranea no puede ser nula
CODIGO VARCHAR(10) NOT NULL, -- Una clave foranea no puede ser nula
CANTDAD INT,
PRECIO FLOAT,

PRIMARY KEY(NUMERO, CODIGO),
FOREIGN KEY (NUMERO) REFERENCES facturas (NUMERO),
FOREIGN KEY (CODIGO) REFERENCES productos (CODIGO)

);

	-- Validamos informacion
    SELECT * FROM items;