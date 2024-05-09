/*
Jorge Ricardo Díaz Sagot - C12565
Christopher Víquez Aguilar - C08538
*/
-- Create the new lab #2 database with my ID
CREATE DATABASE C12565

GO

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
	Telefono CHAR(8), -- Solo numeros telefonicos costarricenses.
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
    Telefono CHAR(8),
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
    CedProf CHAR(10) NOT NULL, -- 3.b.i
    Carga INT NOT NULL DEFAULT 0, -- 3.c
    CedAsist CHAR(10),
    CONSTRAINT FK_GRUPO_CURS FOREIGN KEY (SiglaCurso) 
		REFERENCES CURSO(Sigla) 
		ON DELETE NO ACTION, -- 3.b.iii
    CONSTRAINT FK_GRUPO_PROF FOREIGN KEY (CedProf) 
		REFERENCES PROFESOR(Cedula) 
		ON UPDATE CASCADE, -- 3.b.iv
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
    Nota FLOAT, 
	CHECK(Nota >= 0 AND Nota <= 100), -- 3.d
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
		REFERENCES ESTUDIANTE(Cedula) 
		ON DELETE CASCADE, -- 3.b.ii
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


INSERT INTO
	ESTUDIANTE (Cedula,Email,NombreP,Apellido1,Apellido2,Sexo,FechaNac,Direccion,Telefono,Carne,Estado)
VALUES
	('559876542','cmg@ucr.ac.cr','Carlos','Mata','Guzmán','m','1996-03-03','San Jose','875193','B55987','A'),
	('991234567','moh@ucr.ac.cr','Marcela','Orozco','Hernández','f','1983-01-12','Guanacaste','215818','A01234','A')

INSERT INTO
	PROFESOR (Cedula,Email,NombreP,Apellido1,Apellido2,Sexo,FechaNac,Direccion,Telefono,Categoria,FechaNomb,Titulo,Oficina)
VALUES
	('12311231','alan.calderon@ecci.ucr.ac.cr','Alan','Calderon','Castro','m','1972-02-07','Alajuela','260933','Asociado','1988-03-01','Máster','225'),
	('123456789','alexandra.martinez@ecci.ucr.ac.cr','Alexandra','Martínez','Porras','f','1978-12-28','Heredia','096326','Asociado','2009-07-01','Doctora','233')

INSERT INTO
	ASISTENTE (Cedula,NumHoras)
VALUES
	('559876542',4),
	('991234567',4)

INSERT INTO
	CURSO (Sigla,Nombre,Creditos)
VALUES
	('CI1312','Bases de Datos I',4),
	('CI1330','Ingeniería de Software I',4)

INSERT INTO
	GRUPO (SiglaCurso,NumGrupo,Semestre,Anno,CedProf,Carga,CedAsist)
VALUES
	('CI1312',1,2,'2024','12311231',10,'991234567'),
	('CI1330',1,2,'2024','123456789',10,'559876542')

INSERT INTO
	LLEVA (CedEstudiante,SiglaCurso,NumGrupo,Semestre,Anno,Nota)
VALUES
	('559876542','CI1312',1,2,'2024',75),
	('991234567','CI1330',1,2,'2024',60)

INSERT INTO
	CARRERA (Codigo,Nombre,AnnoCreacion)
VALUES
	('Bach01Comp','Bachillerato en Computación e Informática','1973-11-14'),
	('Lic01Comp','Licenciatura en Computación e Informática','1973-11-14')

INSERT INTO
	EMPADRONADO_EN (CedEstudiante,CodCarrera,FechaIngreso,FechaGraduacion)
VALUES
	('559876542','Bach01Comp','2024-01-01','2028-01-01'),
	('991234567','Lic01Comp','2024-01-01','2028-01-01')

INSERT INTO
	PERTENECE_A (SiglaCurso,CodCarrera,NivelPlanEstudios)
VALUES
	('CI1312','Bach01Comp',4),
	('CI1330','Lic01Comp',1)

-- 5

-- a
SELECT * FROM PROFESOR

-- b
SELECT * FROM GRUPO

-- c
UPDATE PROFESOR SET Cedula = '11111111' WHERE NombreP = 'Alan'

-- d
SELECT * FROM PROFESOR

SELECT * FROM GRUPO