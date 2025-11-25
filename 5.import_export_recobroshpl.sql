USE master
Go

-- activar opciones avanzadas
EXEC sp_configure 'show advanced options', 1; 

RECONFIGURE; 

-- activar OLE Automation (para exportar)
EXEC sp_configure 'Ole Automation Procedures', 1; 
 
RECONFIGURE; 

-- activar xp_cmdshell ( verifica la exportación )
EXEC sp_configure 'xp_cmdshell', 1; 

RECONFIGURE; 


-- Dar permisos  al usuario (para importar)
ALTER SERVER ROLE [bulkadmin] ADD MEMBER [bases\angem]
GO

USE recobrohplpruebas
GO


 DROP TABLE if exists Almacen_Archivos;


CREATE TABLE Almacen_Archivos (
    id_Archivo INT PRIMARY KEY IDENTITY(1,1),
    NombreArchivo VARCHAR(255) NOT NULL,
    FechaCarga DATETIME DEFAULT GETDATE(),
    DatosArchivo VARBINARY(MAX) NOT NULL
);

USE recobrohplpruebas
GO


-- SP PARA IMPORTAR CUALQUIER ARCHIVO

CREATE OR ALTER PROCEDURE dbo.sp_ImportarArchivo (
    @RutaCarpetaEntrada NVARCHAR(1000),
    @NombreArchivo NVARCHAR(255)
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @RutaCompleta NVARCHAR(2000);
    DECLARE @tsql NVARCHAR(2000);
    

    -- Construimos la ruta completa
    SET @RutaCompleta = @RutaCarpetaEntrada + '\' + @NombreArchivo;
    
    -- SQL Dinámico para OPENROWSET
    SET @tsql = 'INSERT INTO Almacen_Archivos (NombreArchivo, DatosArchivo) ' +
                'SELECT ' + 
                '''' + @NombreArchivo + ''', ' +
                'Archivo.* ' +
                'FROM Openrowset(BULK ' + '''' + @RutaCompleta + '''' + ', SINGLE_BLOB) AS Archivo';
    
    PRINT 'Importando ' + @NombreArchivo + '...';
    EXEC (@tsql);
    
    SET NOCOUNT OFF;
END
GO

--PARA EXPORTAR CUALQUIER ARCHIVO (USA OLE AUTOMATION)
-- ---
CREATE OR ALTER PROCEDURE dbo.sp_ExportarArchivo (
    @NombreArchivo NVARCHAR(1000),
    @RutaCarpetaSalida NVARCHAR(1000)
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @DatosArchivo VARBINARY(MAX);
    DECLARE @RutaCompleta NVARCHAR(2000);
    DECLARE @Obj INT;

    -- Obtenemos los datos desde la nueva tabla
    SELECT 
        @DatosArchivo = DatosArchivo,
        @NombreArchivo = NombreArchivo
    FROM 
        Almacen_Archivos
    WHERE 
        NombreArchivo = @NombreArchivo;

    

    --ruta d salida
    SET @RutaCompleta = @RutaCarpetaSalida + '\' + @NombreArchivo;

    -- se usa OLE Automation para escribir el archivo
    BEGIN TRY
        PRINT 'Exportando ID ' + CAST(@NombreArchivo AS VARCHAR) + ' a ' + @RutaCompleta;
        EXEC sp_OACreate 'ADODB.Stream', @Obj OUTPUT;
        EXEC sp_OASetProperty @Obj, 'Type', 1;
        EXEC sp_OAMethod @Obj, 'Open';
        EXEC sp_OAMethod @Obj, 'Write', NULL, @DatosArchivo;
        EXEC sp_OAMethod @Obj, 'SaveToFile', NULL, @RutaCompleta, 2; -- 2 = Sobrescribir
        EXEC sp_OAMethod @Obj, 'Close';
        EXEC sp_OADestroy @Obj;
        PRINT 'Archivo exportado exitosamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al exportar el archivo.';
        EXEC sp_OADestroy @Obj;
    END CATCH

    SET NOCOUNT OFF;
END
GO

USE recobrohplpruebas
GO
 --IMPORTACIÓN (Archivo .jpg)
EXEC dbo.sp_ImportarArchivo
    @RutaCarpetaEntrada = 'C:\Temp\Importar',
    @NombreArchivo = 'imagen1.jpg';
GO



--exportacion
EXEC dbo.sp_ExportarArchivo
    @NombreArchivo = 'imagen1.jpg',
    @RutaCarpetaSalida = 'C:\Temp\Exportar';
GO

--comprobamos
EXEC xp_cmdshell 'dir C:\Temp\Exportar\imagen1.jpg';
GO