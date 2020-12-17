IF OBJECT_ID('[dsp].[Table_HasIdentityColumn]') IS NOT NULL
	DROP FUNCTION [dsp].[Table_HasIdentityColumn];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[Table_HasIdentityColumn] (@FullTableName TSTRING)
RETURNS BIT
AS
BEGIN
    RETURN 1;
END;
GO
