------------------------------------------------------
-- Autor       : IES HERMANOS MACHADO
-- Descripci�n : Script COMPLETO (CREACI�N DE TABLESPACE, USUARIO Y TABLAS, E INSERCI�N DE DATOS) - PROYECTO BBDD
-- Responsables : Fernando M�rquez Rodr�guez , Rafael Jos� Ossorio Lop�z, Victor Carrasco Artacho, Carlos Gonz�lez Ruiz, Gabriel Rodr�guez F�lix 
------------------------------------------------------

------------------------------------------------------
--CREACI�N Y ASIGNACI�N DE TABLESPACE 
--CREACI�N DE USUARIO
------------------------------------------------------

--CREAMOS EL TABLESPACE CON EL SYS PARA LUEGO PONERSELO AL USUARIO
CREATE TABLESPACE PROYECTO_BBDD_DUAL_DATOS DATAFILE
'F:\bbdd\Oracle\product\18.0.0\oradata\XE\proyecto_bbdd_dual_datos4.dbf'
SIZE 100M 
AUTOEXTEND ON NEXT 100M MAXSIZE UNLIMITED;

alter session set "_ORACLE_SCRIPT"=true;

--CREAMOS EL USUARIO CON EL TABLESPACE CREADO
CREATE USER ADMIN_GEST_ENERG IDENTIFIED BY ROOTROOT DEFAULT TABLESPACE PROYECTO_BBDD_DUAL_DATOS;

--LE DAMOS LOS PERMISOS AL USUARIO
GRANT CREATE SESSION, ALTER SESSION, CREATE TABLE, CREATE SEQUENCE,
CREATE TABLESPACE, UNLIMITED TABLESPACE, CREATE PROCEDURE TO ADMIN_GEST_ENERG;

CONNECT ADMIN_GEST_ENERG/ROOTROOT;

------------------------------------------------------
--CREACI�N DE LAS TABLAS
------------------------------------------------------

--CREAMOS LA TABLA CLIENTE

CREATE TABLE CLIENTE (
NIF                 VARCHAR2(9),
DIRECCION_DOMICILIO VARCHAR2(50),
NUMERO_TELEFONO     NUMBER(9),
CODPOSTAL           NUMBER(5),
EMAIL               VARCHAR2(50)
);

--MODIFICAMOS LA TABLA CLIENTE PARA A�ADIRLE LA PK

ALTER TABLE CLIENTE
ADD CONSTRAINT CLIENTE_PK_NIF PRIMARY KEY (NIF);

--CREAMOS LA TABLA INMUEBLE

CREATE TABLE INMUEBLE(
COD_CATASTRAL         VARCHAR2(20),
DIRECCION             VARCHAR2(50)NOT NULL, 
CODPOSTAL             NUMBER(5)NOT NULL,
EFICIENCIA_ENERGETICA CHAR NOT NULL   
);

--LA MODIFICAMOS

ALTER TABLE INMUEBLE
ADD CONSTRAINT INMUEBLE_PK PRIMARY KEY(COD_CATASTRAL)
ADD CONSTRAINT INMUEBLE_UQ_DIRECCION UNIQUE (DIRECCION); 

--CREAMOS Y MODIFICAMOS LA TABLA CONTADOR

CREATE TABLE CONTADOR(
COD_CONTADOR  NUMBER(4),
COD_CATASTRAL VARCHAR2(20),
TIPO          VARCHAR2(20) NOT NULL,
CONSUMO       NUMBER(7,2)    
);

ALTER TABLE CONTADOR 
ADD CONSTRAINT CONTADOR_PK PRIMARY KEY(COD_CONTADOR, COD_CATASTRAL)
ADD CONSTRAINT CONTADOR_TIPO_CK CHECK(TIPO IN ('GAS', 'ELECTRICIDAD'))
ADD CONSTRAINT CONTADOR_FK_COD_CATASTRAL FOREIGN KEY (COD_CATASTRAL) REFERENCES INMUEBLE(COD_CATASTRAL);

