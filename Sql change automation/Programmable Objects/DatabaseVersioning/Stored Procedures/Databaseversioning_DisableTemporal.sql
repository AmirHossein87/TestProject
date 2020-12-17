IF OBJECT_ID('[DatabaseVersioning].[Databaseversioning_DisableTemporal]') IS NOT NULL
	DROP PROCEDURE [DatabaseVersioning].[Databaseversioning_DisableTemporal];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [DatabaseVersioning].[Databaseversioning_DisableTemporal]
    @SchemaName TSTRING, @TableName TSTRING
AS
BEGIN
    -- Validate TableName
    EXEC dsp.Validate_CheckNotNull @ProcId = @@PROCID, @ArgumentName = 'TableName', @ArgumentValue = @TableName, @Message = 'TableName could not be allow null';

    -- Validate SchemaName
    EXEC dsp.Validate_CheckNotNull @ProcId = @@PROCID, @ArgumentName = 'SchemaName', @ArgumentValue = @SchemaName,
    @Message = 'SchemaName could not be allow null';

    -- Validate TemporalType
    IF NOT EXISTS (   SELECT    *
                        FROM    dsp.SystemTable
                       WHERE SchemaName = @SchemaName AND   TableName = @TableName AND  TemporalTypeId = dspconst.TemporalType_Temporal())
        EXEC dsperr.ThrowInvalidOperation @ProcId = @@PROCID, @Message = 'TemporalType is not Temporal';

    -- Disable Temporal
    EXEC dsp.Table_DisableTemporalAttribute @SchemaName = @SchemaName, @TableName = @TableName;
END;




GO
