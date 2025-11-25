drop database if exists recobrohpl;
create database recobrohpl;
use recobrohpl;

create table estadoExpediente(
id_estadoExpediente int primary key identity(1,1),
descripcion varchar(100) not null
);

create table tipoGestion(
id_tipoGestion int primary key identity(1,1),
descripcion varchar(110) not null
);

create table resultadoGestion(
id_resultado int primary key identity(1,1),
descripcion varchar(100) not null
);

create table tipoProducto(
id_tipoProducto int primary key identity(1,1),
descripcion varchar(100)
);

/* creamos la entidades principales */

create table acreedor(
id_acreedor int primary key identity(1,1),
nombreEmpresa varchar(50) not null,
cif varchar (20) not null unique, --ponemos restricon de unico y no puede estar vacio
contacto varchar(30),
comision decimal(5,2)
);

create table  deudor (
id_deudor int primary key identity(1,1),
nombre varchar(30)not null,
apellido varchar(30),
dni varchar(20) not null unique,
direccion varchar(200),
telefono varchar(12),
email varchar(100) unique
);

create table gestor(
id_gestor int primary key identity(1,1),
nombreUsuario VARCHAR(50) NOT NULL UNIQUE,
NombreCompleto VARCHAR(200) NOT NULL,
Email VARCHAR(100) NOT NULL UNIQUE, -- El email  nico
puesto VARCHAR(50) --  'Gestor', 'Supervisor', 'Admin
);


--tablas de transacciones

CREATE TABLE EXPEDIENTE (
    id_Expediente INT PRIMARY KEY IDENTITY(1,1),
    id_deudor INT NOT NULL,
    id_acreedor INT NOT NULL,
    id_gestorAsignado INT, 
    id_estadoExpediente INT NOT NULL,
    fechaAsignacion DATE NOT NULL DEFAULT GETDATE(), -- Fecha en que el expediente se creo
    cantidadTotal DECIMAL(18, 2) NOT NULL,
    cantidaPendiente DECIMAL(18, 2) NOT NULL
);

CREATE TABLE DEUDA (
    id_Deuda INT PRIMARY KEY IDENTITY(1,1),
    id_Expediente INT NOT NULL,
    id_tipoProducto INT NOT NULL,
    ReferenciaProducto VARCHAR(100), 
    cantidadTotal DECIMAL(18, 2) NOT NULL,
     cantidaPendiente DECIMAL(18, 2) NOT NULL,
    fechaVencimiento DATE
);

-- Tabla GESTION
CREATE TABLE GESTION (
    id_Gestion BIGINT PRIMARY KEY IDENTITY(1,1), 
    id_Expediente INT NOT NULL,
    id_gestor INT NOT NULL,
    FechaHora DATETIME NOT NULL DEFAULT GETDATE(), -- Momento exacto de la gesti n
    id_tipoGestion INT NOT NULL,
    id_resultado INT NOT NULL,
    Notas VARCHAR(500), 
    FechaProximaGestion DATE 
);

-- Tabla PAGO
CREATE TABLE PAGO (
    id_Pago INT PRIMARY KEY IDENTITY(1,1),
    id_Expediente INT NOT NULL,
    FechaPago DATE NOT NULL,
    MontoPagado DECIMAL(18, 2) NOT NULL,
    MetodoPago VARCHAR(50), 
    ReferenciaBancaria VARCHAR(100) 
);

-- Tabla ACUERDO_PAGO
CREATE TABLE ACUERDO_PAGO (
    id_Acuerdo INT PRIMARY KEY IDENTITY(1,1),
    id_Expediente INT NOT NULL,
    FechaAcuerdo DATE NOT NULL DEFAULT GETDATE(),
    MontoTotalAcordado DECIMAL(18, 2) NOT NULL,
    NumeroCuotas INT NOT NULL,
    MontoCuota DECIMAL(18, 2) NOT NULL,
    Periodicidad VARCHAR(20) 
);

-- Relaciones de la tabla EXPEDIENTE
ALTER TABLE EXPEDIENTE ADD CONSTRAINT FK_Expediente_Deudor
    FOREIGN KEY (id_deudor) REFERENCES deudor (id_deudor);

ALTER TABLE EXPEDIENTE ADD CONSTRAINT FK_Expediente_Acreedor
    FOREIGN KEY (id_acreedor) REFERENCES acreedor (id_acreedor);

ALTER TABLE EXPEDIENTE ADD CONSTRAINT FK_Expediente_Gestor
    FOREIGN KEY (ID_GestorAsignado) REFERENCES gestor (id_gestor);

ALTER TABLE EXPEDIENTE ADD CONSTRAINT FK_Expediente_Estado
    FOREIGN KEY (ID_EstadoExpediente) REFERENCES estadoExpediente (id_estadoExpediente);

-- Relaciones de la tabla DEUDA
ALTER TABLE DEUDA ADD CONSTRAINT FK_Deuda_Expediente
    FOREIGN KEY (id_Expediente) REFERENCES EXPEDIENTE (id_Expediente) ON DELETE CASCADE;
    -- Si un expediente se elimina, sus deudas  tambi n 

ALTER TABLE DEUDA ADD CONSTRAINT FK_Deuda_TipoProducto
    FOREIGN KEY (id_tipoProducto) REFERENCES tipoProducto (id_tipoProducto);

-- Relaciones de la tabla GESTION
ALTER TABLE GESTION ADD CONSTRAINT FK_Gestion_Expediente
    FOREIGN KEY (id_Expediente) REFERENCES EXPEDIENTE (id_Expediente) ON DELETE CASCADE;
    -- Si un expediente se elimina, su historial de gestiones tambi n .

ALTER TABLE GESTION ADD CONSTRAINT FK_Gestion_Gestor
    FOREIGN KEY (id_gestor) REFERENCES gestor (id_gestor);

ALTER TABLE GESTION ADD CONSTRAINT FK_Gestion_Tipo
    FOREIGN KEY (id_tipoGestion) REFERENCES tipoGestion (id_tipoGestion);

ALTER TABLE GESTION ADD CONSTRAINT FK_Gestion_Resultado
    FOREIGN KEY (id_resultado) REFERENCES resultadoGestion (id_resultado);

-- Relaciones de la tabla PAGO
ALTER TABLE PAGO ADD CONSTRAINT FK_Pago_Expediente
    FOREIGN KEY (id_Expediente) REFERENCES EXPEDIENTE (id_Expediente);
    

-- Relaciones de la tabla ACUERDO_PAGO
ALTER TABLE ACUERDO_PAGO ADD CONSTRAINT FK_Acuerdo_Expediente
    FOREIGN KEY (id_Expediente) REFERENCES EXPEDIENTE (id_Expediente) ON DELETE CASCADE;
 
