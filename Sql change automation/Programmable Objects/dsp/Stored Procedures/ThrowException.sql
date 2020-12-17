IF OBJECT_ID('[dsp].[ThrowException]') IS NOT NULL
	DROP PROCEDURE [dsp].[ThrowException];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	PROCEDURE [dsp].[ThrowException]
	@Exception TJSON
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ExceptionId INT = JSON_VALUE(@Exception, '$.errorId');
	THROW @ExceptionId, @Exception, 1;
END;





GO
