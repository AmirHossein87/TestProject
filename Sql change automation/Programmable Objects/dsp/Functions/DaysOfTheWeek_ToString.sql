IF OBJECT_ID('[dsp].[DaysOfTheWeek_ToString]') IS NOT NULL
	DROP FUNCTION [dsp].[DaysOfTheWeek_ToString];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   FUNCTION [dsp].[DaysOfTheWeek_ToString] (@DaysOfWeek INT)
RETURNS TSTRING
AS
BEGIN
    DECLARE @ret TSTRING = '';
    IF (@DaysOfWeek & 0x01 = 0x01)
        SET @ret = @ret + 'sun,';
    IF (@DaysOfWeek & 0x02 = 0x02)
        SET @ret = @ret + 'mon,';
    IF (@DaysOfWeek & 0x04 = 0x04)
        SET @ret = @ret + 'tue,';
    IF (@DaysOfWeek & 0x08 = 0x08)
        SET @ret = @ret + 'wed,';
    IF (@DaysOfWeek & 0x10 = 0x10)
        SET @ret = @ret + 'thu,';
    IF (@DaysOfWeek & 0x20 = 0x20)
        SET @ret = @ret + 'fri,';
    IF (@DaysOfWeek & 0x40 = 0x40)
        SET @ret = @ret + 'sat,';

    SET @ret = IIF(@ret LIKE '%,', LEFT(@ret, LEN(@ret) - 1), @ret);
    RETURN @ret;
END;
GO
