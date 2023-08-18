CREATE DATABASE ANALISIS_CASINO
GO
USE ANALISIS_CASINO
GO

DROP TABLE sancionesAplicadas

GO

CREATE TABLE sancionesAplicadas  (
ID						INT PRIMARY KEY 
,Sociedad_Operadora		VARCHAR(50)
,Nombre_casino			VARCHAR(50)
,Resolucion_Exenta		INT
,Fecha					DATE
,Monto_sancion_UTM 		VARCHAR(50)
,Descripcion_sancion 	VARCHAR(1000)
,Estado					VARCHAR(50)

)

SET DATEFORMAT DMY; BULK INSERT sancionesAplicadas FROM 'C:\DATOS\data_sanciones aplicadasSuperintendenciaaCasinosJuego.CSV' 
WITH   (FIRSTROW =2
	   ,FIELDTERMINATOR= ';'
	   ,ROWTERMINATOR = '\n');  
GO
---
select distinct estado into ESTADOS from sancionesAplicadas

alter table sancionesAplicadas add ESTADO_ID INT 

alter table ESTADOS add ID_ESTADO INT IDENTITY PRIMARY KEY

update ESTADOS set estado = 'SIN INFORMACION' WHERE estado IS NULL 

UPDATE sancionesAplicadas set ESTADO_ID = ID_ESTADO FROM sancionesAplicadas SA
INNER JOIN ESTADOS E ON E.estado = SA.estado
---
ALTER TABLE sancionesAplicadas DROP COLUMN estado
ALTER TABLE sancionesAplicadas DROP COLUMN Sociedad_Operadora
ALTER TABLE sancionesAplicadas DROP COLUMN Nombre_casino

---
select * From sancionesaplicadas 
SELECT * FROM SOCIEDADES
SELECT * FROM CASINO 
SELECT * FROM ESTADOS
---

select Sociedad_Operadora into SOCIEDADES from sancionesaplicadas

ALTER TABLE SOCIEDADES ADD ID_SOCIEDAD INT IDENTITY PRIMARY KEY 

ALTER TABLE sancionesaplicadas ADD SOCIEDAD_ID INT 

UPDATE sancionesaplicadas SET SOCIEDAD_ID = ID_SOCIEDAD FROM sancionesaplicadas 
INNER JOIN SOCIEDADES ON SOCIEDADES.Sociedad_Operadora  = sancionesaplicadas.Sociedad_Operadora
---

SELECT Nombre_casino  INTO CASINO FROM sancionesaplicadas

ALTER TABLE CASINO ADD ID_CASINO INT IDENTITY PRIMARY KEY 

ALTER TABLE sancionesaplicadas ADD CASINO_ID INT 

UPDATE sancionesaplicadas SET CASINO_ID = ID_CASINO FROM sancionesaplicadas
INNER JOIN CASINO C ON C.Nombre_casino  = sancionesaplicadas.Nombre_casino
---
ALTER TABLE sancionesAplicadas ADD UTM FLOAT 
ALTER TABLE sancionesAplicadas ADD CLP FLOAT 
ALTER TABLE sancionesAplicadas ADD A—O INT  
update  sancionesAplicadas set UTM = CONVERT(INT, replace(substring(Monto_sancion_UTM,1,3),'U', ' '))
update sancionesAplicadas set CLP = UTM * 58.248
update  sancionesAplicadas set A—O =  year(fecha) from sancionesAplicadas
---
 
CREATE VIEW XX
AS 
SELECT Sociedad_Operadora,estado, count(*) as 'TOTAL PENDIENTE'
FROM sancionesAplicadas SA	INNER JOIN SOCIEDADES S ON S.ID_SOCIEDAD		= SA.SOCIEDAD_ID
							INNER JOIN ESTADOS E	ON E.ID_ESTADO			= SA.ESTADO_ID
						    WHERE estado = 'Pendiente de pago'
							GROUP BY Sociedad_Operadora,estado   

CREATE VIEW XXXX
AS
SELECT nombre_casino, estado, count(*) AS TOTAL
from sancionesAplicadas SA INNER JOIN CASINO C	ON C.ID_CASINO	= SA.CASINO_ID
						   INNER JOIN ESTADOS E ON  E.ID_ESTADO = SA.ESTADO_ID
							WHERE estado = 'Pagada'		   
							GROUP BY nombre_casino, estado
						  

SELECT Nombre_casino, sum(CLP) as TOTAL 
FROM sancionesAplicadas SA inner join CASINO C ON C.ID_CASINO = SA.CASINO_ID
GROUP BY Nombre_casino 
having sum(CLP) > 100
						   

SELECT count(*) as total FROM CASINO where Nombre_casino =  'Casino de Juegos del Pac›fico'

SELECT Sociedad_Operadora  FROM SOCIEDADES  WHERE Sociedad_Operadora =  'Marina del Sol S.A.'





