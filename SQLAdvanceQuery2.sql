/*
# 1. Operaciones SQL
*/

USE DB_JP_SQL_BASICO;

SELECT * FROM SCHOOL;

-- __________________________

USE DB_JP_SQL_BASICO

SELECT
    *
FROM
    SCHOOL
WHERE NUM_OF_STUDENTS IS NULL

-- __________________

USE DB_JP_SQL_BASICO

SELECT
    *
FROM
    SCHOOL
WHERE NUM_OF_STUDENTS IS NOT NULL

-- ______________________

USE DB_JP_SQL_BASICO

SELECT
    NAME, ACRONYM
FROM
    SCHOOL
WHERE
    NUM_OF_STUDENTS IS NOT NULL
AND
    NAME LIKE 'C%a' -- LIKE is Regex but powerless

USE DB_JP_SQL_BASICO

SELECT
    NAME, ACRONYM, NUM_OF_STUDENTS
FROM
    SCHOOL
WHERE
    NUM_OF_STUDENTS IS NOT NULL
AND
    (
        NAME LIKE 'cien%'
    OR
        NAME LIKE '%admin%'
    )
ORDER BY
    NUM_OF_STUDENTS, NAME

/*
# 2. Nested query
*/

USE DB_JP_SQL_BASICO

SELECT * FROM COURSE

SELECT * FROM [GROUP]

INSERT INTO
    COURSE (ACRONYM, NAME, CREDITS)
VALUES
    ('CS101', 'Intro to Computer Science', 3),
    ('MA101', 'Calculus I', 4),
    ('PHY101', 'Physics I', 4),
    ('HT101', 'History of World Civilization', 3),
    ('ENG101', 'English Composition', 3)

INSERT INTO
    [GROUP] (NUMBER, SEMESTER, YEAR, ACRONYM)
VALUES
    (1, 1, 2023, 'CS101'),
    (3, 1, 2023, 'PHY101'),
    (4, 1, 2023, 'HT101'),
    (6, 2, 2023, 'CS101'),
    (8, 2, 2023, 'PHY101'),
    (9, 2, 2023, 'HT101'),
    (10, 2, 2023, 'ENG101'),
    (13, 1, 2024, 'PHY101'),
    (14, 1, 2024, 'HT101'),
    (15, 1, 2024, 'ENG101')

-- ______________________________

SELECT
    NAME, CREDITS
FROM
    COURSE
WHERE ACRONYM IN -- We search ACRONYM inside of the thins of the scope
    (
        SELECT
            ACRONYM
        FROM
            [GROUP]
        WHERE
            [YEAR] = 2023 AND SEMESTER = 1
    )

-- _______________________________

SELECT
    ACRONYM
FROM
    COURSE
WHERE NOT EXISTS
    (
        SELECT
           *
        FROM
            [GROUP]
        WHERE
            [GROUP].ACRONYM = [COURSE].ACRONYM
        AND
            [GROUP].SEMESTER = 2
        AND
            [GROUP].[YEAR] = 2023
    )

-- ____________________________
-- EXIST y NOT EXIST review if the SELECT clause match with the WHERE anid.
SELECT
    ACRONYM AS ACR, NAME as CourseName
FROM
    COURSE AS C
WHERE EXISTS /*NOT EXISTS*/
    (
        SELECT
           *
        FROM
            [GROUP] as G
        WHERE
            C.ACRONYM = G.ACRONYM
        AND
            G.SEMESTER = 2
        AND
            G.YEAR = 2023
    )

/*
# 3. Join
*/

/*ALL Combinatios
AxB = producto cruz de ambos conjuntos
*/
use DB_JP_SQL_BASICO;
SELECT * FROM [GROUP], COURSE

-- _______________________

USE DB_JP_SQL_BASICO
-- Intersection of same attr A&B
SELECT
    C.NAME, C.CREDITS, G.NUMBER, G.SEMESTER AS SEM, G.[YEAR]
FROM
    COURSE AS C
INNER JOIN -- INNER is not necessary
    [GROUP] AS G
ON -- Related PK with FK
    C.ACRONYM = G.ACRONYM
