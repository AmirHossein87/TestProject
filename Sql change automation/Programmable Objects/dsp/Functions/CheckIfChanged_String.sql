IF OBJECT_ID('[dsp].[CheckIfChanged_String]') IS NOT NULL
	DROP FUNCTION [dsp].[CheckIfChanged_String];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	FUNCTION [dsp].[CheckIfChanged_String] (@NewValue TSTRING,
	@OldValue TSTRING,
	@NullAsNotSet BIT = 0)
RETURNS TSTRING
AS
BEGIN
	DECLARE @ResultValue TSTRING = @OldValue;

	IF (dsp.Param_IsChanged(dsp.Convert_ToSqlvariant(@OldValue), dsp.Convert_ToSqlvariant(@NewValue), @NullAsNotSet) = 1)
		SET @ResultValue = @NewValue;

	RETURN @ResultValue;
END;








GO
