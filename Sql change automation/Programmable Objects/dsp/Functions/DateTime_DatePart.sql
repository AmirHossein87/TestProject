IF OBJECT_ID('[dsp].[DateTime_DatePart]') IS NOT NULL
	DROP FUNCTION [dsp].[DateTime_DatePart];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   FUNCTION [dsp].[DateTime_DatePart] (@DatePart CHAR(1),
    @Date VARCHAR(10))
RETURNS INT
AS
BEGIN
    -- SQL Prompt Formatting Off
    RETURN (   SELECT   Q.StrValue
                 FROM   (   SELECT  ROW_NUMBER() OVER (ORDER BY (SELECT   1)) AS Id, SS.value AS StrValue
                              FROM  STRING_SPLIT(@Date, '-') AS SS) Q
                WHERE   Q.Id = (CASE LOWER(@DatePart)
                                    WHEN 'y' THEN 1
                                    WHEN 'm' THEN 2
                                    WHEN 'd' THEN 3 
									ELSE 0
                                END));
END;
GO