ORDER BY
    C.NAME, G.NUMBER, G.SEMESTER, G.[YEAR]

-- _______________________

USE DB_JP_SQL_BASICO
-- A - B
SELECT
    C.ACRONYM, C.NAME, C.CREDITS, G.NUMBER, G.SEMESTER, G.[YEAR]
FROM
    COURSE AS C -- A
LEFT JOIN
    [GROUP] AS G -- B
ON
    C.ACRONYM = G.ACRONYM
WHERE -- If we want the Intersection (A-B+A&B) Erase this where
	G.ACRONYM IS NULL
ORDER BY
    G.NUMBER, G.SEMESTER, G.[YEAR]

-- _______________________

USE DB_JP_SQL_BASICO
-- The base query is bad 'cause we define before GROUP dependent of COURSE
-- B - A
SELECT
    C.NAME, C.CREDITS, G.NUMBER, G.SEMESTER, G.[YEAR]
FROM
    COURSE AS C
RIGHT JOIN
    [GROUP] AS G
ON
    C.ACRONYM = G.ACRONYM
WHERE -- If we erase this is B - A & B&A
    C.ACRONYM IS NULL
ORDER BY
    G.NUMBER, G.SEMESTER, G.[YEAR]

-- ________________

USE DB_JP_SQL_BASICO

SELECT
    C.NAME, C.CREDITS, G.NUMBER, G.SEMESTER, G.[YEAR]
FROM
    COURSE AS C
FULL OUTER JOIN
    [GROUP] AS G
ON
    C.ACRONYM = G.ACRONYM
ORDER BY
    G.NUMBER, G.SEMESTER, G.[YEAR]

-- _______________________

USE DB_JP_SQL_BASICO

SELECT
    C.NAME, C.CREDITS, G.NUMBER, G.SEMESTER, G.[YEAR]
FROM
    COURSE AS C
FULL OUTER JOIN
    [GROUP] AS G
ON
    C.ACRONYM = G.ACRONYM
WHERE
    C.ACRONYM IS NULL OR G.ACRONYM IS NULL
ORDER BY
    G.NUMBER, G.SEMESTER, G.[YEAR]

/*
# 4. Grouping and aggregation
*/

SELECT
    ACRONYM, NUMBER, COUNT(*) AS ACR_COUNT
FROM
    [GROUP]
GROUP BY ACRONYM,NUMBER

-- __________________

SELECT
    ACRONYM,
    COUNT(*) AS ACR_COUNT,
    AVG (CREDITS) AS ACR_AVG,
    MAX(CREDITS) AS ACR_MAX,
    MIN(CREDITS) AS ACR_MIN
FROM
    COURSE
GROUP BY
    ACRONYM

-- ___________________ The class finish here.

-- Here init with Having clause, that filter on Grouped attr

SELECT
    ACRONYM,
    COUNT(*) COURSE_COUNT,
    AVG (CREDITS) AS AVG_CREDITS
FROM
    COURSE
GROUP BY
    ACRONYM
HAVING
    AVG (CREDITS) > 3;

-- ________________ Update a table Schema

ALTER TABLE
    INSTRUCTOR
ADD
    NAME VARCHAR(255) NULL

-- ________________  add Names and IDs cause are the PK

INSERT INTO
    INSTRUCTOR (NAME)
VALUES
    ('Joe Doe'),
    ('Mary Doe'),
    ('Elle Doe')

-- Try to insert that object into IMPARTS table.
INSERT INTO
    IMPARTS
VALUES
    (1,10,2,2023,'ENG101')

-- How much courses Impart each Instructor.
SELECT
    I.NAME AS I_NAME,
	COUNT(*) AS COUNT_G
FROM
    INSTRUCTOR AS I
-- LEFT JOIN
INNER JOIN
    IMPARTS AS IM
ON
    I.ID = IM.ID
GROUP BY
    I.NAME

/*
## **5\. Triggers**
DML Triggers are fired as a response to dml statements (**insert, update or delete**).
A dml trigger can be created to address one or more dml events for a single table or view.
This means that a single dml trigger can handle inserting, updating and deleting records
from a specific table or view, but it can only handle data being changed on that single table or view.
*/
USE DB_JP_SQL_BASICO
SELECT * FROM SCHOOL;
SELECT * FROM COURSE;
SELECT * FROM [GROUP];
SELECT * FROM TAKES

