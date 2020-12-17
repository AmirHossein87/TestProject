IF OBJECT_ID('[dsp].[Audit_Trace]') IS NOT NULL
	DROP PROCEDURE [dsp].[Audit_Trace];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[Audit_Trace]
	@ProcId AS INT,
	@Message AS TSTRING,
	@Param0 AS TSTRING = '<notset>',
	@Param1 AS TSTRING = '<notset>',
	@Param2 AS TSTRING = '<notset>'
AS
BEGIN
	-- Format Message
	EXEC dsp.Log_Trace @ProcId = @ProcId, @Message = @Message, @Param0 = @Param0, @Param1 = @Param1, @Param2 = @Param2;
END;




GO
