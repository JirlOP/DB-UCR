/*
Exam 1 Practice
*/

CREATE DATABASE EXAM_1_PRACTICE
GO
USE EXAM_1_PRACTICE
GO



CREATE TABLE EQUIPO (
	Nombre VARCHAR(30),
	CONSTRAINT PK_EQUIPO PRIMARY KEY(Nombre),
	Ciudad VARCHAR(30) NOT NULL,
	Division CHAR(1) DEFAULT 'F', -- A,B,C,D etc. Default ligas menores para nuevos equipos
	Liga VARCHAR(30) NOT NULL
)

CREATE TABLE JUEGO (
	Id uniqueidentifier,
	CONSTRAINT PK_JUEGO PRIMARY KEY(Id),
	Fecha DATETIME NOT NULL,
	EquipoGanador VARCHAR(30), -- autocalculado al medir carreras en JUEGA. nulo porque se puede cancelar el partido
	LanzadorGanador uniqueidentifier,
	LanzadorPerdedor uniqueidentifier,
	LanzadorSalvamento uniqueidentifier
)

CREATE TABLE JUEGA_PARTIDO(
	IdJuego uniqueidentifier,
	CONSTRAINT PK_JUEGA_PARTIDO PRIMARY KEY(IdJuego, NombreEquipo),
	CONSTRAINT FK_JUEGA_PARTIDO_JUEGO FOREIGN KEY(IdJuego)
		REFERENCES JUEGO(Id),
	NombreEquipo VARCHAR(30), -- este se supone que son maximo dos
	CONSTRAINT FK_JUEGA_PARTIDO_EQUIPO FOREIGN KEY(NombreEquipo)
		REFERENCES EQUIPO(Nombre),
	[Local] BIT,
	Carreras INT,
	Hits INT,
	Errores INT,
)

CREATE TABLE JUGADOR(
	Id uniqueidentifier,
	CONSTRAINT PK_JUGADOR PRIMARY KEY(Id),
	NombreEquipo VARCHAR(30),
	CONSTRAINT FK_JUGADOR_EQUIPO FOREIGN KEY(NombreEquipo)
		REFERENCES EQUIPO(Nombre),
	PrimerNombre VARCHAR(20) NOT NULL,
	SegundoNombre VARCHAR(20),
	PrimerApellido VARCHAR(20) NOT NULL,
	SegundoApellido VARCHAR(20),
	FechaNacimiento DATE,
	LugarNacimiento VARCHAR(30),
	ManoHabil CHAR(1) NOT NULL,
	BA float, -- Calculated by a trigger
)

CREATE TABLE TIENE_HIT(
	IdJuego	uniqueidentifier,
	CONSTRAINT PK_TIENE_HIT PRIMARY KEY(IdJuego, IdJugador),
	CONSTRAINT FK_TIENE_HIT_JUEGO FOREIGN KEY(IdJuego)
		REFERENCES JUEGO(Id),
	IdJugador uniqueidentifier,
	CONSTRAINT FK_TIENE_HIT_JUGADOR FOREIGN KEY(IdJugador)
		REFERENCES JUGADOR(Id),
	HitsSencillos TINYINT,
	HitsDobles TINYINT,
	HitsTriples	TINYINT,
	HitsHomeRun TINYINT
)



CREATE TABLE LANZADOR(
	IdJugador uniqueidentifier,
	CONSTRAINT PK_LANZADOR PRIMARY KEY(IdJugador),
	CONSTRAINT FK_LANZADOR_JUGADOR FOREIGN KEY(IdJugador)
		REFERENCES JUGADOR(Id),
	ERA FLOAT
)


CREATE TABLE ENTRENADOR(
	Id uniqueidentifier,
	CONSTRAINT PK_ENTRENADOR PRIMARY KEY(Id),
	NombreEquipo VARCHAR(30),
	CONSTRAINT FK_ENTRENADOR_EQUIPO FOREIGN KEY(NombreEquipo)
		REFERENCES EQUIPO(Nombre),
	PrimerNombre VARCHAR(20) NOT NULL,
	SegundoNombre VARCHAR(20),
	PrimerApellido VARCHAR(20) NOT NULL,
	SegundoApellido VARCHAR(20),
	FechaNacimiento DATE,
	LugarNacimiento VARCHAR(30),
)


CREATE TABLE MANAGER(
	Id uniqueidentifier,
	CONSTRAINT PK_MANAGER PRIMARY KEY(Id),
	NombreEquipo VARCHAR(30),
	PrimerNombre VARCHAR(20) NOT NULL,
	SegundoNombre VARCHAR(20),
	PrimerApellido VARCHAR(20) NOT NULL,
	SegundoApellido VARCHAR(20),
	FechaNacimiento DATE,
	LugarNacimiento VARCHAR(30),
	CONSTRAINT FK_MANAGER_EQUIPO FOREIGN KEY(NombreEquipo)
		REFERENCES EQUIPO(Nombre)
)

