IF OBJECT_ID('[dsp].[SetIfChanged_Int]') IS NOT NULL
	DROP PROCEDURE [dsp].[SetIfChanged_Int];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[SetIfChanged_Int]
    @ProcId INT, @PropName TSTRING, @NewValue BIGINT, @OldValue BIGINT OUTPUT, @HasPermission BIT = NULL, @NullAsNotSet BIT = 0, @IsUpdated BIT = NULL OUTPUT
AS
BEGIN
    SET @IsUpdated = ISNULL(@IsUpdated, 0);
    SET @HasPermission = ISNULL(@HasPermission, 1);
    IF (dsp.Param_IsChanged(@OldValue, @NewValue, @NullAsNotSet) = 0)
        RETURN;

    IF (@HasPermission = 0) --
        EXEC dsperr.ThrowAccessDeniedOrObjectNotExists @ProcId = @ProcId, @Message = 'PropName: {0}', @Param0 = @PropName;

    SET @IsUpdated = 1;
    SET @OldValue = @NewValue;
END;


GO
