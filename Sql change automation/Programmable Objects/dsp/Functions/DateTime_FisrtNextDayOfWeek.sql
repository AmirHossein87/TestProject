IF OBJECT_ID('[dsp].[DateTime_FisrtNextDayOfWeek]') IS NOT NULL
	DROP FUNCTION [dsp].[DateTime_FisrtNextDayOfWeek];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	FUNCTION [dsp].[DateTime_FisrtNextDayOfWeek] (@NextDay INT)
RETURNS DATETIME
AS
BEGIN
	-- Mon:0, Tue:1, Wed:2, Thr:3, Fri:4, Sat:5, Sun:6
	DECLARE @CalculatedTime DATETIME = DATEADD(DAY, (DATEDIFF(DAY, @NextDay, GETDATE()) / 7) * 7 + 7, @NextDay);
	RETURN @CalculatedTime;
END;



GO
