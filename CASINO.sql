CREATE DATABASE ANALISIS_CASINO
GO
USE ANALISIS_CASINO_2
GO

DROP TABLE sancionesAplicadas
DROP TABLE DATOS_SOCIEDAD
DROP TABLE DATOS_SANCIONES
DROP TABLE ESTADOS
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

--CAMBIO DE NOMBRE EN COLUMNAS--
exec sp_rename 'ESTADOS.Estado'							, 'ESTADO'				, 'COLUMN' 
exec sp_rename 'sancionesAplicadas.Fecha'				, 'FECHA'				, 'COLUMN' 
exec sp_rename 'sancionesAplicadas.Resolucion_exenta'	, 'RESOLUCION_EXENTA'	, 'COLUMN' 
exec sp_rename 'sancionesAplicadas.Nombre_casino'		, 'NOMBRE_CASINO'		, 'COLUMN' 
exec sp_rename 'DATOS_SANCIONES.Descripcion_sancion'	, 'DESCRIPCION_SANCION'	, 'COLUMN' 
exec sp_rename 'DATOS_SANCIONES.Monto_sancion_UTM'		, 'MONTO_SANCION_UTM'	, 'COLUMN' 
exec sp_rename 'DATOS_SOCIEDAD.Sociedad_Operadora'		, 'SOCIEDAD_OPERADORA'	, 'COLUMN' 
exec sp_rename 'sancionesAplicadas.anno'				, 'AÑO'					, 'COLUMN'

--CREACION TABLA DATOS_SOCIEDAD--
select DISTINCT Sociedad_Operadora INTO DATOS_SOCIEDAD From sancionesAplicadas

ALTER TABLE DATOS_SOCIEDAD ADD ID_SOCIEDAD INT IDENTITY PRIMARY KEY 
ALTER TABLE sancionesAplicadas ADD SOCIEDAD_ID INT 

UPDATE sancionesAplicadas SET SOCIEDAD_ID = ID_SOCIEDAD FROM sancionesAplicadas
INNER JOIN DATOS_SOCIEDAD DS ON sancionesAplicadas.Sociedad_Operadora = DS.Sociedad_Operadora

--CREACION TABLA ESTADOS--
SELECT DISTINCT Estado into ESTADOS FROM sancionesAplicadas
UPDATE ESTADOS SET Estado = 'Sin Informacion' where Estado is null 

ALTER TABLE ESTADOS ADD ID_ESTADO INT IDENTITY PRIMARY KEY 
ALTER TABLE sancionesAplicadas ADD ESTADO_ID INT

UPDATE sancionesAplicadas SET ESTADO_ID = ID_ESTADO FROM sancionesAplicadas
INNER JOIN ESTADOS E ON sancionesAplicadas.Estado = E.Estado

--CREACION TABLA DATOS_SANCIONES--
select distinct Descripcion_sancion,Monto_sancion_UTM INTO DATOS_SANCIONES from sancionesAplicadas

alter table DATOS_SANCIONES add ID_SANCIONES INT IDENTITY PRIMARY KEY
ALTER TABLE sancionesAplicadas ADD SANCIONES_ID INT

UPDATE sancionesAplicadas SET SANCIONES_ID = ID_SANCIONES FROM sancionesAplicadas
INNER JOIN DATOS_SANCIONES DSD ON sancionesAplicadas.Monto_sancion_UTM = DSD.Monto_sancion_UTM

--AGREGAR UTM,CLP Y USD, A LA TABLA DATOS_SANCIONES--
ALTER TABLE  sancionesAplicadas ADD UTM FLOAT 
ALTER TABLE  sancionesAplicadas ADD CLP FLOAT 
ALTER TABLE	 sancionesAplicadas ADD USD FLOAT 
ALTER TABLE	 sancionesAplicadas ADD AÑO INT 

select UTM * 58.248 AS CLP from DATOS_SANCIONES

update  sancionesAplicadas set AÑO =  year(fecha) from sancionesAplicadas
update  sancionesAplicadas set UTM = CONVERT(INT, replace(substring(Monto_sancion_UTM,1,3),'U', ' '))
update  sancionesAplicadas set CLP = UTM * 58.248
update  sancionesAplicadas set USD = CLP * 1012.70

--BORRAR COLUMNAS DE LA TABLA PRINCIPAL--
ALTER TABLE sancionesAplicadas DROP COLUMN Sociedad_Operadora,  Descripcion_sancion,Estado

