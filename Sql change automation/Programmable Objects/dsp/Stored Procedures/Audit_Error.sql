IF OBJECT_ID('[dsp].[Audit_Error]') IS NOT NULL
	DROP PROCEDURE [dsp].[Audit_Error];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	PROCEDURE [dsp].[Audit_Error]
	@ProcId AS INT, @Message AS TSTRING, @Param0 AS TSTRING = '<notset>', @Param1 AS TSTRING = '<notset>', @Param2 AS TSTRING = '<notset>'
AS
BEGIN
	-- Format Message
	EXEC dsp.Log_Error @ProcId = @ProcId, @Message = @Message, @Param0 = @Param0, @Param1 = @Param1, @Param2 = @Param2;
END;


GO
