--create database  Taller1
create table Empleados ( 
ID_Empleado	int primary key identity not null,
AP_Paterno		varchar(200) null,
AP_Materno		varchar(200) null,
Nombres			varchar(200) null,
rut				varchar(10) null,
ID_Jefatura		int null,
Empresa			varchar(200) null,
Email			varchar(200) null
)


--set @ID_Empleado = SCOPE_IDENTITY()



/*select
	AP_Paterno = @AP_Paterno,
	AP_Materno = @AP_Materno,
	Nombres = @Nombres,
	rut = @rut,
	ID_Jefatura = @ID_Jefatura,
	Empresa = @Empresa
	from Empleados where ID_Empleado = @ID_Empleado*/
select * from Empleados

drop table Empleados

truncate table Empleados

--------------------------------------------------------------------
--------------------------------------------------------------------

alter PROCEDURE SP_INGRESA_EMPLEADO(
@AP_Paterno		VARCHAR(200),
@AP_Materno		VARCHAR(200),
@Nombres		VARCHAR(200),
@rut			VARCHAR(10),
@ID_Jefatura	VARCHAR(200),
@Empresa		VARCHAR(200),
@email			VARCHAR(200) null
)
AS 
BEGIN
	
	if(@AP_Paterno = '' or @AP_Materno = '' or @Nombres = '' or @ID_Jefatura = '' or @Empresa = '' or @email = '')
	select 'FALTAN DATOS'
else
insert into Empleados values
(
	@AP_Paterno,
	@AP_Materno,
	@Nombres,
	@rut,
	@ID_Jefatura,
	@Empresa,
	@email 
)
 print 'se añadio correvtamente el empleado'
END


--exec SP_INGRESA_EMPLEADO 'Mansilla', 'Muñoz', 'Javier Ignacio', '19956215-0', '1313', 'LOL.inc', null
--exec SP_INGRESA_EMPLEADO 'Soto', 'Muñoz', 'Felipe Andres', '21240484-5', '121', 'LOLCITO.CL', null
--exec SP_INGRESA_EMPLEADO 'Silva', 'Trincado', 'Fernando Antonio', '21322200-7', '122', 'fort', null
--exec SP_INGRESA_EMPLEADO 'Medina', 'Fernandez', 'Rodrigo Andres', '15349720-6', '322', 'valo', null
--exec SP_INGRESA_EMPLEADO 'seifer', 'rojas', 'Lucas Andres', '1534680-6', '322', 'valo', null
--exec SP_INGRESA_EMPLEADO 'rojas', 'medina', 'Rodrigo Ingnacio', '18749720-6', '392', 'orizon', null
--exec SP_INGRESA_EMPLEADO 'opazo', 'silva', 'Lucas Fernando', '21654720-6', '322', 'valo', null


--------------------------------------------------------------------
--------------------------------------------------------------------

alter procedure SP_ELIMINAR_EMPLEADO (
@ID_Empleado	INT
)
as
begin

	delete from Empleados where ID_Empleado =  @ID_Empleado
if @@ROWCOUNT = 1
	print 'Se elimino correctamente!'
else
print 'NO se elimino correctamente!'
end

exec SP_ELIMINAR_EMPLEADO 2  

select * from Empleados

--------------------------------------------------------------------
--------------------------------------------------------------------

ALTER procedure SP_GENERA_EMAIL @ID_Empleado INT
AS 
BEGIN 
	IF @ID_Empleado = '' OR @ID_Empleado IS NULL 
	PRINT 'Los datos estan equivocados o incorrectos'
	else 
	update Empleados
	set Email = SUBSTRING(Nombres,1,5) +'.'+ SUBSTRING(AP_Paterno,1,3) + '.' + SUBSTRING(AP_Materno,1,3) + '@' + Empresa + '.cl'
	where ID_Empleado = @ID_Empleado
	print 'Se añadio el correo exitosamente!'
end


exec SP_GENERA_EMAIL 1
exec SP_GENERA_EMAIL 2
exec SP_GENERA_EMAIL 4
exec SP_GENERA_EMAIL 5
exec SP_GENERA_EMAIL 6
exec SP_GENERA_EMAIL 7
exec SP_GENERA_EMAIL 8

select * from empleados