--SELECT GENERAL--
SELECT * FROM sancionesAplicadas
SELECT * FROM DATOS_SOCIEDAD
SELECT * FROM DATOS_SANCIONES
SELECT * FROM ESTADOS
-----------------------------------------CONSULTAS---------------------------------------------------


--INNER JOIN SIMPLES--
SELECT ID, NOMBRE_CASINO,RESOLUCION_EXENTA, FECHA, ESTADO_ID, ESTADO 
		 FROM SANCIONESAPLICADAS SA INNER JOIN ESTADOS			 E  ON SA.ESTADO_ID		 =  E.ID_ESTADO

SELECT * FROM SANCIONESAPLICADAS SA INNER JOIN DATOS_SANCIONES   DA	ON DA.ID_SANCIONES	 =  SA.SANCIONES_ID

SELECT * FROM SANCIONESAPLICADAS SA INNER JOIN DATOS_SOCIEDAD	 DS	ON DS.ID_SOCIEDAD	 =  SA.SOCIEDAD_ID

SELECT * FROM ESTADOS				FULL JOIN sancionesAplicadas SA ON ESTADOS.ID_ESTADO = SA.ESTADO_ID 
		 WHERE ESTADO = 'Sin informacion'

--INNER JOIN COMPLEJOS--
SELECT sa.ID, sa.Nombre_casino, sa.Fecha, e.ESTADO, SA.UTM, SA.CLP FROM sancionesAplicadas SA 
									INNER JOIN ESTADOS			E	ON E.ID_ESTADO		=  SA.ESTADO_ID
									INNER JOIN DATOS_SANCIONES	DS	ON DS.ID_SANCIONES	=  SA.SANCIONES_ID 
									WHERE DAY(Fecha) between 9 and 30 

SELECT 
 SA.ID
,SA.Nombre_casino
,SA.Resolucion_Exenta
,SA.Fecha
,SA.SANCIONES_ID
,SA.ESTADO_ID
,SA.SOCIEDAD_ID
,E.ESTADO
,DS.DESCRIPCION_SANCION
,DS.MONTO_SANCION_UTM	
,SA.UTM
,SA.CLP 
,SA.USD
,DSO.SOCIEDAD_OPERADORA FROM sancionesAplicadas SA 
									INNER JOIN ESTADOS			E	ON E.ID_ESTADO		=  SA.ESTADO_ID
									INNER JOIN DATOS_SANCIONES	DS	ON DS.ID_SANCIONES	=  SA.SANCIONES_ID
									INNER JOIN DATOS_SOCIEDAD	DSO	ON DSO.ID_SOCIEDAD	=  SA.SOCIEDAD_ID

SELECT 
 SA.ID
,SA.Resolucion_Exenta
,SA.Fecha
,SA.SANCIONES_ID
,SA.UTM
,DS.DESCRIPCION_SANCION FROM sancionesAplicadas SA 
									INNER JOIN DATOS_SANCIONES	DS	ON DS.ID_SANCIONES	=  SA.SANCIONES_ID 
									WHERE Resolucion_Exenta like '%81%'


SELECT * FROM sancionesAplicadas SA INNER JOIN DATOS_SANCIONES DS ON DS.ID_SANCIONES = SA.SANCIONES_ID WHERE DAY(Fecha) BETWEEN 9 AND 30  

--CONSULTAS CON BETWEEN--

select		*		from sancionesAplicadas where	MONTH(Fecha) 		between		11		and		12
select		*		from sancionesAplicadas where	DAY(Fecha)			between		9		and		30
select		*		from sancionesAplicadas where	year(Fecha)			between		2009	and		2010 
select		*		from sancionesAplicadas where	Nombre_casino		between		'A'		and		'D' 
--CONSULTAS CON OPERACIONES--

SELECT	SUM(CLP)		FROM sancionesAplicadas 
SELECT	MIN(CLP)		FROM sancionesAplicadas
SELECT	SUM(CLP)		FROM sancionesAplicadas
SELECT	SUM(USD)		FROM sancionesAplicadas

--CONSULTAS CON OPERACION RESTA--

SELECT	CLP - UTM AS RESTA		FROM sancionesAplicadas
SELECT	USD - CLP AS RESTA		FROM sancionesAplicadas
SELECT	USD - UTM AS RESTA		FROM sancionesAplicadas

