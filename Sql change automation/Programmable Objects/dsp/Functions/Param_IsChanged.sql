IF OBJECT_ID('[dsp].[Param_IsChanged]') IS NOT NULL
	DROP FUNCTION [dsp].[Param_IsChanged];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--Check if a parameter has been updated or not
CREATE FUNCTION [dsp].[Param_IsChanged] (
	@OldValue SQL_VARIANT,
	@NewValue SQL_VARIANT,
	@NullAsNotSet BIT
)
RETURNS BIT
AS
BEGIN
	RETURN IIF(dsp.Param_IsSetBase(@NewValue, @NullAsNotSet) = 1 AND dsp.Util_IsEqual(@OldValue, @NewValue) = 0, 1, 0);
END;




GO
