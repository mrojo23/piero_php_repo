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

/* EOF */
