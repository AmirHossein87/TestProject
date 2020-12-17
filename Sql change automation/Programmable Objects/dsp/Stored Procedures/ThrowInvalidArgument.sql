IF OBJECT_ID('[dsp].[ThrowInvalidArgument]') IS NOT NULL
	DROP PROCEDURE [dsp].[ThrowInvalidArgument];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE	PROCEDURE [dsp].[ThrowInvalidArgument]
	@ProcId INT, @ArgumentName TSTRING, @ArgumentValue TSTRING, @Message TSTRING = NULL
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Exception TJSON;
	EXEC @Exception = dsp.Exception_BuildInvalidArgument @ProcId = @ProcId, @ArgumentName = @ArgumentName, @ArgumentValue = @ArgumentValue, @Message = @Message;
	EXEC dsp.ThrowException @Exception = @Exception;
END;











GO