CREATE TABLE ARBITRO(
	Id uniqueidentifier,
	CONSTRAINT PK_ARBITRO PRIMARY KEY(Id),
	PrimerNombre VARCHAR(20) NOT NULL,
	SegundoNombre VARCHAR(20),
	PrimerApellido VARCHAR(20) NOT NULL,
	SegundoApellido VARCHAR(20),
	FechaNacimiento DATE,
	LugarNacimiento VARCHAR(30)
)

CREATE TABLE ARBITRA(
	IdJuego uniqueidentifier,
	IdArbitro uniqueidentifier,
	CONSTRAINT PK_ARBITRA PRIMARY KEY(IdJuego, IdArbitro),
	CONSTRAINT FK_ARBITRA_JUEGO FOREIGN KEY(IdJuego)
		REFERENCES JUEGO(Id),
	CONSTRAINT FK_ARBITRA_ARBITRO FOREIGN KEY(IdArbitro)
		REFERENCES ARBITRO(Id)
)



INSERT INTO
	EQUIPO (Nombre, Ciudad, Liga)
VALUES
	('Yankees', 'New York', 'AL'),
	('Mets', 'New York', 'NL')


INSERT INTO
	JUGADOR (Id, NombreEquipo, PrimerNombre, SegundoNombre, PrimerApellido,
	SegundoApellido, FechaNacimiento, LugarNacimiento, ManoHabil, BA)
VALUES
	(NEWID(), 'Yankees', 'Babe', 'Ruth', 'George', 'Herman', '1895-02-06',
		'Baltimore', 'D', 0.342),
	(NEWID(), 'Mets', 'Tom', 'Seaver', 'George', 'Thomas', '1944-11-17', 'Fresno',
		'D', 0.311),
	(NEWID(), 'Yankees', 'Lou', 'Gehrig', 'Henry', 'Louis', '1903-06-19',
		'New York', 'I', 0.340),
	(NEWID(), 'Mets', 'Dwight', 'Gooden', 'Eugene', 'Dwight', '1964-11-16',
		'Tampa', 'D', 0.300)


/*
uniqueidentifier for IdJuego
8d28b10a-a450-468a-a33b-e47cd5558593

e058d8f1-a6c6-49e5-b487-618012c60b98

22306eef-0028-47d2-9dd9-f0747060621f

a4f1a07b-e37e-4a0d-a119-2c060a863240

c1464f51-cce9-4de5-a5df-4e8ae2083a8e

6af9bd41-e8f3-4036-8312-b173de6c6c5b
*/

INSERT INTO
	JUEGO (Id, Fecha, EquipoGanador, LanzadorGanador, LanzadorPerdedor,
		LanzadorSalvamento)
