IF OBJECT_ID('[dsp].[Table_ValidateExtendedPropertyValueByKey]') IS NOT NULL
	DROP PROCEDURE [dsp].[Table_ValidateExtendedPropertyValueByKey];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[Table_ValidateExtendedPropertyValueByKey]
    @SchemaName TSTRING, @TableName TSTRING, @ExtendedPropertyName TSTRING
AS
BEGIN
    IF NOT EXISTS (   SELECT TOP 1  1
                        FROM    dsp.Table_GetExtendedPropertyValueByKey(@SchemaName, @TableName, @ExtendedPropertyName) )
        EXEC dsperr.ThrowInvalidOperation @ProcId = @@PROCID, @Message = 'Table does not have extended property with name {0}', @Param0 = @ExtendedPropertyName;
END;
GO
