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
