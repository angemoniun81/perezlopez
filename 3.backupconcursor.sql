--use master;
CREATE OR ALTER PROCEDURE sp_backupRecobros_cursor--cremamos el procedimeinto
	@path VARCHAR(256)
AS
BEGIN
	SET NOCOUNT ON;

	-- variables
	DECLARE @name VARCHAR(128);
	DECLARE @filename VARCHAR(256);
	DECLARE @filedate VARCHAR(20);

	-- asignar la fecha
	SET @filedate = CONVERT(VARCHAR(20), GETDATE(), 112);

	--Declararos el Cursor
	DECLARE db_cursor CURSOR FOR
		SELECT name 
		FROM master.sys.databases
		WHERE name IN ('recobroshpl11', 'recobro');

	
	OPEN db_cursor;

	--  Cargamos la primera fila
	FETCH NEXT FROM db_cursor INTO @name;

	--Inicia el bucle (mientras haya filas)
	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		--  construir el nombre y hace lacopia
		SET @filename = @path + @name + '_' + @filedate + '.BAK';
		BACKUP DATABASE @name TO DISK = @filename WITH INIT;

		-- carga la siguiente fila
		FETCH NEXT FROM db_cursor INTO @name;
	END

	
	CLOSE db_cursor;

	 --Libera el cursor
	DEALLOCATE db_cursor;
END
GO

-- EXEC sp_backupRecobros_cursor 'C:\Backup\'