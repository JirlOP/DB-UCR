/*
Jorge Ricardo D�az Sagot - C12565
Christopher V�quez Aguilar - C08538
*/

USE C12565


/*
[50 pts] Programe un trigger que simule un borrado en cascada desde la tabla Carrera
hacia la tabla Empadronado_en. Es decir, que cuando se borre una carrera, se borren
también las tuplas de Empadronado_en asociadas a dicha carrera, de manera que no
queden estudiantes empadronados en esa carrera. Suponga que solo se borra una
carrera a la vez.
*/

GO

CREATE OR ALTER TRIGGER BorrarCarreraCascade
    ON CARRERA
INSTEAD OF DELETE
AS
BEGIN
    DELETE FROM EMPADRONADO_EN
    WHERE CodCarrera = (SELECT Codigo FROM deleted)

	DELETE FROM PERTENECE_A
    WHERE CodCarrera = (SELECT Codigo FROM deleted)

	DELETE FROM CARRERA
    WHERE Codigo = (SELECT Codigo FROM deleted)
END

GO

USE C12565

-- Antes del trigger y el borrado en carrera 
SELECT * FROM CARRERA
SELECT * FROM EMPADRONADO_EN
SELECT * FROM PERTENECE_A

-- Activate Trigger
DELETE FROM CARRERA
WHERE Codigo LIKE 'Bach01Comp'

-- Despues del trigger y el borrado en carrera 
SELECT * FROM CARRERA
SELECT * FROM EMPADRONADO_EN
SELECT * FROM PERTENECE_A


GO
/*
3.c.i) 
*/

INSERT CARRERA 
	VALUES(
		'Bach01Comp', 'Bachillerato en Computación e Informática', '1973-11-14'
	)

SELECT * FROM CARRERA
SELECT * FROM EMPADRONADO_EN
SELECT * FROM PERTENECE_A

-- Activate Trigger
DELETE FROM CARRERA
WHERE Codigo LIKE 'Bach01Comp'

SELECT * FROM CARRERA
SELECT * FROM EMPADRONADO_EN
SELECT * FROM PERTENECE_A


/*
3.c.ii) 
*/

INSERT CARRERA 
	VALUES(
		'Bach01Comp', 'Bachillerato en Computación e Informática', '1973-11-14'
	)
	
INSERT EMPADRONADO_EN 
	VALUES(
		'559876542', 'Bach01Comp', '2020-03-12', '2023-09-20'
	)

SELECT * FROM CARRERA
SELECT * FROM EMPADRONADO_EN

-- Activate Trigger
DELETE FROM CARRERA
WHERE Codigo LIKE 'Bach01Comp'

SELECT * FROM CARRERA
SELECT * FROM EMPADRONADO_EN
