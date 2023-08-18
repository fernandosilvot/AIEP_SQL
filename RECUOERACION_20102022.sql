
-- CLASE DE RECUPERACION 20-10
-- PROFESOR JUANCARLOS AVILA
-- TALLER DE BASES DE DATOS

create database restorant
go
use restorant 
go




create table pedidos(id int identity primary key not null,
                     pedido varchar(70),
					 mesa int,
					 estado varchar(70)
					 )
					 


create table cocinas (id int identity primary key not null,
                     orden varchar(70),				
					 estado varchar(70) default 'PENDIENTE'
					 )




CREATE TABLE BITACORAS ( id int identity primary key not null,
                         FECHA_HORA  DATETIME,
						 NUMERO_BOLETA INT ,
						 NUMERO_IP VARCHAR(70),
						 RUT_EMPLEADO  VARCHAR(70)
						 )


CREATE PROCEDURE SP_INGRESA_PEDIDO ( @pedido varchar(70),
				@mesa int,
				@estado varchar(70))
AS BEGIN

			INSERT INTO PEDIDOS VALUES (@pedido, @mesa,@estado)

END

EXEC SP_INGRESA_PEDIDO 'PIZZA DE PEPERONI DOBLE QUESO',7,NULL


SELECT * FROM PEDIDOS
SELECT * FROM cocinas


-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
---------------------------------TRIGGERS------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------




ALTER TRIGGER TG_INGRESO_COCINA
ON
PEDIDOS
FOR INSERT
AS BEGIN
		DECLARE @PEDIDO VARCHAR(70)
		SELECT @PEDIDO = pedido FROM inserted
		
		INSERT INTO COCINAS (ORDEN) VALUES (@PEDIDO)

END




ALTER PROCEDURE SP_CAMBIO_ESTADO_COCINA (@ID INT)
AS BEGIN

		UPDATE COCINAS SET ESTADO = 'LISTO' WHERE ID = @ID
END

EXEC SP_CAMBIO_ESTADO_COCINA 2




ALTER TRIGGER TG_ACTUALIZA_ESTADO_PEDIDO
ON COCINAS
FOR UPDATE
AS BEGIN

  --PRINT 'ESTOS SON LOS VALORES ES LA TABLA INSERTED'
  ----SELECT * FROM INSERTED
   --PRINT 'ESTOS SON LOS VALORES ES LA TABLA DELETED'
	--SELECT * FROM DELETED


	DECLARE @ESTADO VARCHAR(70)
	DECLARE @ORDEN VARCHAR(70)

	SELECT @ESTADO = 'TERMINADO'
	SELECT @ORDEN = ORDEN FROM INSERTED
	UPDATE PEDIDOS SET ESTADO = @ESTADO WHERE PEDIDO = @ORDEN
END






EXEC SP_INGRESA_PEDIDO 'CAZUELA DE VACUNO',3,NULL
EXEC SP_INGRESA_PEDIDO 'CAZUELA DE POLLO',3,NULL
EXEC SP_INGRESA_PEDIDO 'ARROZ CON CARNE DE VACUNO',7,NULL
EXEC SP_INGRESA_PEDIDO 'FIDEOS',8,NULL
EXEC SP_INGRESA_PEDIDO 'LOMO A LO POBRE',6,NULL
EXEC SP_INGRESA_PEDIDO 'EMPANADA DE PINO',23,NULL
EXEC SP_INGRESA_PEDIDO 'ARROZ TOMATE Y HUEVO',13,NULL
EXEC SP_INGRESA_PEDIDO 'FIDEOS CON PALTA Y VIENESA',33,NULL


SELECT * FROM PEDIDOS
SELECT * FROM cocinas

EXEC SP_CAMBIO_ESTADO_COCINA 3