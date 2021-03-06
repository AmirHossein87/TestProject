IF OBJECT_ID('[dsp].[Database_IsReadOnly]') IS NOT NULL
	DROP FUNCTION [dsp].[Database_IsReadOnly];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	FUNCTION [dsp].[Database_IsReadOnly] (@DatabaseName TSTRING)
RETURNS BIT
AS
BEGIN
	RETURN IIF(DATABASEPROPERTYEX(ISNULL(@DatabaseName, DB_NAME()), 'Updateability') = 'READ_ONLY', 1, 0);
END;


GO