-- Alter table course to add new attr
ALTER TABLE
    COURSE
ADD
    AREA_ACRONYM CHAR(6) NULL
    CONSTRAINT FK_SCHOOL FOREIGN KEY (AREA_ACRONYM) REFERENCES SCHOOL(ACRONYM)

-- Set values to new relation with SCHOOL
UPDATE [COURSE] SET AREA_ACRONYM = 'EMat' WHERE ACRONYM = 'MA101';
UPDATE [COURSE] SET AREA_ACRONYM = 'EAT' WHERE ACRONYM = 'HT101';
UPDATE [COURSE] SET AREA_ACRONYM = 'ECCI' WHERE ACRONYM = 'CS101';
UPDATE [COURSE] SET AREA_ACRONYM = 'ELM' WHERE ACRONYM = 'ENG101';
UPDATE [COURSE] SET AREA_ACRONYM = 'ECCI' WHERE ACRONYM = 'PHY101';

/*
-- If we update on TAKES updates students number in SCHOOL
*/
CREATE TRIGGER
    UPDATE_STUDENTS_NUMBER
ON
    TAKES  -- Here we define the table that will be trigger
AFTER INSERT AS -- Here we define the event that will trigger the trigger(INSERT)

BEGIN -- Open a new code block (optional)
    UPDATE
        SCHOOL
    SET
        NUM_OF_STUDENTS = NUM_OF_STUDENTS +
        T.GCOUNT FROM
        (
            SELECT
                 C.AREA_ACRONYM, COUNT(AREA_ACRONYM) as GCOUNT
            FROM
                inserted AS NEW_TAKES -- "inserted" is the temp table that have the new values do update
            JOIN
                [GROUP] AS G
            ON
                NEW_TAKES.ACRONYM = G.ACRONYM AND
                NEW_TAKES.NUMBER = G.NUMBER AND
                NEW_TAKES.SEMESTER = G.SEMESTER AND
                NEW_TAKES.[YEAR] = G.[YEAR]
            JOIN
                COURSE AS C
            ON
                C.ACRONYM = G.ACRONYM
            GROUP BY C.AREA_ACRONYM
        ) AS T -- New local variable as table a.k.a query result
    WHERE
        SCHOOL.ACRONYM = T.AREA_ACRONYM
END -- Close the code block


--______________________________________________


/*
At this point if STUDENT is empty, when we add a new student, the trigger will
wont work, cause the table is empty. So we need to add a new student to test the trigger.
If we add a new student, the trigger in student not work, cause the trigger is in TAKES.
*/
SELECT * FROM STUDENT

INSERT INTO
    STUDENT
VALUES
    ('jose@email.com','Jose','Ramirez','B65728',NULL),
    ('petter@email.com','Petter','Ramirez','B65729',NULL)
	('jose@email.com','Jose','Ramirez','B65728',NULL),
    ('petter@email.com','Petter','Ramirez','B65729',NULL)

SELECT * FROM TAKES

/*
Esto cambia el número de estudiantes en el curso CS101,
o sea va a activar al trigger de arriba aumentando el constador
de los estudiantes de SCHOOL de la escuela de compu.
*/
INSERT INTO
    TAKES
VALUES
    ('jose@email.com',1,1,2023,'CS101'),
    ('petter@email.com',6,2,2023,'CS101')

/*
En este caso, el trigger va a hacer dos cosas:
1. Aumentar el contador de estudiantes en la escuela de compu
2. Disminuir el contador de estudiantes en la escuela de compu
Porque tiene propiedades ON INSERT, DELETE
PERO estamos redundando el código, podemos hacerlo con otra técnica más
eficiente.
*/
ALTER TRIGGER UPDATE_STUDENTS_NUMBER -- ALTER moadifica el trigger
ON
    TAKES
