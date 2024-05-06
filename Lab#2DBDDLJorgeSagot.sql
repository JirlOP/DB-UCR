/*
Jorge Ricardo Díaz Sagot - C12565
Cristopher Víquez - C
*/
-- Create the new lab #2 database with my ID
CREATE DATABASE C12565

USE C12565

-- Creating a new Scheme for University DB 
CREATE TABLE ESTUDIANTE (
	Cedula CHAR(10), -- La cedula nacional serian 9, pero si se agrega el 0 al principio cambia.
		CONSTRAINT PK_ESTUDIANTE PRIMARY KEY (Cedula),
	-- Se asume que la longitud maxima de Email es: nombre + "." + apellidos + terminacion (15+1+15+15+15)
	Email VARCHAR(61) NOT NULL, 
	NombreP VARCHAR(15) NOT NULL,
	Apellido1 VARCHAR(15) NOT NULL,
	Apellido2 VARCHAR(15),
	Sexo CHAR(1) NOT NULL,
	FechaNac DATE NOT NULL,
	Direccion VARCHAR(255),
	Telefono CHAR(6), -- Solo numeros telefonicos costarricenses.
	Carne VARCHAR(6) NOT NULL, -- Si es estudiante tiene Carne
	Estado CHAR(1) -- Supuse en era si estaba Activo = A, Congelado = C, Inactivo = I y asi. 
)

CREATE TABLE PROFESOR (
    Cedula CHAR(10), 
		CONSTRAINT PK_PROFESOR PRIMARY KEY (Cedula),
    Email VARCHAR(61) NOT NULL,
    NombreP VARCHAR(15) NOT NULL,
    Apellido1 VARCHAR(15) NOT NULL,
    Apellido2 VARCHAR(15),
    Sexo CHAR(1) NOT NULL,
    FechaNac DATE NOT NULL,
    Direccion VARCHAR(255),
    Telefono CHAR(6),
    Categoria VARCHAR(50), -- No tengo claro que es categoria 
    FechaNomb DATE,
    Titulo VARCHAR(50),
    Oficina VARCHAR(50)
);

CREATE TABLE ASISTENTE (
    Cedula CHAR(10),
		CONSTRAINT PK_ASISTENTE PRIMARY KEY (Cedula),
		CONSTRAINT FK_ASISTENTE FOREIGN KEY (Cedula) 
			REFERENCES ESTUDIANTE(Cedula),
    NumHoras TINYINT -- No mas de 
);

CREATE TABLE CURSO (
    Sigla CHAR(6), -- Los cursos de la UCR tienen 6 siglas, nos basamos en eso.
		CONSTRAINT PK_PRIMARY PRIMARY KEY (Sigla),
    Nombre VARCHAR(40) NOT NULL, -- Se asume que los cursos no tienen más de 40 caracteres de nombre
    Creditos TINYINT NOT NULL
);


CREATE TABLE GRUPO (
    SiglaCurso CHAR(6),
    NumGrupo TINYINT, -- Se esperan no más de 30 grupos
    Semestre TINYINT,
    Anno INT, 
    CONSTRAINT PK_GRUPO PRIMARY KEY (SiglaCurso, NumGrupo, Semestre, Anno),
    CedProf CHAR(10) NOT NULL,
    Carga INT NOT NULL,
    CedAsist CHAR(10),
    CONSTRAINT FK_GRUPO_CURS FOREIGN KEY (SiglaCurso) 
		REFERENCES CURSO(Sigla),
    CONSTRAINT FK_GRUPO_PROF FOREIGN KEY (CedProf) 
		REFERENCES PROFESOR(Cedula),
    CONSTRAINT FK_GRUPO_ASIS FOREIGN KEY (CedAsist)
		REFERENCES ASISTENTE(Cedula)
);


CREATE TABLE LLEVA (
    CedEstudiante CHAR(10),
    SiglaCurso CHAR(6),
    NumGrupo TINYINT,
    Semestre TINYINT,
    Anno INT,
    CONSTRAINT PK_LLEVA PRIMARY KEY (CedEstudiante, SiglaCurso, NumGrupo, Semestre, Anno),
    Nota FLOAT, -- de 0 a 100 con decimales
    CONSTRAINT PK_LLEVA_ESTU FOREIGN KEY (CedEstudiante) 
		REFERENCES ESTUDIANTE(Cedula),
    CONSTRAINT PK_LLEVA_GRUP FOREIGN KEY (SiglaCurso, NumGrupo, Semestre, Anno) 
		REFERENCES GRUPO(SiglaCurso, NumGrupo, Semestre, Anno)
);

CREATE TABLE CARRERA (
    Codigo VARCHAR(20) 
	CONSTRAINT PK_CARRERA PRIMARY KEY (Codigo),
    Nombre VARCHAR(50),
    AnnoCreacion DATE
);


CREATE TABLE EMPADRONADO_EN (
    CedEstudiante CHAR(10),
    CodCarrera VARCHAR(20),
    FechaIngreso DATE,
    FechaGraduacion DATE,
    CONSTRAINT PK_EMPADRONADO_EN PRIMARY KEY (CedEstudiante, CodCarrera),
    CONSTRAINT FK_EMPADRONADO_EN_ESTU FOREIGN KEY (CedEstudiante) 
		REFERENCES ESTUDIANTE(Cedula),
    CONSTRAINT FK_EMPADRONADO_EN_CARR FOREIGN KEY (CodCarrera) 
		REFERENCES CARRERA(Codigo)
);


CREATE TABLE PERTENECE_A (
    SiglaCurso CHAR(6),
    CodCarrera VARCHAR(20),
    CONSTRAINT PK_PERTENECE_A PRIMARY KEY (SiglaCurso, CodCarrera),
    CONSTRAINT FK_PERTENECE_A_CURS FOREIGN KEY (SiglaCurso) 
		REFERENCES CURSO(Sigla),
    CONSTRAINT FK_PERTENECE_A_CARR FOREIGN KEY (CodCarrera) 
		REFERENCES CARRERA(Codigo),
    NivelPlanEstudios TINYINT
);
