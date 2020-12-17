IF OBJECT_ID('[dsp].[Int_Min]') IS NOT NULL
	DROP FUNCTION [dsp].[Int_Min];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[Int_Min] (@Value1 INT,
    @Value2 INT)
RETURNS TABLE
RETURN (   SELECT   MIN(value.v) MinValue
             FROM   (VALUES (@Value1), (@Value2)) AS value (v) );

GO