--CREAMOS Y MODIFICAMOS LA TABLA EMPLEADO Y LA SECUENCIA CON LA QUE TRABAJAREMOS

CREATE TABLE EMPLEADO(
NIF                 VARCHAR2(9) NOT NULL,
CODEMPLEADO         NUMBER(6),
DIRECCION_DOMICILIO VARCHAR2(50),
NUMERO_TELEFONO     NUMBER(9) NOT NULL,
CODPOSTAL           NUMBER(5),
EMAIL               VARCHAR2(50),
COD_DEPARTAMENTO    NUMBER(4)
);

ALTER TABLE EMPLEADO
ADD CONSTRAINT EMPLEADO_PK_CODEMPLEADO PRIMARY KEY (CODEMPLEADO);
    
CREATE SEQUENCE SEQ_COD_EMPLEADO
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 999999
;

--CREAMOS Y MODIFICAMOS LA TABLA DEPARTAMENTO Y LA SECUENCIA CON LA QUE TRABAJAREMOS

CREATE TABLE DEPARTAMENTO(

COD_DEPARTAMENTO NUMBER(4),
ESPECIALIDAD     VARCHAR2(50),
EMPLEADO_JEFE    NUMBER(6) 
);

ALTER TABLE DEPARTAMENTO
ADD CONSTRAINT DEPARTAMENTO_PK_COD_DEPT PRIMARY KEY (COD_DEPARTAMENTO)
ADD CONSTRAINT DEPARTAMENTO_FK_JEFE FOREIGN KEY (EMPLEADO_JEFE) REFERENCES EMPLEADO(CODEMPLEADO)
ADD CONSTRAINT DEPARTAMENTO_UQ_ESPECIALIDAD UNIQUE (ESPECIALIDAD)
ADD CONSTRAINT DEPARTAMENTO_UQ_EMPLEADO_JEFE UNIQUE (EMPLEADO_JEFE);

CREATE SEQUENCE SEQ_COD_DEPARTAMENTO
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 9999
;

--MODIFICAMOS LA TABLA EMPLEADO PARA ESTABLECER LA RELACI�N CON DEPARTAMENTO

ALTER TABLE EMPLEADO
ADD CONSTRAINT EMPLEADO_FK_COD_DEPT FOREIGN KEY (COD_DEPARTAMENTO) REFERENCES DEPARTAMENTO(COD_DEPARTAMENTO);

--CREAMOS Y MODIFICAMOS LA TABLA CONTRATO Y LA SECUENCIA CON LA QUE TRABAJAREMOS

CREATE TABLE CONTRATO(
COD_CONTRATO     NUMBER(10),
NIF_CLIENTE      VARCHAR2(9), 
COD_DEPARTAMENTO NUMBER(4),
COD_CONTADOR     NUMBER(4),
COD_CATASTRAL    VARCHAR2(20)
);

ALTER TABLE CONTRATO
ADD CONSTRAINT CONTRATO_PK PRIMARY KEY(COD_CONTRATO, NIF_CLIENTE, COD_DEPARTAMENTO, COD_CONTADOR)
ADD CONSTRAINT CONTRATO_CLIENTE_FK FOREIGN KEY(NIF_CLIENTE) REFERENCES CLIENTE(NIF)
ADD CONSTRAINT CONTRATO_DEPARTAMENTO_FK FOREIGN KEY(COD_DEPARTAMENTO) REFERENCES DEPARTAMENTO(COD_DEPARTAMENTO)
ADD CONSTRAINT CONTRATO_CONTADOR_FK FOREIGN KEY(COD_CONTADOR, COD_CATASTRAL) REFERENCES CONTADOR(COD_CONTADOR, COD_CATASTRAL)
;

CREATE SEQUENCE SEQ_COD_CONTRATO
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 9999999999
;

