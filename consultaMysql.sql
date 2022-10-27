use negocio;
select avg(p.precio) as promedio , p.sucursal_id , s.sucursal
from precio_ultima_actualizacion p
join sucursal s on s.IdSucursal = p.sucursal_id
where sucursal_id= '91688';