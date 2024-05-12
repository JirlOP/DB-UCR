/*
Laboratorio 3
Jorge Ricardo Díaz Sagot - C12565
*/


USE DB_University
GO
/*
SELECT * FROM tabla1 t1 JOIN tabla2 t2 ON t1.a = t2.b JOIN tabla3 t3 ON t3.c = t2.c
Three table join example
*/

/*
4. Recupere el nombre y primer apellido de los asistentes(Asistente y Estudiante),
y el nombre de los cursos(Grupo) que han asistido.
Si un asistente ha asistido varias veces un mismo curso, el curso s�lo debe
aparecer una vez en el resultado.
*/
SELECT DISTINCT
	Est.NombreP,
	Est.Apellido1,
	Gru.SiglaCurso
FROM
	Estudiante AS Est
JOIN
	Asistente AS Asi
	ON Est.Cedula = Asi.Cedula
JOIN
	Grupo AS Gru
	ON Asi.Cedula = Gru.CedAsist

/*
5. Para el estudiante llamado �Gabriel S�nchez�(Estudiante), liste el expediente acad�mico (incluyendo
sigla del curso, n�mero de grupo, semestre, a�o(Grupo) y nota(Lleva)) de los cursos que ha
matriculado, y el nivel del plan de estudios en el que est� cada uno de los cursos
aprobados. El listado debe ordenarse por nivel del plan de estudios, y luego por sigla.
*/
--SELECT *
--FROM LLEVA
--WHERE CedEstudiante LIKE '22123456'


SELECT
	Lle.CedEstudiante,
	Lle.SiglaCurso AS Sigla_Curso,
	Lle.NumGrupo AS Expediente_NumGrupo,
	Lle.Semestre AS Expediente_Semestre,
	Lle.Anno AS Expendiente_Anno,
	Lle.Nota AS Expediente_Nota,
	Per.NivelPlanEstudios
FROM
	Lleva AS Lle
JOIN
	Grupo AS Gru
	ON Lle.SiglaCurso = Gru.SiglaCurso
	AND Lle.Anno = Gru.Anno
	AND Lle.Semestre = Gru.Semestre
	AND Lle.NumGrupo = Gru.NumGrupo
JOIN
	Pertenece_a AS Per
	ON Gru.SiglaCurso = Per.SiglaCurso
WHERE Lle.CedEstudiante IN -- Una query anidada de estudiante porque solo se necesita para buscar Nombre
	(
		SELECT
			Cedula
		FROM
			Estudiante
		WHERE
			NombreP LIKE 'Gabriel'
			AND Apellido1 LIKE 'Sánchez'
	)
ORDER BY
	Per.NivelPlanEstudios,
	Sigla_Curso


/*
6.Escriba las siguientes consultas en SQL, tomando como referencia las Figuras 1 y 2 de
esta guía. Para estas consultas es necesario agrupar la información de la(s) tabla(s). En
MS SQL Server, para agrupar datos se usa la cláusula GROUP BY.

Algunas veces se requiere filtrar sobre los grupos creados, para lo cual se usa la
cláusula HAVING (funciona de forma similar al WHERE, pero en lugar de filtrar
tuplas/registros, el HAVING filtra grupos después de aplicar el GROUP BY). También es
usual combinar el agrupamiento de datos con funciones de agregación, tales como
MAX, COUNT, SUM, etc.
*/

/*
7. Recupere la cantidad(COUNT) de profesores(Profesor) por grado académico (título). Ordene el resultado
por cantidad de profesores(ORDER BY DESC), de mayor a menor.
*/
--SELECT * FROM Profesor

SELECT
	ISNULL(Titulo, 'Sin Titulo') AS Titulo, -- Para ajustar los nulos a valor de negocio.
	COUNT(*) AS Cantidad_Profesores
FROM
	Profesor
GROUP BY
	Titulo
ORDER BY
	Cantidad_Profesores DESC


/*
8. Calcule el promedio(AVG) de notas de cada estudiante. El reporte debe listar la cédula del
estudiante en la primera columna y su promedio en la segunda columna(Lleva), ordenado por
cédula(GROUP BY). La columna de promedio de notas nombrarse como PromedioNotas.
*/
-- SELECT * FROM Lleva
SELECT
	CedEstudiante,
	AVG(Nota) AS PromedioNotas
FROM
	Lleva
GROUP BY
	CedEstudiante

/*
9. Para cada proyecto de investigación(Investigacion), obtenga el total de carga asignada al proyecto (la
suma de la carga de cada uno de sus participantes)(Participa en). La columna del total debe
nombrarse como TotalCarga.
*/
--SELECT * FROM Participa_en
-- SELECT * FROM Investigacion