------------------------------------------------------
--INSERCI�N DE DATOS
------------------------------------------------------

INSERT INTO CLIENTE(NIF,DIRECCION_DOMICILIO,NUMERO_TELEFONO,CODPOSTAL,EMAIL) VALUES('11111111A','Calle Feria N�3',954242644,41003,'email1@gmail.com');
INSERT INTO CLIENTE(NIF,DIRECCION_DOMICILIO,NUMERO_TELEFONO,CODPOSTAL,EMAIL) VALUES('22222222B','Calle Macarena N�16',954985432,41003,'email2@gmail.com');
INSERT INTO CLIENTE(NIF,DIRECCION_DOMICILIO,NUMERO_TELEFONO,CODPOSTAL,EMAIL) VALUES('33333333C','Calle Don Juan S/N',954573321,41007,'email3@gmail.com');
INSERT INTO CLIENTE(NIF,DIRECCION_DOMICILIO,NUMERO_TELEFONO,CODPOSTAL,EMAIL) VALUES('44444444D','Avenida de la Prensa N�19',954843954,41007,'email4@gmail.com');
INSERT INTO CLIENTE(NIF,DIRECCION_DOMICILIO,NUMERO_TELEFONO,CODPOSTAL,EMAIL) VALUES('55555555E','Calle Madre Mar�a Teresa N�4',954865677,41005,'email5@gmail.com');
INSERT INTO CLIENTE(NIF,DIRECCION_DOMICILIO,NUMERO_TELEFONO,CODPOSTAL,EMAIL) VALUES('66666666F','Calle Pirineos N�1',954032554,41018,'email6@gmail.com');
INSERT INTO CLIENTE(NIF,DIRECCION_DOMICILIO,NUMERO_TELEFONO,CODPOSTAL,EMAIL) VALUES('77777777G','Calle Porvenir N�19',954242644,41013,'email7@gmail.com');
INSERT INTO CLIENTE(NIF,DIRECCION_DOMICILIO,NUMERO_TELEFONO,CODPOSTAL,EMAIL) VALUES('88888888H','Calle �guilas S/N',954233485,41003,'email8@gmail.com');
INSERT INTO CLIENTE(NIF,DIRECCION_DOMICILIO,NUMERO_TELEFONO,CODPOSTAL,EMAIL) VALUES('99999999I','Calle Marchena S/N',954242644,41013,'email9@gmail.com');
INSERT INTO CLIENTE(NIF,DIRECCION_DOMICILIO,NUMERO_TELEFONO,CODPOSTAL,EMAIL) VALUES('13135854J','Calle Estoril N�6',954766982,41006,'email10@gmail.com');

COMMIT;

INSERT INTO INMUEBLE(COD_CATASTRAL,DIRECCION,CODPOSTAL,EFICIENCIA_ENERGETICA) VALUES('1234567AB1234A0000AB','Calle Macarena N�3',41003,'A');
INSERT INTO INMUEBLE(COD_CATASTRAL,DIRECCION,CODPOSTAL,EFICIENCIA_ENERGETICA) VALUES('1920433ME4323K4367TZ','Calle Castilla N�11',41010,'B');
INSERT INTO INMUEBLE(COD_CATASTRAL,DIRECCION,CODPOSTAL,EFICIENCIA_ENERGETICA) VALUES('7859669JZ2863R4325YM','Calle Ba�os N�18',41002,'A');
INSERT INTO INMUEBLE(COD_CATASTRAL,DIRECCION,CODPOSTAL,EFICIENCIA_ENERGETICA) VALUES('7316823LW5728N6382QT','Calle Corredur�a N�4',41003,'B');
INSERT INTO INMUEBLE(COD_CATASTRAL,DIRECCION,CODPOSTAL,EFICIENCIA_ENERGETICA) VALUES('2635885BT4725M6996PL','Calle Enladrillada N�21',41003,'C');
INSERT INTO INMUEBLE(COD_CATASTRAL,DIRECCION,CODPOSTAL,EFICIENCIA_ENERGETICA) VALUES('7628599RT7633S4556FT','Calle Arroyo N�41',41008,'D');
INSERT INTO INMUEBLE(COD_CATASTRAL,DIRECCION,CODPOSTAL,EFICIENCIA_ENERGETICA) VALUES('2855475LO4699T1522RE','Calle Venecia N�16',41008,'C');
INSERT INTO INMUEBLE(COD_CATASTRAL,DIRECCION,CODPOSTAL,EFICIENCIA_ENERGETICA) VALUES('8863695NN4332B7655GM','Calle J�piter N�11',41003,'B');
INSERT INTO INMUEBLE(COD_CATASTRAL,DIRECCION,CODPOSTAL,EFICIENCIA_ENERGETICA) VALUES('1526369UK4623T2770MP','Calle Galera N�9',41001,'B');
INSERT INTO INMUEBLE(COD_CATASTRAL,DIRECCION,CODPOSTAL,EFICIENCIA_ENERGETICA) VALUES('6300365VO4523X4726IP','Calle Albuera N�7',41001,'A');

