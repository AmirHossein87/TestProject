IF OBJECT_ID('[dsp].[Setting_SystemUserId]') IS NOT NULL
	DROP FUNCTION [dsp].[Setting_SystemUserId];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[Setting_SystemUserId] ()
RETURNS INT
AS
BEGIN
    RETURN (SELECT  S.SystemUserId FROM dsp.Setting AS S);
END;




GO