AFTER INSERT, DELETE
AS
BEGIN

    /*Insert*/

    UPDATE
        SCHOOL
    SET
        NUM_OF_STUDENTS = NUM_OF_STUDENTS +
        T.GCOUNT FROM
        (
            SELECT
                 C.AREA_ACRONYM, COUNT(AREA_ACRONYM) as GCOUNT
            FROM
                inserted AS NEW_TAKES /*inserted, deleted, updated*/
            JOIN
                [GROUP] AS G
            ON
                NEW_TAKES.ACRONYM = G.ACRONYM AND
                NEW_TAKES.NUMBER = G.NUMBER AND
                NEW_TAKES.SEMESTER = G.SEMESTER AND
                NEW_TAKES.[YEAR] = G.[YEAR]
            JOIN
                COURSE AS C
            ON
                C.ACRONYM = G.ACRONYM
            GROUP BY C.AREA_ACRONYM
        ) AS T
    WHERE
        SCHOOL.ACRONYM = T.AREA_ACRONYM

     /*Delete*/

    UPDATE
        SCHOOL
    SET
        NUM_OF_STUDENTS = NUM_OF_STUDENTS -
        T.GCOUNT FROM
        (
            SELECT
                 C.AREA_ACRONYM, COUNT(AREA_ACRONYM) as GCOUNT
            FROM
                deleted AS DELETED_TAKES /*inserted, deleted, updated*/
            JOIN
                [GROUP] AS G
            ON
                DELETED_TAKES.ACRONYM = G.ACRONYM AND
                DELETED_TAKES.NUMBER = G.NUMBER AND
                DELETED_TAKES.SEMESTER = G.SEMESTER AND
                DELETED_TAKES.[YEAR] = G.[YEAR]
            JOIN
                COURSE AS C
            ON
                C.ACRONYM = G.ACRONYM
            GROUP BY C.AREA_ACRONYM
        ) AS T
    WHERE
        SCHOOL.ACRONYM = T.AREA_ACRONYM

END

-----------------------
-- Se borra takes para probar el nuevo trigger
SELECT * FROM TAKES
SELECT * FROM SCHOOL
DELETE FROM TAKES -- Aquí se le borran los dos estudiantes de TAKES
-- O sea, quita dos estudiantes de la ECCI en SCHOOL

-----------------------

/*
# 6. Views
*/
USE DB_JP_SQL_BASICO

CREATE VIEW FULL_STUDENT_BOARD AS
SELECT
        ST.FIRST_NAME,
		ST.LAST_NAME,
		T.EMAIL,
		T.NUMBER,
		T.SEMESTER,
		T.[YEAR],
		G.ACRONYM,
		C.NAME,
		C.AREA_ACRONYM
FROM
    TAKES AS T
JOIN
    [GROUP] AS G
ON
    T.ACRONYM = G.ACRONYM AND
    T.NUMBER = G.NUMBER AND
    T.SEMESTER = G.SEMESTER AND
    T.[YEAR] = G.[YEAR]
JOIN
    COURSE AS C
ON
    C.ACRONYM = G.ACRONYM
JOIN
    STUDENT AS ST
ON
    ST.EMAIL = T.EMAIL


/* --------------
Aquí nosotros llamamos al método que creó la view
---------------*/
SELECT * FROM FULL_STUDENT_BOARD




/* ---------------------------------------------------------------------------------
## **7\. Stored procedures**
In SQL Server, a procedure is a stored program that you can pass parameters into.
It does not return a value like a function does.
However, it can return a success/failure status to the procedure that called it.
*/

-- Declara la función que nos devuelve el Acronimo de un curso.
CREATE PROCEDURE GetCourseName (
    @ACRONYM CHAR(6) -- Input parameter
)
AS BEGIN
SELECT NAME
FROM COURSE
WHERE ACRONYM = @ACRONYM
END

-- Ejecuta la función declarada
EXECUTE GetCourseName @ACRONYM = 'CS101';



/*
Store procedure with no return, but output parameters
*/
CREATE PROCEDURE GetEmptySchoolsCount (
    @PEmptySchoolsCount INT OUTPUT
)
AS
BEGIN
    SELECT
        @PEmptySchoolsCount = COUNT(*)
    FROM
        SCHOOL
    WHERE NUM_OF_STUDENTS = 0
