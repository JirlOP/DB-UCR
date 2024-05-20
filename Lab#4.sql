/*
Jorge Ricardo D�az Sagot - C12565
Christopher V�quez Aguilar - C08538
*/

USE C12565

/*
Ejercicio 3
*/

------------- a -------------
CREATE FUNCTION CreditosPorSemestre (
    @CedEstudiante CHAR(10),
    @Semestre TINYINT,
    @Anno INT
)
RETURNS INT -- retorna la cantidad de creditos por semestre del estudiante
AS
BEGIN  -- body of the function
    DECLARE @OutCreditos TINYINT
    

	RETURN @OutCreditos
END



------------- b -------------
CREATE PROCEDURE EmpadronarEstudiante (
	@CedEstudiante CHAR(10),
	@CodigoCarrera VARCHAR(20)
)
AS
BEGIN

END



------------- c -------------
CREATE PROCEDURE ActualizarCreditos (
	@NombreCursoPattern VARCHAR(40),
	@PorcentajeAumentar INT
)
AS
BEGIN

END