SELECT
	NumProy,
	SUM(Carga) AS TotalCarga
FROM
	Participa_en
GROUP BY
	NumProy

/*
10. Para aquellos cursos que pertenecen a más de 2 carreras(Pertenece_a), recupere la sigla del curso y
la cantidad de carreras que tienen ese curso en su plan de estudios. Muestre la columna
de la cantidad de carreras como CantidadCarreras.
*/

-- SELECT * FROM Pertenece_a

SELECT
	SiglaCurso,
	COUNT(SiglaCurso) AS CantidadCarreras -- Solo hizo falta contar la cantidad de cursos que se repiten
FROM
	Pertenece_a -- Tiene Carreras y cursos
GROUP BY
	SiglaCurso
HAVING
	COUNT(SiglaCurso) > 2 -- Solo los que tienen mas de 2 carreras


/*
11. Para todas las facultades(Facultades), recupere el nombre de la facultad y la cantidad de carreras
que posee(Carrera). Si hay facultades que no poseen escuelas o carreras, deben salir en el
listado con cero en la cantidad de carreras. Ordene descendentemente por cantidad de
carreras (de la facultad que tiene más carreras la que tiene menos). Finalmente, la
columna de la cantidad de carreras debe nombrarse como CantidadCarreras.
*/
--SELECT * FROM Facultad
--SELECT * FROM Carrera
--SELECT * FROM CURSO

SELECT
	Fac.Nombre,
	COUNT(Car.Nombre) AS CantidadCarreras
FROM
	Facultad AS Fac
JOIN
	Escuela AS Esc
	ON Fac.Codigo = Esc.CodFacultad
LEFT JOIN -- Para que salgan las facultades que no tienen carreras
	Carrera AS Car
	ON Esc.Codigo = Car.CodEscuela
GROUP BY
	Fac.Nombre
ORDER BY
	CantidadCarreras DESC


/*
12. Liste la cantidad de estudiantes matriculados en cada grupo de cursos de computación
(sigla inicia con el prefijo “CI”). Se debe mostrar el número de grupo, la sigla de curso,
el semestre y el año de cada grupo, además de la cantidad de estudiantes matriculados
en él (con el nombre de columna CantidadEstudiantes)(Tabla Lleva). Si hay grupos que no tienen
estudiantes matriculados, deben salir en el listado con cero en la cantidad de
estudiantes(Tabla Grupo). Ordene por año, luego por semestre, y finalmente por sigla y grupo.
*/

--SELECT * FROM Lleva
--SELECT * FROM Grupo

SELECT
	Gru.NumGrupo,
	Gru.SiglaCurso,
	Gru.Semestre,
	Gru.Anno,
	COUNT(Lle.CedEstudiante) AS CantidadEstudiantes
FROM
	Lleva AS Lle
RIGHT JOIN -- Para que salgan los grupos que no tienen estudiantes
	Grupo AS Gru
	ON Lle.SiglaCurso = Gru.SiglaCurso
	AND Lle.Anno = Gru.Anno
	AND Lle.Semestre = Gru.Semestre
	AND Lle.NumGrupo = Gru.NumGrupo
WHERE
	Gru.SiglaCurso LIKE 'CI%'
GROUP BY -- Se agrupan todos los identificadores únicos de un grupo
	Gru.NumGrupo,
	Gru.SiglaCurso,
	Gru.Semestre,
	Gru.Anno
ORDER BY
	Gru.Anno,
	Gru.Semestre,
	Gru.SiglaCurso,
	Gru.NumGrupo

/*
13. Liste los grupos (identificados por sigla de curso, número de grupo, semestre y año)
donde la nota mínima obtenida por los estudiantes fue mayor o igual a 70 (es decir,
todos los estudiantes aprobaron). Muestre también la nota mínima (MinimaNota),
máxima (MaximaNota), y promedio (Promedio) de cada grupo en el resultado. Ordene
el resultado descendentemente por el promedio de notas del grupo
*/
SELECT
	SiglaCurso,
	NumGrupo,
	Semestre,
	Anno,
	MIN(Nota) AS MinimaNota,
	MAX(Nota) AS MaximaNota,
	AVG(Nota) AS Promedio
FROM
	Lleva
GROUP BY
	SiglaCurso,
	NumGrupo,
	Semestre,
	Anno
HAVING
	MIN(Nota) >= 70
ORDER BY
	Promedio DESC


