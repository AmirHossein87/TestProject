IF OBJECT_ID('[dsp].[DateTime_HasBetween]') IS NOT NULL
	DROP FUNCTION [dsp].[DateTime_HasBetween];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[DateTime_HasBetween] (@TimeToCheck DATETIME,
    @FromTime DATETIME,
    @ToTime DATETIME)
RETURNS BIT
WITH SCHEMABINDING
AS
BEGIN
    DECLARE @HasBelong BIT = 0;

    IF (@TimeToCheck IS NULL) --
        RETURN 0;

    SET @FromTime = CONCAT(DATEPART(YEAR, @TimeToCheck), '-', DATEPART(MONTH, @FromTime), '-', DATEPART(DAY, @FromTime));
    SET @ToTime = CONCAT(DATEPART(YEAR, @TimeToCheck), '-', DATEPART(MONTH, @ToTime), '-', DATEPART(DAY, @ToTime));

    IF (@TimeToCheck >= @FromTime AND   @TimeToCheck < @ToTime)
        SET @HasBelong = 1;

    RETURN @HasBelong;
END;


GO
