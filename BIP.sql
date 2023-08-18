CREATE DATABASE ANALISIS_BIP
GO
USE ANALISIS_BIP
GO

DROP TABLE tarVip2022
GO


CREATE TABLE tarVip2022  (
ID						INT PRIMARY KEY 
,CODIGO					VARCHAR(5)
,ENTIDAD				VARCHAR(20)
,NOMBRE_FANTASIA		VARCHAR(50)
,DIRECCION				VARCHAR(200)
,COMUNA					VARCHAR(50)
,HORARIO_REFERENCIAL	VARCHAR(200)
,LONGITUD				VARCHAR(100)
,LATITUD				VARCHAR(100)
)

BULK INSERT tarVip2022 FROM 'C:\DATOS\data_tarVip2022.CSV' 
WITH ( FIRSTROW =2,   
FIELDTERMINATOR= ';',   
ROWTERMINATOR = '\n');
GO


SELECT * FROM tarVip2022
select * from COMUNAS

select distinct COMUNA, COUNT(*) as NOMBRE_COMUNA  from tarVip2022 GROUP BY COMUNA

alter table COMUNAS ADD ID_COMUNA INT IDENTITY PRIMARY KEY
---------------------------------------------------------------------------------------------------------
UPDATE tarVip2022 SET COMUNA = ID_COMUNA 
FROM tarVip2022 INNER JOIN COMUNAS 
ON tarVip2022.COMUNA = COMUNAS.NOMBRE_COMUNA


SELECT * FROM tarVip2022 INNER JOIN COMUNAS 
ON tarVip2022.COMUNA = COMUNAS.ID_COMUNA

---------------------------------------------------------------------------------------------------------
ALTER TABLE tarVip2022 add ID_COMUNA INT 
UPDATE tarVip2022 SET ID_COMUNA = COMUNA

ALTER TABLE tarVip2022 DROP COLUMN COMUNA
---------------------------------------------------------------------------------------------------------

SELECT DISTINCT ENTIDAD AS NOMBRE_ENTIDAD INTO ENTIDADES FROM tarVip2022 

SELECT * FROM ENTIDADES

ALTER TABLE ENTIDADES ADD ID_ENTIDAD INT IDENTITY PRIMARY KEY
---------------------------------------------------------------------------------------------------------
UPDATE tarVip2022 SET ENTIDAD = ID_ENTIDAD 
FROM tarVip2022 INNER JOIN ENTIDADES
ON tarVip2022.ENTIDAD = ENTIDADES.NOMBRE_ENTIDAD

SELECT * FROM tarVip2022 INNER JOIN ENTIDADES 
ON tarVip2022.ENTIDAD = ENTIDADES.ID_ENTIDAD
---------------------------------------------------------------------------------------------------------
ALTER TABLE tarVip2022 ADD ID_ENTIDAD INT 
UPDATE tarVip2022 SET ID_ENTIDAD = ENTIDAD

ALTER TABLE tarVip2022 DROP COLUMN ENTIDAD
---------------------------------------------------------------------------------------------------------
SELECT ID, LONGITUD, LATITUD INTO UBICACION FROM tarVip2022

SELECT * FROM tarVip2022

ALTER TABLE tarVip2022 ADD ID_UBICACION INT 

ALTER TABLE tarVip2022 DROP COLUMN LATITUD, LONGITUD

UPDATE tarVip2022 SET tarVip2022.ID_UBICACION = UBICACION.ID FROM tarVip2022
INNER JOIN UBICACION ON UBICACION.ID = tarVip2022.ID


SELECT * FROM tarVip2022 INNER JOIN UBICACION
ON tarVip2022.ID_UBICACION = UBICACION.ID
---------------------------------------------------------------------------------------------------------

DROP TABLE UBICACION