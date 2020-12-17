IF OBJECT_ID('[dsp].[Formatter_FormatString]') IS NOT NULL
	DROP FUNCTION [dsp].[Formatter_FormatString];

GO
/*
	Unsupported Programmable Object
	-------------------------------
	This script was placed in the Unsupported folder during the initial import process as it
	contains a type of object that requires special handling. This has been done to prevent
	the script from failing during the script-generation and database deployment processes.

	In order to include the script within the Programmable Objects folder, some modifications
	will need to be made to ensure that it executes successfully. For more information,
	please refer to the documentation:
	https://www.red-gate.com/sca/dev/unsupported-programmable-objects
*/

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[Formatter_FormatString] (@str NVARCHAR(/*NoCodeQuality*/4000))
RETURNS NVARCHAR(/*NoCodeQuality*/4000)
WITH SCHEMABINDING
AS
BEGIN
	RETURN NULLIF(TRIM(@str), '');
END;



GO
