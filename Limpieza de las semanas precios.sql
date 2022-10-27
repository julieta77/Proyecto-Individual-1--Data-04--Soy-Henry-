-- Limpieza de las semanas precios

-- tabla semana1 

-- Analizamos valores faltantes de la tabla semanal 1
SELECT precio from precio_semanal_1 where precio = '' ;
SELECT producto_id from precio_semanal_1 where producto_id = '' ;
SELECT sucursal_id from precio_semanal_1 where sucursal_id = '' ;
SELECT fecha from precio_semanal_1 where fecha = '' ;

update precio_semanal_1 set producto_id = 0 where producto_id = '' ; -- lo valores faltantes  los lleno con un 0
update precio_semanal_1 set sucursal_id = 0 where sucursal_id= ''  ;
update precio_semanal_1 set precio = 0 where precio= ''  ; -- como es la tabla mas antigua no podemos saber el precio de los datos faltante. Por eso le ponemos 0

UPDATE precio_semanal_1 set producto_id = replace(producto_id,'-','');
UPDATE precio_semanal_1 set sucursal_id = replace(sucursal_id,'-','');

SELECT  sucursal_id -- aca nos dimos cuentas que en sucursal_id hay algunos que no existen en IdSucursal. vamos a crear una tabla de errores y agregamos lo errores en la tabla
from precio_semanal_1
where sucursal_id not in (select p1.sucursal_id
                          from precio_semanal_1 p1
                          join sucursal s on p1.sucursal_id = s.IdSucursal);

create table TablaError(
idError int auto_increment,
motivo varchar(200),
datoError varchar(230),
fecha date,
primary key(idError))ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

insert into tablaError(motivo,datoError,fecha)
select 'no existe el idSucursal', sucursal_id, fecha
from precio_semanal_1
where sucursal_id not in (select p1.sucursal_id
                          from precio_semanal_1 p1
                          join sucursal s on p1.sucursal_id = s.IdSucursal);
                          
select p1.producto_id -- valores que no exiten en IdProducto(15 en total) lo agregamos en la tabla de error
from precio_semanal_1 p1
join producto p on p1.producto_id = p.IdProduct;

insert into tablaerror(motivo , datoError,fecha)
select 'no existe el IdProducto',producto_id, fecha
from precio_semanal_1
where producto_id not in (select p1.producto_id 
                         from precio_semanal_1 p1
                         join producto p on p1.producto_id = p.IdProduct);
                         
-- cambiamos el tipo de la columna fecha
ALTER TABLE precio_semanal_1 MODIFY fecha date;
ALTER TABLE precio_semanal_1 MODIFY precio float;
-- cambiamos los nombres de la columnas 
ALTER TABLE precio_semanal_1  RENAME COLUMN producto_id TO IdProduct ;
ALTER TABLE precio_semanal_1  RENAME COLUMN sucursal_id TO IdSucursal ;

ALTER TABLE precio_semanal_1 ADD INDEX(IdProduct); -- creamos index para que busque mas rapido
ALTER TABLE precio_semanal_1 ADD INDEX(IdSucursal);
ALTER TABLE precio_semanal_1 ADD INDEX(fecha);

-- Tabla Precio_semanal_20200419

-- Analizamos valores faltantes de la tabla precios_semanal
SELECT precio from precio_semanal_2 where precio = '0' ; -- si hay datos faltantes
SELECT producto_id from precio_semanal_2 where producto_id = '' ; -- no hay nulos
SELECT sucursal_id from precio_semanal_2 where sucursal_id = ''; -- no hay nulos
SELECT fecha from precio_semanal_2 where fecha = '' ;-- no hay nulos

-- temporamente a precio le ponemos 0
update  precio_semanal_2 set precio = '0' where precio = '';

-- vamos a corregir los datos 
update  precio_semanal_2 set sucursal_id = replace(sucursal_id,'00:00:00','');
update  precio_semanal_2 set producto_id = replace(producto_id,'-','');
update  precio_semanal_2 set sucursal_id = replace(sucursal_id,'-','');

select p2.sucursal_id
from precio_semanal_2 p2
join sucursal s on p2.sucursal_id = s.IdSucursal; -- hay sucursal_id que no exiten 

select p2.producto_id
from precio_semanal_2 p2
join producto p on p2.producto_id = p.IdProduct;  -- hay producto_id que no exiten(muy pocos)

