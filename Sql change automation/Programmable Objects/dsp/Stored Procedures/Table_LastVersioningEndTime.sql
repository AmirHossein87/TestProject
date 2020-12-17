IF OBJECT_ID('[dsp].[Table_LastVersioningEndTime]') IS NOT NULL
	DROP PROCEDURE [dsp].[Table_LastVersioningEndTime];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   PROCEDURE [dsp].[Table_LastVersioningEndTime] (
    @SchemaName TSTRING, @TableName TSTRING, @LastVersioningTime DATETIME2 OUTPUT)
AS
BEGIN
    DECLARE @Query TSTRING;
    DECLARE @Params TSTRING;

    SET @Query = CONCAT('SET @Result = (SELECT  MAX(VersioningEndTime) FROM ', @SchemaName, '.', @TableName, 'History )');

    SET @Params = '@Result DATETIME2 OUTPUT';

    EXEC sys.sp_executesql @Query, @Params, @Result = @LastVersioningTime OUTPUT;

END;




GO
