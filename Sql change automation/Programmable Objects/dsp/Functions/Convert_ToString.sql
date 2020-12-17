IF OBJECT_ID('[dsp].[Convert_ToString]') IS NOT NULL
	DROP FUNCTION [dsp].[Convert_ToString];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[Convert_ToString] (@Value SQL_VARIANT)
RETURNS NVARCHAR(MAX /*NCQ*/)
WITH SCHEMABINDING
BEGIN
    RETURN CAST(@Value
AS  NVARCHAR(4000));
END;
GO