-- vamos a pasar todo lo que no exita a la trabla de errores

insert into tablaerror (motivo,datoError,fecha)
select 'no existe el idSucursal', sucursal_id ,fecha
from precio_semanal_2
where sucursal_id not in (select p2.sucursal_id
                        from precio_semanal_2 p2
                        join sucursal s on p2.sucursal_id = s.IdSucursal); 
                        
insert into tablaerror (motivo,datoError,fecha)
select 'no existe el idProduct', producto_id ,fecha
from precio_semanal_2
where producto_id not in (select p2.producto_id
                          from precio_semanal_2 p2
                           join producto p on p2.producto_id = p.IdProduct);
                           
-- cambiamos el tipo de la columna fecha
ALTER TABLE precio_semanal_2 MODIFY fecha date;
-- cambiamos los nombres de la columnas 
ALTER TABLE precio_semanal_2  RENAME COLUMN producto_id TO IdProduct ;
ALTER TABLE precio_semanal_2  RENAME COLUMN sucursal_id TO IdSucursal ;
ALTER TABLE precio_semanal_2 ADD INDEX(IdProduct);-- creamos index para que busque mas rapido
ALTER TABLE precio_semanal_2 ADD INDEX(IdSucursal);
ALTER TABLE precio_semanal_2 ADD INDEX(fecha);

-- los precios nulos ahora lo comparamos con la semana anterior y le agregamos el valor anterior 

SELECT  p1.precio  , p2.precio
FROM precio_semanal_2 p2
join precio_semanal_1 p1 on p2.IdProduct = p1.IdProduct
where p2.precio = '0';

UPDATE precio_semanal_2 p2
JOIN  precio_semanal_1 p1 ON p2.IdProduct = p1.IdProduct
SET p2.precio = p1.precio
WHERE p2.precio = '0';

-- cambiamos el tipo de la columna precio
ALTER TABLE precio_semanal_2 MODIFY precio float;
                          
-- Tabla precio_ultima_actualizacion

SELECT precio from precio_ultima_actualizacion where precio = '' ; -- si hay datos faltantes
SELECT IdProduct from precio_ultima_actualizacion where IdProduct = '' ; -- no hay nulos
SELECT IdSucursal from precio_ultima_actualizacion where IdSucursal = ''; -- no hay nulos
SELECT fecha from precio_ultima_actualizacion where fecha = '' ;-- no hay nulos

-- temporalmente le pondremos 0 al precio nulo
update precio_ultima_actualizacion set precio = 0 where precio = ''; 

-- vamos a corregir los datos 
update  precio_ultima_actualizacion set IdProduct = replace(IdProduct,'-','');
update  precio_ultima_actualizacion set IdSucursal = replace(IdSucursal,'-','');

select p.IdSucursal
from precio_ultima_actualizacion p
join sucursal s on p.IdSucursal= s.IdSucursal; -- hay algunos que no existen el idSucursal

select p53.IdProduct
from precio_ultima_actualizacion p53
join producto p on p53.IdProduct = p.IdProduct;  -- existe todo el idProduct

-- los idSucursal que no exite lo agregamos a la tabla error
insert into tablaerror(motivo,datoError,fecha)
select 'no existe el IdSucursal',IdSucursal ,fecha
from precio_ultima_actualizacion
where IdSucursal not in( select p.IdSucursal
                      from precio_ultima_actualizacion p
                      join sucursal s on p.IdSucursal = s.IdSucursal);

-- cambiamos el tipo de la columna fecha
ALTER TABLE precio_ultima_actualizacion MODIFY fecha date;

ALTER TABLE precio_ultima_actualizacion ADD INDEX(IdProduct);-- creamos index para que busque mas rapido
ALTER TABLE precio_ultima_actualizacion ADD INDEX(IdSucursal);
ALTER TABLE precio_ultima_actualizacion ADD INDEX(fecha);

-- remplanzamos los valores nulos de precio por una semana anterior

update precio_ultima_actualizacion p
join precio_semanal_2 p2 on p.IdProduct = p2.IdProduct
set p.precio = p2.precio
where p.precio = '0';
-- cambiamos el tipo de la columna precio
ALTER TABLE precio_ultima_actualizacion MODIFY precio float;
                          
