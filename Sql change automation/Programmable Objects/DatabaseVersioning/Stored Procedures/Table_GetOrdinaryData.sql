IF OBJECT_ID('[DatabaseVersioning].[Table_GetOrdinaryData]') IS NOT NULL
	DROP PROCEDURE [DatabaseVersioning].[Table_GetOrdinaryData];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [DatabaseVersioning].[Table_GetOrdinaryData]
    @SchemaName TSTRING = NULL, @TableName TSTRING = NULL, @CreatedStartTime DATETIME, @ModifiedStartTime DATETIME, @EndTime DATETIME,
    @ResultItems TSTRING = NULL OUTPUT
AS
BEGIN
    -- Provisiong parameters
    DECLARE @Query TSTRING;
    DECLARE @Params TSTRING;
	DECLARE @MaxRecords INT;
	DECLARE @Columns TSTRING;
	
    SET @SchemaName = ISNULL(@SchemaName, 'dbo');
	-- Get maxrecord
	DECLARE @GetDataRowCount INT, @MirroringIsEnabled INT;
	EXEC DatabaseVersioning.Setting_GetProps @GetDataRowCount = @GetDataRowCount OUTPUT, @MirroringIsEnabled = @MirroringIsEnabled OUTPUT
	SET @MaxRecords =  @GetDataRowCount
	-- Get columns
	SET @Columns = (SELECT DatabaseVersioning.Table_Columns(@SchemaName,@TableName))


    -- Validate TableName
    EXEC dsp.Validate_CheckNotNull @ProcId = @@PROCID, @ArgumentName = 'TableName', @ArgumentValue = @TableName, @Message = 'TableName could not be allow null';

    -- TableName must be exists
    IF NOT EXISTS (SELECT TOP 1 1 FROM  sys.tables WHERE name = @TableName) --
        EXEC dsp.ThrowInvalidArgument @ProcId = @@PROCID, @ArgumentName = 'TableName', @ArgumentValue = @TableName,
            @Message = 'TableName does not exists in tables list';

    -- Table must have Ordinary attribute in TemporalType extended property
    IF NOT EXISTS (   SELECT TOP 1  1
                        FROM    dsp.SystemTable TLBOTT
                       WHERE TLBOTT.SchemaName = @SchemaName AND TLBOTT.TableName = @TableName AND
                             ISNULL(TLBOTT.TemporalTypeId, 0) = dspconst.TemporalType_Ordinary())
        EXEC dsperr.ThrowInvalidOperation @ProcId = @@PROCID, @Message = 'Table has not Ordinary TemporalType attribute,TableName is {0}.{1}',
            @Param0 = @SchemaName, @Param1 = @TableName;

    -- Get data by parameters
    SET @Query =
        CONCAT(
            '
	SET @Result = (SELECT Top (',@MaxRecords,') ' ,@Columns, ' FROM  '                        , @SchemaName, '.', @TableName, --
            ' WHERE (CreatedTime > ''', CONVERT(VARCHAR, @CreatedStartTime, 121), ''' AND CreatedTime <= ', '''', CONVERT(VARCHAR, @EndTime, 121), ''')',
            ' OR ', --
            '(ModifiedTime IS NOT NULL AND ModifiedTime > ''', CONVERT(VARCHAR, @ModifiedStartTime, 121), ''' AND ModifiedTime <= ', '''',
            CONVERT(VARCHAR, @EndTime, 121), ''')', ' FOR JSON AUTO,INCLUDE_NULL_VALUES)
	');
    SET @Params = '@Result NVARCHAR(MAX) OUTPUT';
	SELECT @Query
    EXEC sys.sp_executesql @Query, @Params, @Result = @ResultItems OUTPUT;

END;








GO
