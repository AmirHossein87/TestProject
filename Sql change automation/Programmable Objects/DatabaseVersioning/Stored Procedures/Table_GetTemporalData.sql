IF OBJECT_ID('[DatabaseVersioning].[Table_GetTemporalData]') IS NOT NULL
	DROP PROCEDURE [DatabaseVersioning].[Table_GetTemporalData];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [DatabaseVersioning].[Table_GetTemporalData]
    @SchemaName TSTRING, @TableName TSTRING, @CreatedStartTime DATETIME2, @EndTime DATETIME2, @MainJsonResult TJSON = NULL OUTPUT,
    @HistoryJsonResult TJSON = NULL OUTPUT
AS
BEGIN
    DECLARE @MainQuery TSTRING;
    DECLARE @HistoryQuery TSTRING;
    DECLARE @Params TSTRING;
    DECLARE @Params1 TSTRING;
	DECLARE @MaxRecords INT;
	DECLARE @Columns TSTRING;

	-- Get maxrecord
	DECLARE @GetDataRowCount INT, @MirroringIsEnabled INT;
	EXEC DatabaseVersioning.Setting_GetProps @GetDataRowCount = @GetDataRowCount OUTPUT, @MirroringIsEnabled = @MirroringIsEnabled OUTPUT
	SET @MaxRecords =  @GetDataRowCount

	-- Get Columns
	SET @Columns = (SELECT DatabaseVersioning.Table_Columns(@SchemaName,@TableName))

    SET @CreatedStartTime = ISNULL(dsp.DateTime_ConvertLocalToUTC(@CreatedStartTime), dspconst.ReferenceTime());
    SET @EndTime = ISNULL(dsp.DateTime_ConvertLocalToUTC(@EndTime), GETDATE());

    -- Validate SchemaName
    EXEC dsp.Validate_CheckNotNull @ProcId = @@PROCID, @ArgumentName = 'SchemaName', @ArgumentValue = @SchemaName,
    @Message = 'SchemaName could not be allow null';

    -- Validate TableName
    EXEC dsp.Validate_CheckNotNull @ProcId = @@PROCID, @ArgumentName = 'TableName', @ArgumentValue = @TableName, @Message = 'TableName could not be allow null';

    -- Get TemporalTypeId attribute
    DECLARE @TemporalTypeId TSTRING;
    SELECT  @TemporalTypeId = TemporalTypeId
      FROM  dsp.SystemTable
     WHERE  SchemaName = @SchemaName AND TableName = @TableName;

    -- Validate ExtendedPropertyKey 
    IF (ISNULL(@TemporalTypeId, 0) <> dspconst.TemporalType_Temporal()) --
        EXEC dsperr.ThrowInvalidOperation @ProcId = @@PROCID, @Message = 'Table has not TemporalTypeId extended property with Temporal value';

    -- Set Main json for result 
    SET @MainQuery =
        CONCAT(
            '
  SET @Result = (SELECT  Top (  ',@MaxRecords, ')' ,@Columns,' FROM  ', @SchemaName, '.', @TableName, ' M ', --

            ' WHERE (M.VersioningStartTime > ', '''', CONVERT(VARCHAR, @CreatedStartTime, 121) + '''', 'AND  M.VersioningStartTime <=',
            '''' + CONVERT(VARCHAR, @EndTime, 121), ''')', ' FOR JSON AUTO ,INCLUDE_NULL_VALUES)');

    SET @Params = '@Result NVARCHAR(MAX) OUTPUT';
    EXEC sys.sp_executesql @MainQuery, @Params, @Result = @MainJsonResult OUTPUT;
	
    -- Set History json for result
    SET @HistoryQuery =
        CONCAT(
            ' SET @Result = (SELECT  Top ( ' ,@MaxRecords, ')',@Columns,' FROM  ' , @SchemaName, '.', @TableName, 'History H', --

            ' WHERE ( H.VersioningEndTime > ', '''', CONVERT(VARCHAR, @CreatedStartTime, 121) + '''', 'AND  H.VersioningEndTime <=',
            '''' + CONVERT(VARCHAR, @EndTime, 121), '''', ')
             FOR JSON AUTO ,INCLUDE_NULL_VALUES)');

    SET @Params1 = '@Result NVARCHAR(MAX) OUTPUT';
    EXEC sys.sp_executesql @HistoryQuery, @Params1, @Result = @HistoryJsonResult OUTPUT;

END;



GO
