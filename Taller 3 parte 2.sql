create table Pacientes(
rut_titular			varchar(max),
nombre				varchar(100),
ap_paterno			varchar(100),
ap_materno			varchar(100),
edad				int,
sexo				varchar(10),
direccion			varchar(1000),
comuna				varchar(50),
cod_comuna			varchar(50),
ciudad				varchar(100),
region				int,
telefono			varchar(100),
telefono_ce			varchar(100),
mail				varchar(100),
Costo_Final			float,
Contraseña			varbinary(8000)
)

select * from Pacientes

Bulk insert Pacientes from 'C:\DATOS\Taller3.txt' 
with (
FIRSTROW = 2,
FIELDTERMINATOR = '\t',
ROWTERMINATOR = '\n'
)

--
update Pacientes set telefono_ce = 'Sin telefono' where telefono_ce = '0'
--

--
insert into Pacientes select * From Pacientes
--

--
select COUNT(*) from Pacientes
--

--
truncate table pacientes 
--

--
Alter table pacientes add ID_Pacientes int identity primary key
alter table pacientes add Clave Varchar(max)
--

--
alter table pacientes drop column clave
--

--
drop table Pacientes
--


insert into Pacientes (rut_titular,nombre,ap_paterno,ap_materno,edad,sexo,direccion,comuna,cod_comuna,ciudad,
						region,telefono,telefono_ce,mail,Costo_Final,Contraseña)
						values('010858462-9', 'EDUARDO ARIEL', 'VALENZUELA', 'VELASQUEZ', 46 ,'M' , 'LAS TORCAZAS 920 PUDAHUEL', '13111', 'SANTIAGO', '13' ,'6016070'  ,'82392206' ,'eavv@terra.cl',  '5,96' , ENCRYPTBYPASSPHRASE('password','Contraseña usuario'))



select * from Pacientes where rut_titular = '010858462-9'