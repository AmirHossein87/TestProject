IF OBJECT_ID('[DatabaseVersioning].[DatabaseVersioning_EnableTemporal]') IS NOT NULL
	DROP PROCEDURE [DatabaseVersioning].[DatabaseVersioning_EnableTemporal];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [DatabaseVersioning].[DatabaseVersioning_EnableTemporal]
    @SchemaName TSTRING, @TableName TSTRING
AS
BEGIN
    -- Validate TableName
    EXEC dsp.Validate_CheckNotNull @ProcId = @@PROCID, @ArgumentName = 'TableName', @ArgumentValue = @TableName, @Message = 'TableName could not be allow null';

    -- Validate SchemaName
    EXEC dsp.Validate_CheckNotNull @ProcId = @@PROCID, @ArgumentName = 'SchemaName', @ArgumentValue = @SchemaName,
    @Message = 'SchemaName could not be allow null';

    -- Validate for existstance "Temporal" in extended property
    DECLARE @TemporalTypeValue INT = dspconst.TemporalType_Temporal();
    IF NOT EXISTS (   SELECT TOP 1  1
                        FROM    dsp.SystemTable
                       WHERE SchemaName = @SchemaName AND   TableName = @TableName AND  TemporalTypeId = /*dspconst.TemporalType_Temporal()*/ 2)
        EXEC dsperr.ThrowInvalidOperation @ProcId = @@PROCID, @Message = 'TemporalType is not Temporal';

    -- Enable Temporal
    EXEC dsp.Table_EnableTemporalAttribute @SchemaName = @SchemaName, @TableName = @TableName;
END;









GO
