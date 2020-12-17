IF OBJECT_ID('[dsp].[Log_Disable]') IS NOT NULL
	DROP PROCEDURE [dsp].[Log_Disable];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- Stop Logging System but keep settings
CREATE PROCEDURE [dsp].[Log_Disable]
AS
BEGIN
	
	-- Set enable flag
	UPDATE dsp.LogUser SET	IsEnabled = 0 WHERE UserName = SYSTEM_USER;
	PRINT 'LogSystem> LogSystem has been disbaled.';

	EXEC sp_set_session_context 'dsp.Log_IsEnabled', 0, @read_only = 0;

END


GO