COMMIT;

INSERT INTO CONTADOR(COD_CONTADOR,COD_CATASTRAL,TIPO,CONSUMO) VALUES(1,'1920433ME4323K4367TZ','GAS',2346.23);
INSERT INTO CONTADOR(COD_CONTADOR,COD_CATASTRAL,TIPO,CONSUMO) VALUES(2,'7859669JZ2863R4325YM','ELECTRICIDAD',7654.34);
INSERT INTO CONTADOR(COD_CONTADOR,COD_CATASTRAL,TIPO,CONSUMO) VALUES(3,'7316823LW5728N6382QT','ELECTRICIDAD',12234.8);
INSERT INTO CONTADOR(COD_CONTADOR,COD_CATASTRAL,TIPO,CONSUMO) VALUES(4,'2855475LO4699T1522RE','ELECTRICIDAD',9443.68);
INSERT INTO CONTADOR(COD_CONTADOR,COD_CATASTRAL,TIPO,CONSUMO) VALUES(5,'7628599RT7633S4556FT','GAS',6223.43);
INSERT INTO CONTADOR(COD_CONTADOR,COD_CATASTRAL,TIPO,CONSUMO) VALUES(6,'1526369UK4623T2770MP','GAS',6778.93);
INSERT INTO CONTADOR(COD_CONTADOR,COD_CATASTRAL,TIPO,CONSUMO) VALUES(7,'6300365VO4523X4726IP','GAS',54632.61);
INSERT INTO CONTADOR(COD_CONTADOR,COD_CATASTRAL,TIPO,CONSUMO) VALUES(8,'6300365VO4523X4726IP','ELECTRICIDAD',31204.5);
INSERT INTO CONTADOR(COD_CONTADOR,COD_CATASTRAL,TIPO,CONSUMO) VALUES(9,'2635885BT4725M6996PL','GAS',9401.2);
INSERT INTO CONTADOR(COD_CONTADOR,COD_CATASTRAL,TIPO,CONSUMO) VALUES(10,'8863695NN4332B7655GM','GAS',42035);
INSERT INTO CONTADOR(COD_CONTADOR,COD_CATASTRAL,TIPO,CONSUMO) VALUES(11,'7859669JZ2863R4325YM','GAS',5321.9);
INSERT INTO CONTADOR(COD_CONTADOR,COD_CATASTRAL,TIPO,CONSUMO) VALUES(12,'7316823LW5728N6382QT','GAS',14026.1);
INSERT INTO CONTADOR(COD_CONTADOR,COD_CATASTRAL,TIPO,CONSUMO) VALUES(13,'2855475LO4699T1522RE','GAS',7821.32);

COMMIT;

