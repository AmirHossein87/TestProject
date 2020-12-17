IF OBJECT_ID('[dsp].[Json_Getproperties]') IS NOT NULL
	DROP FUNCTION [dsp].[Json_Getproperties];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[Json_Getproperties] (@Json NVARCHAR(MAX),
    @WithTypes BIT = 0)
RETURNS NVARCHAR(MAX)
WITH SCHEMABINDING
AS
BEGIN
    DECLARE @PropertiesName NVARCHAR(MAX);
    SELECT  @PropertiesName = COALESCE(@PropertiesName + ', ', '') + JRN.JKey + IIF(ISNULL(@WithTypes, 0) = 1,
                                                                                    (CASE
                                                                                         WHEN JRN.JType IN ( 1, 2 )
                                                                                             THEN ' NVARCHAR(MAX)' --
                                                                                         WHEN JRN.JType = 3
                                                                                             THEN ' BIT' --
                                                                                         WHEN JRN.JType = 4
                                                                                             THEN ' NVARCHAR(MAX) AS JSON' --
                                                                                     END),
                                                                                    '')
      FROM  dsp.Json_ReadNested('$', @Json) AS JRN
     WHERE  JRN.JPath = '$' AND JRN.JIndex = 0;

    RETURN @PropertiesName;
END;

GO
