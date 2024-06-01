-- JORGE RICARDO DIAZ SAGOT C12565

/*
4. (5 puntus). Cree una consulta que obtenga todas las cuentas que tengan mås de 5 oro y que tenga
equipado un casco rojo de power ranger.

El Personaje Username 1 tiene 10 de oro y tiene equipado un casco rojo de power ranger.
*/

USE C12565_EXAMEN_1

SELECT * FROM PERSONAJE
SELECT * FROM INVENTARIAR_CASCO
SELECT * FROM CASCO

SELECT
    P.Nombre, P.Ataque, P.Defensa, P.UsernameCuenta
FROM
    PERSONAJE AS P
JOIN
    INVENTARIAR_CASCO AS IC
        ON P.Nombre = IC.NombrePersonaje
JOIN
    CASCO AS C
        ON IC.NECasco = C.Nombre
        AND IC.LECasco = C.Lugar
WHERE -- NESTED QUERY that returns if there is more the 4 Oro
    P.UsernameCuenta IN (
        SELECT
            UsernameCuenta
        FROM
            INVENTARIAR_MATERIAL
        WHERE
            NombreMaterial = 'Oro'
            AND Cantidad >= 5
    )
    AND C.Color = 'ROJO'
    AND IC.NECasco = 'Power Ranger'
	AND IC.Equipado = 1 -- If the item is equipped show the user

GO


/*
5. (6 puntos) Cree un procedimiento almacenado o funci6n llamado ActualizarStatsEquipamento
que actualiza cl total de defensa y ataque tiene una cuenta usuaria dado el equipamiento que
actualmente tiene equipado. El paråmetro de entrada es la identificacion de la cuenta de usuario.
El procedimiento almacenado solo devuelve si se realiz6 con éxito o no la actualizaciön. Por
ejemplo, si la cuenta "Alice" tiene equipado un casco de 3 defensa, una espada de 10 daño, y un
collar que da 2 defensa y 1 de daño alice tendra en total 11 daño y 5 defensa.

Personaje 1 tiene dos cosas equipadas que suman 5 ataque y 17 defensa.
*/

