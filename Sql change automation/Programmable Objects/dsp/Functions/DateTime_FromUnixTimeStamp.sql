IF OBJECT_ID('[dsp].[DateTime_FromUnixTimeStamp]') IS NOT NULL
	DROP FUNCTION [dsp].[DateTime_FromUnixTimeStamp];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[DateTime_FromUnixTimeStamp] (
@UnixTime BIGINT
)
RETURNS datetime
AS
BEGIN

  RETURN DATEADD(S,@UnixTime,'1970-01-01')

END
GO
