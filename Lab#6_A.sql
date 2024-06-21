USE C12565

-- Escenario 1: Nivel de aislamiento read uncommitted

-- 6
set implicit_transactions off;
set transaction isolation level read uncommitted;
begin transaction t1; 
PRINT @@TRANCOUNT
Select avg(Nota) from Lleva;

-- 8
Select avg(Nota) from Lleva;

-- 10
Select avg(Nota) from Lleva;
Commit transaction t1;

-- Escenario 2: Nivel de aislamiento read committed

-- 12
set implicit_transactions off;
set transaction isolation level read committed;
begin transaction t3;
Select avg(Nota) from Lleva;

-- 14
Select max(Nota) from Lleva;

-- 16
Commit transaction t3;

-- Escenario 3: Nivel de aislamiento repeatable read

-- 18
set implicit_transactions off;
set transaction isolation level repeatable read;
begin transaction t5;
Select avg(Nota) from Lleva;

-- 20
Select avg(Nota) from Lleva;
commit transaction t5;

-- 22
set implicit_transactions off;
set transaction isolation level serializable;
begin transaction t7;
Select avg(Nota) from Lleva;

-- 24
Select avg(Nota) from Lleva;
commit transaction t7;