use recobrohpl11;


DECLARE @MontoPago DECIMAL(18, 2) = 100.00;
DECLARE @DeudaActual DECIMAL(18, 2);

BEGIN TRY
    BEGIN TRAN;

    SELECT @DeudaActual = cantidaPendiente
    FROM EXPEDIENTE
    WHERE id_Expediente = 1;

    IF @MontoPago > @DeudaActual
    BEGIN
        THROW 50001, 'Error: El  pago es superior a la deuda pendiente.', 1;
    END;

    INSERT INTO PAGO (id_Expediente, FechaPago, MontoPagado)
    VALUES (1, GETDATE(), @MontoPago);

    UPDATE EXPEDIENTE
    SET cantidaPendiente = cantidaPendiente - @MontoPago
    WHERE id_Expediente = 1;

    COMMIT TRAN;
    PRINT 'Operación realizada con éxito.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN;

    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH;

SELECT id_Expediente, cantidadTotal, cantidaPendiente 
FROM EXPEDIENTE 
WHERE id_Expediente = 1;