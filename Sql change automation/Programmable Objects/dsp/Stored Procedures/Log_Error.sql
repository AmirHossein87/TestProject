IF OBJECT_ID('[dsp].[Log_Error]') IS NOT NULL
	DROP PROCEDURE [dsp].[Log_Error];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	PROCEDURE [dsp].[Log_Error]
	@ProcId AS INT, @Message AS TSTRING, @Param0 AS TSTRING = '<notset>', @Param1 AS TSTRING = '<notset>', @Param2 AS TSTRING = '<notset>'
AS
BEGIN
	SET @Message = 'Error: ' + @Message;
	EXEC dsp.Log_Trace @ProcId = @ProcId, @Message = @Message, @Param0 = @Param0, @Param1 = @Param1, @Param2 = @Param2, @Elipse = 0;
END;







GO
