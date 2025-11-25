INSERT INTO estadoExpediente (descripcion) VALUES
('Nuevo'), ('En Gestión'), ('Promesa de Pago'), ('Acuerdo de Pago'), ('Saldado'), ('Incobrable'), ('Judicializado');

INSERT INTO tipoGestion (descripcion) VALUES
('Llamada Saliente'), ('Llamada Entrante'), ('Email Enviado'), ('SMS Enviado'), ('Carta Enviada'), ('Visita');

INSERT INTO resultadoGestion (descripcion) VALUES
('Promesa de Pago'), ('No Contesta'), ('Numero Equivocado'), ('Disputa Deuda'), ('Pago Realizado'), ('Deudor Inlocalizable'), ('Buzon de Voz');

INSERT INTO tipoProducto (descripcion) VALUES
('Prestamo Personal'), ('Tarjeta Credito'), ('Factura Telefonica'), ('Microcredito');

-- Insertar entidades principales 
INSERT INTO acreedor (nombreEmpresa, cif, contacto, comision) VALUES
('Banco malo', 'A12345678', 'Noa Pérez', 15.50),
('Telefonica del Este', 'B87654321', 'Luchi', 20.00);

INSERT INTO gestor (nombreUsuario, NombreCompleto, Email, puesto) VALUES
('hlopez','hector Lopez', 'hlopez@recobros.com', 'Gestor'),
('aperez','Ana Sanchez', 'aperez@recobros.com', 'Gestor'),
('malvarez', 'Maria Alvarez', 'malvarez@recobros.com', 'Supervisor');

INSERT INTO deudor (nombre, apellido, dni, direccion, telefono, email) VALUES
('belen', ' Perez', '12345678Z', 'Calle Falsa 123', '600112233', 'belen.perez@example.com'),
('jose', 'dubra te', '87654321X', 'Avenida Siempre  45', '699887766', 'jose.dubra@example.com');

-- Insertar casos/expedientes de ejemplo
INSERT INTO EXPEDIENTE (id_deudor, id_acreedor, ID_GestorAsignado, ID_EstadoExpediente, cantidadTotal, cantidaPendiente)
VALUES
(1, 1, 1, 2, 1000.00, 1000.00),  
(2, 2, 2, 1, 150.00, 150.00); 

-- Insertar las deudas específicas de esos expedientes
INSERT INTO DEUDA (id_Expediente, id_tipoProducto, ReferenciaProducto, cantidadTotal, cantidaPendiente, FechaVencimiento)
VALUES
(1, 2, 'TC-4567...8901', 1000.00, 1000.00, '2024-01-15'),
(2, 3, 'FACT-00123', 75.00, 75.00, '2024-02-01'),        
(2, 3, 'FACT-00180', 75.00, 75.00, '2024-03-01');        

-- Insertar una gestión de ejemplo
INSERT INTO GESTION (id_Expediente, id_gestor, id_tipoGestion, id_resultado, Notas, FechaProximaGestion)
VALUES
(1, 1, 1, 7, 'Primer intento de llamada, salta buzon de voz. Se deja mensaje.', GETDATE() + 1); go