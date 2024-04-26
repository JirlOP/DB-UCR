/*
	Query of DB_University
*/

/*
a) Recupere el nombre, los apellidos, el n�mero de oficina y la fecha de 
nombramiento de todos los profesores.
*/

USE DB_University

SELECT 
	NombreP, 
	Apellido1, 
	Apellido2,
	Oficina AS NumOficina,
	FechaNomb
FROM Profesor

/*
b) Recupere la c�dula y el nombre completo de los estudiantes que han llevado 
el curso �ART2�. Recupere tambi�n la nota que obtuvieron en dicho curso
*/

USE DB_University

SELECT 
	E.Cedula,
	E.NombreP,
	E.Apellido1,
	E.Apellido2,
	L.Nota AS ART2_Nota
FROM 
	Estudiante AS E
JOIN
	Lleva AS L
		ON E.Cedula = L.CedEstudiante
WHERE
	L.SiglaCurso LIKE 'ART2'


/*
c) Recupere el n�mero de carn� y el nombre de los estudiantes que tienen notas 
entre 60 y 80 en cualquier curso, sin que salgan registros repetidos
*/
USE DB_University

SELECT DISTINCT -- Creo que esto es 
	E.Carne, E.NombreP
FROM 
	Estudiante AS E
JOIN
	Lleva AS L
		ON E.Cedula = L.CedEstudiante
WHERE 
	L.Nota BETWEEN 59 AND 81
--GROUP BY 
	--E.Carne, E.NombreP 


/*
d) Recupere la sigla de los cursos que tienen como requisito al curso �CI1312�.
*/
USE DB_University

SELECT 
	RD.SiglaCursoRequeridor
FROM 
	Requiere_De AS RD
WHERE 
	RD.SiglaCursoRequisito LIKE 'CI1312'

/*
e. Recupere la nota m�xima, la nota m�nima y el promedio de notas obtenidas 
en el curso �CI1221�. Esto debe hacerse en una misma consulta. Dele nombre 
a las columnas del resultado mediante alias.
*/
USE DB_University

SELECT 
	MAX(L.Nota) AS NotaMax,
	MIN(L.Nota) AS NotaMin,
	AVG(L.Nota) AS Promedio
FROM 
	Grupo as G
JOIN 
	Lleva AS L
		ON L.SiglaCurso = G.SiglaCurso
WHERE
	G.SiglaCurso LIKE 'CI1221'

/*
f) Recupere el nombre de las Escuelas y el nombre de todas sus Carreras, 
ordenadas por nombre de Escuela y luego por nombre de Carrera.
*/
USE DB_University

SELECT 
	E.Nombre AS NombreEscuela,
	C.Nombre AS NombreCarrera
FROM 
	Escuela AS E
LEFT JOIN
	Carrera AS C
		ON E.Codigo = C.CodEscuela
ORDER BY NombreEscuela, NombreCarrera

/*
g) Recupere la cantidad de profesores que trabajan en la Escuela de 
Computaci�n e Inform�tica. Suponga que no conoce el c�digo de esta 
escuela, solo su nombre.
*/
USE DB_University

SELECT 
	COUNT(*) AS CantProfesores
FROM 
	Escuela AS E
LEFT JOIN
	Trabaja_en AS TE
		ON E.Codigo = TE.CodEscuela
WHERE E.Nombre LIKE '%Compu%'
	

/*
h) Recupere la c�dula de los estudiantes que no est�n empadronados en 
ninguna carrera
*/
USE DB_University

SELECT 
	E.Cedula
FROM 
	Estudiante AS E
LEFT JOIN 
	Empadronado_en AS EN
		ON E.Cedula = EN.CedEstudiante 
WHERE EN.CedEstudiante IS NULL

/*
i) Recupere el nombre de los estudiantes cuyo primer apellido termina en �a�. 
�C�mo cambiar�a la consulta para incluir tambi�n a los estudiantes cuyo 
nombre inicia con M�? �C�mo cambiar�a la consulta para que solo recupere 
los estudiantes cuyo primer apellido inicia con �M� y termina con �a�?
*/
USE DB_University
-- Part 1
SELECT 
	E.NombreP
FROM 
	Estudiante AS E
WHERE 
	E.Apellido1 LIKE '%a'

-- Part 2
SELECT 
	E.NombreP
FROM 
	Estudiante AS E
WHERE 
	E.Apellido1 LIKE '%a'
	OR E.NombreP LIKE 'M%'

-- Part 3
SELECT 
	E.NombreP
FROM 
	Estudiante AS E
WHERE 
	E.Apellido1 LIKE '%a'
	AND E.Apellido1 LIKE 'M%'

/*
k) Recupere el nombre de los estudiantes cuyo nombre tiene exactamente 6 
caracteres.
*/
USE DB_University

SELECT 
	E.NombreP
FROM 
	Estudiante AS E
WHERE
	E.NombreP LIKE '______'

/*
i) Liste el nombre completo de los profesores y de los estudiantes de g�nero 
masculino (el resultado debe salir en una sola lista consolidada).
*/
USE DB_University

SELECT 
	NombreP, 
	Apellido1,
	Apellido2,
	Sexo
FROM 
	Estudiante
WHERE 
	Sexo LIKE 'm'
UNION
SELECT
	NombreP,
	Apellido1,
	Apellido2,
	Sexo
FROM 
	Profesor
WHERE 
	Sexo LIKE 'm'
