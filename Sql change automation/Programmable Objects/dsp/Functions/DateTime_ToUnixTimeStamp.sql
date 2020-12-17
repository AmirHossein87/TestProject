IF OBJECT_ID('[dsp].[DateTime_ToUnixTimeStamp]') IS NOT NULL
	DROP FUNCTION [dsp].[DateTime_ToUnixTimeStamp];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[DateTime_ToUnixTimeStamp] (@time DATETIME)
RETURNS INTEGER
AS
BEGIN
    DECLARE @diff BIGINT 
    IF @time >= '20380119' 
    BEGIN 
        SET @diff = CONVERT(BIGINT, DATEDIFF(S, '19700101', '20380119')) 
            + CONVERT(BIGINT, DATEDIFF(S, '20380119', @time)) 
    END 
    ELSE 
        SET @diff = DATEDIFF(S, '19700101', @time) 
    RETURN @diff 
END;

GO
