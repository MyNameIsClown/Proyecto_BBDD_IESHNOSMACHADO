------------------------------------------------------
-- Autor       : IES HERMANOS MACHADO
-- Descripci�n : Script 2 CREACION TABLA DEPARTAMENTO - PROYECTO BBDD
-- Responsables : Fernando M�rquez Rodr�guez , Rafael Jos� Ossorio Lop�z, Victor Carrasco Artacho, Carlos Gonz�lez Ruiz, Gabriel Rodr�guez F�lix 
------------------------------------------------------

CREATE TABLE DEPARTAMENTO(

COD_DEPARTAMENTO NUMBER(4),
ESPECIALIDAD     VARCHAR(50),
NEMPLEADOS       NUMBER(5),
JEFEDEPT         NUMBER(6)

);

ALTER TABLE DEPARTAMENTO
ADD CONSTRAINT DEPARTAMENTO_PK_COD_DEPT PRIMARY KEY (COD_DEPARTAMENTO);