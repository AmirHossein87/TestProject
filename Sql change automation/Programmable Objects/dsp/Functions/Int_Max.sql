IF OBJECT_ID('[dsp].[Int_Max]') IS NOT NULL
	DROP FUNCTION [dsp].[Int_Max];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[Int_Max] (@Value1 INT,
    @Value2 INT)
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    DECLARE @MaxValue INT;

    SELECT  @MaxValue = MAX(value.v)
      FROM  (VALUES (@Value1), (@Value2)) AS value (v);

    RETURN @MaxValue;
END;

GO