INSERT INTO EMPLEADO(NIF,CODEMPLEADO,DIRECCION_DOMICILIO,NUMERO_TELEFONO,CODPOSTAL,EMAIL,COD_DEPARTAMENTO) VALUES('43265476Z',SEQ_COD_EMPLEADO.NEXTVAL,'Calle Brasil N�5',954362817,41013,'empleado1@email.com',NULL);
INSERT INTO EMPLEADO(NIF,CODEMPLEADO,DIRECCION_DOMICILIO,NUMERO_TELEFONO,CODPOSTAL,EMAIL,COD_DEPARTAMENTO) VALUES('93845321G',SEQ_COD_EMPLEADO.NEXTVAL,'Calle Castelar S/N',683259638,41001,'empleado2@email.com',NULL);
INSERT INTO EMPLEADO(NIF,CODEMPLEADO,DIRECCION_DOMICILIO,NUMERO_TELEFONO,CODPOSTAL,EMAIL,COD_DEPARTAMENTO) VALUES('24277813T',SEQ_COD_EMPLEADO.NEXTVAL,'Calle Baltasar Graci�n N�9',706382936,41007,'empleado3@email.com',NULL);
INSERT INTO EMPLEADO(NIF,CODEMPLEADO,DIRECCION_DOMICILIO,NUMERO_TELEFONO,CODPOSTAL,EMAIL,COD_DEPARTAMENTO) VALUES('91234523L',SEQ_COD_EMPLEADO.NEXTVAL,'Calle Jilguero N�4',955368203,41006,'empleado4@email.com',NULL);
INSERT INTO EMPLEADO(NIF,CODEMPLEADO,DIRECCION_DOMICILIO,NUMERO_TELEFONO,CODPOSTAL,EMAIL,COD_DEPARTAMENTO) VALUES('01365342P',SEQ_COD_EMPLEADO.NEXTVAL,'Calle Juan de Mariana S/N',693625477,41005,'empleado5@email.com',NULL);
INSERT INTO EMPLEADO(NIF,CODEMPLEADO,DIRECCION_DOMICILIO,NUMERO_TELEFONO,CODPOSTAL,EMAIL,COD_DEPARTAMENTO) VALUES('41267331T',SEQ_COD_EMPLEADO.NEXTVAL,'Avenida de la Cruz del Campo N�31',642399865,'41005','empleado6@email.com',NULL);
INSERT INTO EMPLEADO(NIF,CODEMPLEADO,DIRECCION_DOMICILIO,NUMERO_TELEFONO,CODPOSTAL,EMAIL,COD_DEPARTAMENTO) VALUES('67223581S',SEQ_COD_EMPLEADO.NEXTVAL,'Calle Camilo Jos� Cela N�12',954877636,41018,'empleado7@email.com',NULL);
INSERT INTO EMPLEADO(NIF,CODEMPLEADO,DIRECCION_DOMICILIO,NUMERO_TELEFONO,CODPOSTAL,EMAIL,COD_DEPARTAMENTO) VALUES('37862530K',SEQ_COD_EMPLEADO.NEXTVAL,'Calle �feso N�3',684369411,41007,'empleado8@email.com',NULL);
INSERT INTO EMPLEADO(NIF,CODEMPLEADO,DIRECCION_DOMICILIO,NUMERO_TELEFONO,CODPOSTAL,EMAIL,COD_DEPARTAMENTO) VALUES('72535681R',SEQ_COD_EMPLEADO.NEXTVAL,'Calle Bogot� N�9',649802136,41013,'empleado9@email.com',NULL);
INSERT INTO EMPLEADO(NIF,CODEMPLEADO,DIRECCION_DOMICILIO,NUMERO_TELEFONO,CODPOSTAL,EMAIL,COD_DEPARTAMENTO) VALUES('46638207C',SEQ_COD_EMPLEADO.NEXTVAL,'Calle Duque de Rivas S/N',954238679,41005,'empleado10@email.com',NULL);
INSERT INTO EMPLEADO(NIF,CODEMPLEADO,DIRECCION_DOMICILIO,NUMERO_TELEFONO,CODPOSTAL,EMAIL,COD_DEPARTAMENTO) VALUES('68322692M',SEQ_COD_EMPLEADO.NEXTVAL,'Calle Salteras N�7',954722388,41006,'empleado11@email.com',NULL);
INSERT INTO EMPLEADO(NIF,CODEMPLEADO,DIRECCION_DOMICILIO,NUMERO_TELEFONO,CODPOSTAL,EMAIL,COD_DEPARTAMENTO) VALUES('72889632W',SEQ_COD_EMPLEADO.NEXTVAL,'Calle Galicia N�31',655293866,41006,'empleado12@email.com',NULL);
INSERT INTO EMPLEADO(NIF,CODEMPLEADO,DIRECCION_DOMICILIO,NUMERO_TELEFONO,CODPOSTAL,EMAIL,COD_DEPARTAMENTO) VALUES('38995687Q',SEQ_COD_EMPLEADO.NEXTVAL,'Calle Marchena N�6',688273699,41013,'empleado13@email.com',NULL);
INSERT INTO EMPLEADO(NIF,CODEMPLEADO,DIRECCION_DOMICILIO,NUMERO_TELEFONO,CODPOSTAL,EMAIL,COD_DEPARTAMENTO) VALUES('20536289V',SEQ_COD_EMPLEADO.NEXTVAL,'Calle Mi�o N�3',954239948,41011,'empleado14@email.com',NULL);
INSERT INTO EMPLEADO(NIF,CODEMPLEADO,DIRECCION_DOMICILIO,NUMERO_TELEFONO,CODPOSTAL,EMAIL,COD_DEPARTAMENTO) VALUES('64186538R',SEQ_COD_EMPLEADO.NEXTVAL,'Calle Castilla N�16',954133969,41010,'empleado15@email.com',NULL);

