IF OBJECT_ID('[const].[UserName_SystemAdmin]') IS NOT NULL
	DROP FUNCTION [const].[UserName_SystemAdmin];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [const].[UserName_SystemAdmin]()
RETURNS TSTRING
AS
BEGIN
    RETURN 'Log_Admin';
END
 
GO
