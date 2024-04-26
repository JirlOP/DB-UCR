/*
	Query of DB_University
*/

/*
a) Recupere el nombre, los apellidos, el número de oficina y la fecha de 
nombramiento de todos los profesores.
*/

USE DB_Univesity

SELECT 
	NombreP, 
	Apellido1, 
	Apellido2,
	Oficina AS NumOficina,
	FechaNomb
FROM Profesor

/*
b) Recupere la cédula y el nombre completo de los estudiantes que han llevado 
el curso ‘ART2’. Recupere también la nota que obtuvieron en dicho curso
*/

USE DB_Univesity

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
c) Recupere el número de carné y el nombre de los estudiantes que tienen notas 
entre 60 y 80 en cualquier curso, sin que salgan registros repetidos
*/
USE DB_Univesity

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
d) Recupere la sigla de los cursos que tienen como requisito al curso ‘CI1312’.
*/
