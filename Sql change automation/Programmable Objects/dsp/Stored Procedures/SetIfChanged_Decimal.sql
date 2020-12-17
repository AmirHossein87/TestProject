IF OBJECT_ID('[dsp].[SetIfChanged_Decimal]') IS NOT NULL
	DROP PROCEDURE [dsp].[SetIfChanged_Decimal];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[SetIfChanged_Decimal]
    @ProceId INT, @PropName TSTRING, @NewValue DECIMAL, @OldValue DECIMAL OUT, @HasPermission BIT = 1, @NullAsNotSet BIT = 0, @IsUpdated BIT OUT
AS
BEGIN
    SET @HasPermission = ISNULL(@HasPermission, 0);

    IF (dsp.Param_IsChanged(@OldValue, @NewValue, @NullAsNotSet) = 0)
        RETURN;

    IF (@HasPermission = 0) --
        EXEC dsperr.ThrowAccessDeniedOrObjectNotExists @ProcId = @ProceId, @Message = 'PropName: {0}', @Param0 = @PropName;

    SET @IsUpdated = 1;
    SET @OldValue = @NewValue;
END;
GO