COMMIT;

INSERT INTO DEPARTAMENTO(COD_DEPARTAMENTO,ESPECIALIDAD,EMPLEADO_JEFE) VALUES(SEQ_COD_DEPARTAMENTO.NEXTVAL,'Electricidad',1);
INSERT INTO DEPARTAMENTO(COD_DEPARTAMENTO,ESPECIALIDAD,EMPLEADO_JEFE) VALUES(SEQ_COD_DEPARTAMENTO.NEXTVAL,'Gas',3);

COMMIT;

UPDATE EMPLEADO SET COD_DEPARTAMENTO = 1 WHERE CODEMPLEADO = 1;
UPDATE EMPLEADO SET COD_DEPARTAMENTO = 2 WHERE CODEMPLEADO = 2;
UPDATE EMPLEADO SET COD_DEPARTAMENTO = 2 WHERE CODEMPLEADO = 3;
UPDATE EMPLEADO SET COD_DEPARTAMENTO = 1 WHERE CODEMPLEADO = 4;
UPDATE EMPLEADO SET COD_DEPARTAMENTO = 1 WHERE CODEMPLEADO = 5;
UPDATE EMPLEADO SET COD_DEPARTAMENTO = 1 WHERE CODEMPLEADO = 6;
UPDATE EMPLEADO SET COD_DEPARTAMENTO = 2 WHERE CODEMPLEADO = 7;
UPDATE EMPLEADO SET COD_DEPARTAMENTO = 1 WHERE CODEMPLEADO = 8;
UPDATE EMPLEADO SET COD_DEPARTAMENTO = 1 WHERE CODEMPLEADO = 9;
UPDATE EMPLEADO SET COD_DEPARTAMENTO = 2 WHERE CODEMPLEADO = 10;
UPDATE EMPLEADO SET COD_DEPARTAMENTO = 1 WHERE CODEMPLEADO = 11;
UPDATE EMPLEADO SET COD_DEPARTAMENTO = 2 WHERE CODEMPLEADO = 12;
UPDATE EMPLEADO SET COD_DEPARTAMENTO = 2 WHERE CODEMPLEADO = 13;
UPDATE EMPLEADO SET COD_DEPARTAMENTO = 2 WHERE CODEMPLEADO = 14;
UPDATE EMPLEADO SET COD_DEPARTAMENTO = 1 WHERE CODEMPLEADO = 15;

