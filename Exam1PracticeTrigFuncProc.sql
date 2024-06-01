

USE EXAM_1_PRACTICE
GO
-- 4. ------------------------------------------
/*
4. Implemente un procedimiento almacenado o funci�n llamado
ObtenerlndicadoresRendimiento que devuelve el promedio, m�ximo y minimo de
carreras en juegos locales de un equipo. El identificador del equipo debe especificarse
por argumentos.
*/

CREATE OR ALTER PROCEDURE ObtenerIndicadoresRendimiento( -- solo para juegos locales del team
	@PatronNombreEquipo VARCHAR(30),
	@OutPromCarreras FLOAT OUTPUT,
	@OutMaxCarreras FLOAT OUTPUT,
	@OutMinCarreras FLOAT OUTPUT
)
AS
BEGIN
	/*
	Group the team requested, in that group filter by games as local.
	When do that extract the output values
	*/
	SELECT
		@OutPromCarreras = AVG((CONVERT(FLOAT,JP.Carreras))),
		@OutMaxCarreras = MAX(JP.Carreras),
		@OutMinCarreras = MIN(JP.Carreras)
	FROM
		JUEGA_PARTIDO AS JP
	WHERE
		 JP.NombreEquipo LIKE @PatronNombreEquipo
		AND JP.[Local] = 1
	GROUP BY
		JP.NombreEquipo
END

GO

USE EXAM_1_PRACTICE

SELECT * FROM JUEGA_PARTIDO
WHERE
	[Local] = 1
	AND  NombreEquipo LIKE 'Y%'

DECLARE @PromCarreras FLOAT;
DECLARE @MaxCarreras FLOAT;
DECLARE @MinCarreras FLOAT;

-- Call the stored procedure
EXEC ObtenerIndicadoresRendimiento
    @PatronNombreEquipo = 'Yan%',
    @OutPromCarreras = @PromCarreras OUTPUT,
    @OutMaxCarreras = @MaxCarreras OUTPUT,
    @OutMinCarreras = @MinCarreras OUTPUT;

-- Output the values
SELECT
    @PromCarreras AS PromCarreras,
    @MaxCarreras AS MaxCarreras,
    @MinCarreras AS MinCarreras;

GO

-- 5. ------------------------------------------
/*
Implemente un procedimiento o funci�n llamado ObtenerPromedioDoubleHits que
devuelva el promedio de hits dobles de un jugador en el historial de juegos. El
identificador del jugador debe especificarse por argumentos.
*/

CREATE OR ALTER FUNCTION ObtenerPromedioDoubleHits(
	@IdJugador uniqueidentifier
)
RETURNS FLOAT
AS
BEGIN
	DECLARE @OutPutDoubleHitMean FLOAT
	SELECT
		@OutPutDoubleHitMean = AVG((CONVERT(FLOAT,TH.HitsDobles)))
	FROM
		TIENE_HIT AS TH
	WHERE
		TH.IdJugador = @IdJugador
	GROUP BY
		TH.IdJugador

	RETURN @OutPutDoubleHitMean
END


GO

SELECT dbo.ObtenerPromedioDoubleHits((SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Babe'))
	AS promedioDoubleHitsJugador


SELECT * FROM TIENE_HIT WHERE IdJugador = '806BCE20-2D71-425C-9EBA-C91892F20343'


GO
-- 6. ------
/*
Implemente un trigger llamado ActualizarBA que refresca la m�trica de BA para un
jugador. Asuma que los tipos de hits tienen el mismo peso para calcular la m�trica.

Esto mete en el terreno las tablas de JUGADOR Y TIENE_HIT
Cuando se a�ade un Jugador a TIENE_HIT, ese jugador tiene que volver a calcular su promedio de bateo

ASUMO QUE CADA HIT VALE 1 PUNTO
*/

--SELECT * FROM TIENE_HIT

CREATE OR ALTER TRIGGER
	ActualizarBA
ON
	TIENE_HIT
AFTER INSERT AS
BEGIN
	UPDATE
		JUGADOR
	SET
		BA = T.SumOfHits / T.GamesPlayedByPlayer
		FROM
        (
            SELECT
                 NEW_TIENE_HIT.IdJugador,
				 COUNT(*) AS GamesPlayedByPlayer,
				 SUM(NEW_TIENE_HIT.HitsSencillos)
				 + SUM(NEW_TIENE_HIT.HitsDobles)
				 + SUM(NEW_TIENE_HIT.HitsTriples)
				 + SUM(NEW_TIENE_HIT.HitsHomeRun)  AS SumOfHits -- Here sum all points
            FROM
                inserted AS NEW_TIENE_HIT -- "inserted" is the temp table that have the new values do update
            GROUP BY
				NEW_TIENE_HIT.IdJugador
        ) AS T -- New local variable as table a.k.a query result
	WHERE
		JUGADOR.Id = T.IdJugador
END

GO

-- -----------Test the trigger--------------

-- Add new JUEGO

INSERT INTO JUEGO
VALUES(
	'6af9bd41-e8f3-4036-8312-b173deacacaa', '2021-10-10', 'Yankees',
	(SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Tom'),
	(SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Babe'),
	(SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Dwight')
)

SELECT * FROM JUGADOR
WHERE PrimerNombre = 'Tom'
-- Before Insert
-- 4E5F3D5C-8829-4142-B7AC-8686CD85DA63	Mets	Tom	Seaver	George	Thomas	1944-11-17	Fresno	D	0,311

-- Add new TIENE_HIT
INSERT INTO TIENE_HIT
VALUES(
	'6af9bd41-e8f3-4036-8312-b173deacacaa',
	(SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Tom'),
	1, 1, 1, 1
)

-- The trigger should update the BA of the player
SELECT * FROM JUGADOR
WHERE PrimerNombre = 'Tom'
-- 4E5F3D5C-8829-4142-B7AC-8686CD85DA63	Mets	Tom	Seaver	George	Thomas	1944-11-17	Fresno	D	4

SELECT SUM(HitsSencillos) AS Sencillos, SUM(HitsDobles) AS Dobles, SUM(HitsTriples) AS Triples, SUM(HitsHomeRun) AS HomeRun
FROM TIENE_HIT
WHERE IdJugador = (SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Tom')
GROUP BY IdJugador

SELECT *
FROM TIENE_HIT
WHERE IdJugador = (SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Tom')

