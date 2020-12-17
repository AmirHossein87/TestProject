IF OBJECT_ID('[dsp].[Json_GetSelectScript]') IS NOT NULL
	DROP FUNCTION [dsp].[Json_GetSelectScript];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[Json_GetSelectScript] (@Json NVARCHAR(MAX)/*NQC*/)
RETURNS NVARCHAR(MAX) /*NQC*/
AS
BEGIN
    IF (LEN(ISNULL(@Json, '')) < 3)
        RETURN '';

    DECLARE @WithClause TSTRING = 'WITH (' + dsp.Json_Getproperties(@Json, 1) + ')';
    DECLARE @Query TSTRING = N'SELECT * FROM OPENJSON(''' + @Json + N''') ' + ISNULL(@WithClause, '') + N' AS OJ';

    RETURN @Query;
END;

GO
