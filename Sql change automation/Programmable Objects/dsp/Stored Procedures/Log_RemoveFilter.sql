IF OBJECT_ID('[dsp].[Log_RemoveFilter]') IS NOT NULL
	DROP PROCEDURE [dsp].[Log_RemoveFilter];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- @Filter if NULL then all filter will be removed
CREATE PROCEDURE [dsp].[Log_RemoveFilter]
    @Filter TSTRING = NULL
AS
BEGIN
	SET NOCOUNT ON;
	-- Enable the Log System
    IF ( dsp.Log_IsEnabled() = 0 )
        EXEC dsp.Log_Enable;

	-- Remove all filters
    IF ( @Filter IS NULL )
    BEGIN
        DELETE  dsp.LogFilterSetting
        WHERE   UserName = SYSTEM_USER;
        PRINT 'LogSystem> All filters have been removed.';
        RETURN;
    END;
	
	-- Remove the existing filter
    IF EXISTS ( SELECT 1 FROM dsp.LogFilterSetting AS LFS WHERE LFS.Log_Filter = @Filter AND LFS.UserName = SYSTEM_USER )
    BEGIN
        DELETE  LogFilterSetting
        WHERE   Log_Filter = @Filter AND UserName = SYSTEM_USER;
        PRINT 'LogSystem> Filter has been removed.';
        RETURN;
    END;
	
	-- Print not-find message
    PRINT 'LogSystem> Could not find the filter.';
END;


GO