COMMIT;

INSERT INTO CONTRATO(COD_CONTRATO,NIF_CLIENTE,COD_DEPARTAMENTO,COD_CONTADOR,COD_CATASTRAL) VALUES(SEQ_COD_CONTRATO.NEXTVAL,'55555555E',2,7,'6300365VO4523X4726IP');
INSERT INTO CONTRATO(COD_CONTRATO,NIF_CLIENTE,COD_DEPARTAMENTO,COD_CONTADOR,COD_CATASTRAL) VALUES(SEQ_COD_CONTRATO.NEXTVAL,'88888888H',2,4,'2855475LO4699T1522RE');
INSERT INTO CONTRATO(COD_CONTRATO,NIF_CLIENTE,COD_DEPARTAMENTO,COD_CONTADOR,COD_CATASTRAL) VALUES(SEQ_COD_CONTRATO.NEXTVAL,'13135854J',1,2,'7859669JZ2863R4325YM');
INSERT INTO CONTRATO(COD_CONTRATO,NIF_CLIENTE,COD_DEPARTAMENTO,COD_CONTADOR,COD_CATASTRAL) VALUES(SEQ_COD_CONTRATO.NEXTVAL,'11111111A',1,2,'7859669JZ2863R4325YM');
INSERT INTO CONTRATO(COD_CONTRATO,NIF_CLIENTE,COD_DEPARTAMENTO,COD_CONTADOR,COD_CATASTRAL) VALUES(SEQ_COD_CONTRATO.NEXTVAL,'99999999I',1,3,'7316823LW5728N6382QT');
INSERT INTO CONTRATO(COD_CONTRATO,NIF_CLIENTE,COD_DEPARTAMENTO,COD_CONTADOR,COD_CATASTRAL) VALUES(SEQ_COD_CONTRATO.NEXTVAL,'77777777G',2,5,'7628599RT7633S4556FT');
INSERT INTO CONTRATO(COD_CONTRATO,NIF_CLIENTE,COD_DEPARTAMENTO,COD_CONTADOR,COD_CATASTRAL) VALUES(SEQ_COD_CONTRATO.NEXTVAL,'66666666F',1,2,'7859669JZ2863R4325YM');
INSERT INTO CONTRATO(COD_CONTRATO,NIF_CLIENTE,COD_DEPARTAMENTO,COD_CONTADOR,COD_CATASTRAL) VALUES(SEQ_COD_CONTRATO.NEXTVAL,'22222222B',2,2,'7859669JZ2863R4325YM');
INSERT INTO CONTRATO(COD_CONTRATO,NIF_CLIENTE,COD_DEPARTAMENTO,COD_CONTADOR,COD_CATASTRAL) VALUES(SEQ_COD_CONTRATO.NEXTVAL,'88888888H',2,7,'6300365VO4523X4726IP');
INSERT INTO CONTRATO(COD_CONTRATO,NIF_CLIENTE,COD_DEPARTAMENTO,COD_CONTADOR,COD_CATASTRAL) VALUES(SEQ_COD_CONTRATO.NEXTVAL,'33333333C',1,5,'7628599RT7633S4556FT');
INSERT INTO CONTRATO(COD_CONTRATO,NIF_CLIENTE,COD_DEPARTAMENTO,COD_CONTADOR,COD_CATASTRAL) VALUES(SEQ_COD_CONTRATO.NEXTVAL,'44444444D',1,6,'1526369UK4623T2770MP');

COMMIT;