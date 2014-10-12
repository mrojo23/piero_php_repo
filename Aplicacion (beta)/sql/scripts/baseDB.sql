/*
	primer modelo de la base de datos para Piero
*/
CREATE DATABASE Piero_DBTest;
USE    Piero_DBTest;

/* /////////////////////////////////////////////////////////////////////////////////////////////////
                                       DEFINICION DE TABLAS
///////////////////////////////////////////////////////////////////////////////////////////////// */

/* *************************************************************************************************
*  Datos Cliente
***************************************************************************************************/

/* Datos 'fijos' */

CREATE TABLE TClientes( /*tab Customers DB*/
	ID  int UNSIGNED NOT NULL AUTO_INCREMENT,
	CustomerNumber varchar(8) NOT NULL UNIQUE, 
	CompanyName varchar(50) NOT NULL UNIQUE,
	StartDate Date,
	SalesAgent varchar(50),
	CreditLimit int UNSIGNED DEFAULT '0',
	Email varchar(50),
	MobileNo varchar(13),
	Comments varchar(500),
	Deleted BOOLEAN DEFAULT FALSE,
	PRIMARY KEY (ID),
	FULLTEXT KEY buscador (CustomerNumber,CompanyName,SalesAgent,Email,MobileNo,Comments)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

/* Datos Semanales*/

CREATE TABLE TSemanaCliente(
	ID_semana SMALLINT(4) UNSIGNED NOT NULL,
	ID_cliente INT UNSIGNED NOT NULL,
	ID_Group TINYINT(3) UNSIGNED,
	Stop BOOLEAN DEFAULT FALSE,
	PRIMARY KEY (ID_semana,ID_cliente)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

/* Tipo de Cliente */

CREATE TABLE TCustomerType(
	ID  TINYINT (2) UNSIGNED NOT NULL AUTO_INCREMENT,
	CustomerType varchar(50) NOT NULL,
	ID_producto TINYINT(3) UNSIGNED NOT NULL,
	Deleted BOOLEAN DEFAULT FALSE,
	PRIMARY KEY (ID),
	UNIQUE KEY `GruPro` (`CustomerType`, `ID_producto`)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

/* Cliente referencia */

CREATE TABLE TGroup(
    ID TINYINT(3)UNSIGNED NOT NULL AUTO_INCREMENT,
	Grupo  TINYINT UNSIGNED NOT NULL UNIQUE,
	Deleted BOOLEAN DEFAULT FALSE,
	Relatedto int UNSIGNED  UNIQUE, /*Cliente de referencia*/ 
	PRIMARY KEY (ID)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

/* *************************************************************************************************
*  Datos Productos
***************************************************************************************************/

/*  Productos */

CREATE TABLE TProducto(
    ID TINYINT(3)UNSIGNED NOT NULL AUTO_INCREMENT,
    Producto varchar(50) NOT NULL UNIQUE,
    Deleted BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (ID)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

/* Productos del Cliente*/

CREATE TABLE TProductoCliente(
    ID_producto TINYINT(3)UNSIGNED NOT NULL,
    ID_semana SMALLINT(4) UNSIGNED NOT NULL,
    ID_cliente INT UNSIGNED NOT NULL, /*Si el cliente no esta, es que no tiene este producto*/
    ID_CustomerType TINYINT UNSIGNED DEFAULT NULL, /*Si null atencion personal*/
    PRIMARY KEY (ID_producto,ID_semana ,ID_cliente)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

/* *************************************************************************************************
*  Datos Pais
***************************************************************************************************/

/* Datos 'fijos' */
	
CREATE TABLE TPais(
    ID TINYINT (3)UNSIGNED NOT NULL AUTO_INCREMENT,
	Codigo_pais CHAR (2) UNIQUE NOT NULL,
	Deleted BOOLEAN DEFAULT FALSE,
	PRIMARY KEY (ID)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;
	
/* Datos Semanales */

CREATE TABLE TSemanaPais(
 	ID_semana SMALLINT(4) UNSIGNED NOT NULL,
	ID_pais TINYINT (3) UNSIGNED NOT NULL,
	ID_moneda TINYINT UNSIGNED,
	IVA TINYINT UNSIGNED,
	Litros SMALLINT UNSIGNED,
	PRIMARY KEY (ID_semana,ID_pais)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;	

/* Zona */
	
CREATE TABLE Tzona(
     ID TINYINT (2) UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
     Codigo_pais CHAR (2) NOT NULL,
	 numero TINYINT (2) NOT NULL DEFAULT '1',
     letra char(1) DEFAULT '',
     ID_producto TINYINT(3) UNSIGNED NOT NULL,
     Deleted BOOLEAN DEFAULT FALSE,
	 PRIMARY KEY (ID),
	 UNIQUE KEY `idxZona` (`Codigo_pais`,`numero`,`letra`,`ID_producto`)	 
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

/* ISO 3166-1 Alpha-2 code */

CREATE TABLE TcodigoPais(
    Codigo_pais CHAR (2) NOT NULL,
	Nombre varchar(50),
	PRIMARY KEY (Codigo_pais)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

/* Moneda */

CREATE TABLE Tmoneda(
    ID TINYINT UNSIGNED NOT NULL,
	Nombre varchar(50),
	Simbolo varchar (6),
	Deleted BOOLEAN DEFAULT FALSE,
	PRIMARY KEY (ID)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

/* *************************************************************************************************
*  Precios Zona
***************************************************************************************************/

/* Precio Coste */

CREATE TABLE TSemanaPrecio(
 	ID_semana SMALLINT(4) UNSIGNED NOT NULL,
	ID_zona TINYINT (2) UNSIGNED NOT NULL,
	Precio_EU DECIMAL(20,15) UNSIGNED, /*precio en eu*/
	Precio_MoN DECIMAL(20,15) UNSIGNED, /*precio en Moneda nacional*/	
	PRIMARY KEY (ID_semana,ID_zona)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;	

/* Margen de venta aplicado a grupos*/

CREATE TABLE TSemanaMargenG(
	ID_semana SMALLINT(4) UNSIGNED NOT NULL,
	ID_zona TINYINT (2) UNSIGNED NOT NULL,
	ID_CustomerType TINYINT (2) UNSIGNED,
	Margen DECIMAL(20,15),
    PRIMARY KEY (ID_semana,ID_zona,ID_CustomerType)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

/* Margen de venta aplicado a persona*/

CREATE TABLE TSemanaMargenP(
	ID_semana SMALLINT(4) UNSIGNED NOT NULL,
	ID_zona TINYINT (2) UNSIGNED NOT NULL,
	ID_cliente INT UNSIGNED,
	Margen DECIMAL(20,15),
    PRIMARY KEY (ID_semana,ID_zona,ID_cliente)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

/* *************************************************************************************************
*  Calendario 
***************************************************************************************************/	

/* Anyo */

CREATE TABLE TAno (
    ID TINYINT (4) UNSIGNED NOT NULL AUTO_INCREMENT,
    Ano varchar(4) NOT NULL UNIQUE,
	Estado  BOOLEAN DEFAULT TRUE, /* 'TRUE': año en curso, 'FALSE':año cerrado */	 
	PRIMARY KEY (ID)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

/* Semana */

CREATE TABLE TSemana (
	ID SMALLINT(4) UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT, 
    No_semana TINYINT(2) UNSIGNED NOT NULL,/*1-52*/
    ID_ano TINYINT (4) UNSIGNED NOT NULL,	
	Semana varchar(10) NOT NULL,/*13/10/2014*/
	Estado  TINYINT(1) NOT NULL DEFAULT '1',/* -1: Obsoleta,0: cerrada, 1-N :Estado N del proceso */	 
	PRIMARY KEY (ID),
	UNIQUE KEY `idxSemana` (`No_semana`,`ID_ano`)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

/* /////////////////////////////////////////////////////////////////////////////////////////////////
                                       RELACION  DE TABLAS
///////////////////////////////////////////////////////////////////////////////////////////////// */
	

ALTER TABLE `TSemanaCliente`
    ADD CONSTRAINT `TSemanaCliente_ibfk_1` 
	    FOREIGN KEY (`ID_semana`) 
	    REFERENCES `TSemana` (`ID`) 
		ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `TSemanaCliente_ibfk_2` 
	    FOREIGN KEY (`ID_cliente`) 
	    REFERENCES `TClientes` (`ID`) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `TSemanaCliente_ibfk_3` 
	    FOREIGN KEY (`ID_Group`) 
	    REFERENCES `TGroup` (`ID`) 
		ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `TSemanaPais`
    ADD CONSTRAINT `TSemanaPais_ibfk_1` 
	    FOREIGN KEY (`ID_semana`) 
		REFERENCES `TSemana` (`ID`) 
		ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `TSemanaPais_ibfk_2` 
	    FOREIGN KEY (`ID_pais`) 
		REFERENCES `TPais` (`ID`) 
		ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `TSemanaPais_ibfk_3` 
	    FOREIGN KEY (`ID_moneda`) 
		REFERENCES `Tmoneda` (`ID`) 
		ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `TSemanaPrecio`
    ADD CONSTRAINT `TSemanaPrecio_ibfk_1` 
	    FOREIGN KEY (`ID_semana`) 
		REFERENCES `TSemana` (`ID`) 
		ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `TSemanaPrecio_ibfk_2` 
	    FOREIGN KEY (`ID_zona`) 
		REFERENCES `Tzona` (`ID`) 
		ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `TSemanaMargenG`
    ADD CONSTRAINT `TSemanaMargenG_ibfk_1` 
	    FOREIGN KEY (`ID_semana`) 
		REFERENCES `TSemana` (`ID`) 
		ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `TSemanaMargenG_ibfk_2` 
	    FOREIGN KEY (`ID_zona`) 
		REFERENCES `Tzona` (`ID`) 
		ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `TSemanaMargenG_ibfk_3` 
	    FOREIGN KEY (`ID_CustomerType`) 
		REFERENCES `TCustomerType` (`ID`) 
		ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `TSemanaMargenP`
    ADD CONSTRAINT `TSemanaMargenP_ibfk_1` 
	    FOREIGN KEY (`ID_semana`) 
		REFERENCES `TSemana` (`ID`) 
		ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `TSemanaMargenP_ibfk_2` 
	    FOREIGN KEY (`ID_zona`) 
		REFERENCES `Tzona` (`ID`) 
		ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `TSemanaMargenP_ibfk_3` 
	    FOREIGN KEY (`ID_cliente`) 
		REFERENCES `TClientes` (`ID`) 
		ON DELETE CASCADE ON UPDATE CASCADE;
			
ALTER TABLE `TPais`
    ADD CONSTRAINT `TPais_ibfk_1` 
	    FOREIGN KEY (`Codigo_pais`) 
		REFERENCES `TcodigoPais` (`Codigo_pais`) 
		ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `Tzona`	
    ADD CONSTRAINT `Tzona_ibfk_1` 
	    FOREIGN KEY (`Codigo_pais`) 
		REFERENCES `TcodigoPais` (`Codigo_pais`) 
		ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `Tzona_ibfk_2` 
	    FOREIGN KEY (`ID_producto`) 
		REFERENCES `TProducto` (`ID`) 
		ON DELETE CASCADE ON UPDATE CASCADE;		
	
ALTER TABLE `TSemana`
    ADD CONSTRAINT `TSemana_ibfk_1` 
	    FOREIGN KEY (`ID_ano`) 
		REFERENCES `TAno` (`ID`) 
		ON DELETE CASCADE ON UPDATE CASCADE;	
  
ALTER TABLE `TGroup`
    ADD CONSTRAINT `TGroup_ibfk_1` 
	    FOREIGN KEY (`Relatedto`) 
		REFERENCES `TClientes` (`ID`) 
		ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `TProductoCliente`
    ADD CONSTRAINT `TProductoCliente_ibfk_1` 
	    FOREIGN KEY (`ID_producto`) 
		REFERENCES `TProducto` (`ID`) 
		ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `TProductoCliente_ibfk_2` 
	    FOREIGN KEY (`ID_cliente`) 
		REFERENCES `TClientes` (`ID`) 
		ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT `TProductoCliente_ibfk_3` 
	    FOREIGN KEY (`ID_CustomerType`) 
		REFERENCES `TCustomerType` (`ID`) 
		ON DELETE SET NULL ON UPDATE CASCADE,
	ADD CONSTRAINT `TProductoCliente_ibfk_4` 
	    FOREIGN KEY (`ID_semana`) 
	    REFERENCES `TSemana` (`ID`) 
		ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `TCustomerType`
    ADD CONSTRAINT `TCustomerType_ibfk_1` 
	    FOREIGN KEY (`ID_producto`) 
		REFERENCES `TProducto` (`ID`) 
		ON DELETE CASCADE ON UPDATE CASCADE;

/* ////////////////// INSERTS ///////////////////////////////////////////////*/

USE    Piero_DBTest;


/*INSERT INTO table_name (column1,column2,column3,...)
VALUES (value1,value2,value3,...);*/

INSERT INTO tano(Ano) VALUES ("2014");


USE    Piero_DBTest;

INSERT INTO tsemana (No_semana, ID_ano, Semana, Estado) values
(1 ,1 ,'30/12/2013' ,-1 ),
(2 ,1 ,'06/01/2014' ,-1 ),
(3 ,1 ,'13/01/2014' ,-1 ),
(4 ,1 ,'20/01/2014' ,-1 ),
(5 ,1 ,'27/01/2014' ,-1 ),
(6 ,1 ,'03/02/2014' ,-1 ),
(7 ,1 ,'10/02/2014' ,-1 ),
(8 ,1 ,'17/02/2014' ,-1 ),
(9 ,1 ,'24/02/2014' ,-1 ),
(10 ,1 ,'03/03/2014' ,-1 ),
(11 ,1 ,'10/03/2014' ,-1 ),
(12 ,1 ,'17/03/2014' ,-1 ),
(13 ,1 ,'24/03/2014' ,-1 ),
(14 ,1 ,'31/03/2014' ,-1 ),
(15 ,1 ,'07/04/2014' ,-1 ),
(16 ,1 ,'14/04/2014' ,-1 ),
(17 ,1 ,'21/04/2014' ,-1 ),
(18 ,1 ,'28/04/2014' ,1 ),
(19 ,1 ,'05/05/2014' ,99 ),
(20 ,1 ,'12/05/2014' ,99 ),
(21 ,1 ,'19/05/2014' ,99 ),
(22 ,1 ,'26/05/2014' ,99 ),
(23 ,1 ,'02/06/2014' ,99 ),
(24 ,1 ,'09/06/2014' ,99 ),
(25 ,1 ,'16/06/2014' ,99 ),
(26 ,1 ,'23/06/2014' ,99 ),
(27 ,1 ,'30/06/2014' ,99 ),
(28 ,1 ,'07/07/2014' ,99 ),
(29 ,1 ,'14/07/2014' ,99 ),
(30 ,1 ,'21/07/2014' ,99 ),
(31 ,1 ,'28/07/2014' ,99 ),
(32 ,1 ,'04/08/2014' ,99 ),
(33 ,1 ,'11/08/2014' ,99 ),
(34 ,1 ,'18/08/2014' ,99 ),
(35 ,1 ,'25/08/2014' ,99 ),
(36 ,1 ,'01/09/2014' ,99 ),
(37 ,1 ,'08/09/2014' ,99 ),
(38 ,1 ,'15/09/2014' ,99 ),
(39 ,1 ,'22/09/2014' ,99 ),
(40 ,1 ,'29/09/2014' ,99 ),
(41 ,1 ,'06/10/2014' ,99 ),
(42 ,1 ,'13/10/2014' ,99 ),
(43 ,1 ,'20/10/2014' ,99 ),
(44 ,1 ,'27/10/2014' ,99 ),
(45 ,1 ,'03/11/2014' ,99 ),
(46 ,1 ,'10/11/2014' ,99 ),
(47 ,1 ,'17/11/2014' ,99 ),
(48 ,1 ,'24/11/2014' ,99 ),
(49 ,1 ,'01/12/2014' ,99 ),
(50 ,1 ,'08/12/2014' ,99 ),
(51 ,1 ,'15/12/2014' ,99 ),
(52 ,1 ,'22/12/2014' ,99 );


USE    Piero_DBTest;

/*INSERT INTO table_name (column1,column2,column3,...)
VALUES (value1,value2,value3,...);*/

INSERT INTO TProducto(Producto) VALUES
                         ("EDC"),
						 ("ESO"),
						 ("Peajes"),
						 ("Recuperacion de IVA");

USE    Piero_DBTest;

/*INSERT INTO table_name (column1,column2,column3,...)
VALUES (value1,value2,value3,...);*/

INSERT INTO tgroup(Grupo) VALUES
                         ("1"),
						 ("2"),
						 ("3"),
						 ("4"),
						 ("5");



USE    Piero_DBTest;

/*INSERT INTO table_name (column1,column2,column3,...)
VALUES (value1,value2,value3,...);*/

INSERT INTO tcustomertype(ID_producto,CustomerType) VALUES
                         (1,"EDC Type A"),
						 (1,"EDC Type B"),
						 (1,"EDC Type C"),
						 (1,"EDC Type D"),
						 (1,"EDC Type F"),
						 (2,"ESO Type A"),
						 (2,"ESO Type B"),
						 (2,"ESO Type C"),
						 (3,"Boludo"),
						 (3,"Re-Pelotudo"),
						 (3,"Forro"),
						 (3,"Kretino de Kreta");

/*
EOF
*/