CREATE OR ALTER PROCEDURE backup_recobros
    @path VARCHAR(256)
AS
BEGIN -- 
    SET NOCOUNT ON; -- 

    --  Las declaraciones van DENTRO del BEGIN
    DECLARE @name VARCHAR(50),
            @filename VARCHAR(256),
            @filedate VARCHAR(256), 
            @backupcount INT,
            @currentbackup INT; 

    -- creamos tabla temporal
    CREATE TABLE #tempbackup (
        intID INT IDENTITY(1, 1),
        name VARCHAR(200)
    );

    -- para incluir la fecha en el nombre del fichero
    SET @filedate = CONVERT(VARCHAR(20), GETDATE(), 112);

    INSERT INTO #tempbackup (name)
    SELECT name
    FROM master.sys.databases 
    WHERE name IN ('recobroshpl11', 'recobro');

    SELECT TOP 1 @backupcount = intID 
    FROM #tempbackup
    ORDER BY intID DESC;

    PRINT @backupcount;

    IF ((@backupcount IS NOT NULL) AND (@backupcount > 0))
    BEGIN 

        SET @currentbackup = 1; -- valor incial
        
        WHILE (@currentbackup <= @backupcount) -- mientra la condicion sea verdadra el bucle se ejecutar
        BEGIN -- inicio de loop
            SELECT @name = name,
                   @filename = @path + name + '_' + @filedate + '.BAK'
            FROM #tempbackup
            WHERE intID = @currentbackup;

            PRINT @filename;

            --  Usar WITH INIT para sobreescribir si el backup ya existe
            BACKUP DATABASE @name TO DISK = @filename WITH INIT; 

            SET @currentbackup = @currentbackup + 1;
        END -- fin del WHILE o bucle

    END --  Cierre del bloque IF

    -- Limpiar la tabla temporal
    DROP TABLE #tempbackup;

END --* Este es el END principal del Stored Procedure
GO

-- ---
-- recuerda la cp backup tiene q existir 
 EXEC backup_recobros 'C:\Backup\'
-- ---