END


/*
We can create/change variables in SQL
*/
DECLARE @EmptySchoolsCount INT;

EXEC GetEmptySchoolsCount @PEmptySchoolsCount = @EmptySchoolsCount OUTPUT;

PRINT 'Schools with zero students: ' + CONVERT(VARCHAR(10),@EmptySchoolsCount)

SET @EmptySchoolsCount = @EmptySchoolsCount * 2

PRINT 'Schools with zero students X 2: ' + CONVERT(VARCHAR(10),@EmptySchoolsCount)

/*
## 8. User defined functions
1. User-defined functions can't be used to perform actions that
modify the database state.
2. User-defined functions can't contain an OUTPUT INTO clause
that has a table as its target.
3. User-defined functions can't return multiple result sets.
Use a stored procedure if you need to return multiple result sets.
*/

CREATE FUNCTION GetTotalUniversityStudents(
    @SchoolPattern VARCHAR(10) -- Variable to search
)
RETURNS INT /*Return type must be specified. This is an scalar function*/
AS
BEGIN
    -- Return variable
    DECLARE @OutStudentsCount INT

    IF @SchoolPattern IS NOT NULL -- Si no es nulo suma todos los estudiantes de las escuelas que cumplan con el patrón
    BEGIN -- Scope del if
        SELECT
            @OutStudentsCount = SUM(NUM_OF_STUDENTS)
        FROM
            SCHOOL
        WHERE
            NAME LIKE @SchoolPattern
    END
    ELSE -- Si es nulo suma todos los estudiantes de todas las escuelas
    BEGIN
        SELECT
            @OutStudentsCount = SUM(NUM_OF_STUDENTS)
        FROM
            SCHOOL
    END

    -- Esto es redundante, pero es un ejemplo de cómo se puede hacer
    IF @OutStudentsCount IS NULL -- Si no hay estudiantes, devuelve 0
        BEGIN
            SET @OutStudentsCount = 0
        END

    RETURN @OutStudentsCount
END

/*
Tengo que llama a ejecutar la función de manera que todo haga match.
*/
DECLARE @SchoolPattern VARCHAR(100)

DECLARE @Result int

SET @SchoolPattern = '%a%'

EXEC @Result = GetTotalUniversityStudents @SchoolPattern = @SchoolPattern

PRINT @Result

------------------------------------------------------------

/*
Función para obtener los estudiantes de una escuela
CREATE OR ALTER nos permite modificar la función sin tener que borrarla y volverla a crear
Este devuelve una tabla.
*/
USE DB_JP_SQL_BASICO
CREATE OR ALTER FUNCTION GetSchoolStudents( /*https://support.microsoft.com/en-gb/topic/kb3190548-update-introduces-create-or-alter-transact-sql-statement-in-sql-server-2016-fd0596f3-9098-329c-a7a5-2e18f29ad1d4*/
    @SchoolPattern VARCHAR(10)
)
RETURNS TABLE
AS
    RETURN (
        SELECT
            S.NAME,
            S.ACRONYM AS SCHOOL_ACR,
            C.ACRONYM AS COURSE_ACR,
            G.NUMBER,
            G.SEMESTER,
            G.[YEAR],
            T.EMAIL
        FROM
            SCHOOL AS S
        INNER JOIN
            COURSE AS C
        ON
            S.ACRONYM = C.AREA_ACRONYM
        INNER JOIN
            [GROUP] AS G
        ON
            G.ACRONYM = C.ACRONYM
        INNER JOIN
            TAKES AS T
        ON
            T.ACRONYM = G.ACRONYM AND
            T.NUMBER = G.NUMBER AND
            T.SEMESTER = G.SEMESTER AND
            T.[YEAR] = G.[YEAR]
        WHERE
            S.NAME LIKE @SchoolPattern
)

/*
Create an variable of table type to receive a table of the function.
*/

DECLARE @TMP_TABLE TABLE (
    NAME VARCHAR(255),
    SCHOOL_ACR CHAR(6),
    COURSE_ACR CHAR(6),
    NUMBER SMALLINT,
    SEMESTER SMALLINT,
    YEAR SMALLINT,
    EMAIL VARCHAR(255)
)


