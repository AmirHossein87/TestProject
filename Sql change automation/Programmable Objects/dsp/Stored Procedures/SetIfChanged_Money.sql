IF OBJECT_ID('[dsp].[SetIfChanged_Money]') IS NOT NULL
	DROP PROCEDURE [dsp].[SetIfChanged_Money];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[SetIfChanged_Money]
    @ProcId INT, @PropName TSTRING, @NewValue MONEY, @OldValue MONEY OUT, @HasPermission BIT = 1, @NullAsNotSet BIT = 0, @IsUpdated BIT = NULL OUTPUT
AS
BEGIN
    SET @HasPermission = ISNULL(@HasPermission, 1);

    IF (dsp.Param_IsChanged(@OldValue, @NewValue, @NullAsNotSet) = 0)
        RETURN;

    IF (@HasPermission = 0) --
        EXEC dsperr.ThrowAccessDeniedOrObjectNotExists @ProcId = @ProcId, @Message = 'PropName: {0}', @Param0 = @PropName;

    SET @IsUpdated = 1;
    SET @OldValue = @NewValue;
END;
GO
