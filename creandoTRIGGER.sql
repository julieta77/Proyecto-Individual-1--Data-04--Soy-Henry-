create table auditoria_precio(
IdAuditoria int auto_increment,
precio varchar(80),
IdProduct varchar(50) ,
IdSucursal varchar(50), 
fecha date,
primary key(IdAuditoria)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

drop table auditoria_precio;

drop trigger precioTrigger;

DELIMITER $$
CREATE TRIGGER precioTrigger
AFTER INSERT ON precio_ultima_actualizacion
FOR EACH ROW 
BEGIN
      INSERT INTO auditoria_precio (precio,IdProduct , IdSucursal,fecha) 
      VALUES ( NEW.precio,NEW.IdProduct, NEW.IdSucursal,NEW.fecha);
END; $$