-- Populate a table variable. Will make more sense once we are in the relational algebra section. Take it easy :)
INSERT INTO
    @TMP_TABLE
SELECT * FROM GetSchoolStudents('%A%')

-- Print the table variable
SELECT * FROM @TMP_TABLE;

------------------------------------------------ Run all previous to get it work

/*
# 9\. Cursor

https://learn.microsoft.com/en-us/sql/relational-databases/cursors?view=sql-server-ver16#type-of-cursors

Cursors are used to retrieve data **row-by-row**
from a result set and perform operations on each row.
Generally speaking, set-based operations (which operate on all
the rows in the result set at once) are faster and more efficient in SQL Server,
so it's usually better to **avoid** using cursors whenever possible

## Use Cases

1\. Perform complex **computations or transformations** on each row of a result
set that cannot easily be expressed in a single SQL statement

2\. Process or handle one row at a time.
This could be necessary for calling a **stored procedure** for each row

3\. Process rows in a specific order, and each row's processing
may depend on the previous rows

## Considerations

1. Cursors can have a significant performance impact because they process rows individually, **leading to more reads**, more **locking**, and more **memory usage**
*/

USE DB_JP_SQL_BASICO

DECLARE @S_NAME VARCHAR(255), @NUM_OF_STUDENTS INT

-- LOCAL: Solo visible para este batch de instrucciones y no para los eventos desencadenadores
-- FAST_FORWARD: Solo se desplaza hacia adelante, de primera fila a ultima
/*
Declaramos un cursor que primero va a ser busqueda LOCAL y despu�s FAST_FORWARD.
FOR definidos en que queremos iterar
Con OPEN ponemos a funcionar el CURSOR
*/
DECLARE ROW_CURSOR CURSOR LOCAL FAST_FORWARD FOR  -- Hay varios tipos de cursores dependiento del Data Source
    (SELECT NAME, NUM_OF_STUDENTS FROM SCHOOL)

-- Siempre se debe abrir el cursor primero
OPEN ROW_CURSOR


FETCH NEXT FROM ROW_CURSOR INTO @S_NAME, @NUM_OF_STUDENTS
-- Varibale global siempre, cuando no hay mas filas cambia a 1
WHILE @@FETCH_STATUS = 0 -- @@ variables din�micas del sistema
BEGIN
    PRINT CONCAT('The school name is: ',@S_NAME,'. It has ', @NUM_OF_STUDENTS, ' students')
    -- mover cursor a la siguiente fila
    FETCH NEXT FROM ROW_CURSOR INTO @S_NAME, @NUM_OF_STUDENTS
END

--- Siempre cerrar el cursor y liberar la memoria usada
CLOSE ROW_CURSOR
DEALLOCATE ROW_CURSOR -- Desreferencia el cursos en disco para cerrar su coneixi�n a disco.


/*
	New CURSOR to validate if there are students en each SCHOOL
	Same script as above but with conditionals.
*/

USE DB_JP_SQL_BASICO

DECLARE @S_NAME VARCHAR(255), @NUM_OF_STUDENTS INT

DECLARE ROW_CURSOR CURSOR LOCAL FAST_FORWARD FOR
    (SELECT NAME, NUM_OF_STUDENTS FROM SCHOOL)

OPEN ROW_CURSOR


FETCH NEXT FROM ROW_CURSOR INTO @S_NAME, @NUM_OF_STUDENTS

WHILE @@FETCH_STATUS = 0
BEGIN
    IF @NUM_OF_STUDENTS IS NOT NULL BEGIN
        PRINT CONCAT('The school name is: ',@S_NAME,'. It has ', @NUM_OF_STUDENTS, ' students')
    END
    ELSE BEGIN
        PRINT CONCAT('The school name is: ',@S_NAME,'. It has unknown number of students')
    END
    FETCH NEXT FROM ROW_CURSOR INTO @S_NAME, @NUM_OF_STUDENTS
END

CLOSE ROW_CURSOR
DEALLOCATE ROW_CURSOR
