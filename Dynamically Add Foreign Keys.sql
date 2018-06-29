USE YOUR_DATABASE;
DECLARE @SQL NVARCHAR(MAX), @Table NVARCHAR(100), @Schema NVARCHAR(100), @Column NVARCHAR(100), @SourceTable NVARCHAR(100);

SET @Column = 'Application_Id' --Set Column Name
SET @SourceTable = 'Source_Application' -- Set Source Table that is the Primary

--Get all tables, besides source, that have Application_Id Column in them.
IF OBJECT_ID('tempdb..#Tables') IS NOT NULL DROP TABLE #Tables
SELECT COLUMN_NAME,TABLE_NAME,TABLE_SCHEMA
INTO #Tables
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = @Column AND TABLE_NAME <> @SourceTable AND TABLE_SCHEMA = 'EDWDimensional'

--SELECT * FROM #Tables

--loop through tables adding the foreign key, note schema is hard coded for source table, you may have to change.
WHILE (SELECT COUNT(*) FROM #Tables) > 0
	BEGIN
		SET @Table = (SELECT TOP 1 TABLE_NAME FROM #Tables)
		SET @Schema = (SELECT TOP 1 TABLE_SCHEMA FROM #Tables)
		SET @SQL = 
			'ALTER TABLE [' + @Schema + '].[' + @Table + ']
				ADD CONSTRAINT FK_JobID_' + @Schema + '_'+ @Table +' FOREIGN KEY ([' + @Column + '])
					REFERENCES dbo.['+ @SourceTable +'] ([JobRunId]) 
						ON UPDATE CASCADE'
		EXEC sp_executesql @SQL
		DELETE FROM #Tables WHERE TABLE_NAME = @Table AND TABLE_SCHEMA = @Schema
	END

