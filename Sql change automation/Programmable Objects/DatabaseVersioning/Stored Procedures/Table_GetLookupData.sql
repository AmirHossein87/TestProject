IF OBJECT_ID('[DatabaseVersioning].[Table_GetLookupData]') IS NOT NULL
	DROP PROCEDURE [DatabaseVersioning].[Table_GetLookupData];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [DatabaseVersioning].[Table_GetLookupData]
    @SchemaName TSTRING = NULL, @TableName TSTRING = NULL, @ResultItems TSTRING = NULL OUTPUT
AS
BEGIN

    -- Provisiong parameters
    DECLARE @Query TSTRING;
    DECLARE @Params TSTRING;
	DECLARE @Columns TSTRING; 
    SET @SchemaName = ISNULL(@SchemaName, 'dbo');
	-- Get columns
	SET @Columns = (SELECT DatabaseVersioning.Table_Columns(@SchemaName,@TableName))

    -- Validate TableName
    EXEC dsp.Validate_CheckNotNull @ProcId = @@PROCID, @ArgumentName = 'TableName', @ArgumentValue = @TableName, @Message = 'TableName could not be allow null';

    -- TableName must be exists
    IF NOT EXISTS (SELECT TOP 1 1 FROM  sys.tables WHERE name = @TableName) --
        EXEC dsp.ThrowInvalidArgument @ProcId = @@PROCID, @ArgumentName = 'TableName', @ArgumentValue = @TableName,
            @Message = 'TableName does not exists in tables list';

    -- Table must have Lookup attribute in TemporalType extended property
    IF NOT EXISTS (   SELECT TOP 1  1
                        FROM    dsp.SystemTable ST
                       WHERE ST.SchemaName = @SchemaName AND ST.TableName = @TableName AND  ISNULL(ST.TemporalTypeId, 0) = dspconst.TemporalType_Lookup())
        EXEC dsperr.ThrowInvalidOperation @ProcId = @@PROCID, @Message = 'Table has not Lookup TemporalType attribute,TableName is {0}.{1}',
            @Param0 = @SchemaName, @Param1 = @TableName;

    -- Get data by parameters
    SET @Query = CONCAT('
	SET @Result = (SELECT' ,@Columns,    ' FROM ', @SchemaName, '.', @TableName, '
	FOR JSON AUTO,INCLUDE_NULL_VALUES)
	');
    SET @Params = '@Result NVARCHAR(MAX) OUTPUT';

    EXEC sys.sp_executesql @Query, @Params, @Result = @ResultItems OUTPUT;

END;








GO
