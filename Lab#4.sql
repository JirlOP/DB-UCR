/*
Jorge Ricardo Díaz Sagot - C12565
Christopher Víquez Aguilar - C08538
*/

USE C12565

/*
Ejercicio 3
*/

------------- a -------------
CREATE OR ALTER FUNCTION CreditosMatriculadosPorSemestre (
    @CedEstudiante CHAR(10),
    @Semestre TINYINT,
    @Anno INT
)
RETURNS INT -- retorna la cantidad de creditos por semestre del estudiante
AS
BEGIN  -- body of the function
    DECLARE @OutCreditos TINYINT

		-- Si el estudiante existe, retornar la cantidad de creditos
		IF EXISTS (SELECT * FROM LLEVA WHERE CedEstudiante LIKE @CedEstudiante)
			SELECT
				@OutCreditos = SUM(C.Creditos)
			FROM
				LLEVA AS L
			JOIN
				GRUPO AS G
				ON L.SiglaCurso = G.SiglaCurso
				AND L.NumGrupo = G.NumGrupo
				AND L.Semestre = G.Semestre
				AND L.Anno = G.Anno
			JOIN
				CURSO AS C
				ON G.SiglaCurso = C.Sigla
			WHERE
				L.CedEstudiante LIKE @CedEstudiante
				AND L.Semestre = @Semestre
				AND L.Anno = @Anno
		-- Si no retorna 0
		ELSE
			SELECT @OutCreditos = 0

	RETURN @OutCreditos
END

-- Ver cuales estudiantes llevan cursos
SELECT * FROM LLEVA

-- Invocar para ver si funciona
SELECT dbo.CreditosMatriculadosPorSemestre('991234567%', 2, 2024)
	AS creditos_semestrales
-- 4 cred

-- Si tiene la versión del DB(C12565) Lab#2 para los dos estudiantes solo llevan un curso
-- Si añadimos un curso a 991234567
INSERT INTO
	CURSO (Sigla,Nombre,Creditos)
VALUES
	('CI0125','Desempeno y Experimentacion',4)

INSERT INTO
	GRUPO (SiglaCurso,NumGrupo,Semestre,Anno,CedProf,Carga,CedAsist)
VALUES
	('CI0125',1,2,2024,'123456789',10,NULL)

INSERT INTO
	LLEVA (CedEstudiante,SiglaCurso,NumGrupo,Semestre,Anno,Nota)
VALUES
	('991234567','CI0125',1,2,2024,70)

-- Invocar para ver si funciona
SELECT dbo.CreditosMatriculadosPorSemestre('991234567%', 2, 2024)
	AS creditos_semestrales
-- 8 cred



------------- b -------------
SELECT * FROM EMPADRONADO_EN

-- Si un estudiante se mete a una nueva carrera
-- Se debe insertar una nueva tupla en esta tabla

CREATE OR ALTER PROCEDURE EmpadronarEstudiante (
	@CedEstudiante CHAR(10),
	@CodigoCarrera VARCHAR(20)
)
AS
BEGIN
	-- Si el estudiante no está empadronado en la carrera
	IF NOT EXISTS (SELECT * FROM EMPADRONADO_EN
		WHERE CedEstudiante LIKE @CedEstudiante
			AND CodCarrera LIKE @CodigoCarrera)
		INSERT INTO
			EMPADRONADO_EN (CedEstudiante,CodCarrera,FechaIngreso)
		VALUES -- pone la fecha actual
			(@CedEstudiante,@CodigoCarrera,GETDATE())
END

-- Ver carreras
SELECT * FROM CARRERA
SELECT * FROM EMPADRONADO_EN
SELECT * FROM ESTUDIANTE

-- Ver 559876542 va a ser empadornado en licenciatura de computacion
EXEC EmpadronarEstudiante @CodigoCarrera='Lic01Comp', @CedEstudiante='559876542 '-- en desorden

-- Aqui vemos que se agregó perfectamente.
SELECT * FROM EMPADRONADO_EN


------------- c -------------
CREATE PROCEDURE ActualizarCreditos (
	@NombreCursoPattern VARCHAR(40),
	@PorcentajeAumentar INT
)
AS
BEGIN

END
