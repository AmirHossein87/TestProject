IF OBJECT_ID('[dsp].[CheckIfChanged_Int]') IS NOT NULL
	DROP FUNCTION [dsp].[CheckIfChanged_Int];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[CheckIfChanged_Int] (@NewValue BIGINT,
    @OldValue BIGINT,
    @NullAsNotSet BIT = 0)
RETURNS BIGINT
AS
BEGIN
    DECLARE @ResultValue BIGINT = @OldValue;
    IF (dsp.Param_IsChanged(@OldValue, @NewValue, @NullAsNotSet) = 1)
        SET @ResultValue = @NewValue;

    RETURN @ResultValue;
END;








GO
