--creamos el esquema para la tabla recobros
use recobrohplpruebas;

drop schema if exists cliente;
create schema cliente;

drop table if exists acreedor;

create table cliente.acreedor(
id_acreedor int primary key identity(1,1),--queremos oculta este campo para el grupo de visitantes
nombreEmpresa varchar(50) not null,
cif varchar (20) not null unique, 
contacto varchar(30),
comision decimal(5,2)--queremos oculta este campo para el grupo de visitantes
);

select * from cliente.acreedor;

--cremaos una vista
drop view if exists cliente.vistaacreedor;
create view cliente.vistaacreedor as select nombreEmpresa,cif,contacto from cliente.acreedor;

select * from cliente.vistaacreedor;
--cremaos un rol de revisor
drop role if exists revisor;
create role revisor;
--le damos permisos en la vista q heos creado
grant select on cliente.vistaacreedor to revisor;

--ahora crwmaos un usario y lo añadimos el grpo revisor

drop user if exists juando;
create user juando without login;

alter role revisor add member juando;


--accediendo com juan tanto a la vista como a la tabla

execute as user ='juando';
print user
select * from cliente.acreedor;
select * from cliente.vistaacreedor;
revert

--ahora lo haremos con un procedimiento almacenado para inserta datos
--cremoas un rol para meter datos
drop role if exists insertadatosacreedor;
create role insertadatosacreedor;
alter role insertadatosacreedor add member juando;

--creamos proce
grant execute on schema::cliente to insertadatosacreedor;
create or alter proc cliente.insertaaccredor
--parametro 
@nombreEmpresa varchar(50),
@cif varchar (20),
@contacto varchar (50),
@comision decimal(5,2)
as begin
insert into cliente.acreedor
(nombreEmpresa,cif,contacto,comision)
values
(@nombreEmpresa,@cif,@contacto,@comision)
end;
--probando si podemos introducir datos en el atabla
execute as user ='juando';
print user

INSERT INTO cliente.acreedor(nombreEmpresa, cif, contacto, comision) VALUES
('Banco Co', 'Ap12347878', 'Rober Pérez', 15.50);

--demostrando q juando puede inserta datos a traves del procemiento
exec cliente.insertaaccredor
@nombreEmpresa = 'bankia',
@cif ='123e',
@contacto='luis pe',
@comision=78.2;