CREATE OR ALTER PROCEDURE ActualizarStatsEquipamento
(
    @NombrePersonaje VARCHAR(50),
    @Feedback BIT OUTPUT
)
AS
BEGIN
    /*
        1. Tengo que agarrar todos los INVENTARIOS de los EQUIPOS y buscar
        sus stats de ATAQUE y DEFENSA. Según el Personaje dado.
        2. Esos stats se suman en las variables @Ataque y @Defensa que voy a definir.
        3. Revisar que las piezas estén equipadas.
        4. Si estan equipadas si se suma al total de ataque y defensa.
        5. Retornar 1 si se realizó con éxito o 0 si no se realizó.
            * Se realizó con éxito si se sumó correctamente los stats.
            * No se realizó si no se encontró el personaje.
            * No se realizó si no se hicieron cambios.
    */

    SET @Feedback = 1
    -- Buscar si el personaje existe
    IF NOT EXISTS(
        SELECT
            1
        FROM
            PERSONAJE
        WHERE
            Nombre LIKE @NombrePersonaje
    )
    BEGIN
        SET @Feedback = 0
    END

    -- Variables para guardar los stats de ataque y defensa
    DECLARE @Ataque FLOAT = 0
    DECLARE @Defensa FLOAT = 0

	SELECT
		@Ataque AS AtaqueFinal, @Defensa AS DefensaFinal

    -- Buscar y asignar los stats de ataque y defensa de cada pieza de equipo
    -- COLLAR
    SELECT
        @Ataque = COALESCE(COL.CantidadAtaque, 0),
        @Defensa = COALESCE(COL.CantidadDefensa, 0)
    FROM
        INVENTARIAR_COLLAR AS INVCOL
    JOIN
        COLLAR AS COL
            ON INVCOL.NECollar = COL.Nombre
            AND INVCOL.LECollar = COL.Lugar
    WHERE
        INVCOL.NombrePersonaje LIKE @NombrePersonaje
        AND INVCOL.Equipado = 1

	SELECT
	@Ataque AS AtaqueFinal, @Defensa AS DefensaFinal

    -- CASCO
    SELECT
        @Ataque = @Ataque + COALESCE(CAS.CantidadAtaque, 0),
        @Defensa = @Defensa + COALESCE(CAS.CantidadDefensa, 0)
    FROM
        INVENTARIAR_CASCO AS INVCAS
    JOIN
        CASCO AS CAS
            ON INVCAS.NECasco = CAS.Nombre
            AND INVCAS.LECasco = CAS.Lugar
    WHERE
        INVCAS.NombrePersonaje LIKE @NombrePersonaje
        AND INVCAS.Equipado = 1

    -- CARA
    SELECT
        @Ataque = @Ataque + COALESCE(CAR.CantidadAtaque, 0),
        @Defensa = @Defensa + COALESCE(CAR.CantidadDefensa, 0)
    FROM
        INVENTARIAR_CARA AS INVCAR
    JOIN
        CARA AS CAR
            ON INVCAR.NECara = CAR.Nombre
            AND INVCAR.LECara = CAR.Lugar
    WHERE
        INVCAR.NombrePersonaje LIKE @NombrePersonaje
        AND INVCAR.Equipado = 1

    -- TORSO
    SELECT
        @Ataque = @Ataque + COALESCE(TOR.CantidadAtaque, 0),
        @Defensa = @Defensa + COALESCE(TOR.CantidadDefensa, 0)
    FROM
        INVENTARIAR_TORSO AS INVTOR
    JOIN
        TORSO AS TOR
            ON INVTOR.NETorso = TOR.Nombre
            AND INVTOR.LETorso = TOR.Lugar
    WHERE
        INVTOR.NombrePersonaje LIKE @NombrePersonaje
        AND INVTOR.Equipado = 1

    -- MANOS
    SELECT
        @Ataque = @Ataque + COALESCE(MAN.CantidadAtaque, 0),
        @Defensa = @Defensa + COALESCE(MAN.CantidadDefensa, 0)
    FROM
        INVENTARIAR_MANOS AS INVMAN
    JOIN
        MANOS AS MAN
            ON INVMAN.NEManos = MAN.Nombre
            AND INVMAN.LEManos = MAN.Lugar
    WHERE
        INVMAN.NombrePersonaje LIKE @NombrePersonaje
        AND INVMAN.Equipado = 1

    -- PANTALONES
    SELECT
        @Ataque = @Ataque + COALESCE(PAN.CantidadAtaque, 0),
        @Defensa = @Defensa + COALESCE(PAN.CantidadDefensa, 0)
    FROM
        INVENTARIAR_PANTALONES AS INVPAN
    JOIN
        PANTALONES AS PAN
            ON INVPAN.NEPantalones = PAN.Nombre
            AND INVPAN.LEPantalones = PAN.Lugar
    WHERE
        INVPAN.NombrePersonaje LIKE @NombrePersonaje
        AND INVPAN.Equipado = 1

    -- ZAPATOS
    SELECT
        @Ataque = @Ataque + COALESCE(ZAP.CantidadAtaque, 0),
        @Defensa = @Defensa + COALESCE(ZAP.CantidadDefensa, 0)
    FROM
        INVENTARIAR_ZAPATOS AS INVZAP
    JOIN
        ZAPATOS AS ZAP
            ON INVZAP.NEZapatos = ZAP.Nombre
            AND INVZAP.LEZapatos = ZAP.Lugar
    WHERE
        INVZAP.NombrePersonaje LIKE @NombrePersonaje
        AND INVZAP.Equipado = 1

    -- ARMA
    SELECT
        @Ataque = @Ataque + COALESCE(ARM.CantidadAtaque, 0),
        @Defensa = @Defensa + COALESCE(ARM.CantidadDefensa, 0)
    FROM
        INVENTARIAR_ARMA AS INVAR
    JOIN
        ARMA AS ARM
            ON INVAR.NEArma = ARM.Nombre
            AND INVAR.LEArma = ARM.Lugar
    WHERE
        INVAR.NombrePersonaje LIKE @NombrePersonaje
        AND INVAR.Equipado = 1


    -- Si la suma actual es la misma que la que ya tiene el personaje
    -- No se hace nada y se retorna 0
    IF @Ataque = (SELECT Ataque FROM PERSONAJE WHERE Nombre = @NombrePersonaje)
        AND @Defensa = (SELECT Defensa FROM PERSONAJE WHERE Nombre = @NombrePersonaje)
    BEGIN
        SET @Feedback = 0
    END

    -- Si la suma actual es diferente a la que ya tiene el personaje
    -- Se actualiza y se retorna 1
	SELECT
		@Ataque AS AtaqueFinal, @Defensa AS DefensaFinal
	
    UPDATE
        PERSONAJE
    SET
        Ataque = @Ataque,
        Defensa = @Defensa
    WHERE
        Nombre = @NombrePersonaje

END

GO
-- TEST the store procedure

SELECT * FROM PERSONAJE

DECLARE @Feedback BIT;

EXEC ActualizarStatsEquipamento @NombrePersonaje = 'Personaje 1', @Feedback = @Feedback OUTPUT;

SELECT @Feedback AS Feedback;

SELECT * FROM PERSONAJE


GO


/*
6. (6 un triggcr llamado ValidarEquiparEçuipo que verifica c impida que una persona
usuaria en una cuenta equipe una pieza que no sc haya registrado como ganada para la misma en
cl juego. Por ejemplo, si Ia cuenta "Alice" tiene equipado un guante de 21 defensa, este tuvo que
ser ganado por la cuenta primero. Si considera que su modelo conceptual y lógico ya responden a
requerimiento, no cree el trigger, pero explique cuáles restriccion€s de integridad referencial
lo controlan.

*/

/*
R/ En el modelo relacional y conceptual se proveyó un sistema que no permite tener EQUIPO
que nos este en el inventario del personaje. 
Pero esto llevo a crea un booleano de equipado o no en el mismo inventario. 
Además de crear una restricción para que de error si se intenta añadir
más de un VERDADERO a las tablas con esta cualidad.
Investigando descrubrí que se pueden hacer "índices filtrado", con los cuales
puedo responder desde SQL para que no se repitan TRUE por error.
*/