SELECT * FROM SANCIONESAPLICADAS WHERE ESTADO_ID	=	'2'		AND SOCIEDAD_ID		=	'1'
SELECT * FROM sancionesAplicadas WHERE SOCIEDAD_ID	=	'10'	AND SANCIONES_ID	=	'16'	 

--CONSULTAS CON AND--

SELECT DISTINCT COUNT(*) AS TOTAL FROM sancionesAplicadas WHERE MONTH(Fecha) = 5
select Nombre_casino, ESTADO_ID ,count(*) as TOTAL from sancionesAplicadas group by Nombre_casino, estado_id

---CONSULTA CON HAVING--

SELECT UTM, SUM(CLP)AS TOTAL FROM sancionesAplicadas GROUP BY UTM HAVING SUM(CLP) > 340 
---------------------------------------------------------------------------------------------------------

--CREADAS POR MI--

create view TOTAL_PESOS_CLP_POR_UTM
as
SELECT UTM, SUM(CLP)AS 'TOTAL CLP' FROM sancionesAplicadas GROUP BY UTM HAVING SUM(CLP) > 340 
ORDER BY UTM DESC

SELECT * FROM sancionesAplicadas

create view RESOLUCION_POR_ESTADO
as 
select Resolucion_Exenta,estado 
from sancionesAplicadas SA inner join ESTADOS E ON E.ID_ESTADO = SA.ESTADO_ID
GROUP BY Resolucion_Exenta, estado
--CREADAS POR LA PRUEBA--

CREATE VIEW TOTAL_MULTAS_POR_SOCIEDAD
AS
SELECT Sociedad_Operadora, SUM(UTM)AS TOTAL FROM sancionesAplicadas INNER JOIN DATOS_SOCIEDAD ON 
DATOS_SOCIEDAD.ID_SOCIEDAD = sancionesAplicadas.SOCIEDAD_ID
GROUP BY Sociedad_Operadora HAVING SUM(UTM) > 100 
order by SUM(UTM) DESC 
--
SELECT * FROM TOTAL_MULTAS_POR_SOCIEDAD 
SELECT * FROM TOTAL_DEUDA_UTM_CON_ESTADO_PENDIENTE_DE_PAGO
SELECT * FROM RESOLUCION_POR_ESTADO
SELECT * FROM TOTAL_PESOS_CLP_POR_UTM
--
CREATE VIEW TOTAL_DEUDA_UTM_CON_ESTADO_PENDIENTE_DE_PAGO
AS
select Sociedad_Operadora, Nombre_casino, Estado, SUM(UTM)AS TOTAL from sancionesAplicadas inner join ESTADOS on ESTADOS.ID_ESTADO = sancionesAplicadas.ESTADO_ID 
								 inner join DATOS_SOCIEDAD on DATOS_SOCIEDAD.ID_SOCIEDAD = sancionesAplicadas.SOCIEDAD_ID WHERE Estado = 'Pendiente de pago'
								 GROUP BY Sociedad_Operadora,Estado,Nombre_casino HAVING SUM(UTM)> 100
								 ORDER BY SUM(UTM) DESC


--REEMPLAZAR DATOS--

UPDATE DATOS_SOCIEDAD set Sociedad_Operadora = replace(Sociedad_Operadora, 'Ý', 'i') where Sociedad_Operadora like '%i%'

--
SELECT * FROM sancionesAplicadas
SELECT * FROM DATOS_SANCIONES
SELECT * fROM DATOS_SOCIEDAD

SELECT Resolucion_Exenta
,MAX(Resolucion_Exenta) AS 'MAS GRANDE DE 100'
FROM sancionesAplicadas 
GROUP BY Resolucion_Exenta 
HAVING MAX(Resolucion_Exenta) > 100

SELECT ID, Nombre_casino, SOCIEDAD_ID, SANCIONES_ID, ESTADO_ID FROM sancionesAplicadas 
									INNER JOIN DATOS_SANCIONES  ON DATOS_SANCIONES.ID_SANCIONES	= sancionesAplicadas.SANCIONES_ID  
									INNER JOIN DATOS_SOCIEDAD	ON DATOS_SOCIEDAD.ID_SOCIEDAD	= sancionesAplicadas.SOCIEDAD_ID
									INNER JOIN ESTADOS			ON ESTADOS.ID_ESTADO			= sancionesAplicadas.ESTADO_ID 


SELECT COUNT(SOCIEDAD_ID) as TOTAL , AÑO FROM sancionesAplicadas GROUP BY AÑO HAVING COUNT(SOCIEDAD_ID) > 3;