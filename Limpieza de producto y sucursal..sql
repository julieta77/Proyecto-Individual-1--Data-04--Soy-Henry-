-- Limpieza de producto y sucursal. 

-- Tabla Producto
SELECT * 
FROM producto;

-- Analizamos valores faltantes de la tabla producto

SELECT categoria1 from producto where categoria1 = '' ;
SELECT categoria2 from producto where categoria2 = '' ;
SELECT categoria3 from producto where categoria3 = '' ;
select idProduct from producto where idProduct = '';
select marca from producto where marca = '' ; 
select nombre from producto where nombre = '';
select presentacion from producto where presentacion = '';

-- Eliminamos categorías porque tiene una gran cantidad de datos faltantes. Además de que a mi cliente no le son  necesarias para su proyecto.
ALTER TABLE producto DROP COLUMN categoria1;
ALTER TABLE producto DROP COLUMN categoria2;
ALTER TABLE producto DROP COLUMN categoria3;

-- A las columnas con poco datos faltantes le ponemos "Sin dato" .
UPDATE producto SET marca = 'Sin Dato' WHERE marca= "" ;
UPDATE producto SET nombre = 'Sin Dato' WHERE nombre = "" ;
UPDATE producto SET presentacion = 'Sin Dato' WHERE presentacion = "" ; 

-- remplazamos '-' por  ''.
UPDATE producto set IdProduct = replace(IdProduct,'-','');

-- visualizamos duplicados en la columna idProduct
select distinct(idProduct)
from producto; 
SELECT IdProduct, COUNT(*) FROM producto GROUP BY IdProduct HAVING COUNT(*) > 1;-- resultado no hay duplicados

alter table producto add primary key (IdProduct); -- agrego una primary key 

-- Tabla Sucursal. 
select *
from sucursal;

-- Analizamos valores faltantes de la tabla sucursal

SELECT idSucursal from sucursal where idSucursal = '' ;
SELECT comercioid from sucursal where comercioid = '' ;
SELECT banderaid from sucursal where banderaid = '' ;
SELECT banderaDescripcion from sucursal where banderaDescripcion = '' ;
SELECT comercioRazonSocial from sucursal where comercioRazonSocial = '' ;
SELECT provincia from sucursal where provincia = '' ;
SELECT localidad from sucursal where localidad = '' ;
SELECT direccion from sucursal where direccion = '' ;
SELECT lat from sucursal where lat = '' ;
SELECT lng from sucursal where lng = '' ;
SELECT sucursalNombre from sucursal where sucursalNombre = '' ;
SELECT sucursalTipo from sucursal where sucursalTipo = '' ;

-- Resultado no hay nulos  en la tabla sucursal 

-- cambiamos el tipo de dato de la columnas 
ALTER TABLE sucursal MODIFY comercioId int; 
ALTER TABLE sucursal MODIFY banderaId int;
ALTER TABLE sucursal MODIFY lat decimal(15,12);
ALTER TABLE sucursal MODIFY lng decimal(15,12);

-- cambiamos los nombres de las columnas

ALTER TABLE sucursal RENAME COLUMN idSucursal TO IdSucursal;
ALTER TABLE sucursal RENAME COLUMN comercioId TO IdComercio;
ALTER TABLE sucursal RENAME COLUMN banderaId TO IdBandera;
ALTER TABLE sucursal RENAME COLUMN lat TO latitud;
ALTER TABLE sucursal RENAME COLUMN lng TO longitud;
ALTER TABLE sucursal RENAME COLUMN sucursalNombre TO sucursal;
ALTER TABLE sucursal RENAME COLUMN sucursalTipo TO Tipo_sucursal;

UPDATE sucursal set IdSucursal = replace(IdSucursal,'-',''); -- cambiamos '-' por nada

-- visualizamos duplicados en la columna idSucursal
select distinct idSucursal from sucursal; -- hay duplicados
SELECT IdSucursal, COUNT(*) FROM sucursal GROUP BY IdSucursal HAVING COUNT(*) > 1;

-- En respuesta a los valores duplicados de IdSucursal(solo eran 8 ids ) creamos una tabla nueva sin duplicado. Renombramos la antigua tabla sucursal como valores duplicados en idSucursal.
CREATE TABLE sucursal1(
IdSucursal varchar(30) ,
IdComercio int ,
IdBandera int ,
banderaDescripcion text ,
comercioRazonSocial text ,
provincia varchar(200) ,
localidad varchar(200) ,
direccion varchar(200) ,
latitud decimal(15,12) ,
longitud decimal(15,12) ,
sucursal varchar(210) ,
Tipo_sucursal varchar(210))ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

INSERT INTO sucursal1 
SELECT IdSucursal,IdComercio,IdBandera,banderaDescripcion,comercioRazonSocial,provincia,localidad,direccion,latitud,longitud,sucursal,Tipo_sucursal
FROM sucursal group by IdSucursal ; 

SELECT IdSucursal, COUNT(*) FROM sucursal1 GROUP BY IdSucursal HAVING COUNT(*) > 1; -- verificamos si hay duplicado

RENAME TABLE sucursal TO sucursalRepetida;
RENAME TABLE sucursal1 TO sucursal;

alter table sucursal add primary key (IdSucursal); -- agrego una primary key 