IF OBJECT_ID('[dsp].[Validate_CheckNotNull]') IS NOT NULL
	DROP PROCEDURE [dsp].[Validate_CheckNotNull];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dsp].[Validate_CheckNotNull]
    @ProcId INT, @ArgumentName TSTRING, @ArgumentValue TSTRING, @Message TSTRING = NULL
AS
BEGIN
    IF (@ArgumentValue IS NULL) --
        EXEC dsp.ThrowInvalidArgument @ProcId = @ProcId, @ArgumentName = @ArgumentName, @ArgumentValue = @ArgumentValue, @Message = @Message;
END;









GO
