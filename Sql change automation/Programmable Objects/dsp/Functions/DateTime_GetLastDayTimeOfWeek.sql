IF OBJECT_ID('[dsp].[DateTime_GetLastDayTimeOfWeek]') IS NOT NULL
	DROP FUNCTION [dsp].[DateTime_GetLastDayTimeOfWeek];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   FUNCTION [dsp].[DateTime_GetLastDayTimeOfWeek] (@DayOfWeek INT,
    @Time TIME)
RETURNS DATETIME
AS
BEGIN
    -- Calculate last settlement date by SettlementDayOfWeek
    DECLARE @Date DATE = GETDATE();
    WHILE (dsp.DaysOfTheWeek_FromString(DATENAME(WEEKDAY, @Date)) <> @DayOfWeek)
    SET @Date = DATEADD(DAY, -1, @Date);

    DECLARE @LastDayTime DATETIME = CONVERT(DATETIME2, CONCAT(@Date, ' ', @Time));

    RETURN @LastDayTime;
END;
GO