VALUES
	('8d28b10a-a450-468a-a33b-e47cd5558593', '2019-04-01', 'Yankees',
		(SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Babe'),
		(SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Tom'),
		(SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Dwight')),
	('e058d8f1-a6c6-49e5-b487-618012c60b98', '2019-04-02', 'Mets',
		(SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Tom'),
		(SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Babe'),
		(SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Dwight')),
	('22306eef-0028-47d2-9dd9-f0747060621f', '2019-04-03', 'Yankees',
		(SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Babe'),
		(SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Tom'),
		(SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Dwight')),
	('a4f1a07b-e37e-4a0d-a119-2c060a863240', '2019-04-04', 'Mets',
		(SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Tom'),
		(SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Babe'),
		(SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Dwight')),
	('c1464f51-cce9-4de5-a5df-4e8ae2083a8e', '2019-04-05', 'Yankees',
		(SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Babe'),
		(SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Tom'),
		(SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Dwight')),
	('6af9bd41-e8f3-4036-8312-b173de6c6c5b', '2019-04-06', 'Mets',
		(SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Tom'),
		(SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Babe'),
		(SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Dwight'))


INSERT INTO
	JUEGA_PARTIDO (IdJuego, NombreEquipo, [Local], Carreras, Hits, Errores)
VALUES -- These two teams have to have same id for the same game
	('8d28b10a-a450-468a-a33b-e47cd5558593', 'Yankees', 1, 5, 10, 0),
	('8d28b10a-a450-468a-a33b-e47cd5558593', 'Mets', 0, 3, 5, 1),
	('e058d8f1-a6c6-49e5-b487-618012c60b98', 'Yankees', 1, 3, 5, 1),
	('e058d8f1-a6c6-49e5-b487-618012c60b98', 'Mets', 0, 5, 10, 0),
	('22306eef-0028-47d2-9dd9-f0747060621f', 'Yankees', 1, 5, 10, 0),
	('22306eef-0028-47d2-9dd9-f0747060621f', 'Mets', 0, 3, 5, 1),
	('a4f1a07b-e37e-4a0d-a119-2c060a863240', 'Yankees', 0, 3, 5, 1),
	('a4f1a07b-e37e-4a0d-a119-2c060a863240', 'Mets', 1, 5, 10, 0),
	('c1464f51-cce9-4de5-a5df-4e8ae2083a8e', 'Yankees', 0, 5, 10, 0),
	('c1464f51-cce9-4de5-a5df-4e8ae2083a8e', 'Mets', 1, 3, 5, 1),
	('6af9bd41-e8f3-4036-8312-b173de6c6c5b', 'Yankees', 0, 3, 5, 1),
	('6af9bd41-e8f3-4036-8312-b173de6c6c5b', 'Mets', 1, 5, 10, 0)
-- 6 plays between two same teams


INSERT INTO
	TIENE_HIT (IdJuego, IdJugador, HitsSencillos, HitsDobles, HitsTriples, HitsHomeRun)
VALUES
	('8d28b10a-a450-468a-a33b-e47cd5558593', (SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Babe'), 3, 2, 0, 1),
	('8d28b10a-a450-468a-a33b-e47cd5558593', (SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Tom'), 2, 2, 0, 1),
	('8d28b10a-a450-468a-a33b-e47cd5558593', (SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Lou'), 1, 4, 0, 1),
	('8d28b10a-a450-468a-a33b-e47cd5558593', (SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Dwight'), 1, 1, 0, 1),
	('e058d8f1-a6c6-49e5-b487-618012c60b98', (SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Babe'), 1, 2, 0, 1),
	('e058d8f1-a6c6-49e5-b487-618012c60b98', (SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Tom'), 1, 4, 0, 1),
	('e058d8f1-a6c6-49e5-b487-618012c60b98', (SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Lou'), 1, 1, 0, 1),
	('e058d8f1-a6c6-49e5-b487-618012c60b98', (SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Dwight'), 1, 0, 0, 1),
	('22306eef-0028-47d2-9dd9-f0747060621f', (SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Babe'), 1, 2, 0, 1),
	('22306eef-0028-47d2-9dd9-f0747060621f', (SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Tom'), 1, 1, 0, 1),
	('22306eef-0028-47d2-9dd9-f0747060621f', (SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Lou'), 1, 2, 0, 1),
	('22306eef-0028-47d2-9dd9-f0747060621f', (SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Dwight'), 1, 1, 0, 1),
	('a4f1a07b-e37e-4a0d-a119-2c060a863240', (SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Babe'), 1, 5, 0, 1),
	('a4f1a07b-e37e-4a0d-a119-2c060a863240', (SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Tom'), 1, 2, 0, 1),
	('a4f1a07b-e37e-4a0d-a119-2c060a863240', (SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Lou'), 1, 1, 0, 1),
	('a4f1a07b-e37e-4a0d-a119-2c060a863240', (SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Dwight'), 1, 5, 0, 1),
	('c1464f51-cce9-4de5-a5df-4e8ae2083a8e', (SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Babe'), 1, 3, 0, 1),
	('c1464f51-cce9-4de5-a5df-4e8ae2083a8e', (SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Tom'), 1, 5, 0, 1),
	('c1464f51-cce9-4de5-a5df-4e8ae2083a8e', (SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Lou'), 1, 4, 0, 1),
	('c1464f51-cce9-4de5-a5df-4e8ae2083a8e', (SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Dwight'), 1, 1, 0, 1),
	('6af9bd41-e8f3-4036-8312-b173de6c6c5b', (SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Babe'), 1, 2, 0, 1),
	('6af9bd41-e8f3-4036-8312-b173de6c6c5b', (SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Tom'), 1, 2, 0, 1),
	('6af9bd41-e8f3-4036-8312-b173de6c6c5b', (SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Lou'), 1, 1, 0, 1),
	('6af9bd41-e8f3-4036-8312-b173de6c6c5b', (SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Dwight'), 1, 1, 0, 1)


INSERT INTO
	LANZADOR (IdJugador, ERA)
VALUES
	((SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Babe'), 2.28),
	((SELECT Id FROM JUGADOR WHERE PrimerNombre = 'Tom'), 2.86)

INSERT INTO
	ENTRENADOR (Id, NombreEquipo, PrimerNombre, SegundoNombre, PrimerApellido,
	SegundoApellido, FechaNacimiento, LugarNacimiento)
VALUES
	(NEWID(), 'Yankees', 'Joe', 'Paul', 'Torre', 'Michael', '1940-07-18', 'Brooklyn'),
	(NEWID(), 'Mets', 'Yogi', 'Berra', 'Lawrence', 'Peter', '1925-05-12', 'St. Louis')


INSERT INTO
	MANAGER (Id, NombreEquipo, PrimerNombre, SegundoNombre, PrimerApellido,
	SegundoApellido, FechaNacimiento, LugarNacimiento)
VALUES
	(NEWID(), 'Yankees', 'Joe', 'Paul', 'Torre', 'Michael', '1940-07-18',
		'Brooklyn'),
	(NEWID(), 'Mets', 'Yogi', 'Berra', 'Lawrence', 'Peter', '1925-05-12',
		'St. Louis')

INSERT INTO
	ARBITRO (Id, PrimerNombre, SegundoNombre, PrimerApellido, SegundoApellido,
	FechaNacimiento, LugarNacimiento)
VALUES
	(NEWID(), 'Joe', 'Paul', 'Torre', 'Michael', '1940-07-18', 'Brooklyn'),
	(NEWID(), 'Yogi', 'Berra', 'Lawrence', 'Peter', '1925-05-12', 'St. Louis')
