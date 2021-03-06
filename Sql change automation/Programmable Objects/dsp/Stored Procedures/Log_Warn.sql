IF OBJECT_ID('[dsp].[Log_Warn]') IS NOT NULL
	DROP PROCEDURE [dsp].[Log_Warn];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	PROCEDURE [dsp].[Log_Warn]
	@ProcId AS INT, @Message AS TSTRING, @Param0 AS TSTRING = '<notset>', @Param1 AS TSTRING = '<notset>', @Param2 AS TSTRING = '<notset>'
AS
BEGIN
	SET @Message = 'Warning: ' + @Message;
	EXEC dsp.Log_Trace @ProcId = @ProcId, @Message = @Message, @Param0 = @Param0, @Param1 = @Param1, @Param2 = @Param2, @Elipse = 0;
END;



GO
