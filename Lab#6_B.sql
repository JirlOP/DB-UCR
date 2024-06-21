USE C12565

-- Escenario 1: Nivel de aislamiento read uncommitted

-- 7
set implicit_transactions off;
begin transaction t2;
PRINT @@TRANCOUNT
Select * from sys.sysprocesses 
where open_tran = 1;
Update Lleva 
set Nota = Nota*(0.8)
where Nota is not null;

-- 9
rollback transaction t2;

-- Escenario 2: Nivel de aislamiento read committed

-- 13
set implicit_transactions off;
begin transaction t4;
Update Lleva 
set Nota = Nota*(0.8)
where Nota is not null;

-- 15
Select * from sys.sysprocesses
where open_tran = 1 
commit transaction t4;

-- Escenario 3: Nivel de aislamiento repeatable read

-- 19
set implicit_transactions off;
begin transaction t6;
Insert into Lleva(CedEstudiante, SiglaCurso,NumGrupo, Semestre, Anno, Nota)
values('12345', 'CI0127', 1, 1,2019, 85);

-- 23
set implicit_transactions off;
begin transaction t8;
Insert into Lleva(CedEstudiante, SiglaCurso,NumGrupo, Semestre, Anno, Nota)
values('12345', 'CI0127', 1, 1,2019, 85);

-- 25
commit transaction t8;