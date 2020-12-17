IF OBJECT_ID('[dsp].[SetIfChanged_String]') IS NOT NULL
	DROP PROCEDURE [dsp].[SetIfChanged_String];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[SetIfChanged_String]
    @ProcId INT, @PropName TSTRING, @NewValue TSTRING, @OldValue TSTRING OUTPUT, @HasPermission BIT = NULL, @NullAsNotSet BIT = 0, @IsUpdated BIT = NULL OUTPUT
AS
BEGIN
    SET @HasPermission = ISNULL(@HasPermission, 1);

    IF (dsp.Param_IsChanged(dsp.Convert_ToSqlvariant(@OldValue), dsp.Convert_ToSqlvariant(@NewValue), @NullAsNotSet) = 0)
        RETURN;

    IF (@HasPermission = 0) --
        EXEC dsperr.ThrowAccessDeniedOrObjectNotExists @ProcId = @ProcId, @Message = 'PropName: {0}', @Param0 = @PropName;

    SET @IsUpdated = 1;
    SET @OldValue = @NewValue;
END;






GO
